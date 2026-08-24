package in.sp.main.Repository;

import in.sp.main.Entities.CentreInstructor;
import in.sp.main.Entities.MartialArtsCenter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CentreInstructorRepository extends JpaRepository<CentreInstructor, Long> {

    List<CentreInstructor> findByCenterAndActiveTrue(MartialArtsCenter center);

    List<CentreInstructor> findByCenter_IdAndActiveTrue(Long centerId);

    List<CentreInstructor> findByCenter_Id(Long centerId);
}
