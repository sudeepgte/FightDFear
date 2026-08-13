package in.sp.main.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.razorpay.RazorpayClient;
import com.razorpay.Refund;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorRepository;

@Service
public class DoctorPaymentService {

    public static final String STATUS_PAID = "PAID";
    public static final String STATUS_REFUNDED = "REFUNDED";
    public static final String STATUS_REFUND_PENDING = "REFUND_PENDING";
    public static final String STATUS_MOCK_PAID = "MOCK_PAID";

    @Value("${razorpay.key.id:}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret:}")
    private String razorpayKeySecret;

    @Value("${app.payments.mock-enabled:false}")
    private boolean mockEnabled;

    @Value("${app.doctor.commission-percent:15}")
    private double defaultCommissionPercent;

    @Autowired
    private DoctorAppointmentRepository appointmentRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorNotificationService notificationService;

    @Autowired
    private PushNotificationService pushNotificationService;

    public boolean razorpayConfigured() {
        return razorpayKeyId != null && !razorpayKeyId.isBlank()
                && razorpayKeySecret != null && !razorpayKeySecret.isBlank();
    }

    public boolean mockPaymentsEnabled() {
        return mockEnabled && !razorpayConfigured();
    }

    public boolean paymentsAvailable() {
        return razorpayConfigured() || mockPaymentsEnabled();
    }

    public void applyPaidSettlement(DoctorAppointment appt, double amountPaid) {
        double commissionPct = defaultCommissionPercent;
        if (appt.getDoctor() != null && appt.getDoctor().getCommissionPercent() != null) {
            commissionPct = appt.getDoctor().getCommissionPercent();
        }
        commissionPct = Math.max(0, Math.min(100, commissionPct));
        double platformFee = Math.round(amountPaid * commissionPct) / 100.0;
        double doctorEarning = Math.max(0, amountPaid - platformFee);

        appt.setAmountPaid(amountPaid);
        appt.setPlatformFee(platformFee);
        appt.setDoctorEarning(doctorEarning);
        appt.setPaymentStatus(mockPaymentsEnabled() && (appt.getRazorpayPaymentId() == null
                || appt.getRazorpayPaymentId().startsWith("mock_"))
                ? STATUS_MOCK_PAID
                : STATUS_PAID);
        if (appt.getReceiptNumber() == null || appt.getReceiptNumber().isBlank()) {
            appt.setReceiptNumber(generateReceiptNumber(appt));
        }

        Doctor doctor = appt.getDoctor();
        if (doctor != null) {
            double bal = doctor.getPayoutBalance() == null ? 0 : doctor.getPayoutBalance();
            double total = doctor.getTotalEarned() == null ? 0 : doctor.getTotalEarned();
            doctor.setPayoutBalance(bal + doctorEarning);
            doctor.setTotalEarned(total + doctorEarning);
            if (doctor.getCommissionPercent() == null) {
                doctor.setCommissionPercent(defaultCommissionPercent);
            }
            doctorRepository.save(doctor);
        }
    }

