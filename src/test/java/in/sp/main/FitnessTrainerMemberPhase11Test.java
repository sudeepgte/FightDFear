package in.sp.main;

import in.sp.main.Controller.MobileFitnessController;
import in.sp.main.Controller.MobileFitnessTrainerAuthController;
import in.sp.main.Controller.PaymentController;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FitnessService;
import in.sp.main.Service.FitnessTrainerProfileService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(properties = {
    "app.payments.mock-enabled=true",
    "razorpay.key.id=rzp_test_key",
    "razorpay.key.secret=rzp_test_secret"
})
@ActiveProfiles("test")
@Transactional
public class FitnessTrainerMemberPhase11Test {

    @Autowired
    private FitnessTrainerProfileService trainerProfileService;

    @Autowired
    private FitnessTrainerRepository trainerRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FitnessClassRepository fitnessClassRepository;

    @Autowired
    private FitnessBookingRepository bookingRepository;

    @Autowired
    private FitnessService fitnessService;

    @Autowired
    private MobileFitnessTrainerAuthController trainerAuthController;

    @Autowired
    private MobileFitnessController fitnessController;

    @Autowired
    private PaymentController paymentController;

    @Test
    @DisplayName("Fitness Trainer 18 criteria profile completion calculation")
    public void testTrainer18CriteriaCompletion() {
        FitnessTrainer t = new FitnessTrainer();
        // Incomplete initially
        List<String> missing = trainerProfileService.missingItems(t);
        assertFalse(missing.isEmpty(), "New trainer must have missing items");
        int initialPct = trainerProfileService.calculateCompletionPct(t);
        assertEquals(0, initialPct, "Initial completion pct should be 0");
        assertFalse(trainerProfileService.isReadyForVerification(t));

        // Fill all 18 criteria
        t.setFullName("Priya Menon");
        t.setDesignation("Senior Fitness Coach");
        t.setPhone("9876543210");
        t.setExperience(5);
        t.setCredentialNumber("ACE-CPT-98765");
        t.setAddress("42 Fitness Ave, Indiranagar");
        t.setCity("Bengaluru");
        t.setState("Karnataka");
        t.setPincode("560038");
        t.setSpecializations("HIIT, Yoga, Strength Training");
        t.setAudience("Women Only, Beginners");
        t.setOpenDays("Monday, Wednesday, Friday, Saturday");
        t.setOpenTime(LocalTime.of(6, 0));
        t.setCloseTime(LocalTime.of(20, 0));
        t.setBio("Passionate women fitness expert specializing in functional conditioning.");
        t.setSessionMode("STUDIO");
        t.setTypicalPrice(500.0);
        t.setCertificationsPath("/uploads/certifications/ace_cert.pdf");
        t.setGalleryPhotos("/uploads/gallery/studio1.jpg");

        List<String> afterMissing = trainerProfileService.missingItems(t);
        assertTrue(afterMissing.isEmpty(), "Missing items must be empty when all 18 criteria are fulfilled: " + afterMissing);
        int finalPct = trainerProfileService.calculateCompletionPct(t);
        assertEquals(100, finalPct, "Completion percentage should be 100%");
        assertTrue(trainerProfileService.isReadyForVerification(t), "Trainer must be ready for verification");
    }

    @Test
    @DisplayName("Trainer classes CRUD and auto-refund cancellation")
    public void testTrainerClassesCrudAndRefund() {
        FitnessTrainer trainer = new FitnessTrainer();
        trainer.setFullName("Coach Rahul");
        trainer.setEmail("rahul.coach@test.com");
        trainer.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        trainer = trainerRepository.save(trainer);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("loggedTrainer", trainer);

        // 1. Create Class
        Map<String, Object> createBody = new HashMap<>();
        createBody.put("className", "Power Zumba Evening");
        createBody.put("category", "Zumba");
        createBody.put("description", "High-energy cardio dance class.");
        createBody.put("classDate", LocalDate.now().plusDays(2).toString());
        createBody.put("classTime", "18:00");
        createBody.put("durationMinutes", 60);
        createBody.put("sessionType", "STUDIO");
        createBody.put("maxCapacity", 25);
        createBody.put("price", 350.0);
        createBody.put("meetingLinkOrLocation", "Studio B, Indiranagar");

        ResponseEntity<Map<String, Object>> createRes = trainerAuthController.createClass(createBody, session);
        assertEquals(200, createRes.getStatusCode().value());
        assertTrue((Boolean) createRes.getBody().get("success"));
        Map<String, Object> classData = (Map<String, Object>) createRes.getBody().get("class");
        Long classId = ((Number) classData.get("id")).longValue();
        assertNotNull(classId);

        // 2. Edit Class
        Map<String, Object> editBody = new HashMap<>();
        editBody.put("price", 400.0);
        editBody.put("maxCapacity", 30);
        ResponseEntity<Map<String, Object>> editRes = trainerAuthController.editClass(classId, editBody, session);
        assertEquals(200, editRes.getStatusCode().value());
        Map<String, Object> updatedClass = (Map<String, Object>) editRes.getBody().get("class");
        assertEquals(400.0, ((Number) updatedClass.get("price")).doubleValue());

        // 3. User registers for class and trainer deletes class -> verify refund to user wallet
        User user = new User();
        user.setFullName("Client Maya");
        user.setEmail("maya.client@test.com");
        user.setWalletBalance(100.0);
        user = userRepository.save(user);

        FitnessClass fc = fitnessClassRepository.findById(classId).orElseThrow();
        FitnessBooking booking = new FitnessBooking();
        booking.setUser(user);
        booking.setTrainer(trainer);
        booking.setFitnessClass(fc);
        booking.setPaymentAmount(400.0);
        booking.setPaymentStatus("PAID");
        booking.setStatus("CONFIRMED");
        booking = bookingRepository.save(booking);

        ResponseEntity<Map<String, Object>> deleteRes = trainerAuthController.deleteClass(classId, session);
        assertEquals(200, deleteRes.getStatusCode().value());
        assertTrue((Boolean) deleteRes.getBody().get("success"));

        // Verify class deleted
        assertTrue(fitnessClassRepository.findById(classId).isEmpty());

        // Verify user received 400 refund to wallet (100 initial + 400 refund = 500)
        User refreshedUser = userRepository.findById(user.getId()).orElseThrow();
        assertEquals(500.0, refreshedUser.getWalletBalance());

        // Verify booking status changed to CANCELLED
        FitnessBooking refreshedBooking = bookingRepository.findById(booking.getId()).orElseThrow();
        assertEquals("CANCELLED", refreshedBooking.getStatus());
    }

