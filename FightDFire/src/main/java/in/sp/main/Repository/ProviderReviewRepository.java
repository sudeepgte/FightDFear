package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.ProviderReview;

public interface ProviderReviewRepository extends JpaRepository<ProviderReview, Long> {
    List<ProviderReview> findByProviderIdOrderByCreatedAtDesc(Long providerId);
    boolean existsByUserIdAndProviderId(Long userId, Long providerId);
}