    public String generateMeetingPassword() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 8);
    }

    public String generatePrivateRoomId(Long appointmentId) {
        String suffix = UUID.randomUUID().toString().substring(0, 8);
        return "FDF-DOC-" + (appointmentId == null ? "NEW" : appointmentId) + "-" + suffix;
    }

    @Transactional
    public Map<String, Object> refundIfPaid(DoctorAppointment appt, String cancelledBy, String reason) {
        Map<String, Object> result = new HashMap<>();
        result.put("refunded", false);
        if (appt == null) {
            return result;
        }
        appt.setCancelledBy(cancelledBy);
        if (reason != null && !reason.isBlank()) {
            appt.setCancelReason(reason.trim());
        }

        Double paid = appt.getAmountPaid();
        String paymentId = appt.getRazorpayPaymentId();
        boolean wasPaid = paid != null && paid > 0
                && (STATUS_PAID.equals(appt.getPaymentStatus())
                || STATUS_MOCK_PAID.equals(appt.getPaymentStatus())
                || (appt.getPaymentStatus() == null && paymentId != null && !paymentId.isBlank()));

        if (!wasPaid) {
            appointmentRepository.save(appt);
            return result;
        }

        if (STATUS_REFUNDED.equals(appt.getPaymentStatus())) {
            result.put("refunded", true);
            result.put("alreadyRefunded", true);
            return result;
        }

        // Reverse doctor payout balance if previously credited
        reverseDoctorEarning(appt);

        if (paymentId != null && paymentId.startsWith("mock_")) {
            appt.setPaymentStatus(STATUS_REFUNDED);
            appt.setRefundId("mock_rfnd_" + System.currentTimeMillis());
            appt.setRefundAmount(paid);
            appt.setRefundedAt(LocalDateTime.now());
            appointmentRepository.save(appt);
            result.put("refunded", true);
            result.put("refundId", appt.getRefundId());
            result.put("amount", paid);
            notifyRefund(appt);
            return result;
        }

        if (!razorpayConfigured() || paymentId == null || paymentId.isBlank()) {
            appt.setPaymentStatus(STATUS_REFUND_PENDING);
            appointmentRepository.save(appt);
            result.put("refunded", false);
            result.put("pendingManual", true);
            result.put("message", "Payment marked for manual refund");
            return result;
        }

        try {
            RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
            JSONObject req = new JSONObject();
            req.put("amount", (int) Math.round(paid * 100));
            req.put("speed", "normal");
            Refund refund = client.payments.refund(paymentId, req);
            String refundId = refund.get("id");
            appt.setRefundId(refundId);
            appt.setRefundAmount(paid);
            appt.setRefundedAt(LocalDateTime.now());
            appt.setPaymentStatus(STATUS_REFUNDED);
            appointmentRepository.save(appt);
            result.put("refunded", true);
            result.put("refundId", refundId);
            result.put("amount", paid);
            notifyRefund(appt);
            return result;
        } catch (Exception ex) {
            appt.setPaymentStatus(STATUS_REFUND_PENDING);
            appointmentRepository.save(appt);
            result.put("refunded", false);
            result.put("error", "Refund failed: " + ex.getMessage());
            result.put("pendingManual", true);
            return result;
        }
    }

    public Map<String, Object> receiptPayload(DoctorAppointment appt) {
        Map<String, Object> m = new HashMap<>();
        if (appt == null) {
            return m;
        }
        m.put("receiptNumber", appt.getReceiptNumber());
        m.put("appointmentId", appt.getId());
        m.put("amountPaid", appt.getAmountPaid());
        m.put("platformFee", appt.getPlatformFee());
        m.put("doctorEarning", appt.getDoctorEarning());
        m.put("paymentStatus", appt.getPaymentStatus());
        m.put("razorpayPaymentId", appt.getRazorpayPaymentId());
        m.put("razorpayOrderId", appt.getRazorpayOrderId());
        m.put("refundId", appt.getRefundId());
        m.put("refundAmount", appt.getRefundAmount());
        m.put("status", appt.getStatus() == null ? null : appt.getStatus().name());
        m.put("appointmentTime", appt.getAppointmentTime() == null ? null : appt.getAppointmentTime().toString());
        m.put("consultationType", appt.getConsultationType() == null ? null : appt.getConsultationType().name());
        if (appt.getDoctor() != null) {
            m.put("doctorName", appt.getDoctor().getFullName());
            m.put("doctorId", appt.getDoctor().getId());
        }
        if (appt.getUser() != null) {
            m.put("patientName", appt.getUser().getFullName());
            m.put("patientId", appt.getUser().getId());
        }
        return m;
    }

    private void reverseDoctorEarning(DoctorAppointment appt) {
        if (appt.getDoctorEarning() == null || appt.getDoctorEarning() <= 0 || appt.getDoctor() == null) {
            return;
        }
        Doctor doctor = appt.getDoctor();
        double bal = doctor.getPayoutBalance() == null ? 0 : doctor.getPayoutBalance();
        doctor.setPayoutBalance(Math.max(0, bal - appt.getDoctorEarning()));
        doctorRepository.save(doctor);
    }

    private void notifyRefund(DoctorAppointment appt) {
        if (appt.getDoctor() != null) {
            notificationService.notifyDoctor(
                    appt.getDoctor(),
                    "PAYMENT_REFUND",
                    "Booking refunded",
                    "Appointment #" + appt.getId() + " refund of ₹"
                            + (appt.getRefundAmount() == null ? 0 : appt.getRefundAmount().intValue())
                            + " was issued.",
                    true);
        }
        if (appt.getUser() != null) {
            pushNotificationService.notifyUser(
                    appt.getUser().getId(),
                    "Payment refunded",
                    "Your Women Doctor booking #" + appt.getId() + " was refunded.",
                    Map.of("type", "DOCTOR_REFUND", "appointmentId", String.valueOf(appt.getId())));
        }
    }

    private String generateReceiptNumber(DoctorAppointment appt) {
        String day = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd", Locale.ROOT));
        long idPart = appt.getId() == null ? System.currentTimeMillis() % 100000 : appt.getId();
        return "FDF-DOC-" + day + "-" + idPart;
    }

    public void requireCancellableForRefund(DoctorAppointment appt) {
        if (appt.getStatus() == DoctorAppointmentStatus.COMPLETED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Completed appointments cannot be refunded via cancel");
        }
    }
}
