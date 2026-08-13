package in.sp.main.Repository;

import java.time.Instant;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import in.sp.main.Entities.RateLimitBucket;

public interface RateLimitBucketRepository extends JpaRepository<RateLimitBucket, Long> {

    long countByBucketKeyAndCreatedAtAfter(String bucketKey, Instant windowStart);

    @Modifying
    @Query("DELETE FROM RateLimitBucket r WHERE r.bucketKey = :bucketKey AND r.createdAt < :cutoff")
    int deleteByBucketKeyAndCreatedAtBefore(
            @Param("bucketKey") String bucketKey,
            @Param("cutoff") Instant cutoff);
}
