package in.sp.main.Service;

import in.sp.main.Entities.ExpressPost;
import in.sp.main.Entities.ExpressPostType;
import in.sp.main.Entities.Review;
import in.sp.main.Entities.SalonReview;
import in.sp.main.Repository.ExpressPostRepository;
import in.sp.main.Repository.ReviewRepository;
import in.sp.main.Repository.SalonReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class IndexTemplatesFeedService {

    private static final String[] PERSON_IMAGES = {
            "/beauty/images/person_1.jpg",
            "/beauty/images/person_2.jpg",
            "/beauty/images/person_3.jpg",
            "/beauty/images/person_4.jpg",
            "/beauty/images/person_5.jpg",
            "/beauty/images/person_6.jpg"
    };

    private static final String[] BLOG_IMAGES = {
            "/beauty/images/image_1.jpg",
            "/beauty/images/image_2.jpg",
            "/beauty/images/image_3.jpg"
    };

    @Autowired
    private SalonReviewRepository salonReviewRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ExpressPostRepository expressPostRepository;

    @Transactional(readOnly = true)
    public Map<String, Object> buildFeed() {
        List<Map<String, Object>> reviews = buildReviews();
        List<Map<String, Object>> posts = buildRecentPosts(reviews);

        Map<String, Object> feed = new HashMap<>();
        feed.put("reviews", reviews);
        feed.put("posts", posts);
        feed.put("signature", buildSignature(reviews, posts));
        feed.put("updatedAt", LocalDateTime.now().toString());
        return feed;
    }

    private List<Map<String, Object>> buildReviews() {
        List<Map<String, Object>> combined = new ArrayList<>();

        for (SalonReview sr : salonReviewRepository.findTop20ByOrderByCreatedAtDesc()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", "salon-" + sr.getId());
            item.put("source", "SALON");
            item.put("userName", sr.getUserName() != null ? sr.getUserName() : "Guest");
            item.put("rating", sr.getRating());
            item.put("comment", sr.getComment() != null ? sr.getComment() : "");
            item.put("position", sr.getSalon() != null ? sr.getSalon().getName() + " Client" : "Salon Client");
            item.put("salonName", sr.getSalon() != null ? sr.getSalon().getName() : "");
            item.put("createdAt", sr.getCreatedAt() != null ? sr.getCreatedAt().toString() : "");
            item.put("sortTime", sr.getCreatedAt() != null ? sr.getCreatedAt() : LocalDateTime.MIN);
            combined.add(item);
        }

        for (Review r : reviewRepository.findTop20ByOrderByCreatedAtDesc()) {
            Map<String, Object> item = new HashMap<>();
            String name = r.getUser() != null && r.getUser().getFullName() != null
                    ? r.getUser().getFullName() : "Guest";
            String position = r.getStylist() != null ? "Stylist Client" : "Beauty Client";
            item.put("id", "stylist-" + r.getId());
            item.put("source", "STYLIST");
            item.put("userName", name);
            item.put("rating", r.getRating() != null ? r.getRating() : 0);
            item.put("comment", r.getComment() != null ? r.getComment() : "");
            item.put("position", position);
            item.put("salonName", r.getSalon() != null ? r.getSalon().getName() : "");
            item.put("createdAt", r.getCreatedAt() != null ? r.getCreatedAt().toString() : "");
            item.put("sortTime", r.getCreatedAt() != null ? r.getCreatedAt() : LocalDateTime.MIN);
            combined.add(item);
        }

        List<Map<String, Object>> sorted = combined.stream()
                .sorted(Comparator.comparing(
                        (Map<String, Object> m) -> (LocalDateTime) m.get("sortTime")).reversed())
                .limit(12)
                .peek(m -> m.remove("sortTime"))
                .collect(Collectors.toList());
        for (int i = 0; i < sorted.size(); i++) {
            sorted.get(i).put("avatarUrl", PERSON_IMAGES[i % PERSON_IMAGES.length]);
        }
        return sorted;
    }

    private List<Map<String, Object>> buildRecentPosts(List<Map<String, Object>> reviews) {
        List<Map<String, Object>> posts = new ArrayList<>();

        for (ExpressPost p : expressPostRepository.findTop10ByPostTypeOrderByCreatedAtDesc(ExpressPostType.GENERAL)) {
            posts.add(mapExpressPost(p, posts.size()));
        }

        if (posts.size() < 6) {
            for (Map<String, Object> review : reviews) {
                if (posts.size() >= 6) break;
                posts.add(mapReviewAsPost(review, posts.size()));
            }
        }

        return posts.stream().limit(6).collect(Collectors.toList());
    }

    private Map<String, Object> mapExpressPost(ExpressPost p, int index) {
        LocalDateTime at = p.getCreatedAt() != null ? p.getCreatedAt() : LocalDateTime.now();
        String author = p.getUser() != null && p.getUser().getFullName() != null
                ? p.getUser().getFullName() : "Community Member";
        String content = p.getContent() != null ? p.getContent() : "";
        String title = content.length() > 48 ? content.substring(0, 48).trim() + "…" : content;
        if (title.isBlank()) title = "Community Update";

        Map<String, Object> post = new HashMap<>();
        post.put("id", "post-" + p.getId());
        post.put("title", title);
        post.put("excerpt", content.length() > 160 ? content.substring(0, 160).trim() + "…" : content);
        post.put("authorName", author);
        post.put("imageUrl", p.getMediaUrl() != null && !p.getMediaUrl().isBlank()
                ? p.getMediaUrl() : BLOG_IMAGES[index % BLOG_IMAGES.length]);
        putDateParts(post, at);
        return post;
    }

    private Map<String, Object> mapReviewAsPost(Map<String, Object> review, int index) {
        LocalDateTime at = LocalDateTime.now();
        try {
            if (review.get("createdAt") != null) {
                at = LocalDateTime.parse(review.get("createdAt").toString());
            }
        } catch (Exception ignored) {
        }
        int rating = review.get("rating") instanceof Number n ? n.intValue() : 0;
        String salon = review.get("salonName") != null ? review.get("salonName").toString() : "Glow Space";
        String stars = "★".repeat(Math.max(0, Math.min(5, rating))) + "☆".repeat(Math.max(0, 5 - rating));

        Map<String, Object> post = new HashMap<>();
        post.put("id", "review-post-" + review.get("id"));
        post.put("title", salon + " — " + stars);
        post.put("excerpt", review.get("comment") != null ? review.get("comment").toString() : "");
        post.put("authorName", review.get("userName") != null ? review.get("userName").toString() : "Guest");
        post.put("imageUrl", BLOG_IMAGES[index % BLOG_IMAGES.length]);
        putDateParts(post, at);
        return post;
    }

    private void putDateParts(Map<String, Object> post, LocalDateTime at) {
        post.put("day", String.valueOf(at.getDayOfMonth()));
        post.put("month", at.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH));
        post.put("year", String.valueOf(at.getYear()));
        post.put("createdAt", at.toString());
    }

    private String buildSignature(List<Map<String, Object>> reviews, List<Map<String, Object>> posts) {
        StringBuilder sb = new StringBuilder();
        for (Map<String, Object> r : reviews) {
            sb.append(r.get("id")).append('|').append(r.get("rating")).append(';');
        }
        for (Map<String, Object> p : posts) {
            sb.append(p.get("id")).append('|').append(p.get("createdAt")).append(';');
        }
        return Integer.toString(sb.toString().hashCode());
    }

    public static String personImage(int index) {
        return PERSON_IMAGES[Math.abs(index) % PERSON_IMAGES.length];
    }
}
