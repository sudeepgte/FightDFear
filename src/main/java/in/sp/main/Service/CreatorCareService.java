package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.CreatorReview;
import in.sp.main.Entities.CreatorSubscription;
import in.sp.main.Entities.PaidContentUnlock;
import in.sp.main.Entities.TipTransaction;
import in.sp.main.Entities.User;
import in.sp.main.Entities.Videoupload;
import in.sp.main.Repository.CreatorReviewRepository;
import in.sp.main.Repository.CreatorSubscriptionRepository;
import in.sp.main.Repository.PaidContentUnlockRepository;
import in.sp.main.Repository.TipTransactionRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.VideoLikeRepository;
import in.sp.main.Repository.VideoUploadRepository;

@Service
public class CreatorCareService {

    public static final String CANCEL_POLICY =
            "Public videos are free. Tips and paid unlocks are not refundable. Subscriptions can be cancelled anytime; access lasts until the period ends.";

    @Autowired private UserRepository userRepository;
    @Autowired private CreatorReviewRepository reviewRepository;
    @Autowired private CreatorSubscriptionRepository subscriptionRepository;
    @Autowired private PaidContentUnlockRepository unlockRepository;
    @Autowired private TipTransactionRepository tipRepository;
    @Autowired private VideoUploadRepository videoRepository;
    @Autowired private VideoLikeRepository likeRepository;
    @Autowired private PushNotificationService pushNotificationService;

    @Transactional
    public void creditPayout(User creator, double amount) {
        if (creator == null || amount <= 0) return;
        creator.setCreatorPayoutBalance(creator.getCreatorPayoutBalance() + amount);
        userRepository.save(creator);
    }

    @Transactional
    public Map<String, Object> requestPayout(User creator) {
        if (creator == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Creator profile required");
        if (PartnerLifecycleSupport.blank(creator.getCreatorUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = creator.getCreatorPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        creator.setCreatorPayoutRequestedAt(LocalDateTime.now());
        userRepository.save(creator);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + creator.getCreatorUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", creator.getCreatorUpiId());
        return m;
    }

    @Transactional
    public TipTransaction fulfillTip(User sender, User creator, double amount, String message) {
        if (sender == null || creator == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Creator not found");
        }
        if (!CreatorProfileService.isApprovedCreator(creator)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Creator not found");
        }
        if (amount <= 0) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid tip");
        TipTransaction tip = new TipTransaction();
        tip.setSender(sender);
        tip.setReceiver(creator);
        tip.setAmount(amount);
        tip.setMessage(message);
        tipRepository.save(tip);
        creditPayout(creator, amount);
        try {
            pushNotificationService.notifyUser(
                    creator.getId(),
                    "Creator Hub",
                    "You received a tip of ₹" + Math.round(amount),
                    Map.of("type", "CREATOR_TIP", "from", String.valueOf(sender.getId())));
        } catch (Exception ignored) {}
        return tip;
    }

    @Transactional
    public CreatorSubscription fulfillSubscribe(User subscriber, User creator, double amountPaid) {
        if (subscriber == null || creator == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Creator not found");
        }
        if (!CreatorProfileService.isApprovedCreator(creator)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Creator not found");
        }
        Double price = creator.getCreatorSubscriptionPrice();
        if (price == null || price <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Subscription not enabled");
        }
        CreatorSubscription sub = subscriptionRepository
                .findBySubscriber_IdAndCreator_Id(subscriber.getId(), creator.getId())
                .orElseGet(CreatorSubscription::new);
        sub.setSubscriber(subscriber);
        sub.setCreator(creator);
        LocalDateTime start = LocalDateTime.now();
        if (sub.getEndDate() != null && sub.getEndDate().isAfter(start)) {
            start = sub.getEndDate();
        }
        sub.setStartDate(LocalDateTime.now());
        sub.setEndDate(start.plusMonths(1));
        sub.setAmountPaid((sub.getAmountPaid() == null ? 0 : sub.getAmountPaid()) + amountPaid);
        subscriptionRepository.save(sub);
        creditPayout(creator, amountPaid);
        return sub;
    }

    @Transactional
    public PaidContentUnlock fulfillUnlock(User user, Videoupload video, double amountPaid) {
        if (user == null || video == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Post not found");
        }
        if (unlockRepository.existsByUser_IdAndVideo_Id(user.getId(), video.getId())) {
            return unlockRepository.findByVideo_Id(video.getId()).stream()
                    .filter(u -> u.getUser() != null && u.getUser().getId().equals(user.getId()))
                    .findFirst()
                    .orElseGet(() -> {
                        PaidContentUnlock u = new PaidContentUnlock();
                        u.setUser(user);
                        u.setVideo(video);
                        u.setAmountPaid(amountPaid);
                        return u;
                    });
        }
        PaidContentUnlock unlock = new PaidContentUnlock();
        unlock.setUser(user);
        unlock.setVideo(video);
        unlock.setAmountPaid(amountPaid);
        unlockRepository.save(unlock);
        if (video.getUser() != null) creditPayout(video.getUser(), amountPaid);
        return unlock;
    }

    @Transactional
    public CreatorSubscription cancelSubscription(User subscriber, User creator) {
        CreatorSubscription sub = subscriptionRepository
                .findBySubscriber_IdAndCreator_Id(subscriber.getId(), creator.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No subscription"));
        if (sub.getEndDate() == null || !sub.getEndDate().isAfter(LocalDateTime.now())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Subscription already ended");
        }
        sub.setEndDate(LocalDateTime.now());
        return subscriptionRepository.save(sub);
    }

    public boolean canReview(User user, User creator) {
        if (user == null || creator == null || user.getId().equals(creator.getId())) return false;
        if (reviewRepository.existsByCreatorAndUser(creator, user)) return false;
        if (subscriptionRepository.findBySubscriber_IdAndCreator_Id(user.getId(), creator.getId()).isPresent()) {
            return true;
        }
        if (tipRepository.findBySender_Id(user.getId()).stream()
                .anyMatch(t -> t.getReceiver() != null && creator.getId().equals(t.getReceiver().getId()))) {
            return true;
        }
        List<Videoupload> posts = videoRepository.findByUser_Id(creator.getId());
        for (Videoupload v : posts) {
            if (unlockRepository.existsByUser_IdAndVideo_Id(user.getId(), v.getId())) return true;
            if (likeRepository.existsByVideoAndUser(v, user)) return true;
        }
        return false;
    }

    @Transactional
    public CreatorReview rate(User user, User creator, int rating, String reviewText) {
        if (user == null || creator == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Creator not found");
        }
        if (!canReview(user, creator) && !reviewRepository.existsByCreatorAndUser(creator, user)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Review after you watch, subscribe, tip, or unlock this creator.");
        }
        if (reviewRepository.existsByCreatorAndUser(creator, user)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already reviewed");
        }
        int stars = Math.max(1, Math.min(5, rating));
        CreatorReview review = new CreatorReview();
        review.setCreator(creator);
        review.setUser(user);
        review.setRating(stars);
        review.setReviewText(reviewText);
        reviewRepository.save(review);
        List<CreatorReview> all = reviewRepository.findByCreatorOrderByCreatedAtDesc(creator);
        double avg = all.stream().filter(r -> r.getRating() != null)
                .mapToInt(CreatorReview::getRating).average().orElse(stars);
        creator.setCreatorRating(avg);
        creator.setCreatorReviewCount(all.size());
        userRepository.save(creator);
        return review;
    }
}
