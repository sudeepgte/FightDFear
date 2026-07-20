package in.sp.main.Controller;
 
import in.sp.main.Entities.Review;
import in.sp.main.Entities.Salon;

import in.sp.main.Entities.SalonReview;

import in.sp.main.Repository.SalonRepository;

import in.sp.main.Service.SalonReviewService;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.*;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;
 
import java.util.List;

import java.util.OptionalDouble;
 
@Controller

@RequestMapping("/salon")

public class SalonReviewController {
 
    @Autowired

    private SalonRepository salonRepo;
 
    @Autowired

    private SalonReviewService reviewService;
 
    // Show salon profile with reviews

    @GetMapping("/reviews")
    public String showReviews(@RequestParam Long id, Model model) {
        Salon salon = salonRepo.findById(id).orElse(null);
        if (salon == null) {
            model.addAttribute("error", "Salon not found!");
            return "redirect:/salons";
        }

        List<SalonReview> reviews = reviewService.getReviewsBySalonId(id);

        // ✅ Calculate average rating
        OptionalDouble avg = reviews.stream().mapToInt(SalonReview::getRating).average();
        double averageRating = avg.isPresent() ? Math.round(avg.getAsDouble() * 10.0) / 10.0 : 0;

        // ✅ Add data to model
        model.addAttribute("salon", salon);
        model.addAttribute("reviews", reviews);
        model.addAttribute("averageRating", averageRating);
        model.addAttribute("totalReviews", reviews.size());

        return "user/salon_reviews";
    }

    // Save new review

    @PostMapping("/reviews/save")

    public String saveReview(@RequestParam Long salonId,

                             @RequestParam String userName,

                             @RequestParam int rating,

                             @RequestParam String comment,

                             RedirectAttributes redirectAttributes) {
 
        Salon salon = salonRepo.findById(salonId).orElse(null);

        if (salon == null) {

            redirectAttributes.addFlashAttribute("error", "Salon not found!");

            return "redirect:/salons";

        }
 
        SalonReview review = new SalonReview();

        review.setSalon(salon);

        review.setUserName(userName);

        review.setRating(rating);

        review.setComment(comment);

        reviewService.saveReview(review);
 
        redirectAttributes.addFlashAttribute("msg", "Thank you for your feedback!");

        return "redirect:/salon/reviews?id=" + salonId;

    }

// SalonReviewController.java

    @GetMapping("/reviews/list")

    public String viewAllReviews(Model model) {

        List<SalonReview> allReviews = reviewService.getAllReviews();

        model.addAttribute("reviews", allReviews);

        return "salon/all_reviews"; // new JSP for admin

    }
 
    // Reply to a review

    @PostMapping("/reviews/reply")

    public String replyToReview(@RequestParam Long reviewId,

                                @RequestParam String reply,

                                RedirectAttributes redirectAttributes) {
 
        SalonReview review = reviewService.getReviewById(reviewId);

        if (review != null) {

            review.setReply(reply);

            reviewService.saveReview(review);

            redirectAttributes.addFlashAttribute("msg", "Reply added successfully!");

        } else {

            redirectAttributes.addFlashAttribute("error", "Review not found!");

        }

        return "redirect:/salon/reviews1";

    }
   
   
    @GetMapping("/reviews1")
    public String viewSalonReviews(@RequestParam("id") Long salonId, Model model) {
        Salon salon = salonRepo.findById(salonId).orElse(null);
        if (salon == null) {
            model.addAttribute("error", "Salon not found");
            return "error";
        }

        List<SalonReview> reviews = reviewService.getReviewsBySalon(salon);
        model.addAttribute("reviews", reviews);
        model.addAttribute("salon", salon);

        return "salon/reviewList"; // JSP name
    }
}

 