package in.sp.main.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.CentreFavorite;

public interface CentreFavoriteRepository extends JpaRepository<CentreFavorite, CentreFavorite.Key> {
    boolean existsByUserIdAndCentreId(Long userId, Long centreId);
    void deleteByUserIdAndCentreId(Long userId, Long centreId);
    java.util.List<CentreFavorite> findByUserIdOrderByCreatedAtDesc(Long userId);
}
