package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;

public interface UserRepository extends JpaRepository<User, Long> {
 // Add method to find user by email (used for login)
    Optional<User> findByEmail(String email);

    // Purpose: admin verification screens + buddy matching (verified-only filter).
    List<User> findByVerificationStatus(VerificationStatus status);

    // Purpose: existing users created before this field was added can have NULL status in DB.
    List<User> findByVerificationStatusIsNull();
    
    @Query("SELECT u FROM User u WHERE LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
  	       "OR LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
  	       "OR LOWER(u.phoneNumber) LIKE LOWER(CONCAT('%', :keyword, '%'))")
  	List<User> searchUsers(@Param("keyword") String keyword);

    // Purpose: admin user management — list all banned/active users separately.
    List<User> findByBanned(boolean banned);
}
