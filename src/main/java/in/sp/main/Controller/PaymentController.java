package in.sp.main.Controller;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.Utils;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    /**
     * Server-side pending orders for Flutter / cookie-less clients.
     * Web browsers still also keep a session copy for compatibility.
     */
    private static final ConcurrentHashMap<String, PendingOrder> PENDING_ORDERS = new ConcurrentHashMap<>();
    private static final long PENDING_TTL_MS = 30 * 60 * 1000L;

    private record PendingOrder(
            long userId,
            int amountPaise,
            long createdAtMs,
            String type,
            Long targetId,
            String consultationType,
            String appointmentTime,
            String reason) {}

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    @Value("${app.payments.mock-enabled:false}")
    private boolean paymentMockEnabled;

    @Value("${razorpay.webhook.secret:}")
    private String razorpayWebhookSecret;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private DoctorAppointmentRepository appointmentRepo;

    @Autowired
    private DoctorRepository doctorRepo;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private StylistServiceRepository serviceRepository;

    @Autowired
    private ReviewRepository reviewRepo;
    
    @Autowired
    private in.sp.main.Repository.WalletTransactionRepository walletTransactionRepo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private MartialArtsCenterRepository centerRepository;

    @Autowired
    private MartialArtsTypeRepository typeRepository;

    @Autowired
    private in.sp.main.Service.DoctorBookingService doctorBookingService;

    @Autowired
    private in.sp.main.Service.DoctorPaymentService doctorPaymentService;

    @Autowired
    private in.sp.main.Repository.DoctorPaymentEventRepository doctorPaymentEventRepository;

    @Autowired
    private SlotRepository slotRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private MarketplaceEnrollmentRepository marketplaceEnrollmentRepo;
    
    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

    @Autowired
    private Booking1Repository booking1Repository;

    @GetMapping("")
    public String showPaymentPage(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "payment";
    }

    /**
     * Legacy stub that marked payments Success with no gateway check — disabled.
     * Use /payment/create-order + /payment/verify (Razorpay) instead.
     */
    @PostMapping("/pay")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processDirectPayment() {
        Map<String, Object> body = new HashMap<>();
        body.put("error", "Direct payment is disabled. Use Razorpay checkout.");
        return ResponseEntity.status(410).body(body);
    }

    private boolean razorpayConfigured() {
        return doctorPaymentService != null
                ? doctorPaymentService.razorpayConfigured()
                : (razorpayKeyId != null && !razorpayKeyId.isBlank()
                && razorpayKeySecret != null && !razorpayKeySecret.isBlank());
    }

    private boolean paymentsAvailable() {
        return doctorPaymentService.paymentsAvailable();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Integer> pendingOrders(HttpSession session) {
        Object raw = session.getAttribute("pendingRazorpayOrders");
        if (raw instanceof Map<?, ?> map) {
            return (Map<String, Integer>) map;
        }
        Map<String, Integer> pending = new HashMap<>();
        session.setAttribute("pendingRazorpayOrders", pending);
        return pending;
    }

    private void rememberPendingOrder(
            String orderId,
            User user,
            int amountPaise,
            HttpSession session,
            String type,
            Long targetId,
            String consultationType,
            String appointmentTime,
            String reason) {
        purgeExpiredPendingOrders();
        PENDING_ORDERS.put(orderId, new PendingOrder(
                user.getId(),
                amountPaise,
                System.currentTimeMillis(),
                type,
                targetId,
                consultationType,
                appointmentTime,
                reason));
        pendingOrders(session).put(orderId, amountPaise);
    }

    /** Backward-compatible overload for non-doctor payment types. */
    private void rememberPendingOrder(String orderId, User user, int amountPaise, HttpSession session) {
        rememberPendingOrder(orderId, user, amountPaise, session, null, null, null, null, null);
    }

    private PendingOrder takePendingOrder(String orderId, User user, HttpSession session) {
        purgeExpiredPendingOrders();
        PendingOrder global = PENDING_ORDERS.get(orderId);
        if (global != null) {
            if (global.userId() != user.getId()) {
                return null;
            }
            PENDING_ORDERS.remove(orderId);
            pendingOrders(session).remove(orderId);
            return global;
        }
        Map<String, Integer> pending = pendingOrders(session);
        Integer amount = pending.remove(orderId);
        if (amount == null) {
            return null;
        }
        return new PendingOrder(user.getId(), amount, System.currentTimeMillis(), null, null, null, null, null);
    }

    private Integer takePendingAmountPaise(String orderId, User user, HttpSession session) {
        PendingOrder order = takePendingOrder(orderId, user, session);
        return order == null ? null : order.amountPaise();
    }

    private void purgeExpiredPendingOrders() {
        long now = System.currentTimeMillis();
        PENDING_ORDERS.entrySet().removeIf(e -> now - e.getValue().createdAtMs() > PENDING_TTL_MS);
    }

    private boolean verifyRazorpaySignature(String orderId, String paymentId, String signature) throws Exception {
        if (orderId.isBlank() || paymentId.isBlank() || signature.isBlank()) {
            return false;
        }
        JSONObject options = new JSONObject();
        options.put("razorpay_order_id", orderId);
        options.put("razorpay_payment_id", paymentId);
        options.put("razorpay_signature", signature);
        return Utils.verifyPaymentSignature(options, razorpayKeySecret);
    }

    @GetMapping("/users/my-payments")
    public String showMyPayments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "myPayments";
    }

    @GetMapping("/api/payments/my-payments")
    @ResponseBody
    public in.sp.main.dto.PaymentResponseDTO getMyPayments(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new in.sp.main.dto.PaymentResponseDTO();

        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        List<Payment> payments = paymentRepository.findByUserId(user.getId());

        List<Map<String, Object>> transactions = new ArrayList<>();
        double totalPaid = 0;
        double totalFees = 0;

        // Add Enrollment payments
        for (Enrollment e : enrollments) {
            double paid = (e.getAmountPaid() != null) ? e.getAmountPaid() : 0.0;
            double fee = (e.getBatch() != null && e.getBatch().getFee() != null) ? e.getBatch().getFee() : 0.0;
            
            totalFees += fee;
            totalPaid += paid;

            if (paid > 0) {
                Map<String, Object> t = new HashMap<>();
                t.put("date", "Recent"); 
                t.put("amount", paid);
                t.put("status", "Success");
                t.put("description", "Enrollment: " + (e.getBatch() != null ? e.getBatch().getName() : "Martial Arts"));
                transactions.add(t);
            }
        }

        // Add direct payments
        for (Payment p : payments) {
            Map<String, Object> t = new HashMap<>();
            t.put("date", "Transaction");
            t.put("amount", p.getAmount());
            t.put("status", p.getStatus());
            t.put("description", "Direct Payment");
            transactions.add(t);
            totalPaid += p.getAmount();
        }

        double pending = Math.max(0, totalFees - totalPaid);
        String nextDue = (pending > 0) ? "10 " + java.time.LocalDate.now().plusMonths(1).getMonth().name() : "No Dues";

        return new in.sp.main.dto.PaymentResponseDTO(
            totalPaid,
            pending,
            nextDue,
            transactions
        );
    }
    @GetMapping("/config")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> paymentConfig(HttpSession session) {
        Map<String, Object> body = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            body.put("error", "Login required");
            return ResponseEntity.status(401).body(body);
        }
        boolean ready = paymentsAvailable();
        body.put("configured", ready);
        body.put("mock", doctorPaymentService.mockPaymentsEnabled());
        body.put("currency", "INR");
        if (razorpayConfigured()) {
            body.put("key", razorpayKeyId);
        } else if (doctorPaymentService.mockPaymentsEnabled()) {
            body.put("key", "rzp_test_mock");
        }
        return ResponseEntity.ok(body);
    }

    @PostMapping("/create-order")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createOrder(@RequestBody Map<String, Object> data, HttpSession session) {
        Map<String, Object> errorBody = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            errorBody.put("error", "Login required");
            return ResponseEntity.status(401).body(errorBody);
        }
        if (!paymentsAvailable()) {
            errorBody.put("error", "Payment gateway is not configured. Set RAZORPAY_KEY_ID/SECRET or enable app.payments.mock-enabled=true for local testing.");
            return ResponseEntity.status(503).body(errorBody);
        }

        try {
            String type = Objects.toString(data.get("type"), "").trim().toUpperCase(Locale.ROOT);
            Long targetId = null;
            String consultationType = null;
            String appointmentTime = Objects.toString(data.get("appointmentTime"), "").trim();
            String reason = Objects.toString(data.get("reason"), "").trim();
            double amount;
            if ("DOCTOR".equals(type)) {
                Object targetIdObj = data.get("targetId");
                if (targetIdObj == null) {
                    errorBody.put("error", "Doctor id is required");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                targetId = Long.parseLong(targetIdObj.toString());
                Doctor d = doctorRepo.findById(targetId).orElse(null);
                consultationType = Objects.toString(data.get("consultationType"), "CLINIC");
                ConsultationType cType = MobileDoctorController.parseConsultationType(consultationType);
                amount = doctorBookingService.resolveFee(d, cType);
                if (amount <= 0) {
                    errorBody.put("error", "This doctor does not require payment. Book without payment.");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                if (appointmentTime.isBlank()) {
                    errorBody.put("error", "appointmentTime is required for doctor payments");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                LocalDateTime apptTime = MobileDoctorController.parseAppointmentTime(appointmentTime);
                if (apptTime == null) {
                    errorBody.put("error", "Invalid appointmentTime");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                doctorBookingService.requireBookableDoctor(d);
                doctorBookingService.validateAppointmentSlotForPayment(d, user, apptTime);
            } else {
                Object amountRaw = data.get("amount");
                if (amountRaw == null) {
                    errorBody.put("error", "Amount is required");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                String amountStr = amountRaw.toString().replaceAll("[^0-9.]", "");
                try {
                    amount = Double.parseDouble(amountStr);
                } catch (NumberFormatException nfe) {
                    errorBody.put("error", "Invalid amount");
                    return ResponseEntity.badRequest().body(errorBody);
                }
            }
            if (amount <= 0) {
                errorBody.put("error", "Amount must be greater than zero");
                return ResponseEntity.badRequest().body(errorBody);
            }

            int amountPaise = (int) Math.round(amount * 100);
            String orderId;
            String key;

            if (doctorPaymentService.mockPaymentsEnabled()) {
                orderId = "order_mock_" + user.getId() + "_" + System.currentTimeMillis();
                key = "rzp_test_mock";
            } else {
                RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
                JSONObject orderRequest = new JSONObject();
                orderRequest.put("amount", amountPaise);
                orderRequest.put("currency", "INR");
                orderRequest.put("receipt", "txn_" + user.getId() + "_" + System.currentTimeMillis());
                Order order = client.orders.create(orderRequest);
                orderId = order.get("id").toString();
                key = razorpayKeyId;
            }

            rememberPendingOrder(orderId, user, amountPaise, session, type, targetId, consultationType, appointmentTime, reason);

            Map<String, Object> response = new HashMap<>();
            response.put("orderId", orderId);
            response.put("amount", amountPaise);
            response.put("currency", "INR");
            response.put("key", key);
            response.put("mock", doctorPaymentService.mockPaymentsEnabled());
            response.put("amountRupees", amount);
            return ResponseEntity.ok(response);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            errorBody.put("error", ex.getReason());
            return ResponseEntity.status(ex.getStatusCode().value()).body(errorBody);
        } catch (Exception e) {
            e.printStackTrace();
            errorBody.put("error", "Failed to create payment order");
            return ResponseEntity.status(500).body(errorBody);
        }
    }

    @PostMapping("/verify")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifyPayment(@RequestBody Map<String, Object> data, HttpSession session) {
        Map<String, Object> responseMap = new HashMap<>();
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                responseMap.put("error", "Session expired. Please login again.");
                return ResponseEntity.status(401).body(responseMap);
            }
            if (!paymentsAvailable()) {
                responseMap.put("error", "Payment gateway is not configured");
                return ResponseEntity.status(503).body(responseMap);
            }

            String orderId = Objects.toString(data.get("razorpay_order_id"), "").trim();
            String paymentId = Objects.toString(data.get("razorpay_payment_id"), "").trim();
            String signature = Objects.toString(data.get("razorpay_signature"), "").trim();
            String type = Objects.toString(data.get("type"), "").trim();

            PendingOrder pending = takePendingOrder(orderId, user, session);
            if (pending == null) {
                responseMap.put("error", "Unknown or expired payment order. Create a new order and try again.");
                return ResponseEntity.status(400).body(responseMap);
            }
            int expectedPaise = pending.amountPaise();

            boolean isValid;
            try {
                if (doctorPaymentService.mockPaymentsEnabled()
                        || orderId.startsWith("order_mock_")
                        || paymentId.startsWith("mock_")) {
                    isValid = !orderId.isBlank() && !paymentId.isBlank();
                    if (paymentId.isBlank()) {
                        paymentId = "mock_pay_" + System.currentTimeMillis();
                    }
                    if (signature.isBlank()) {
                        signature = "mock_sig";
                    }
                } else {
                    isValid = verifyRazorpaySignature(orderId, paymentId, signature);
                }
            } catch (Exception e) {
                responseMap.put("error", "Payment signature verification failed.");
                return ResponseEntity.status(400).body(responseMap);
            }

            if (!isValid) {
                responseMap.put("error", "Invalid payment signature.");
                return ResponseEntity.status(400).body(responseMap);
            }

            // Authoritative amount from the order we created (never trust client-supplied amount)
            double amountPaid = expectedPaise / 100.0;

            DateTimeFormatter formatterT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            DateTimeFormatter formatterSpace = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

            if ("DOCTOR".equalsIgnoreCase(type) || "DOCTOR".equalsIgnoreCase(Objects.toString(pending.type(), ""))) {
                Long targetId = pending.targetId();
                if (targetId == null && data.get("targetId") != null) {
                    targetId = Long.parseLong(data.get("targetId").toString());
                }
                Doctor d = doctorRepo.findById(targetId).orElse(null);

                String consultTypeStr = pending.consultationType() != null && !pending.consultationType().isBlank()
                        ? pending.consultationType()
                        : data.getOrDefault("consultationType", "CLINIC").toString();
                ConsultationType cType = MobileDoctorController.parseConsultationType(consultTypeStr);

                String apptTimeStr = pending.appointmentTime() != null && !pending.appointmentTime().isBlank()
                        ? pending.appointmentTime()
                        : (data.get("appointmentTime") == null ? "" : data.get("appointmentTime").toString());
                LocalDateTime apptTime = MobileDoctorController.parseAppointmentTime(apptTimeStr);
                if (apptTime == null) {
                    try {
                        apptTime = LocalDateTime.parse(apptTimeStr, formatterSpace);
                    } catch (Exception ex) {
                        apptTime = LocalDateTime.parse(apptTimeStr, formatterT);
                    }
                }

                String reason = pending.reason() != null && !pending.reason().isBlank()
                        ? pending.reason()
                        : Objects.toString(data.get("reason"), "");

                try {
                    DoctorAppointment appt = doctorBookingService.createPaidBooking(
                            d,
                            user,
                            apptTime,
                            cType,
                            reason,
                            amountPaid,
                            orderId,
                            paymentId,
                            signature);
                    responseMap.put("appointmentId", appt.getId());
                    responseMap.put("meetingRoomId", appt.getMeetingRoomId());
                    responseMap.put("meetingPassword", appt.getMeetingPassword());
                    responseMap.put("status", appt.getStatus().name());
                    responseMap.put("receipt", doctorPaymentService.receiptPayload(appt));
                    responseMap.put("success", true);
                } catch (org.springframework.web.server.ResponseStatusException ex) {
                    responseMap.put("error", ex.getReason());
                    return ResponseEntity.status(ex.getStatusCode().value()).body(responseMap);
                }
            } else if ("BEAUTY".equals(type)) {
                Object targetIdObj = data.get("targetId");
                Long targetId = (targetIdObj != null) ? Long.parseLong(targetIdObj.toString()) : null;
                Long stylistId = Long.parseLong(data.get("stylistId").toString());
                Stylist stylist = stylistRepository.findById(stylistId).orElse(null);
                StylistService service = serviceRepository.findById(targetId).orElse(null);

                Booking booking = new Booking();
                booking.setUser(user);
                booking.setStylist(stylist);
                booking.setService(service);
                if (stylist != null) booking.setSalon(stylist.getSalon());
                booking.setBookingTime(LocalDateTime.parse(data.get("bookingTime").toString(), formatterT));
                booking.setStatus(BookingStatus.CONFIRMED);
                booking.setPricePaid(amountPaid);
                booking.setPaymentMode("RAZORPAY");
                booking.setRazorpayOrderId(orderId);
                booking.setRazorpayPaymentId(paymentId);
                booking.setRazorpaySignature(signature);
                bookingRepository.save(booking);
            } else if ("MARTIAL_ARTS".equals(type)) {
                Object enrollmentIdObj = data.get("enrollmentId");
                Enrollment enrollment = null;
                if (enrollmentIdObj != null && !enrollmentIdObj.toString().equals("null") && !enrollmentIdObj.toString().isEmpty()) {
                    try {
                        enrollment = enrollmentRepository.findById(Long.parseLong(enrollmentIdObj.toString())).orElse(null);
                    } catch (NumberFormatException nfe) {
                        // fall through to create new enrollment
                    }
                }

                if (enrollment != null && (enrollment.getUser() == null || !enrollment.getUser().getId().equals(user.getId()))) {
                    responseMap.put("error", "Enrollment does not belong to this user.");
                    return ResponseEntity.status(403).body(responseMap);
                }

                if (enrollment == null) {
                    enrollment = new Enrollment();

                    Object cId = data.get("centerId");
                    if (cId != null && !cId.toString().isEmpty()) {
                        try {
                            enrollment.setCenter(centerRepository.findById(Long.parseLong(cId.toString())).orElse(null));
                        } catch (NumberFormatException ignored) {}
                    }

                    Object bId = data.get("batchId");
                    if (bId != null && !bId.toString().isEmpty()) {
                        try {
                            enrollment.setBatch(batchRepository.findById(Long.parseLong(bId.toString())).orElse(null));
                        } catch (NumberFormatException ignored) {}
                    }

                    enrollment.setUser(user);
                }

                enrollment.setStatus(TrainingStatus.APPROVED);
                enrollment.setPaymentStatus("PAID");
                enrollment.setRazorpayOrderId(orderId);
                enrollment.setRazorpayPaymentId(paymentId);
                enrollment.setRazorpaySignature(signature);
                enrollment.setAmountPaid(amountPaid);
                enrollmentRepository.save(enrollment);

                if (enrollment.getCenter() != null) {
                    user.setMartialArtsCenter(enrollment.getCenter());
                    userRepo.save(user);
                }
            } else if ("MARKETPLACE".equals(type)) {
                Object enrollmentIdObj = data.get("enrollmentId");
                Long enrollmentId = Long.parseLong(enrollmentIdObj.toString());
                MarketplaceEnrollment enrollment = marketplaceEnrollmentRepo.findById(enrollmentId).orElse(null);
                if (enrollment == null || enrollment.getUser() == null || !enrollment.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Enrollment not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                enrollment.setPaymentStatus("PAID");
                enrollment.setRazorpayOrderId(orderId);
                enrollment.setRazorpayPaymentId(paymentId);
                enrollment.setRazorpaySignature(signature);
                enrollment.setAmountPaid(amountPaid);
                marketplaceEnrollmentRepo.save(enrollment);
            } else if ("WORKER_BOOKING".equals(type)) {
                Object targetIdObj = data.get("targetId");
                Long targetId = Long.parseLong(targetIdObj.toString());
                in.sp.main.Entities.WorkerBooking booking = workerBookingRepo.findById(targetId).orElse(null);
                if (booking == null || booking.getClient() == null || !booking.getClient().getId().equals(user.getId())) {
                    responseMap.put("error", "Booking not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if ("PAID".equalsIgnoreCase(booking.getStatus())) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                double expectedAmount = booking.getTotalAmount() != null ? booking.getTotalAmount() : 0.0;
                if (Math.abs(expectedAmount - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match booking total.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                booking.setStatus("PAID");
                workerBookingRepo.save(booking);

                double walletAmount = expectedAmount > 0 ? expectedAmount : amountPaid;

                User worker = booking.getJobApplication().getUser();
                if (worker != null) {
                    worker.setWalletBalance((worker.getWalletBalance() != null ? worker.getWalletBalance() : 0.0) + walletAmount);
                    userRepo.save(worker);

                    in.sp.main.Entities.WalletTransaction workerTx = new in.sp.main.Entities.WalletTransaction(
                        worker, walletAmount, "CREDIT", "Payment received for booking from " + booking.getClient().getFullName(), java.time.LocalDateTime.now()
                    );
                    walletTransactionRepo.save(workerTx);
                }

                User client = booking.getClient();
                if (client != null) {
                    in.sp.main.Entities.WalletTransaction clientTx = new in.sp.main.Entities.WalletTransaction(
                        client, walletAmount, "DEBIT", "Payment made for worker booking", java.time.LocalDateTime.now()
                    );
                    walletTransactionRepo.save(clientTx);
                }
            } else if ("GLOW_BOOKING".equals(type)) {
                Object bookingIdObj = data.get("bookingId");
                if (bookingIdObj == null) {
                    responseMap.put("error", "bookingId is required for Glow booking payment.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                Booking1 glowBooking = booking1Repository.findById(Long.parseLong(bookingIdObj.toString())).orElse(null);
                if (glowBooking == null || glowBooking.getUser() == null
                        || !glowBooking.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Glow booking not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if ("CONFIRMED".equalsIgnoreCase(glowBooking.getStatus())
                        || "PAID".equalsIgnoreCase(glowBooking.getStatus())) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                if (Math.abs(glowBooking.getPrice() - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match booking price.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                glowBooking.setStatus("CONFIRMED");
                glowBooking.setPrice(amountPaid);
                booking1Repository.save(glowBooking);
            } else {
                responseMap.put("error", "Unknown payment type.");
                return ResponseEntity.badRequest().body(responseMap);
            }

            responseMap.put("status", "success");
            responseMap.put("amountPaid", amountPaid);
            return ResponseEntity.ok(responseMap);
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("error", "Server Error: " + e.getMessage());
            return ResponseEntity.status(500).body(responseMap);
        }
    }

    /**
     * Razorpay webhook for payment.captured / payment.failed reconciliation.
     * Configure dashboard URL: POST /payment/webhook/razorpay
     */
    @PostMapping("/webhook/razorpay")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> razorpayWebhook(
            @RequestBody String rawBody,
            @RequestHeader(value = "X-Razorpay-Signature", required = false) String signature) {
        Map<String, Object> res = new HashMap<>();
        try {
            if (razorpayWebhookSecret != null && !razorpayWebhookSecret.isBlank() && signature != null) {
                boolean ok = Utils.verifyWebhookSignature(rawBody, signature, razorpayWebhookSecret);
                if (!ok) {
                    res.put("error", "Invalid webhook signature");
                    return ResponseEntity.status(400).body(res);
                }
            }
            JSONObject payload = new JSONObject(rawBody);
            String event = payload.optString("event");
            String eventId = payload.optString("id", event + "_" + System.currentTimeMillis());
            if (doctorPaymentEventRepository.findByRazorpayEventId(eventId).isPresent()) {
                res.put("success", true);
                res.put("duplicate", true);
                return ResponseEntity.ok(res);
            }
            JSONObject entity = payload.optJSONObject("payload") == null ? null
                    : payload.getJSONObject("payload").optJSONObject("payment") == null ? null
                    : payload.getJSONObject("payload").getJSONObject("payment").optJSONObject("entity");
            String paymentId = entity == null ? null : entity.optString("id", null);
            String orderId = entity == null ? null : entity.optString("order_id", null);

            DoctorPaymentEvent ev = new DoctorPaymentEvent();
            ev.setRazorpayEventId(eventId);
            ev.setEventType(event);
            ev.setRazorpayPaymentId(paymentId);
            ev.setRazorpayOrderId(orderId);
            ev.setPayload(rawBody);
            ev.setProcessed(false);
            ev.setCreatedAt(LocalDateTime.now());

            if (paymentId != null) {
                appointmentRepo.findByRazorpayPaymentId(paymentId).ifPresent(a -> ev.setAppointmentId(a.getId()));
            } else if (orderId != null) {
                appointmentRepo.findByRazorpayOrderId(orderId).ifPresent(a -> ev.setAppointmentId(a.getId()));
            }

            // Recover DOCTOR bookings when verify never ran but payment was captured
            if ("payment.captured".equals(event)
                    && orderId != null
                    && ev.getAppointmentId() == null) {
                PendingOrder pending = PENDING_ORDERS.get(orderId);
                if (pending != null
                        && "DOCTOR".equalsIgnoreCase(pending.type())
                        && pending.targetId() != null) {
                    try {
                        User user = userRepo.findById(pending.userId()).orElse(null);
                        Doctor d = doctorRepo.findById(pending.targetId()).orElse(null);
                        LocalDateTime apptTime = MobileDoctorController.parseAppointmentTime(pending.appointmentTime());
                        ConsultationType cType = MobileDoctorController.parseConsultationType(pending.consultationType());
                        if (user != null && d != null && apptTime != null) {
                            DoctorAppointment appt = doctorBookingService.createPaidBooking(
                                    d,
                                    user,
                                    apptTime,
                                    cType,
                                    pending.reason(),
                                    pending.amountPaise() / 100.0,
                                    orderId,
                                    paymentId,
                                    "webhook");
                            ev.setAppointmentId(appt.getId());
                            PENDING_ORDERS.remove(orderId);
                        }
                    } catch (Exception recoverEx) {
                        ev.setProcessed(false);
                        res.put("recoverError", recoverEx.getMessage());
                    }
                }
            }

            if (!res.containsKey("recoverError")) {
                ev.setProcessed(true);
            }
            doctorPaymentEventRepository.save(ev);
            res.put("success", true);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            res.put("error", e.getMessage());
            return ResponseEntity.status(500).body(res);
        }
    }
}

