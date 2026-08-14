package in.sp.main.Repository;

import in.sp.main.Entities.LawyerFavorite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface LawyerFavoriteRepository extends JpaRepository<LawyerFavorite, Long> {
    List<LawyerFavorite> findByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<LawyerFavorite> findByUserIdAndProviderId(Long userId, Long providerId);
    boolean existsByUserIdAndProviderId(Long userId, Long providerId);
}
