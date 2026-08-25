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
import in.sp.main.Service.PaymentPendingOrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    private static final Logger log = LoggerFactory.getLogger(PaymentController.class);

    /** Legacy session TTL mirror for browsers; authoritative state is in DB. */
    private static final long PENDING_TTL_MS = 30 * 60 * 1000L;

    private record PendingSnapshot(
            long userId,
            int amountPaise,
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
    private in.sp.main.Service.MartialArtsCareService martialArtsCareService;

    @Autowired
    private in.sp.main.Service.GlowCareService glowCareService;

    @Autowired
    private in.sp.main.Service.WomenJobsCareService womenJobsCareService;

    @Autowired
    private in.sp.main.Service.WomenLawyerCareService womenLawyerCareService;

    @Autowired
    private in.sp.main.Service.WomenProductsCareService womenProductsCareService;

    @Autowired
    private in.sp.main.Service.FinancialLiteracyCareService financialLiteracyCareService;

    @Autowired
    private in.sp.main.Service.EventsCareService eventsCareService;

    @Autowired
    private in.sp.main.Service.CreatorCareService creatorCareService;

    @Autowired
    private in.sp.main.Service.FitnessCareService fitnessCareService;

    @Autowired
    private VideoUploadRepository videoUploadPayRepo;

    @Autowired
    private FinancialEnrollmentRepository financialEnrollmentPayRepo;

    @Autowired
    private WomenProductOrderRepository womenProductOrderPayRepo;

    @Autowired
    private ProviderBookingRepository providerBookingPayRepo;

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
    private PaymentPendingOrderService paymentPendingOrderService;

    @Autowired
    private PaymentWebhookEventRepository paymentWebhookEventRepository;

    @Value("${spring.profiles.active:}")
    private String activeProfiles;

    @Autowired
    private SlotRepository slotRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private MarketplaceEnrollmentRepository marketplaceEnrollmentRepo;

    @Autowired
    private FitnessBookingRepository fitnessBookingRepository;

    @Autowired
    private WomenEventRegistrationRepository womenEventRegistrationRepository;
    
    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

    @Autowired
    private Booking1Repository booking1Repository;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

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
        paymentPendingOrderService.savePendingOrder(
                orderId, user, amountPaise, type, targetId, consultationType, appointmentTime, reason);
        pendingOrders(session).put(orderId, amountPaise);
    }

    /** Backward-compatible overload for non-doctor payment types. */
    private void rememberPendingOrder(String orderId, User user, int amountPaise, HttpSession session) {
        rememberPendingOrder(orderId, user, amountPaise, session, null, null, null, null, null);
    }

    private PendingSnapshot resolvePendingSnapshot(String orderId, User user, HttpSession session) {
        Optional<PaymentPendingOrder> dbPending =
                paymentPendingOrderService.findPendingForUser(orderId, user.getId());
        if (dbPending.isPresent()) {
            PaymentPendingOrder p = dbPending.get();
            return new PendingSnapshot(
                    p.getUserId(),
                    p.getAmountPaise(),
                    p.getPaymentType(),
                    p.getTargetId(),
                    p.getConsultationType(),
                    p.getAppointmentTime(),
                    p.getReason());
        }
        PaymentPendingOrder fulfilled = paymentPendingOrderService.findByOrderId(orderId).orElse(null);
        if (fulfilled != null && "FULFILLED".equalsIgnoreCase(fulfilled.getStatus())
                && user.getId().equals(fulfilled.getUserId())) {
            return new PendingSnapshot(
                    fulfilled.getUserId(),
                    fulfilled.getAmountPaise(),
                    fulfilled.getPaymentType(),
                    fulfilled.getTargetId(),
                    fulfilled.getConsultationType(),
                    fulfilled.getAppointmentTime(),
                    fulfilled.getReason());
        }
        Map<String, Integer> pending = pendingOrders(session);
        Integer amount = pending.get(orderId);
        if (amount != null) {
            return new PendingSnapshot(user.getId(), amount, null, null, null, null, null);
        }
        return null;
    }

    private void finalizeSuccessfulPayment(
            String orderId,
            String paymentId,
            User user,
            String paymentType,
            Long targetId,
            int amountPaise,
            Map<String, Object> responseMap) {
        paymentPendingOrderService.findByOrderId(orderId).ifPresent(p -> {
            if ("PENDING".equalsIgnoreCase(p.getStatus())) {
                paymentPendingOrderService.markFulfilled(p, paymentId);
            }
        });
        paymentPendingOrderService.recordFulfillment(
                paymentId, orderId, user.getId(), paymentType, targetId, amountPaise, responseMap);
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
            } else if ("FINANCIAL_BOOKING".equals(type)) {
                Object registrationIdObj = data.get("registrationId") != null ? data.get("registrationId") : data.get("targetId");
                if (registrationIdObj == null) {
                    errorBody.put("error", "registrationId is required for financial session payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                FinancialEnrollment en = financialEnrollmentPayRepo
                        .findById(Long.parseLong(registrationIdObj.toString())).orElse(null);
                if (en == null || en.getUser() == null || !en.getUser().getId().equals(user.getId())) {
                    errorBody.put("error", "Registration not found or access denied");
                    return ResponseEntity.status(403).body(errorBody);
                }
                if ("cancelled".equalsIgnoreCase(en.getStatus()) || "rejected".equalsIgnoreCase(en.getStatus())) {
                    errorBody.put("error", "Registration is cancelled");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                if ("PAID".equalsIgnoreCase(en.getPaymentStatus())) {
                    errorBody.put("error", "Already paid");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                amount = en.getAmount() != null ? Math.max(0, en.getAmount()) : 0;
                if (amount <= 0) {
                    errorBody.put("error", "This session does not require payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                targetId = en.getId();
            } else if ("WOMEN_EVENT".equals(type)) {
                Object registrationIdObj = data.get("registrationId");
                if (registrationIdObj == null) {
                    errorBody.put("error", "registrationId is required for event payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                WomenEventRegistration reg = womenEventRegistrationRepository
                        .findById(Long.parseLong(registrationIdObj.toString())).orElse(null);
                if (reg == null || reg.getUser() == null || !reg.getUser().getId().equals(user.getId())) {
                    errorBody.put("error", "Event registration not found or access denied");
                    return ResponseEntity.status(403).body(errorBody);
                }
                if ("CANCELLED".equalsIgnoreCase(reg.getStatus())) {
                    errorBody.put("error", "Registration is cancelled");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                if (reg.isPaid()) {
                    errorBody.put("error", "Already paid");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                amount = reg.getEvent() != null && reg.getEvent().getEntryFee() != null
                        ? Math.max(0, reg.getEvent().getEntryFee()) : 0;
                if (amount <= 0) {
                    errorBody.put("error", "This event does not require payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
            } else if ("CREATOR_TIP".equals(type) || "CREATOR_SUB".equals(type) || "CREATOR_UNLOCK".equals(type)) {
                Object creatorIdObj = data.get("creatorId") != null ? data.get("creatorId") : data.get("targetId");
                Object videoIdObj = data.get("videoId") != null ? data.get("videoId") : data.get("registrationId");
                if ("CREATOR_UNLOCK".equals(type)) {
                    if (videoIdObj == null) {
                        errorBody.put("error", "videoId is required for unlock");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    Videoupload video = videoUploadPayRepo.findById(Long.parseLong(videoIdObj.toString())).orElse(null);
                    if (video == null) {
                        errorBody.put("error", "Post not found");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    amount = video.getPrice() == null ? 0 : Math.max(0, video.getPrice());
                    if (amount <= 0) {
                        errorBody.put("error", "This post does not require payment");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    targetId = video.getId();
                } else {
                    if (creatorIdObj == null) {
                        errorBody.put("error", "creatorId is required");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    User creator = userRepo.findById(Long.parseLong(creatorIdObj.toString())).orElse(null);
                    if (creator == null || !in.sp.main.Service.CreatorProfileService.isApprovedCreator(creator)) {
                        errorBody.put("error", "Creator not found");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    if ("CREATOR_SUB".equals(type)) {
                        amount = creator.getCreatorSubscriptionPrice() == null ? 0 : Math.max(0, creator.getCreatorSubscriptionPrice());
                        if (amount <= 0) {
                            errorBody.put("error", "Subscription not enabled");
                            return ResponseEntity.badRequest().body(errorBody);
                        }
                    } else {
                        Object amountRaw = data.get("amount");
                        if (amountRaw == null) {
                            errorBody.put("error", "Amount is required");
                            return ResponseEntity.badRequest().body(errorBody);
                        }
                        try {
                            amount = Double.parseDouble(amountRaw.toString().replaceAll("[^0-9.]", ""));
                        } catch (NumberFormatException nfe) {
                            errorBody.put("error", "Invalid amount");
                            return ResponseEntity.badRequest().body(errorBody);
                        }
                    }
                    targetId = creator.getId();
                }
            } else if ("GLOW_BOOKING".equals(type)) {
                Object bookingIdObj = data.get("bookingId") != null ? data.get("bookingId") : data.get("targetId");
                if (bookingIdObj == null) {
                    errorBody.put("error", "bookingId is required for Glow booking payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                Long bookingId = Long.parseLong(bookingIdObj.toString());
                Booking1 glowBooking = booking1Repository.findById(bookingId).orElse(null);
                if (glowBooking == null || glowBooking.getUser() == null
                        || !glowBooking.getUser().getId().equals(user.getId())) {
                    errorBody.put("error", "Booking not found or access denied");
                    return ResponseEntity.status(403).body(errorBody);
                }
                if (glowBooking.getSalon() == null) {
                    errorBody.put("error", "Invalid Glow Space booking");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                String glowSt = glowBooking.getStatus() == null ? "" : glowBooking.getStatus().trim().toUpperCase(Locale.ROOT);
                if ("CONFIRMED".equals(glowSt) || "PAID".equals(glowSt) || "COMPLETED".equals(glowSt)) {
                    errorBody.put("error", "Booking already paid");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                if ("CANCELLED".equals(glowSt) || "REJECTED".equals(glowSt)) {
                    errorBody.put("error", "Booking is not eligible for payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                amount = glowBooking.getPrice();
                if (amount <= 0) {
                    errorBody.put("error", "This booking does not require payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                targetId = bookingId;
            } else if ("MARTIAL_ARTS".equals(type)) {
                Object enrollmentIdObj = data.get("enrollmentId") != null ? data.get("enrollmentId") : data.get("targetId");
                if (enrollmentIdObj == null) {
                    errorBody.put("error", "enrollmentId is required for martial arts payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                Long enrollmentId = Long.parseLong(enrollmentIdObj.toString());
                Enrollment maEnrollment = enrollmentRepository.findById(enrollmentId).orElse(null);
                if (maEnrollment == null || maEnrollment.getUser() == null
                        || !maEnrollment.getUser().getId().equals(user.getId())) {
                    errorBody.put("error", "Enrollment not found or access denied");
                    return ResponseEntity.status(403).body(errorBody);
                }
                if (maEnrollment.getStatus() == TrainingStatus.REJECTED
                        || maEnrollment.getStatus() == TrainingStatus.CANCELLED) {
                    errorBody.put("error", "Enrollment is not eligible for payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                if (maEnrollment.getStatus() != TrainingStatus.APPROVED
                        && maEnrollment.getStatus() != TrainingStatus.IN_PROGRESS) {
                    errorBody.put("error", "Wait for the centre to approve your application before paying");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                if ("PAID".equalsIgnoreCase(maEnrollment.getPaymentStatus())) {
                    errorBody.put("error", "Enrollment already paid");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                Double batchFee = maEnrollment.getBatch() != null ? maEnrollment.getBatch().getFee() : null;
                amount = batchFee == null ? 0 : Math.max(0, batchFee);
                if (amount <= 0) {
                    errorBody.put("error", "This enrollment does not require payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                targetId = enrollmentId;
            } else if ("WOMEN_PRODUCT".equals(type)) {
                List<Long> orderIds = parseWomenProductOrderIds(data);
                if (orderIds.isEmpty()) {
                    errorBody.put("error", "orderId is required for product payment");
                    return ResponseEntity.badRequest().body(errorBody);
                }
                amount = 0;
                for (Long oid : orderIds) {
                    WomenProductOrder o = womenProductOrderPayRepo.findById(oid).orElse(null);
                    if (o == null || o.getUser() == null || !o.getUser().getId().equals(user.getId())) {
                        errorBody.put("error", "Order not found or access denied");
                        return ResponseEntity.status(403).body(errorBody);
                    }
                    if ("PAID".equalsIgnoreCase(o.getPaymentStatus())) {
                        errorBody.put("error", "Order already paid");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    if (!"ONLINE".equalsIgnoreCase(o.getPaymentMethod())) {
                        errorBody.put("error", "Order is not an online payment order");
                        return ResponseEntity.badRequest().body(errorBody);
                    }
                    amount += o.getTotalPrice() == null ? 0 : Math.max(0, o.getTotalPrice());
                }
                targetId = orderIds.get(0);
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
            log.error("Failed to create payment order", e);
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

            Optional<Map<String, Object>> cached =
                    paymentPendingOrderService.findCachedFulfillmentResponse(paymentId, orderId);
            if (cached.isPresent()) {
                Map<String, Object> cachedBody = new HashMap<>(cached.get());
                cachedBody.putIfAbsent("status", "success");
                cachedBody.put("idempotent", true);
                return ResponseEntity.ok(cachedBody);
            }

            PendingSnapshot pending = resolvePendingSnapshot(orderId, user, session);
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
                if (targetId == null) {
                    responseMap.put("error", "Doctor id is missing from this payment order.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                Doctor d = doctorRepo.findById(targetId).orElse(null);
                if (d == null) {
                    responseMap.put("error", "Doctor not found.");
                    return ResponseEntity.badRequest().body(responseMap);
                }

                String consultTypeStr = pending.consultationType() != null && !pending.consultationType().isBlank()
                        ? pending.consultationType()
                        : data.getOrDefault("consultationType", "CLINIC").toString();
                ConsultationType cType = MobileDoctorController.parseConsultationType(consultTypeStr);

                String apptTimeStr = pending.appointmentTime() != null && !pending.appointmentTime().isBlank()
                        ? pending.appointmentTime()
                        : (data.get("appointmentTime") == null ? "" : data.get("appointmentTime").toString());
                LocalDateTime apptTime = MobileDoctorController.parseAppointmentTime(apptTimeStr);
                if (apptTime == null) {
                    responseMap.put("error", "Invalid appointmentTime");
                    return ResponseEntity.badRequest().body(responseMap);
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
                Object enrollmentIdObj = data.get("enrollmentId") != null ? data.get("enrollmentId") : data.get("targetId");
                if (enrollmentIdObj == null && pending.targetId() != null) {
                    enrollmentIdObj = pending.targetId();
                }
                if (enrollmentIdObj == null || enrollmentIdObj.toString().isBlank()
                        || "null".equalsIgnoreCase(enrollmentIdObj.toString())) {
                    responseMap.put("error", "enrollmentId is required");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                Enrollment enrollment;
                try {
                    enrollment = enrollmentRepository.findById(Long.parseLong(enrollmentIdObj.toString())).orElse(null);
                } catch (NumberFormatException nfe) {
                    responseMap.put("error", "Invalid enrollmentId");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                if (enrollment == null) {
                    responseMap.put("error", "Enrollment not found");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                if (enrollment.getUser() == null || !enrollment.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Enrollment does not belong to this user.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if (enrollment.getStatus() != TrainingStatus.APPROVED
                        && enrollment.getStatus() != TrainingStatus.IN_PROGRESS) {
                    responseMap.put("error", "Centre must approve the application before payment.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                if ("PAID".equalsIgnoreCase(enrollment.getPaymentStatus())) {
                    responseMap.put("error", "Enrollment already paid");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                Double expectedFee = enrollment.getBatch() != null ? enrollment.getBatch().getFee() : null;
                double expectedAmount = expectedFee == null ? 0 : Math.max(0, expectedFee);
                if (expectedAmount <= 0) {
                    responseMap.put("error", "This enrollment does not require payment");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                if (Math.abs(expectedAmount - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match batch fee.");
                    return ResponseEntity.badRequest().body(responseMap);
                }

                enrollment.setPaymentStatus("PAID");
                enrollment.setRazorpayOrderId(orderId);
                enrollment.setRazorpayPaymentId(paymentId);
                enrollment.setRazorpaySignature(signature);
                enrollment.setAmountPaid(amountPaid);
                if (enrollment.getStatus() == TrainingStatus.APPROVED) {
                    enrollment.setStatus(TrainingStatus.IN_PROGRESS);
                }
                enrollmentRepository.save(enrollment);

                if (enrollment.getCenter() != null) {
                    user.setMartialArtsCenter(enrollment.getCenter());
                    userRepo.save(user);
                    try {
                        martialArtsCareService.creditPayout(enrollment.getCenter(), amountPaid);
                    } catch (Exception ignored) {}
                }
                if (enrollment.getBatch() != null && enrollment.getBatch().getCapacity() != null
                        && enrollment.getBatch().getCapacity() > 0) {
                    long newCount = enrollmentRepository.countPaidByBatchId(enrollment.getBatch().getId());
                    if (newCount >= enrollment.getBatch().getCapacity()) {
                        enrollment.getBatch().setStatus("Full");
                        batchRepository.save(enrollment.getBatch());
                    }
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
            } else if ("LAWYER_BOOKING".equals(type)) {
                Object targetIdObj = data.get("targetId") != null ? data.get("targetId") : data.get("bookingId");
                Long targetId = Long.parseLong(targetIdObj.toString());
                ProviderBooking booking = providerBookingPayRepo.findById(targetId).orElse(null);
                if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Booking not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if (booking.getStatus() == ProviderBookingStatus.PAID) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                double expectedAmount = booking.getTotalAmount() != null ? booking.getTotalAmount() : 0.0;
                if (expectedAmount > 0 && Math.abs(expectedAmount - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match consult fee.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                booking.setStatus(ProviderBookingStatus.PAID);
                providerBookingPayRepo.save(booking);
                try {
                    womenLawyerCareService.creditPayout(booking.getProvider(), expectedAmount > 0 ? expectedAmount : amountPaid);
                } catch (Exception ignored) {}
            } else if ("WOMEN_PRODUCT".equalsIgnoreCase(type)
                    || "WOMEN_PRODUCT".equalsIgnoreCase(Objects.toString(pending.type(), ""))) {
                List<Long> orderIds = parseWomenProductOrderIds(data);
                if (orderIds.isEmpty() && pending.targetId() != null) {
                    orderIds = List.of(pending.targetId());
                }
                if (orderIds.isEmpty()) {
                    responseMap.put("error", "Order id is missing from this payment.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                double expectedTotal = 0;
                List<WomenProductOrder> toPay = new ArrayList<>();
                for (Long oid : orderIds) {
                    WomenProductOrder order = womenProductOrderPayRepo.findById(oid).orElse(null);
                    if (order == null || order.getUser() == null || !order.getUser().getId().equals(user.getId())) {
                        responseMap.put("error", "Order not found or access denied.");
                        return ResponseEntity.status(403).body(responseMap);
                    }
                    if ("PAID".equalsIgnoreCase(order.getPaymentStatus())) {
                        continue;
                    }
                    expectedTotal += order.getTotalPrice() == null ? 0 : order.getTotalPrice();
                    toPay.add(order);
                }
                if (toPay.isEmpty()) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                if (expectedTotal > 0 && Math.abs(expectedTotal - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match order total.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                for (WomenProductOrder order : toPay) {
                    order.setPaymentMethod("ONLINE");
                    order.setPaymentStatus("PAID");
                    order.setRazorpayPaymentId(paymentId);
                    womenProductOrderPayRepo.save(order);
                    try {
                        womenProductsCareService.creditSeller(order);
                    } catch (Exception ignored) {}
                }
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

                // Broadcast live refresh to worker dashboard
                try {
                    if (booking.getJobApplication() != null && booking.getJobApplication().getUser() != null) {
                        Long workerUserId = booking.getJobApplication().getUser().getId();
                        messagingTemplate.convertAndSend("/topic/worker-bookings/" + workerUserId, "REFRESH");
                    }
                } catch (Exception ignored) {}

                double walletAmount = expectedAmount > 0 ? expectedAmount : amountPaid;

                User worker = booking.getJobApplication().getUser();
                try {
                    womenJobsCareService.creditPayout(booking.getJobApplication(), walletAmount);
                } catch (Exception ignored) {}
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
            } else if ("GLOW_BOOKING".equalsIgnoreCase(type)
                    || "GLOW_BOOKING".equalsIgnoreCase(Objects.toString(pending.type(), ""))) {
                Object bookingIdObj = data.get("bookingId") != null ? data.get("bookingId") : data.get("targetId");
                if (bookingIdObj == null && pending.targetId() != null) {
                    bookingIdObj = pending.targetId();
                }
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
                if (glowBooking.getSalon() == null) {
                    responseMap.put("error", "Invalid Glow Space booking.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                String glowSt = glowBooking.getStatus() == null ? "" : glowBooking.getStatus().trim().toUpperCase(Locale.ROOT);
                if ("CONFIRMED".equals(glowSt) || "PAID".equals(glowSt) || "COMPLETED".equals(glowSt)) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                if ("CANCELLED".equals(glowSt) || "REJECTED".equals(glowSt)) {
                    responseMap.put("error", "Booking is not eligible for payment.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                if (!"PENDING".equals(glowSt)) {
                    responseMap.put("error", "Booking is not awaiting payment.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                double expectedPrice = glowBooking.getPrice();
                if (expectedPrice > 0 && Math.abs(expectedPrice - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match booking price.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                glowBooking.setStatus("CONFIRMED");
                glowBooking.setPrice(amountPaid);
                booking1Repository.save(glowBooking);
                if (glowBooking.getSalon() != null) {
                    glowCareService.creditPayout(glowBooking.getSalon(), amountPaid);
                }
            } else if ("FITNESS".equals(type)) {
                Object bookingIdObj = data.get("bookingId");
                if (bookingIdObj == null) {
                    responseMap.put("error", "bookingId is required for fitness payment.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                FitnessBooking fitnessBooking = fitnessBookingRepository.findById(Long.parseLong(bookingIdObj.toString())).orElse(null);
                if (fitnessBooking == null || fitnessBooking.getUser() == null
                        || !fitnessBooking.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Fitness booking not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if ("PAID".equalsIgnoreCase(fitnessBooking.getPaymentStatus())) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                double expected = fitnessBooking.getPaymentAmount() == null ? 0 : fitnessBooking.getPaymentAmount();
                if (expected > 0 && Math.abs(expected - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match session fee.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                fitnessBooking.setPaymentStatus("PAID");
                fitnessBookingRepository.save(fitnessBooking);
                fitnessCareService.creditPayout(fitnessBooking);
            } else if ("FINANCIAL_BOOKING".equals(type)) {
                Object registrationIdObj = data.get("registrationId") != null
                        ? data.get("registrationId")
                        : (data.get("targetId") != null ? data.get("targetId") : data.get("enrollmentId"));
                if (registrationIdObj == null) {
                    responseMap.put("error", "registrationId is required for financial session payment.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                FinancialEnrollment en = financialEnrollmentPayRepo
                        .findById(Long.parseLong(registrationIdObj.toString())).orElse(null);
                if (en == null || en.getUser() == null || !en.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Registration not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if ("PAID".equalsIgnoreCase(en.getPaymentStatus())) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    return ResponseEntity.ok(responseMap);
                }
                double expected = en.getAmount() == null ? 0 : en.getAmount();
                if (expected > 0 && Math.abs(expected - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match session fee.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                en.setPaymentStatus("PAID");
                en.setRazorpayPaymentId(paymentId);
                if (!"approved".equalsIgnoreCase(en.getStatus()) && !"completed".equalsIgnoreCase(en.getStatus())) {
                    en.setStatus("paid");
                }
                financialEnrollmentPayRepo.save(en);
                try {
                    financialLiteracyCareService.creditPayout(en);
                } catch (Exception ignored) {}
            } else if ("WOMEN_EVENT".equals(type)) {
                Object registrationIdObj = data.get("registrationId");
                if (registrationIdObj == null) {
                    responseMap.put("error", "registrationId is required for event payment.");
                    return ResponseEntity.badRequest().body(responseMap);
                }
                WomenEventRegistration reg = womenEventRegistrationRepository
                        .findById(Long.parseLong(registrationIdObj.toString())).orElse(null);
                if (reg == null || reg.getUser() == null || !reg.getUser().getId().equals(user.getId())) {
                    responseMap.put("error", "Event registration not found or access denied.");
                    return ResponseEntity.status(403).body(responseMap);
                }
                if (reg.isPaid()) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Already paid");
                    responseMap.put("ticketCode", reg.getTicketCode());
                    return ResponseEntity.ok(responseMap);
                }
                double expected = reg.getEvent() != null && reg.getEvent().getEntryFee() != null
                        ? reg.getEvent().getEntryFee() : 0;
                if (expected > 0 && Math.abs(expected - amountPaid) > 0.05) {
                    responseMap.put("error", "Payment amount does not match event entry fee.");
                    return ResponseEntity.status(400).body(responseMap);
                }
                reg.setPaid(true);
                reg.setAmountPaid(amountPaid);
                womenEventRegistrationRepository.save(reg);
                try {
                    eventsCareService.creditPayout(reg);
                } catch (Exception ignored) {}
                responseMap.put("ticketCode", reg.getTicketCode());
            } else if ("CREATOR_TIP".equals(type) || "CREATOR_SUB".equals(type) || "CREATOR_UNLOCK".equals(type)
                    || "CREATOR_TIP".equalsIgnoreCase(Objects.toString(pending.type(), ""))
                    || "CREATOR_SUB".equalsIgnoreCase(Objects.toString(pending.type(), ""))
                    || "CREATOR_UNLOCK".equalsIgnoreCase(Objects.toString(pending.type(), ""))) {
                String payType = type.isBlank() ? Objects.toString(pending.type(), "") : type;
                Long targetId = pending.targetId();
                if ("CREATOR_UNLOCK".equalsIgnoreCase(payType)) {
                    if (targetId == null && data.get("videoId") != null) {
                        targetId = Long.parseLong(data.get("videoId").toString());
                    }
                    Videoupload video = targetId == null ? null : videoUploadPayRepo.findById(targetId).orElse(null);
                    if (video == null) {
                        responseMap.put("error", "Post not found");
                        return ResponseEntity.badRequest().body(responseMap);
                    }
                    try {
                        creatorCareService.fulfillUnlock(user, video, amountPaid);
                    } catch (Exception ignored) {}
                } else {
                    if (targetId == null && data.get("creatorId") != null) {
                        targetId = Long.parseLong(data.get("creatorId").toString());
                    }
                    User creator = targetId == null ? null : userRepo.findById(targetId).orElse(null);
                    if (creator == null) {
                        responseMap.put("error", "Creator not found");
                        return ResponseEntity.badRequest().body(responseMap);
                    }
                    try {
                        if ("CREATOR_SUB".equalsIgnoreCase(payType)) {
                            creatorCareService.fulfillSubscribe(user, creator, amountPaid);
                        } else {
                            creatorCareService.fulfillTip(user, creator, amountPaid,
                                    Objects.toString(data.get("message"), ""));
                        }
                    } catch (Exception ignored) {}
                }
            } else {
                responseMap.put("error", "Unknown payment type.");
                return ResponseEntity.badRequest().body(responseMap);
            }

            responseMap.put("status", "success");
            responseMap.put("amountPaid", amountPaid);
            String resolvedType = type.isBlank() ? Objects.toString(pending.type(), "UNKNOWN") : type;
            finalizeSuccessfulPayment(
                    orderId, paymentId, user, resolvedType, pending.targetId(), expectedPaise, responseMap);
            return ResponseEntity.ok(responseMap);
        } catch (Exception e) {
            log.error("Payment verify failed for order", e);
            responseMap.put("error", "Server Error: Payment verification failed.");
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
            boolean prodProfile = activeProfiles != null && activeProfiles.contains("prod");
            if (razorpayWebhookSecret != null && !razorpayWebhookSecret.isBlank()) {
                if (signature == null || signature.isBlank()) {
                    res.put("error", "Missing webhook signature");
                    return ResponseEntity.status(401).body(res);
                }
                boolean ok = Utils.verifyWebhookSignature(rawBody, signature, razorpayWebhookSecret);
                if (!ok) {
                    res.put("error", "Invalid webhook signature");
                    return ResponseEntity.status(401).body(res);
                }
            } else if (prodProfile) {
                res.put("error", "Webhook secret required in production");
                return ResponseEntity.status(503).body(res);
            }
            JSONObject payload = new JSONObject(rawBody);
            String event = payload.optString("event");
            String eventId = payload.optString("id", event + "_" + System.currentTimeMillis());
            if (paymentWebhookEventRepository.findByRazorpayEventId(eventId).isPresent()
                    || doctorPaymentEventRepository.findByRazorpayEventId(eventId).isPresent()) {
                res.put("success", true);
                res.put("duplicate", true);
                return ResponseEntity.ok(res);
            }
            JSONObject entity = payload.optJSONObject("payload") == null ? null
                    : payload.getJSONObject("payload").optJSONObject("payment") == null ? null
                    : payload.getJSONObject("payload").getJSONObject("payment").optJSONObject("entity");
            String paymentId = entity == null ? null : entity.optString("id", null);
            String orderId = entity == null ? null : entity.optString("order_id", null);

            PaymentWebhookEvent ev = new PaymentWebhookEvent();
            ev.setRazorpayEventId(eventId);
            ev.setEventType(event);
            ev.setRazorpayPaymentId(paymentId);
            ev.setRazorpayOrderId(orderId);
            ev.setPayload(rawBody);
            ev.setProcessed(false);
            ev.setCreatedAt(LocalDateTime.now());

            // Legacy doctor event row for backward-compatible admin queries
            DoctorPaymentEvent doctorEv = new DoctorPaymentEvent();
            doctorEv.setRazorpayEventId(eventId);
            doctorEv.setEventType(event);
            doctorEv.setRazorpayPaymentId(paymentId);
            doctorEv.setRazorpayOrderId(orderId);
            doctorEv.setPayload(rawBody);
            doctorEv.setProcessed(false);
            doctorEv.setCreatedAt(LocalDateTime.now());

            if (paymentId != null) {
                appointmentRepo.findByRazorpayPaymentId(paymentId).ifPresent(a -> {
                    ev.setProcessed(true);
                    doctorEv.setAppointmentId(a.getId());
                    doctorEv.setProcessed(true);
                });
            } else if (orderId != null) {
                appointmentRepo.findByRazorpayOrderId(orderId).ifPresent(a -> {
                    ev.setProcessed(true);
                    doctorEv.setAppointmentId(a.getId());
                    doctorEv.setProcessed(true);
                });
            }

            if ("payment.captured".equals(event) && orderId != null && doctorEv.getAppointmentId() == null) {
                paymentPendingOrderService.findByOrderId(orderId).ifPresent(pending -> {
                    if ("DOCTOR".equalsIgnoreCase(pending.getPaymentType()) && pending.getTargetId() != null) {
                        try {
                            User user = userRepo.findById(pending.getUserId()).orElse(null);
                            Doctor d = doctorRepo.findById(pending.getTargetId()).orElse(null);
                            LocalDateTime apptTime =
                                    MobileDoctorController.parseAppointmentTime(pending.getAppointmentTime());
                            ConsultationType cType =
                                    MobileDoctorController.parseConsultationType(pending.getConsultationType());
                            if (user != null && d != null && apptTime != null) {
                                DoctorAppointment appt = doctorBookingService.createPaidBooking(
                                        d,
                                        user,
                                        apptTime,
                                        cType,
                                        pending.getReason(),
                                        pending.getAmountPaise() / 100.0,
                                        orderId,
                                        paymentId,
                                        "webhook");
                                doctorEv.setAppointmentId(appt.getId());
                                ev.setProcessed(true);
                                doctorEv.setProcessed(true);
                                paymentPendingOrderService.markFulfilled(pending, paymentId);
                            }
                        } catch (Exception recoverEx) {
                            log.warn("Webhook doctor recovery failed for order {}", orderId, recoverEx);
                            res.put("recoverError", "Recovery failed");
                        }
                    }
                });
            }

            if (!res.containsKey("recoverError")) {
                ev.setProcessed(true);
                doctorEv.setProcessed(true);
            }
            paymentWebhookEventRepository.save(ev);
            doctorPaymentEventRepository.save(doctorEv);
            res.put("success", true);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            log.error("Razorpay webhook processing failed", e);
            res.put("error", "Webhook processing failed");
            return ResponseEntity.status(500).body(res);
        }
    }

    private static List<Long> parseWomenProductOrderIds(Map<String, Object> data) {
        List<Long> ids = new ArrayList<>();
        Object raw = data.get("orderIds");
        if (raw instanceof List<?> list) {
            for (Object item : list) {
                if (item == null) continue;
                try {
                    ids.add(Long.parseLong(item.toString()));
                } catch (NumberFormatException ignored) {
                    // skip invalid id
                }
            }
        }
        if (ids.isEmpty()) {
            Object one = data.get("targetId") != null ? data.get("targetId") : data.get("orderId");
            if (one != null) {
                try {
                    ids.add(Long.parseLong(one.toString()));
                } catch (NumberFormatException ignored) {
                    // skip invalid id
                }
            }
        }
        return ids;
    }
}

