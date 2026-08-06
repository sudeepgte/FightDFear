package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DoctorDraftStatus;
import in.sp.main.Entities.DoctorProfileDraft;

public interface DoctorProfileDraftRepository extends JpaRepository<DoctorProfileDraft, Long> {
    List<DoctorProfileDraft> findByStatus(DoctorDraftStatus status);
}
