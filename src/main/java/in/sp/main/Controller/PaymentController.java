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
import java.util.stream.Collectors;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

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
    private SlotRepository slotRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private MarketplaceEnrollmentRepository marketplaceEnrollmentRepo;
    
    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

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
        return razorpayKeyId != null && !razorpayKeyId.isBlank()
                && razorpayKeySecret != null && !razorpayKeySecret.isBlank();
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
    @PostMapping("/create-order")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createOrder(@RequestBody Map<String, Object> data, HttpSession session) {
        Map<String, Object> errorBody = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            errorBody.put("error", "Login required");
            return ResponseEntity.status(401).body(errorBody);
        }
        if (!razorpayConfigured()) {
            errorBody.put("error", "Payment gateway is not configured");
            return ResponseEntity.status(503).body(errorBody);
        }

        try {
            Object amountRaw = data.get("amount");
            if (amountRaw == null) {
                errorBody.put("error", "Amount is required");
                return ResponseEntity.badRequest().body(errorBody);
            }
            String amountStr = amountRaw.toString().replaceAll("[^0-9.]", "");
            double amount;
            try {
                amount = Double.parseDouble(amountStr);
            } catch (NumberFormatException nfe) {
                errorBody.put("error", "Invalid amount");
                return ResponseEntity.badRequest().body(errorBody);
            }
            if (amount <= 0) {
                errorBody.put("error", "Amount must be greater than zero");
                return ResponseEntity.badRequest().body(errorBody);
            }

            int amountPaise = (int) Math.round(amount * 100);
            RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountPaise);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_" + user.getId() + "_" + System.currentTimeMillis());

            Order order = client.orders.create(orderRequest);
            String orderId = order.get("id").toString();

            // Bind this order to the session so /verify cannot invent amounts or foreign orders
            pendingOrders(session).put(orderId, amountPaise);

            Map<String, Object> response = new HashMap<>();
            response.put("orderId", orderId);
            response.put("amount", amountPaise);
            response.put("key", razorpayKeyId);

            return ResponseEntity.ok(response);
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
            if (!razorpayConfigured()) {
                responseMap.put("error", "Payment gateway is not configured");
                return ResponseEntity.status(503).body(responseMap);
            }

            String orderId = Objects.toString(data.get("razorpay_order_id"), "").trim();
            String paymentId = Objects.toString(data.get("razorpay_payment_id"), "").trim();
            String signature = Objects.toString(data.get("razorpay_signature"), "").trim();
            String type = Objects.toString(data.get("type"), "").trim();

            Map<String, Integer> pending = pendingOrders(session);
            Integer expectedPaise = pending.get(orderId);
            if (expectedPaise == null) {
                responseMap.put("error", "Unknown or expired payment order. Create a new order and try again.");
                return ResponseEntity.status(400).body(responseMap);
            }

            boolean isValid;
            try {
                isValid = verifyRazorpaySignature(orderId, paymentId, signature);
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
            pending.remove(orderId);

            DateTimeFormatter formatterT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            DateTimeFormatter formatterSpace = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

            if ("DOCTOR".equals(type)) {
                Object targetIdObj = data.get("targetId");
                Long targetId = (targetIdObj != null) ? Long.parseLong(targetIdObj.toString()) : null;
                Doctor d = doctorRepo.findById(targetId).orElse(null);

                String consultTypeStr = data.getOrDefault("consultationType", "CLINIC").toString();
                ConsultationType cType = ConsultationType.valueOf(consultTypeStr);

                String apptTimeStr = data.get("appointmentTime").toString();
                LocalDateTime apptTime;
                try {
                    apptTime = LocalDateTime.parse(apptTimeStr, formatterSpace);
                } catch (Exception ex) {
                    apptTime = LocalDateTime.parse(apptTimeStr, formatterT);
                }

                DoctorAppointment appt = new DoctorAppointment();
                appt.setUser(user);
                appt.setDoctor(d);
                appt.setAppointmentTime(apptTime);
                appt.setReason(Objects.toString(data.get("reason"), ""));
                appt.setStatus(DoctorAppointmentStatus.PENDING);
                appt.setConsultationType(cType);
                if (cType == ConsultationType.VIDEO) {
                    appt.setMeetingRoomId("Fight D Fear-" + java.util.UUID.randomUUID().toString().substring(0, 8));
                }
                appt.setRazorpayOrderId(orderId);
                appt.setRazorpayPaymentId(paymentId);
                appt.setRazorpaySignature(signature);
                appt.setAmountPaid(amountPaid);
                appointmentRepo.save(appt);
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
}

