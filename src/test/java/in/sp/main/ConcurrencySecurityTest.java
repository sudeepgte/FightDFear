package in.sp.main;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.DayAvailable;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.EnrollmentRequest;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.MartialArtsType;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.WalletTransaction;
import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Repository.MartialArtsTypeRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WalletTransactionRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Repository.WomenProductRepository;
import in.sp.main.Repository.WomenProductSellerRepository;
import in.sp.main.Service.AtomicCoinService;
import in.sp.main.Service.AtomicStockService;
import in.sp.main.Service.DoctorBookingService;
import in.sp.main.Service.DoctorPaymentService;
import in.sp.main.Service.EnrollmentService;
import in.sp.main.Service.WomenProductsCareService;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:concurrency_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=rzp_test_mockkey",
        "razorpay.key.secret=mocksecret1234567890",
        "razorpay.webhook.secret=test-webhook-secret",
        "app.payments.mock-enabled=false",
        "google.maps.apiKey=unused",
        "spring.mvc.view.prefix=/WEB-INF/views/",
        "spring.mvc.view.suffix=.jsp"
})
public class ConcurrencySecurityTest {

    @Autowired
    private AtomicStockService atomicStockService;

    @Autowired
    private AtomicCoinService atomicCoinService;

    @Autowired
    private DoctorBookingService doctorBookingService;

    @Autowired
    private DoctorPaymentService doctorPaymentService;

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private WomenProductsCareService womenProductsCareService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WomenProductRepository productRepository;

    @Autowired
    private WomenProductSellerRepository sellerRepository;

    @Autowired
    private WomenProductOrderRepository orderRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorAppointmentRepository appointmentRepository;

    @Autowired
    private WalletTransactionRepository walletTransactionRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private MartialArtsCenterRepository centerRepository;

    @Autowired
    private MartialArtsTypeRepository typeRepository;

    private User testUser;
    private User testUser1;
    private User testUser2;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setFullName("Concurrency Tester");
        testUser.setEmail("tester" + System.currentTimeMillis() + "@test.com");
        testUser.setPassword("Pass@1234");
        testUser.setRewardPoints(100);
        testUser.setVerificationStatus(VerificationStatus.VERIFIED);
        testUser = userRepository.save(testUser);
        
        testUser1 = new User();
        testUser1.setEmail("payuser1@example.com");
        testUser1.setPassword("Pass@12345");
        testUser1.setFullName("Payment User One");
        testUser1.setPhoneNumber("9876543210");
        testUser1 = userRepository.save(testUser1);

