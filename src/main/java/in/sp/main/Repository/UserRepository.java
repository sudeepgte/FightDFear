package in.sp.main.Repository;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;

public interface UserRepository extends JpaRepository<User, Long> {
    // Add method to find user by email (used for login)
    Optional<User> findByEmail(String email);
    Optional<User> findByPhoneNumber(String phoneNumber);

    List<User> findByVerificationStatus(VerificationStatus status);

    long countByVerificationStatus(VerificationStatus status);

    List<User> findByVerificationStatusIsNull();

    @Query("SELECT u FROM User u WHERE LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
  	       "OR LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
  	       "OR LOWER(u.phoneNumber) LIKE LOWER(CONCAT('%', :keyword, '%'))")
  	List<User> searchUsers(@Param("keyword") String keyword);

    List<User> findByBanned(boolean banned);

    @Query("SELECT u FROM User u WHERE u.verificationStatus = :status AND u.banned = false")
    List<User> findByVerificationStatusAndBannedFalse(@Param("status") VerificationStatus status);

    List<User> findByMartialArtsCenter_Id(Long centerId);
    List<User> findByCreatorProfileStatusIn(List<PartnerProfileStatus> statuses);

    long countByCreatorProfileStatusIn(List<PartnerProfileStatus> statuses);

    List<User> findByVerifiedCreatorTrue();

    @Query("SELECT u FROM User u WHERE u.banned = false AND (u.bannedCreator = false OR u.bannedCreator IS NULL) "
            + "AND (u.verifiedCreator = true OR u.creatorProfileStatus = :approvedStatus)")
    Page<User> findApprovedCreators(@Param("approvedStatus") PartnerProfileStatus approvedStatus, Pageable pageable);
}
