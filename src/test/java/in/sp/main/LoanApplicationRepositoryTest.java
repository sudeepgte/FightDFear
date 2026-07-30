package in.sp.main;

import in.sp.main.Entities.LoanApplication;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.LoanApplicationRepository;
import in.sp.main.Repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.TestPropertySource;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@TestPropertySource(properties = {
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:loan_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect"
})
class LoanApplicationRepositoryTest {

    @Autowired
    private LoanApplicationRepository loanApplicationRepository;

    @Autowired
    private UserRepository userRepository;

    @Test
    void savesAndFindsLoanApplicationForUser() {
        User user = new User();
        user.setFullName("Test User");
        user.setEmail("loan-test@example.com");
        user.setPassword("unused");
        user.setVerificationStatus(VerificationStatus.VERIFIED);
        user = userRepository.save(user);

        LoanApplication app = new LoanApplication();
        app.setUser(user);
        app.setFullName(user.getFullName());
        app.setEmail(user.getEmail());
        app.setLoanType("Personal Loan");
        app.setLoanAmount(50000.0);
        app.setStatus("SUBMITTED");
        app.setSubmittedAt(LocalDateTime.now());
        loanApplicationRepository.save(app);

        assertEquals(1, loanApplicationRepository.findByUserOrderBySubmittedAtDesc(user).size());
        assertEquals(50000.0, loanApplicationRepository.findByUserOrderBySubmittedAtDesc(user).get(0).getLoanAmount());
    }
}
