package in.sp.main.Service;

import java.time.Duration;
import java.time.Instant;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.RateLimitBucket;
import in.sp.main.Exception.RateLimitExceededException;
import in.sp.main.Repository.RateLimitBucketRepository;

@Service
public class RateLimitService {

    @Autowired
    private RateLimitBucketRepository rateLimitBucketRepository;

    @Transactional
    public boolean tryAcquire(String key, int limit, Duration window) {
        Instant windowStart = Instant.now().minus(window);
        rateLimitBucketRepository.deleteByBucketKeyAndCreatedAtBefore(key, windowStart);
        long count = rateLimitBucketRepository.countByBucketKeyAndCreatedAtAfter(key, windowStart);
        if (count >= limit) {
            return false;
        }
        RateLimitBucket bucket = new RateLimitBucket();
        bucket.setBucketKey(key);
        rateLimitBucketRepository.save(bucket);
        return true;
    }

    public void checkOrThrow(String key, int limit, Duration window) {
        if (!tryAcquire(key, limit, window)) {
            throw new RateLimitExceededException("Too many requests. Please try again later.");
        }
    }
}
