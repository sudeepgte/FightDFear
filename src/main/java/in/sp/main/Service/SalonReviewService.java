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
        if (review == null) {
            throw new IllegalArgumentException("Review is required.");
        }
        String name = review.getUserName() == null ? "" : review.getUserName().trim();
        String comment = review.getComment() == null ? "" : review.getComment().trim();
        if (name.length() < 2 || name.length() > 50
                || !name.matches("^[A-Za-z]([A-Za-z .'-]*[A-Za-z])?$")) {
            throw new IllegalArgumentException("Your Name is invalid.");
        }
        if (review.getRating() < 1 || review.getRating() > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5.");
        }
        if (comment.length() < 10 || comment.length() > 1000) {
            throw new IllegalArgumentException("Comment must be between 10 and 1000 characters.");
        }
        review.setUserName(name);
        review.setComment(comment);
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

 