package in.sp.main.Repository;

import in.sp.main.Entities.FitnessClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface FitnessClassRepository extends JpaRepository<FitnessClass, Long> {
    List<FitnessClass> findByTrainer_IdOrderByClassDateAsc(Long trainerId);
    List<FitnessClass> findByClassDateGreaterThanEqualAndStatusOrderByClassDateAsc(LocalDate date, String status);
}
