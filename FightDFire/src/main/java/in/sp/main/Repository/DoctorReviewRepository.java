package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DoctorReview;

public interface DoctorReviewRepository extends JpaRepository<DoctorReview, Long> {
    List<DoctorReview> findByDoctorIdOrderByCreatedAtDesc(Long doctorId);
    boolean existsByUserIdAndDoctorId(Long userId, Long doctorId);
}

