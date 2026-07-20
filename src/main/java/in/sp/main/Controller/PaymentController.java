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

    @PostMapping("/pay")
    @ResponseBody
    public String processDirectPayment(@RequestBody Map<String, Object> payload, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "Please login to make a payment.";
        }
        try {
            double amount = Double.parseDouble(payload.get("amount").toString());
            Payment payment = new Payment();
            payment.setUserId(user.getId());
            payment.setAmount(amount);
            payment.setStatus("Success");
            paymentRepository.save(payment);
            return "Payment of $" + amount + " successful!";
        } catch (Exception e) {
            return "Payment failed: " + e.getMessage();
        }
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
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(401).build();
        }

        try {
            String amountStr = data.get("amount").toString().replaceAll("[^0-9.]", "");
            double amount = 0;
            try {
                amount = Double.parseDouble(amountStr);
            } catch (NumberFormatException nfe) {
                amount = 0;
            }
            if (amount <= 0) amount = 1.0; // Razorpay requires positive amount
            String type = data.get("type").toString(); // "DOCTOR" or "BEAUTY" or "MARTIAL_ARTS"

            RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", (int) (amount * 100)); // amount in paise
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_" + System.currentTimeMillis());

            Order order = client.orders.create(orderRequest);

            Map<String, Object> response = new HashMap<>();
            response.put("orderId", order.get("id"));
            response.put("amount", order.get("amount"));
            response.put("key", razorpayKeyId);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    @PostMapping("/verify")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifyPayment(@RequestBody Map<String, Object> data, HttpSession session) {
        Map<String, Object> responseMap = new HashMap<>();
        try {
            String orderId = Objects.toString(data.get("razorpay_order_id"), "");
            String paymentId = Objects.toString(data.get("razorpay_payment_id"), "");
            String signature = Objects.toString(data.get("razorpay_signature"), "");
            String type = Objects.toString(data.get("type"), "");
            
            System.out.println("Verifying Payment: Order=" + orderId + ", Type=" + type);

            boolean isValid = false;
            try {
                // Bypass for test keys or development environments
                if (razorpayKeyId != null && razorpayKeyId.startsWith("rzp_test_")) {
                    isValid = true;
                } else if (!orderId.isEmpty() && !paymentId.isEmpty() && !signature.isEmpty()) {
                    JSONObject options = new JSONObject();
                    options.put("razorpay_order_id", orderId);
                    options.put("razorpay_payment_id", paymentId);
                    options.put("razorpay_signature", signature);
                    isValid = Utils.verifyPaymentSignature(options, razorpayKeySecret);
                }
            } catch (Exception e) {
                System.out.println("Signature Verification Exception: " + e.getMessage());
                if (razorpayKeyId != null && razorpayKeyId.startsWith("rzp_test_")) isValid = true;
            }

            if (isValid) {
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    responseMap.put("error", "Session expired. Please login again.");
                    return ResponseEntity.status(401).body(responseMap);
                }

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
                    appt.setAmountPaid(Double.parseDouble(data.get("amount").toString()));
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
                    booking.setPricePaid(Double.parseDouble(data.get("amount").toString()));
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
                            System.out.println("Invalid enrollmentId: " + enrollmentIdObj);
                        }
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
                    
                    // Safe amount parsing — handles NaN, null, locale-formatted strings
                    double parsedAmount = 0.0;
                    try {
                        Object amtObj = data.get("amount");
                        if (amtObj != null) {
                            String amtStr = amtObj.toString().replaceAll("[^0-9.]", "");
                            if (!amtStr.isEmpty()) {
                                parsedAmount = Double.parseDouble(amtStr);
                            }
                        }
                    } catch (Exception amtEx) {
                        System.out.println("Amount parse warning: " + amtEx.getMessage());
                    }
                    enrollment.setAmountPaid(parsedAmount);
                    enrollmentRepository.save(enrollment);

                    if (enrollment.getCenter() != null) {
                        user.setMartialArtsCenter(enrollment.getCenter());
                        userRepo.save(user);
                    }
                } else if ("MARKETPLACE".equals(type)) {
                    Object enrollmentIdObj = data.get("enrollmentId");
                    Long enrollmentId = Long.parseLong(enrollmentIdObj.toString());
                    MarketplaceEnrollment enrollment = marketplaceEnrollmentRepo.findById(enrollmentId).orElse(null);
                    if (enrollment != null) {
                        enrollment.setPaymentStatus("PAID");
                        enrollment.setRazorpayOrderId(orderId);
                        enrollment.setRazorpayPaymentId(paymentId);
                        enrollment.setRazorpaySignature(signature);
                        
                        double parsedAmount = 0.0;
                        try {
                            Object amtObj = data.get("amount");
                            if (amtObj != null) {
                                String amtStr = amtObj.toString().replaceAll("[^0-9.]", "");
                                if (!amtStr.isEmpty()) {
                                    parsedAmount = Double.parseDouble(amtStr);
                                }
                            }
                        } catch (Exception amtEx) {
                            System.out.println("Amount parse warning: " + amtEx.getMessage());
                        }
                        enrollment.setAmountPaid(parsedAmount);
                        marketplaceEnrollmentRepo.save(enrollment);
                    }
                } else if ("WORKER_BOOKING".equals(type)) {
                    Object targetIdObj = data.get("targetId");
                    Long targetId = Long.parseLong(targetIdObj.toString());
                    in.sp.main.Entities.WorkerBooking booking = workerBookingRepo.findById(targetId).orElse(null);
                    if (booking != null) {
                        booking.setStatus("PAID");
                        workerBookingRepo.save(booking);

                        double amountPaid = booking.getTotalAmount() != null ? booking.getTotalAmount() : 0.0;
                        
                        // Update Worker Wallet (CREDIT)
                        User worker = booking.getJobApplication().getUser();
                        if (worker != null) {
                            worker.setWalletBalance((worker.getWalletBalance() != null ? worker.getWalletBalance() : 0.0) + amountPaid);
                            userRepo.save(worker);
                            
                            in.sp.main.Entities.WalletTransaction workerTx = new in.sp.main.Entities.WalletTransaction(
                                worker, amountPaid, "CREDIT", "Payment received for booking from " + booking.getClient().getFullName(), java.time.LocalDateTime.now()
                            );
                            walletTransactionRepo.save(workerTx);
                        }

                        // Record Client Transaction (DEBIT)
                        User client = booking.getClient();
                        if (client != null) {
                            in.sp.main.Entities.WalletTransaction clientTx = new in.sp.main.Entities.WalletTransaction(
                                client, amountPaid, "DEBIT", "Payment made for worker booking", java.time.LocalDateTime.now()
                            );
                            walletTransactionRepo.save(clientTx);
                        }
                    }
                }

                responseMap.put("status", "success");
                return ResponseEntity.ok(responseMap);
            } else {
                responseMap.put("error", "Invalid Payment Signature.");
                return ResponseEntity.status(400).body(responseMap);
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("error", "Server Error: " + e.getMessage());
            return ResponseEntity.status(500).body(responseMap);
        }
    }
}

