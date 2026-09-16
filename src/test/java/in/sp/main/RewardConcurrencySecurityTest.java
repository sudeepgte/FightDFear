package in.sp.main;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WalletTransaction;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WalletTransactionRepository;
import in.sp.main.Service.AtomicCoinService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:reward_concurrency_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=test",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused"
})
public class RewardConcurrencySecurityTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WalletTransactionRepository walletTransactionRepository;

    @Autowired
    private AtomicCoinService atomicCoinService;

    private User testUser;

    @BeforeEach
    void setUp() {
        walletTransactionRepository.deleteAll();
        userRepository.deleteAll();

        User user = new User();
        user.setEmail("creator@fightdfear.com");
        user.setFullName("Active Creator");
        user.setRewardPoints(0);
        testUser = userRepository.save(user);
    }

    @Test
    void concurrentRewardCredits_MaintainAtomicBalanceAndAuditRecords() throws Exception {
        int threadCount = 20;
        int pointsPerCredit = 10;
        ExecutorService executor = Executors.newFixedThreadPool(threadCount);
        CountDownLatch latch = new CountDownLatch(threadCount);
        AtomicInteger successCount = new AtomicInteger(0);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < threadCount; i++) {
            final int index = i;
            futures.add(executor.submit(() -> {
                try {
                    atomicCoinService.creditCoins(testUser.getId(), pointsPerCredit, "Concurrent credit #" + index);
                    successCount.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            }));
        }

        latch.await(10, TimeUnit.SECONDS);
        executor.shutdown();

        for (Future<?> f : futures) {
            f.get();
        }

        assertEquals(threadCount, successCount.get(), "All concurrent credit requests should succeed");

        User updatedUser = userRepository.findById(testUser.getId()).orElseThrow();
        int expectedBalance = threadCount * pointsPerCredit;
        assertEquals(expectedBalance, updatedUser.getRewardPoints(),
                "Final reward balance must exactly equal total credited points without race condition loss");

        List<WalletTransaction> txs = walletTransactionRepository.findByUser_IdOrderByTransactionDateDesc(testUser.getId());
        assertEquals(threadCount, txs.size(), "Each credit must generate a corresponding WalletTransaction record");
        for (WalletTransaction tx : txs) {
            assertEquals("CREDIT", tx.getType());
            assertEquals((double) pointsPerCredit, tx.getAmount());
        }
    }

    @Test
    void concurrentCreditAndDebit_MaintainsStrictBalanceIntegrity() throws Exception {
        // Give initial balance
        testUser.setRewardPoints(200);
        testUser = userRepository.save(testUser);

        int creditThreads = 10;
        int debitThreads = 10;
        int totalThreads = creditThreads + debitThreads;
        int creditAmount = 15;
        int debitAmount = 10;

        ExecutorService executor = Executors.newFixedThreadPool(totalThreads);
        CountDownLatch latch = new CountDownLatch(totalThreads);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < creditThreads; i++) {
            final int idx = i;
            futures.add(executor.submit(() -> {
                try {
                    atomicCoinService.creditCoins(testUser.getId(), creditAmount, "Interleaved credit " + idx);
                } finally {
                    latch.countDown();
                }
            }));
        }

        for (int i = 0; i < debitThreads; i++) {
            final int idx = i;
            futures.add(executor.submit(() -> {
                try {
                    atomicCoinService.debitCoins(testUser.getId(), debitAmount, "Interleaved debit " + idx);
                } finally {
                    latch.countDown();
                }
            }));
        }

        latch.await(10, TimeUnit.SECONDS);
        executor.shutdown();

        for (Future<?> f : futures) {
            f.get();
        }

        User finalUser = userRepository.findById(testUser.getId()).orElseThrow();
        int expectedBalance = 200 + (creditThreads * creditAmount) - (debitThreads * debitAmount);
        assertEquals(expectedBalance, finalUser.getRewardPoints(),
                "Interleaved credits and debits must maintain absolute mathematical consistency");
    }
}