    @Test
    @DisplayName("Member self progress log and streak computation")
    public void testMemberProgressLoggingAndStreak() {
        User user = new User();
        user.setFullName("Sneha Patel");
        user.setEmail("sneha.patel@test.com");
        user = userRepository.save(user);

        MockHttpSession userSession = new MockHttpSession();
        userSession.setAttribute("user", user);
        userSession.setAttribute("loggedUser", user);

        Map<String, Object> logBody = new HashMap<>();
        logBody.put("weightKg", 64.5);
        logBody.put("bodyFatPct", 21.0);
        logBody.put("workoutNotes", "45 min morning cardio + core workout");

        ResponseEntity<Map<String, Object>> res = fitnessController.logMyProgress(logBody, userSession);
        assertEquals(200, res.getStatusCode().value());
        assertTrue((Boolean) res.getBody().get("success"));

        Map<String, Object> summary = fitnessService.getUserFitnessProgressSummary(user.getId());
        assertEquals(64.5, ((Number) summary.get("latestWeight")).doubleValue());
        assertEquals(21.0, ((Number) summary.get("latestBodyFat")).doubleValue());
        assertNotNull(summary.get("currentStreakDays"));
    }

    @Test
    @DisplayName("Member class booking with wallet balance deduction")
    public void testMemberClassBookingWithWallet() {
        FitnessTrainer trainer = new FitnessTrainer();
        trainer.setFullName("Coach Sunita");
        trainer.setEmail("sunita.coach@test.com");
        trainer.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        trainer = trainerRepository.save(trainer);

        FitnessClass fc = new FitnessClass();
        fc.setTrainer(trainer);
        fc.setClassName("Sunrise Yoga");
        fc.setCategory("Yoga");
        fc.setClassDate(LocalDate.now().plusDays(1));
        fc.setClassTime(LocalTime.of(7, 0));
        fc.setDurationMinutes(60);
        fc.setSessionType("STUDIO");
        fc.setMaxCapacity(10);
        fc.setCurrentEnrollment(0);
        fc.setPrice(250.0);
        fc.setStatus("ACTIVE");
        fc = fitnessClassRepository.save(fc);

        User user = new User();
        user.setFullName("Pooja Nair");
        user.setEmail("pooja.nair@test.com");
        user.setWalletBalance(500.0);
        user = userRepository.save(user);

        MockHttpSession userSession = new MockHttpSession();
        userSession.setAttribute("user", user);
        userSession.setAttribute("loggedUser", user);

        Map<String, Object> bookBody = new HashMap<>();
        bookBody.put("paymentMethod", "WALLET");

        ResponseEntity<Map<String, Object>> bookRes = fitnessController.bookClass(fc.getId(), bookBody, userSession);
        assertEquals(200, bookRes.getStatusCode().value());
        assertTrue((Boolean) bookRes.getBody().get("success"));

        // User wallet balance deducted by 250 (500 - 250 = 250)
        User updatedUser = userRepository.findById(user.getId()).orElseThrow();
        assertEquals(250.0, updatedUser.getWalletBalance());

        // Class current enrollment incremented
        FitnessClass updatedClass = fitnessClassRepository.findById(fc.getId()).orElseThrow();
        assertEquals(1, updatedClass.getCurrentEnrollment());
    }

    @Test
    @DisplayName("PaymentController creates order for FITNESS booking")
    public void testPaymentControllerFitnessOrder() {
        FitnessTrainer trainer = new FitnessTrainer();
        trainer.setFullName("Coach Anita");
        trainer.setEmail("anita.coach@test.com");
        trainer.setSessionFees(600.0);
        trainer = trainerRepository.save(trainer);

        User user = new User();
        user.setFullName("Kavita Rao");
        user.setEmail("kavita.rao@test.com");
        user = userRepository.save(user);

        FitnessBooking booking = new FitnessBooking();
        booking.setUser(user);
        booking.setTrainer(trainer);
        booking.setPaymentAmount(600.0);
        booking.setPaymentStatus("PENDING");
        booking.setStatus("PENDING");
        booking = bookingRepository.save(booking);

        MockHttpSession userSession = new MockHttpSession();
        userSession.setAttribute("user", user);
        userSession.setAttribute("loggedUser", user);

        Map<String, Object> orderReq = new HashMap<>();
        orderReq.put("type", "FITNESS");
        orderReq.put("bookingId", booking.getId());

        ResponseEntity<Map<String, Object>> orderRes = paymentController.createOrder(orderReq, userSession);
        assertEquals(200, orderRes.getStatusCode().value());
        Map<String, Object> body = orderRes.getBody();
        assertNotNull(body);
        assertTrue(body.containsKey("orderId"));
        assertEquals(600.0, ((Number) body.get("amount")).doubleValue());
    }
}
