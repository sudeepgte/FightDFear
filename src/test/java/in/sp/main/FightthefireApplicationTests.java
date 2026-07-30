package in.sp.main;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(properties = {
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:context_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused-for-context-load"
})
class FightthefireApplicationTests {

    @Test
    void contextLoads() {
    }
}
