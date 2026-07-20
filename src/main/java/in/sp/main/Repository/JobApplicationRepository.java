package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.VerificationStatus;

@Repository
public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {
    List<JobApplication> findByStatus(VerificationStatus status);
    List<JobApplication> findByUser_Id(Long userId);
    List<JobApplication> findAllByOrderByAppliedAtDesc();

    @Query("SELECT DISTINCT j.jobCategory FROM JobApplication j WHERE j.status = :status")
    List<String> findDistinctJobCategoriesByStatus(@Param("status") VerificationStatus status);

    List<JobApplication> findByJobCategoryAndStatus(String jobCategory, VerificationStatus status);
}
