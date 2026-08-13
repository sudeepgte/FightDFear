package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DoctorInstantRequest;

public interface DoctorInstantRequestRepository extends JpaRepository<DoctorInstantRequest, Long> {
    List<DoctorInstantRequest> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<DoctorInstantRequest> findByDoctorIdAndStatusOrderByCreatedAtAsc(Long doctorId, String status);
    List<DoctorInstantRequest> findByStatusOrderByCreatedAtAsc(String status);
}
