package in.sp.main.Service;
 
import in.sp.main.Entities.Review;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonReview;

import in.sp.main.Repository.SalonReviewRepository;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
 
import java.time.LocalDateTime;

import java.util.List;

import java.util.Optional;
 
@Service

public class SalonReviewService {
 
    @Autowired

    private SalonReviewRepository reviewRepo;
 
    public void saveReview(SalonReview review) {

        reviewRepo.save(review);

    }
 
    public List<SalonReview> getReviewsBySalonId(Long salonId) {

        return reviewRepo.findBySalonId(salonId);

    }

// ✅ Get a single review by ID

    public SalonReview getReviewById(Long id) {

        Optional<SalonReview> optional = reviewRepo.findById(id);

        return optional.orElse(null);

    }

    public List<SalonReview> getAllReviews() {

        return reviewRepo.findAll();

    }

    public void replyToReview(Long reviewId, String replyText) {

        SalonReview review = reviewRepo.findById(reviewId).orElse(null);

        if (review != null) {

            review.setReply(replyText);

            review.setRepliedAt(LocalDateTime.now());

            reviewRepo.save(review);

        }

    }
    public List<SalonReview> getReviewsBySalonId(int salonId) {
        return reviewRepo.findBySalonId(salonId);
    }
    
    public List<SalonReview> getReviewsBySalon(Salon salon) {
        return reviewRepo.findBySalon(salon);
    }
   
    }

 