package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.VerificationStatus;

public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    Optional<Doctor> findByEmail(String email);
    List<Doctor> findByVerificationStatus(VerificationStatus status);

    // Purpose: admin doctor search — matches name, email, phone, specialization, or location.
    @Query("SELECT d FROM Doctor d WHERE " +
           "LOWER(d.fullName)       LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(d.email)          LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(d.phone)          LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(d.specialization) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(d.locationText)   LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Doctor> searchDoctors(@Param("keyword") String keyword);
}

