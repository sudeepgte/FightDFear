package in.sp.main.Repository;

import in.sp.main.Entities.Enrollment;
import in.sp.main.Entities.TrainingStatus;
import in.sp.main.Entities.User;
import in.sp.main.Entities.MartialArtsCenter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.Collection;
import java.util.List;

public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    List<Enrollment> findByUserId(Long userId);

    List<Enrollment> findByUser(User user);

    List<Enrollment> findByCenter(MartialArtsCenter center);

    List<Enrollment> findByCenterId(Long centerId);

    List<Enrollment> findByBatch(in.sp.main.Entities.MartialArtsBatch batch);
    List<Enrollment> findByBatchId(Long batchId);

    long countByBatchId(Long batchId);

    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.batch.id = :batchId AND e.paymentStatus = 'PAID'")
    long countPaidByBatchId(@Param("batchId") Long batchId);

    List<Enrollment> findByStatusInAndReminder1hSentFalse(Collection<TrainingStatus> statuses);

    @Modifying
    @Transactional
    @Query("DELETE FROM Enrollment e WHERE e.user.id = :userId")
    void deleteByUserId(@Param("userId") Long userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM Enrollment e WHERE e.center.id = :centerId")
    void deleteByCenterId(@Param("centerId") Long centerId);
}
