package in.sp.main.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.EmailOtpVerification;
import in.sp.main.Entities.OtpPurpose;

public interface EmailOtpVerificationRepository extends JpaRepository<EmailOtpVerification, Long> {

    Optional<EmailOtpVerification> findTopByEmailAndPurposeAndVerifiedFalseOrderByCreatedAtDesc(
            String email, OtpPurpose purpose);

    Optional<EmailOtpVerification> findTopByEmailAndPurposeAndVerifiedTrueOrderByCreatedAtDesc(
            String email, OtpPurpose purpose);

    @Modifying
    @Query("DELETE FROM EmailOtpVerification e WHERE e.expiresAt < :cutoff")
    int deleteExpiredBefore(@Param("cutoff") LocalDateTime cutoff);
}