        testUser2 = new User();
        testUser2.setEmail("payuser2@example.com");
        testUser2.setPassword("Pass@12345");
        testUser2.setFullName("Payment User Two");
        testUser2.setPhoneNumber("9876543211");
        testUser2 = userRepository.save(testUser2);
    }

    @Test
    void testConcurrentStockDecrement_PreventsOversell() throws Exception {
        WomenProductSeller seller = new WomenProductSeller();
        seller.setFullName("Stock Seller");
        seller.setEmail("stockseller" + System.currentTimeMillis() + "@test.com");
        seller.setVerificationStatus(VerificationStatus.VERIFIED);
        seller.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        seller = sellerRepository.save(seller);

        WomenProduct product = new WomenProduct();
        product.setName("Self Defense Pepper Spray");
        product.setSeller(seller);
        product.setStock(1);
        product.setPrice(150.0);
        product.setActive(true);
        product.setDeleted(false);
        product = productRepository.save(product);

        final Long productId = product.getId();
        int threads = 2;
        ExecutorService executor = Executors.newFixedThreadPool(threads);
        CountDownLatch readyLatch = new CountDownLatch(threads);
        CountDownLatch startLatch = new CountDownLatch(1);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < threads; i++) {
            futures.add(executor.submit(() -> {
                readyLatch.countDown();
                try {
                    startLatch.await(5, TimeUnit.SECONDS);
                    atomicStockService.decrementStock(productId, 1);
                    successCount.incrementAndGet();
                } catch (ResponseStatusException ex) {
                    failureCount.incrementAndGet();
                } catch (Exception ex) {
                    failureCount.incrementAndGet();
                }
            }));
        }

        readyLatch.await(5, TimeUnit.SECONDS);
        startLatch.countDown();

        for (Future<?> f : futures) {
            f.get(5, TimeUnit.SECONDS);
        }
        executor.shutdown();

        assertEquals(1, successCount.get(), "Exactly one decrement operation must succeed");
        assertEquals(1, failureCount.get(), "Exactly one decrement operation must fail due to insufficient stock");

        WomenProduct finalProduct = productRepository.findById(productId).orElseThrow();
        assertEquals(0, finalProduct.getStock(), "Final product stock must be exactly 0");
    }

    @Test
    void testConcurrentCoinDebit_PreventsDoubleSpend() throws Exception {
        final Long userId = testUser.getId();
        int threads = 2;
        ExecutorService executor = Executors.newFixedThreadPool(threads);
        CountDownLatch readyLatch = new CountDownLatch(threads);
        CountDownLatch startLatch = new CountDownLatch(1);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < threads; i++) {
            futures.add(executor.submit(() -> {
                readyLatch.countDown();
                try {
                    startLatch.await(5, TimeUnit.SECONDS);
                    atomicCoinService.debitCoins(userId, 100, "Simultaneous debit race");
                    successCount.incrementAndGet();
                } catch (ResponseStatusException ex) {
                    failureCount.incrementAndGet();
                } catch (Exception ex) {
                    failureCount.incrementAndGet();
                }
            }));
        }

        readyLatch.await(5, TimeUnit.SECONDS);
        startLatch.countDown();

        for (Future<?> f : futures) {
            f.get(5, TimeUnit.SECONDS);
        }
        executor.shutdown();

        assertEquals(1, successCount.get(), "Exactly one coin debit must succeed");
        assertEquals(1, failureCount.get(), "Exactly one coin debit must fail due to insufficient balance");

        User finalUser = userRepository.findById(userId).orElseThrow();
        assertEquals(0, finalUser.getRewardPoints(), "User reward points balance must be exactly 0");

        List<WalletTransaction> txs = walletTransactionRepository.findByUser_IdOrderByTransactionDateDesc(userId);
        long debitCount = txs.stream().filter(t -> "DEBIT".equals(t.getType())).count();
        assertEquals(1, debitCount, "Authoritative wallet transaction history must record exactly one DEBIT");
    }

    @Test
    void testConcurrentDoctorBooking_PreventsDoubleBooking() throws Exception {
        Doctor doc = new Doctor();
        doc.setFullName("Dr. Concurrency");
        doc.setEmail("drconcurrency" + System.currentTimeMillis() + "@test.com");
        doc.setPassword("Doc@1234");
        doc.setVerificationStatus(VerificationStatus.VERIFIED);
        doc.setDoctorProfileStatus(DoctorProfileStatus.APPROVED);
        doc.setConsultationFee(0.0);
        doc.setAutoConfirm(true);
        doc = doctorRepository.save(doc);

        final Doctor targetDoc = doc;
        final LocalDateTime slotTime = LocalDateTime.now().plusDays(5).withHour(10).withMinute(0).withSecond(0).withNano(0);

        int threads = 2;
        ExecutorService executor = Executors.newFixedThreadPool(threads);
        CountDownLatch readyLatch = new CountDownLatch(threads);
        CountDownLatch startLatch = new CountDownLatch(1);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < threads; i++) {
            futures.add(executor.submit(() -> {
                readyLatch.countDown();
                try {
                    startLatch.await(5, TimeUnit.SECONDS);
                    doctorBookingService.createRequestBooking(
                            targetDoc, testUser, slotTime, ConsultationType.CLINIC, "Checkup", true);
                    successCount.incrementAndGet();
                } catch (ResponseStatusException ex) {
                    failureCount.incrementAndGet();
                } catch (Exception ex) {
                    failureCount.incrementAndGet();
                }
            }));
        }

        readyLatch.await(5, TimeUnit.SECONDS);
        startLatch.countDown();

        for (Future<?> f : futures) {
            f.get(5, TimeUnit.SECONDS);
        }
        executor.shutdown();

        assertEquals(1, successCount.get(), "Exactly one appointment booking must succeed");
        assertEquals(1, failureCount.get(), "Conflicting appointment booking must be rejected");

        List<DoctorAppointment> appts = appointmentRepository.findByDoctorOrderByAppointmentTimeDesc(targetDoc);
        long activeCount = appts.stream()
                .filter(a -> slotTime.equals(a.getAppointmentTime()) && a.getStatus() != DoctorAppointmentStatus.CANCELLED)
                .count();
        assertEquals(1, activeCount, "Exactly one active appointment must exist for the doctor at that slot");
    }

    @Test
    void testEnrollmentRollback_OnFailure() {
        MartialArtsCenter center = new MartialArtsCenter();
        center.setName("Safety Martial Arts");
        center.setEmail("mac" + System.currentTimeMillis() + "@test.com");
        center = centerRepository.save(center);

        MartialArtsType type = new MartialArtsType();
        type.setName("Self Defense");
        type = typeRepository.save(type);

        EnrollmentRequest req = new EnrollmentRequest();
        req.setUserId(testUser.getId());
        req.setCenterId(center.getId());
        req.setMartialArtTypeId(type.getId());

        long initialCount = enrollmentRepository.count();

        assertThrows(Exception.class, () -> {
            enrollmentService.enrollUser(req, 999999L, Set.of(DayAvailable.MONDAY));
        });

        assertEquals(initialCount, enrollmentRepository.count(),
                "No enrollment record must be persisted if any step of the transaction fails");
    }

    @Test
    void testDuplicatePayout_IdempotencyAndNoDoubleCredit() throws Exception {
        WomenProductSeller seller = new WomenProductSeller();
        seller.setFullName("Payout Seller");
        seller.setEmail("payoutseller" + System.currentTimeMillis() + "@test.com");
        seller.setVerificationStatus(VerificationStatus.VERIFIED);
        seller.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
        seller.setPayoutBalance(0.0);
        seller = sellerRepository.save(seller);

        WomenProduct product = new WomenProduct();
        product.setName("Defense Keychain");
        product.setSeller(seller);
        product.setStock(10);
        product.setPrice(200.0);
        product.setActive(true);
        product.setDeleted(false);
        product = productRepository.save(product);

        WomenProductOrder order = new WomenProductOrder();
        order.setUser(testUser);
        order.setProduct(product);
        order.setSeller(seller);
        order.setQuantity(1);
        order.setTotalPrice(200.0);
        order.setStatus("DELIVERED");
        order.setSellerPayoutCredited(false);
        order = orderRepository.save(order);

        final Long orderId = order.getId();
        int threads = 2;
        ExecutorService executor = Executors.newFixedThreadPool(threads);
        CountDownLatch readyLatch = new CountDownLatch(threads);
        CountDownLatch startLatch = new CountDownLatch(1);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < threads; i++) {
            futures.add(executor.submit(() -> {
                readyLatch.countDown();
                try {
                    startLatch.await(5, TimeUnit.SECONDS);
                    WomenProductOrder o = orderRepository.findById(orderId).orElseThrow();
                    womenProductsCareService.creditSeller(o);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }));
        }

        readyLatch.await(5, TimeUnit.SECONDS);
        startLatch.countDown();

        for (Future<?> f : futures) {
            f.get(5, TimeUnit.SECONDS);
        }
        executor.shutdown();

        WomenProductSeller finalSeller = sellerRepository.findById(seller.getId()).orElseThrow();
        assertEquals(200.0, finalSeller.getPayoutBalance(),
                "Seller must be credited exactly once despite concurrent credit calls");

        WomenProductOrder finalOrder = orderRepository.findById(orderId).orElseThrow();
        assertTrue(finalOrder.getSellerPayoutCredited(), "Order must have sellerPayoutCredited flag set to true");
    }

    @Test
    void testPaymentSettlementAndRefundReplay_PreventsDoubleProcessing() {
        Doctor doc = new Doctor();
        doc.setFullName("Dr. RefundTest");
        doc.setEmail("drrefund" + System.currentTimeMillis() + "@test.com");
        doc.setPassword("Doc@1234");
        doc.setVerificationStatus(VerificationStatus.VERIFIED);
        doc.setDoctorProfileStatus(DoctorProfileStatus.APPROVED);
        doc.setPayoutBalance(0.0);
        doc.setCommissionPercent(10.0);
        doc = doctorRepository.save(doc);

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(testUser);
        appt.setDoctor(doc);
        appt.setAppointmentTime(LocalDateTime.now().plusDays(2));
        appt.setStatus(DoctorAppointmentStatus.CONFIRMED);
        appt.setRazorpayPaymentId("pay_replay_test_123");
        appt = appointmentRepository.save(appt);

        doctorPaymentService.applyPaidSettlement(appt, 1000.0);
        appt = appointmentRepository.save(appt);

        Doctor docAfterPaid = doctorRepository.findById(doc.getId()).orElseThrow();
        assertEquals(900.0, docAfterPaid.getPayoutBalance(), "Doctor should receive 900 earning after settlement");

        doctorPaymentService.refundIfPaid(appt, "PATIENT", "First cancellation");
        appt = appointmentRepository.save(appt);

        Doctor docAfterRefund = doctorRepository.findById(doc.getId()).orElseThrow();
        assertEquals(0.0, docAfterRefund.getPayoutBalance(), "Doctor balance should be reversed to 0 after refund");

        doctorPaymentService.refundIfPaid(appt, "PATIENT", "Duplicate replay cancellation");

        Doctor docAfterReplay = doctorRepository.findById(doc.getId()).orElseThrow();
        assertEquals(0.0, docAfterReplay.getPayoutBalance(), "Doctor balance must remain 0 and not become negative on refund replay");
    }
}
