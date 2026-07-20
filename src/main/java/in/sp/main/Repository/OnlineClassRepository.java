package in.sp.main.Repository;

import in.sp.main.Entities.OnlineClass;
import in.sp.main.Entities.User;
import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.MartialArtsCenter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OnlineClassRepository extends JpaRepository<OnlineClass, Long> {
    List<OnlineClass> findByTrainer(User trainer);
    
    @Query("SELECT oc FROM OnlineClass oc WHERE oc.center.id = :centerId")
    List<OnlineClass> findByCenter_Id(@Param("centerId") Long centerId);
    
    List<OnlineClass> findByCenter(MartialArtsCenter center);
    List<OnlineClass> findByCenterId(Long centerId);
    List<OnlineClass> findByBatchIn(List<MartialArtsBatch> batches);
    java.util.Optional<OnlineClass> findFirstByBatchAndDate(MartialArtsBatch batch, java.time.LocalDate date);
}
