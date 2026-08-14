package in.sp.main.Service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:ratelimit_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false"
})
class RateLimitServiceTest {

    @Autowired
    private RateLimitService rateLimitService;

    @Test
    @Transactional
    void blocksAfterLimitWithinWindow() {
        String key = "test:otp:" + System.nanoTime();
        Duration window = Duration.ofHours(1);
        for (int i = 0; i < 5; i++) {
            assertTrue(rateLimitService.tryAcquire(key, 5, window), "attempt " + i);
        }
        assertFalse(rateLimitService.tryAcquire(key, 5, window));
    }

    @Test
    void checkOrThrowWorksWithoutOuterTransaction() {
        String key = "test:login:" + System.nanoTime();
        assertDoesNotThrow(() -> rateLimitService.checkOrThrow(key, 10, Duration.ofMinutes(15)));
    }
}
