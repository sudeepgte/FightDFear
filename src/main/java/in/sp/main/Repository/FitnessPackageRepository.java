package in.sp.main.Repository;

import in.sp.main.Entities.FitnessPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FitnessPackageRepository extends JpaRepository<FitnessPackage, Long> {
    List<FitnessPackage> findByTrainer_Id(Long trainerId);
    List<FitnessPackage> findByTrainer_IdAndActiveTrue(Long trainerId);
    List<FitnessPackage> findByActiveTrue();
    long countByTrainer_Id(Long trainerId);
}
