package in.sp.main.Repository;

import in.sp.main.Entities.SalonFavorite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SalonFavoriteRepository extends JpaRepository<SalonFavorite, Long> {
    List<SalonFavorite> findByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<SalonFavorite> findByUserIdAndSalonId(Long userId, Long salonId);
    boolean existsByUserIdAndSalonId(Long userId, Long salonId);
    void deleteByUserIdAndSalonId(Long userId, Long salonId);
}
