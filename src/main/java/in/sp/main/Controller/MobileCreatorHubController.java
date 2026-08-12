package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.CreatorProfileService;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/creator-hub")
public class MobileCreatorHubController {

    private static final String[] CREATOR_CATEGORIES = {
            "Safety Awareness", "Entrepreneurship", "Financial Literacy",
            "Skill Development", "Inspirational", "Entertainment"
    };

    @Autowired private UserRepository userRepository;
    @Autowired private VideoUploadRepository videoUploadRepository;
    @Autowired private CreatorStoryRepository creatorStoryRepository;
    @Autowired private CreatorNotificationRepository creatorNotificationRepository;
    @Autowired private VideoBookmarkRepository videoBookmarkRepository;
    @Autowired private UserBlockRepository userBlockRepository;
    @Autowired private BrandCollaborationRepository brandCollaborationRepository;
    @Autowired private BrandCollabApplicationRepository brandCollabApplicationRepository;
    @Autowired private TipTransactionRepository tipTransactionRepository;
    @Autowired private CreatorSubscriptionRepository creatorSubscriptionRepository;
    @Autowired private PaidContentUnlockRepository paidContentUnlockRepository;
    @Autowired private CreatorCashoutRepository creatorCashoutRepository;
    @Autowired private VideoLikeRepository videoLikeRepository;
    @Autowired private VideoCommentRepository videoCommentRepository;
    @Autowired private UserFollowRepository userFollowRepository;
    @Autowired private VideoReportRepository videoReportRepository;
    @Autowired private FileUploadService fileUploadService;
    @Autowired private CreatorProfileService creatorProfileService;
    @Autowired private in.sp.main.Service.CreatorCareService creatorCareService;

    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        return ok(Map.of("categories", List.of(CREATOR_CATEGORIES)));
    }

    @GetMapping("/feed")
    public ResponseEntity<Map<String, Object>> feed(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String sort,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();

        List<Long> blockedUserIds = userBlockRepository.findByUser_Id(currentUser.getId()).stream()
                .map(ub -> ub.getBlockedUser().getId()).toList();
        String cityFilter = city == null ? "" : city.trim().toLowerCase(java.util.Locale.ROOT);
        String sortKey = sort == null ? "newest" : sort.trim().toLowerCase(java.util.Locale.ROOT);

        List<Videoupload> allContent = videoUploadRepository.findAll().stream()
                .filter(v -> !v.isBlocked() && !v.isDraft() && "APPROVED".equals(v.getStatus()))
                .filter(v -> v.getUser() != null && !blockedUserIds.contains(v.getUser().getId()))
                .filter(v -> v.getUser().getId().equals(currentUser.getId())
                        || CreatorProfileService.isApprovedCreator(v.getUser()))
                .filter(v -> canViewUploader(currentUser, v.getUser()))
                .collect(Collectors.toList());

        if (search != null && !search.isBlank()) {
            String q = search.toLowerCase();
            allContent = allContent.stream().filter(v ->
                    contains(v.getTitle(), q) || contains(v.getDescription(), q) || contains(v.getHashtags(), q)
            ).collect(Collectors.toList());
        }
        if (category != null && !category.isBlank()) {
            String cat = category.trim().toLowerCase();
            allContent = allContent.stream()
                    .filter(v -> {
                        String vc = v.getCategory() == null ? "" : v.getCategory().toLowerCase();
                        String uc = v.getUser() == null || v.getUser().getCreatorCategory() == null
                                ? "" : v.getUser().getCreatorCategory().toLowerCase();
                        return vc.contains(cat) || uc.contains(cat);
                    })
                    .collect(Collectors.toList());
        }
        if (!cityFilter.isBlank()) {
            allContent = allContent.stream()
                    .filter(v -> v.getUser() != null && v.getUser().getCreatorCity() != null
                            && v.getUser().getCreatorCity().toLowerCase(java.util.Locale.ROOT).contains(cityFilter))
                    .collect(Collectors.toList());
        }
        allContent.sort((a, b) -> {
            if ("rating".equals(sortKey)) {
                double ra = a.getUser() == null ? 0 : a.getUser().getCreatorRating();
                double rb = b.getUser() == null ? 0 : b.getUser().getCreatorRating();
                int cmp = Double.compare(rb, ra);
                if (cmp != 0) return cmp;
            }
            if (a.getUploadTime() == null && b.getUploadTime() == null) return 0;
            if (a.getUploadTime() == null) return 1;
            if (b.getUploadTime() == null) return -1;
            return b.getUploadTime().compareTo(a.getUploadTime());
        });

        List<Map<String, Object>> posts = allContent.stream()
                .map(v -> postDto(v, currentUser))
                .toList();

        LocalDateTime since = LocalDateTime.now().minusHours(24);
        List<Map<String, Object>> storyGroups = buildStoryGroups(currentUser, blockedUserIds, since);

        List<Map<String, Object>> trending = videoUploadRepository.findAll().stream()
                .filter(v -> !v.isBlocked() && !v.isDraft() && "APPROVED".equals(v.getStatus()))
                .sorted((a, b) -> Integer.compare(b.getViewCount(), a.getViewCount()))
                .limit(5)
                .map(v -> postDto(v, currentUser))
                .toList();

        List<Map<String, Object>> recommended = userRepository.findAll().stream()
                .filter(u -> CreatorProfileService.isApprovedCreator(u) && !u.getId().equals(currentUser.getId()))
                .limit(5)
                .map(this::creatorSummary)
                .toList();

        int unreadNotifCount = creatorNotificationRepository.countByUser_IdAndIsReadFalse(currentUser.getId());
        boolean canUpload = CreatorProfileService.isApprovedCreator(currentUser);

        Map<String, Object> feed = new LinkedHashMap<>();
        feed.put("posts", posts);
        feed.put("stories", storyGroups);
        feed.put("trending", trending);
        feed.put("recommendedCreators", recommended);
        feed.put("categories", List.of(CREATOR_CATEGORIES));
        feed.put("unreadNotificationCount", unreadNotifCount);
        feed.put("count", posts.size());
        feed.put("canUpload", canUpload);
        feed.put("verifiedCreator", currentUser.isVerifiedCreator());
        feed.put("creatorProfileStatus", currentUser.getCreatorProfileStatus() == null
                ? null : currentUser.getCreatorProfileStatus().name());
        feed.put("cancelPolicy", in.sp.main.Service.CreatorCareService.CANCEL_POLICY);
        return ok(feed);
    }

    @GetMapping("/creators/{id}")
    public ResponseEntity<Map<String, Object>> creatorProfile(@PathVariable Long id, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        User creator = userRepository.findById(id).orElse(null);
        if (creator == null) return badRequest("Creator not found");
        if (!creator.getId().equals(currentUser.getId()) && !CreatorProfileService.isApprovedCreator(creator)) {
            return badRequest("Creator not found");
        }

        boolean blocked = userBlockRepository.existsByUser_IdAndBlockedUser_Id(currentUser.getId(), creator.getId())
                || userBlockRepository.existsByUser_IdAndBlockedUser_Id(creator.getId(), currentUser.getId());

        Map<String, Object> profile = creatorSummary(creator);
        profile.put("blocked", blocked);
        if (blocked) {
            return ok(Map.of("creator", profile, "posts", List.of(), "stories", List.of()));
        }

        int followersCount = userFollowRepository.findByFollowed(creator).size();
        int followingCount = userFollowRepository.findByFollower(creator).size();
        boolean isFollowing = userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(currentUser.getId(), creator.getId());
        boolean isRequested = userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedFalse(currentUser.getId(), creator.getId());
        boolean isSubscribed = creatorSubscriptionRepository.existsBySubscriber_IdAndCreator_IdAndEndDateAfter(
                currentUser.getId(), creator.getId(), LocalDateTime.now());

        profile.put("followersCount", followersCount);
        profile.put("followingCount", followingCount);
        profile.put("isFollowing", isFollowing);
        profile.put("isRequested", isRequested);
        profile.put("isSubscribed", isSubscribed);
        profile.put("subscriptionPrice", creator.getCreatorSubscriptionPrice());
        profile.put("walletBalance", creator.getWalletBalance());
        profile.put("isOwnProfile", creator.getId().equals(currentUser.getId()));
        profile.put("canReview", creatorCareService.canReview(currentUser, creator));
        profile.put("canCancelSub", isSubscribed);
        profile.put("cancelPolicy", in.sp.main.Service.CreatorCareService.CANCEL_POLICY);
        profile.put("rating", creator.getCreatorRating());
        profile.put("reviewCount", creator.getCreatorReviewCount());

        List<Map<String, Object>> posts = videoUploadRepository.findByUser_Id(creator.getId()).stream()
                .filter(v -> !v.isBlocked() && !v.isDraft() && "APPROVED".equals(v.getStatus()))
                .map(v -> postDto(v, currentUser))
                .toList();

        LocalDateTime since = LocalDateTime.now().minusHours(24);
        List<Map<String, Object>> stories = creatorStoryRepository
                .findByUser_IdAndIsDraftFalseAndUploadTimeAfter(creator.getId(), since)
                .stream()
                .map(s -> storyDto(s, creator))
                .toList();

        return ok(Map.of("creator", profile, "posts", posts, "stories", stories));
    }

    @GetMapping("/posts/{id}/comments")
    public ResponseEntity<Map<String, Object>> comments(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> items = videoCommentRepository.findByVideo_Id(id).stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("text", c.getText());
            m.put("username", c.getUser() != null ? c.getUser().getFullName() : "User");
            m.put("commentedAt", c.getCommentedAt() == null ? null : c.getCommentedAt().toString());
            return m;
        }).toList();
        return ok(Map.of("comments", items));
    }

    @GetMapping("/bookmarks")
    public ResponseEntity<Map<String, Object>> bookmarks(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = videoBookmarkRepository.findByUser_Id(user.getId()).stream()
                .filter(b -> b.getVideo() != null)
                .map(b -> postDto(b.getVideo(), user))
                .toList();
        return ok(Map.of("posts", items));
    }

    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Videoupload> myUploads = videoUploadRepository.findByUser_Id(user.getId());
        List<Map<String, Object>> drafts = myUploads.stream().filter(Videoupload::isDraft)
                .map(v -> postDto(v, user)).toList();
        List<Map<String, Object>> published = myUploads.stream().filter(v -> !v.isDraft())
                .map(v -> postDto(v, user)).toList();

        int totalViews = published.stream().mapToInt(p -> ((Number) p.getOrDefault("viewCount", 0)).intValue()).sum();
        int totalLikes = published.stream().mapToInt(p -> ((Number) p.getOrDefault("likeCount", 0)).intValue()).sum();
        int unclaimedViews = Math.max(0, totalViews - user.getAdViewsClaimed());
        double estAdRevenue = unclaimedViews * 0.05;

        int subscriberCount = creatorSubscriptionRepository.countByCreator_IdAndEndDateAfter(user.getId(), LocalDateTime.now());
        List<TipTransaction> tips = tipTransactionRepository.findByReceiver_Id(user.getId());
        double totalTips = tips.stream().mapToDouble(TipTransaction::getAmount).sum();

        List<Map<String, Object>> campaigns = brandCollaborationRepository.findByStatus("ACTIVE").stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("title", c.getCampaignTitle());
            m.put("description", c.getDescription());
            m.put("budget", c.getPayRate());
            return m;
        }).toList();

        List<Map<String, Object>> blocked = userBlockRepository.findByUser_Id(user.getId()).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getBlockedUser().getId());
            m.put("name", b.getBlockedUser().getFullName());
            return m;
        }).toList();

        Map<String, Object> userStats = new LinkedHashMap<>();
        userStats.put("rewardPoints", user.getRewardPoints() == null ? 0 : user.getRewardPoints());
        userStats.put("walletBalance", user.getWalletBalance() == null ? 0.0 : user.getWalletBalance());
        userStats.put("isPrivate", user.isPrivate());
        userStats.put("subscriptionPrice", user.getCreatorSubscriptionPrice());
        userStats.put("affiliateCode", user.getCreatorAffiliateCode());
        userStats.put("verifiedCreator", user.isVerifiedCreator());
        userStats.putAll(creatorProfileService.profilePayload(user));

        Map<String, Object> dash = new LinkedHashMap<>();
        dash.put("drafts", drafts);
        dash.put("published", published);
        dash.put("totalViews", totalViews);
        dash.put("totalLikes", totalLikes);
        dash.put("estAdRevenue", estAdRevenue);
        dash.put("unclaimedViews", unclaimedViews);
        dash.put("subscriberCount", subscriberCount);
        dash.put("totalTipsAmount", totalTips);
        dash.put("brandCampaigns", campaigns);
        dash.put("blockedUsers", blocked);
        dash.put("categories", List.of(CREATOR_CATEGORIES));
        dash.put("user", userStats);
        dash.put("approved", CreatorProfileService.isApprovedCreator(user));
        dash.put("canUpload", CreatorProfileService.isApprovedCreator(user));
        dash.put("payoutBalance", user.getCreatorPayoutBalance());
        dash.put("upiId", user.getCreatorUpiId());
        dash.put("cancelPolicy", in.sp.main.Service.CreatorCareService.CANCEL_POLICY);
        return ok(dash);
    }

    @GetMapping("/notifications")
    public ResponseEntity<Map<String, Object>> notifications(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<CreatorNotification> notifs = creatorNotificationRepository.findByUser_IdOrderByCreatedAtDesc(user.getId());
        List<Map<String, Object>> items = new ArrayList<>();
        for (CreatorNotification n : notifs) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", n.getId());
            m.put("type", n.getType());
            m.put("message", n.getMessage());
            m.put("videoId", n.getVideoId());
            m.put("createdAt", n.getCreatedAt() == null ? null : n.getCreatedAt().toString());
            m.put("read", n.isRead());
            if (n.getSender() != null) {
                m.put("senderName", n.getSender().getFullName());
                m.put("senderId", n.getSender().getId());
            }
            items.add(m);
            if (!n.isRead()) {
                n.setRead(true);
                creatorNotificationRepository.save(n);
            }
        }
        return ok(Map.of("notifications", items));
    }

    @PostMapping("/upload")
    @Transactional
    public ResponseEntity<Map<String, Object>> upload(
            @RequestParam String title,
            @RequestParam String description,
            @RequestParam String category,
            @RequestParam String uploadType,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String hashtags,
            @RequestParam(defaultValue = "false") boolean isDraft,
            @RequestParam(defaultValue = "false") boolean isPaidContent,
            @RequestParam(defaultValue = "0.0") Double price,
            @RequestParam(defaultValue = "false") boolean isSubscriberOnly,
            @RequestParam(required = false) String affiliateLink,
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        if (!CreatorProfileService.isApprovedCreator(user)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "error", "Your creator profile must be approved by admin before you can upload."));
        }
        if (file.isEmpty()) return badRequest("Media file is required");

        try {
            String mediaPath = fileUploadService.saveFile(file);
            String thumbPath = (thumbnail != null && !thumbnail.isEmpty()) ? fileUploadService.saveFile(thumbnail) : null;
            String safetyStatus = performAISafetyScan(title + " " + description + " " + hashtags);
            boolean isVideo = file.getContentType() != null && file.getContentType().startsWith("video");

            if ("STORY".equalsIgnoreCase(uploadType)) {
                CreatorStory story = new CreatorStory();
                story.setUser(user);
                story.setMediaPath(mediaPath);
                story.setFileType(isVideo ? "VIDEO" : "IMAGE");
                story.setCaption(description);
                story.setDraft(isDraft);
                story.setPrivate(user.isPrivate());
                creatorStoryRepository.save(story);
                return ok(Map.of("message", "Story uploaded", "type", "STORY", "status", safetyStatus));
            }

            Videoupload video = new Videoupload();
            video.setUser(user);
            video.setTitle(title);
            video.setDescription(description);
            video.setVideoPath(mediaPath);
            video.setThumbnailPath(thumbPath);
            video.setCategory(category);
            video.setLocation(location);
            video.setHashtags(hashtags);
            video.setDraft(isDraft);
            video.setPaidContent(isPaidContent);
            video.setPrice(price);
            video.setSubscriberOnly(isSubscriberOnly);
            video.setAffiliateLink(affiliateLink);
            video.setFileType(isVideo ? "VIDEO" : "IMAGE");
            video.setReel("REEL".equalsIgnoreCase(uploadType));
            video.setUploadTime(LocalDateTime.now());
            video.setStatus(safetyStatus);
            videoUploadRepository.save(video);
            return ok(Map.of("message", "Content uploaded", "postId", video.getId(), "status", safetyStatus));
        } catch (IOException e) {
            return badRequest("Upload failed: " + e.getMessage());
        }
    }

    @PostMapping("/creators/{id}/follow")
    @Transactional
    public ResponseEntity<Map<String, Object>> follow(@PathVariable Long id, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        User creator = userRepository.findById(id).orElse(null);
        if (creator == null) return badRequest("Creator not found");

        Optional<UserFollow> existing = userFollowRepository.findRelation(currentUser, creator);
        if (existing.isPresent()) {
            userFollowRepository.delete(existing.get());
            return ok(Map.of("status", "UNFOLLOWED"));
        }
        UserFollow uf = new UserFollow();
        uf.setFollower(currentUser);
        uf.setFollowed(creator);
        uf.setAccepted(!creator.isPrivate());
        userFollowRepository.save(uf);

        CreatorNotification notif = new CreatorNotification();
        notif.setUser(creator);
        notif.setSender(currentUser);
        notif.setType("FOLLOW");
        notif.setMessage(currentUser.getFullName() + (creator.isPrivate() ? " requested to follow you." : " started following you."));
        creatorNotificationRepository.save(notif);

        return ok(Map.of("status", creator.isPrivate() ? "REQUESTED" : "FOLLOWED"));
    }

    @PostMapping("/creators/tip")
    @Transactional
    public ResponseEntity<Map<String, Object>> tip(@RequestBody Map<String, Object> body, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        Long creatorId = longVal(body.get("creatorId"));
        Double amount = dbl(body.get("amount"));
        String message = str(body.get("message"));
        if (creatorId == null || amount == null || amount <= 0) return badRequest("Invalid tip");
        User creator = userRepository.findById(creatorId).orElse(null);
        if (creator == null) return badRequest("Creator not found");
        if (currentUser.getWalletBalance() == null || currentUser.getWalletBalance() < amount) {
            return badRequest("Insufficient wallet balance");
        }
        currentUser.setWalletBalance(currentUser.getWalletBalance() - amount);
        creator.setWalletBalance((creator.getWalletBalance() == null ? 0.0 : creator.getWalletBalance()) + amount);
        userRepository.save(currentUser);
        userRepository.save(creator);
        TipTransaction tip = new TipTransaction();
        tip.setSender(currentUser);
        tip.setReceiver(creator);
        tip.setAmount(amount);
        tip.setMessage(message);
        tipTransactionRepository.save(tip);
        try { creatorCareService.creditPayout(creator, amount); } catch (Exception ignored) {}
        session.setAttribute("user", currentUser);
        return ok(Map.of("success", true, "newBalance", currentUser.getWalletBalance()));
    }

    @PostMapping("/creators/subscribe")
    @Transactional
    public ResponseEntity<Map<String, Object>> subscribe(@RequestBody Map<String, Object> body, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        Long creatorId = longVal(body.get("creatorId"));
        if (creatorId == null) return badRequest("creatorId required");
        User creator = userRepository.findById(creatorId).orElse(null);
        if (creator == null) return badRequest("Creator not found");
        Double price = creator.getCreatorSubscriptionPrice();
        if (price == null || price <= 0) return badRequest("Subscription not enabled");
        if (currentUser.getWalletBalance() == null || currentUser.getWalletBalance() < price) {
            return badRequest("Insufficient wallet balance");
        }
        CreatorSubscription sub = creatorSubscriptionRepository
                .findBySubscriber_IdAndCreator_Id(currentUser.getId(), creator.getId())
                .orElseGet(CreatorSubscription::new);
        sub.setSubscriber(currentUser);
        sub.setCreator(creator);
        sub.setStartDate(LocalDateTime.now());
        sub.setEndDate(LocalDateTime.now().plusMonths(1));
        sub.setAmountPaid(price);
        creatorSubscriptionRepository.save(sub);
        currentUser.setWalletBalance(currentUser.getWalletBalance() - price);
        creator.setWalletBalance((creator.getWalletBalance() == null ? 0.0 : creator.getWalletBalance()) + price);
        userRepository.save(currentUser);
        userRepository.save(creator);
        try { creatorCareService.creditPayout(creator, price); } catch (Exception ignored) {}
        session.setAttribute("user", currentUser);
        return ok(Map.of("success", true, "newBalance", currentUser.getWalletBalance()));
    }

    @PostMapping("/creators/{id}/unsubscribe")
    @Transactional
    public ResponseEntity<Map<String, Object>> unsubscribe(@PathVariable Long id, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        User creator = userRepository.findById(id).orElse(null);
        if (creator == null) return badRequest("Creator not found");
        try {
            creatorCareService.cancelSubscription(currentUser, creator);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
        return ok(Map.of("message", "Subscription cancelled", "cancelPolicy", in.sp.main.Service.CreatorCareService.CANCEL_POLICY));
    }

    @PostMapping("/creators/{id}/rate")
    @Transactional
    public ResponseEntity<Map<String, Object>> rateCreator(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        User creator = userRepository.findById(id).orElse(null);
        if (creator == null) return badRequest("Creator not found");
        int stars = 5;
        try {
            if (body != null && body.get("rating") != null) stars = Integer.parseInt(String.valueOf(body.get("rating")));
        } catch (Exception ignored) {}
        String text = body == null || body.get("review") == null ? "" : String.valueOf(body.get("review"));
        try {
            creatorCareService.rate(currentUser, creator, stars, text);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
        return ok(Map.of("message", "Thanks for your review"));
    }

    @PostMapping("/posts/{id}/unlock")
    @Transactional
    public ResponseEntity<Map<String, Object>> unlock(@PathVariable Long id, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) return unauthorized();
        Videoupload video = videoUploadRepository.findById(id).orElse(null);
        if (video == null) return badRequest("Post not found");
        if (paidContentUnlockRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), id)) {
            return ok(Map.of("success", true, "alreadyUnlocked", true));
        }
        Double price = video.getPrice() == null ? 0.0 : video.getPrice();
        if (currentUser.getWalletBalance() == null || currentUser.getWalletBalance() < price) {
            return badRequest("Insufficient wallet balance");
        }
        currentUser.setWalletBalance(currentUser.getWalletBalance() - price);
        User creator = video.getUser();
        creator.setWalletBalance((creator.getWalletBalance() == null ? 0.0 : creator.getWalletBalance()) + price);
        userRepository.save(currentUser);
        userRepository.save(creator);
        PaidContentUnlock unlock = new PaidContentUnlock();
        unlock.setUser(currentUser);
        unlock.setVideo(video);
        unlock.setAmountPaid(price);
        paidContentUnlockRepository.save(unlock);
        if (creator != null) {
            try { creatorCareService.creditPayout(creator, price); } catch (Exception ignored) {}
        }
        session.setAttribute("user", currentUser);
        return ok(Map.of("success", true, "newBalance", currentUser.getWalletBalance()));
    }

    @PostMapping("/posts/{id}/bookmark")
    @Transactional
    public ResponseEntity<Map<String, Object>> bookmark(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Videoupload video = videoUploadRepository.findById(id).orElse(null);
        if (video == null) return badRequest("Post not found");
        Optional<VideoBookmark> existing = videoBookmarkRepository.findByUser_IdAndVideo_Id(user.getId(), id);
        if (existing.isPresent()) {
            videoBookmarkRepository.delete(existing.get());
            return ok(Map.of("bookmarked", false));
        }
        VideoBookmark vb = new VideoBookmark();
        vb.setUser(user);
        vb.setVideo(video);
        videoBookmarkRepository.save(vb);
        return ok(Map.of("bookmarked", true));
    }

    @PostMapping("/posts/{id}/view")
    @Transactional
    public ResponseEntity<Map<String, Object>> view(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        Videoupload video = videoUploadRepository.findById(id).orElse(null);
        if (video == null) return badRequest("Post not found");
        video.setViewCount(video.getViewCount() + 1);
        videoUploadRepository.save(video);
        User creator = video.getUser();
        if (creator != null) {
            creator.setRewardPoints((creator.getRewardPoints() == null ? 0 : creator.getRewardPoints()) + 10);
            userRepository.save(creator);
        }
        return ok(Map.of("viewCount", video.getViewCount()));
    }

    @PostMapping("/posts/{id}/like")
    @Transactional
    public ResponseEntity<Map<String, Object>> like(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Videoupload video = videoUploadRepository.findById(id).orElse(null);
        if (video == null) return badRequest("Post not found");
        Optional<VideoLike> existing = videoLikeRepository.findByVideoAndUser(video, user);
        boolean liked;
        if (existing.isPresent()) {
            videoLikeRepository.delete(existing.get());
            liked = false;
        } else {
            VideoLike like = new VideoLike();
            like.setUser(user);
            like.setVideo(video);
            videoLikeRepository.save(like);
            liked = true;
        }
        int likeCount = videoLikeRepository.countByVideo(video);
        video.setLikeCount(likeCount);
        videoUploadRepository.save(video);
        return ok(Map.of("liked", liked, "likeCount", likeCount));
    }

    @PostMapping("/posts/{id}/comments")
    @Transactional
    public ResponseEntity<Map<String, Object>> comment(@PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Videoupload video = videoUploadRepository.findById(id).orElse(null);
        if (video == null) return badRequest("Post not found");
        String text = body == null ? null : body.get("text");
        if (text == null || text.isBlank()) return badRequest("Comment text required");
        VideoComment comment = new VideoComment();
        comment.setUser(user);
        comment.setText(text.trim());
        comment.setCommentedAt(LocalDateTime.now());
        comment.setVideo(video);
        videoCommentRepository.save(comment);
        return ok(Map.of("id", comment.getId(), "username", user.getFullName(), "text", comment.getText()));
    }

    @PostMapping("/posts/{id}/report")
    @Transactional
    public ResponseEntity<Map<String, Object>> report(@PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Videoupload video = videoUploadRepository.findById(id).orElse(null);
        if (video == null) return badRequest("Post not found");
        VideoReport report = new VideoReport();
        report.setVideo(video);
        report.setReportedBy(user);
        report.setReason(body == null ? "Reported from mobile" : str(body.get("reason")));
        videoReportRepository.save(report);
        user.setRewardPoints((user.getRewardPoints() == null ? 0 : user.getRewardPoints()) + 5);
        userRepository.save(user);
        session.setAttribute("user", user);
        return ok(Map.of("message", "Report submitted"));
    }

    @PostMapping("/creators/{id}/block")
    @Transactional
    public ResponseEntity<Map<String, Object>> block(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        User blocked = userRepository.findById(id).orElse(null);
        if (blocked == null) return badRequest("User not found");
        if (!userBlockRepository.existsByUser_IdAndBlockedUser_Id(user.getId(), id)) {
            UserBlock block = new UserBlock();
            block.setUser(user);
            block.setBlockedUser(blocked);
            userBlockRepository.save(block);
        }
        userFollowRepository.findRelation(user, blocked).ifPresent(userFollowRepository::delete);
        userFollowRepository.findRelation(blocked, user).ifPresent(userFollowRepository::delete);
        return ok(Map.of("success", true));
    }

    @PostMapping("/dashboard/cashout")
    @Transactional
    public ResponseEntity<Map<String, Object>> cashout(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        int points = body.get("points") instanceof Number n ? n.intValue() : 0;
        if (points < 100) return badRequest("Minimum 100 points");
        if (user.getRewardPoints() == null || user.getRewardPoints() < points) return badRequest("Insufficient points");
        user.setRewardPoints(user.getRewardPoints() - points);
        double amount = (points / 100.0) * 10.0;
        CreatorCashout cashout = new CreatorCashout();
        cashout.setCreator(user);
        cashout.setPoints(points);
        cashout.setAmount(amount);
        cashout.setStatus("PENDING");
        creatorCashoutRepository.save(cashout);
        userRepository.save(user);
        session.setAttribute("user", user);
        return ok(Map.of("success", true, "amount", amount, "remainingPoints", user.getRewardPoints()));
    }

    @PostMapping("/dashboard/claim-ad-revenue")
    @Transactional
    public ResponseEntity<Map<String, Object>> claimAdRevenue(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        int totalViews = videoUploadRepository.findByUser_Id(user.getId()).stream()
                .filter(v -> !v.isDraft()).mapToInt(Videoupload::getViewCount).sum();
        int unclaimed = Math.max(0, totalViews - user.getAdViewsClaimed());
        if (unclaimed <= 0) return badRequest("No ad revenue to claim");
        double claimAmount = unclaimed * 0.05;
        user.setAdViewsClaimed(totalViews);
        user.setWalletBalance((user.getWalletBalance() == null ? 0.0 : user.getWalletBalance()) + claimAmount);
        userRepository.save(user);
        session.setAttribute("user", user);
        return ok(Map.of("success", true, "claimedAmount", claimAmount, "newBalance", user.getWalletBalance()));
    }

    @PostMapping("/dashboard/toggle-privacy")
    @Transactional
    public ResponseEntity<Map<String, Object>> togglePrivacy(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        user.setPrivate(!user.isPrivate());
        userRepository.save(user);
        session.setAttribute("user", user);
        return ok(Map.of("isPrivate", user.isPrivate()));
    }

    @PostMapping("/dashboard/subscription-price")
    @Transactional
    public ResponseEntity<Map<String, Object>> setSubscriptionPrice(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Double price = dbl(body.get("price"));
        if (price == null || price < 0) return badRequest("Invalid price");
        user.setCreatorSubscriptionPrice(price);
        userRepository.save(user);
        session.setAttribute("user", user);
        return ok(Map.of("price", price));
    }

    @PostMapping("/dashboard/publish-draft")
    @Transactional
    public ResponseEntity<Map<String, Object>> publishDraft(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        if (!CreatorProfileService.isApprovedCreator(user)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "error", "Your creator profile must be approved by admin before you can publish."));
        }
        Long videoId = longVal(body.get("videoId"));
        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video == null || !video.getUser().getId().equals(user.getId())) return badRequest("Not found");
        video.setDraft(false);
        video.setUploadTime(LocalDateTime.now());
        videoUploadRepository.save(video);
        return ok(Map.of("message", "Draft published"));
    }

    @PostMapping("/dashboard/delete-upload")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteUpload(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Long videoId = longVal(body.get("videoId"));
        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video == null || !video.getUser().getId().equals(user.getId())) return badRequest("Not found");
        videoLikeRepository.deleteByVideo(video);
        videoCommentRepository.deleteByVideoId(videoId);
        videoUploadRepository.delete(video);
        return ok(Map.of("message", "Deleted"));
    }

    @PostMapping("/dashboard/unblock")
    @Transactional
    public ResponseEntity<Map<String, Object>> unblock(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Long blockedUserId = longVal(body.get("blockedUserId"));
        userBlockRepository.findByUser_IdAndBlockedUser_Id(user.getId(), blockedUserId)
                .ifPresent(userBlockRepository::delete);
        return ok(Map.of("success", true));
    }

    @PostMapping("/collab/apply")
    @Transactional
    public ResponseEntity<Map<String, Object>> applyCollab(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        if (!CreatorProfileService.isApprovedCreator(user)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "error", "Your creator profile must be approved before applying to campaigns."));
        }
        Long campaignId = longVal(body.get("campaignId"));
        String pitch = str(body.get("pitch"));
        BrandCollaboration collab = brandCollaborationRepository.findById(campaignId).orElse(null);
        if (collab == null) return badRequest("Campaign not found");
        if (brandCollabApplicationRepository.existsByCollaboration_IdAndCreator_Id(campaignId, user.getId())) {
            return badRequest("Already applied");
        }
        BrandCollabApplication app = new BrandCollabApplication();
        app.setCollaboration(collab);
        app.setCreator(user);
        app.setPitch(pitch);
        app.setStatus("PENDING");
        brandCollabApplicationRepository.save(app);
        return ok(Map.of("message", "Application submitted"));
    }

    // ── helpers ──

    private boolean canViewUploader(User viewer, User uploader) {
        if (uploader == null) return false;
        if (uploader.getId().equals(viewer.getId())) return true;
        if (!uploader.isPrivate()) return true;
        return userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(viewer.getId(), uploader.getId());
    }

    private List<Map<String, Object>> buildStoryGroups(User currentUser, List<Long> blockedUserIds, LocalDateTime since) {
        List<CreatorStory> active = creatorStoryRepository.findByIsDraftFalseAndUploadTimeAfter(since).stream()
                .filter(s -> s.getUser() != null && !blockedUserIds.contains(s.getUser().getId()))
                .filter(s -> s.getUser().getId().equals(currentUser.getId())
                        || CreatorProfileService.isApprovedCreator(s.getUser()))
                .filter(s -> canViewUploader(currentUser, s.getUser()))
                .toList();
        Map<Long, List<CreatorStory>> byUser = active.stream()
                .collect(Collectors.groupingBy(s -> s.getUser().getId(), LinkedHashMap::new, Collectors.toList()));
        List<Map<String, Object>> groups = new ArrayList<>();
        for (Map.Entry<Long, List<CreatorStory>> e : byUser.entrySet()) {
            User u = e.getValue().get(0).getUser();
            Map<String, Object> g = new LinkedHashMap<>();
            g.put("userId", u.getId());
            g.put("userName", u.getFullName());
            g.put("profilePhoto", u.getProfilePhoto());
            g.put("verified", u.isVerifiedCreator());
            g.put("items", e.getValue().stream().map(s -> storyDto(s, u)).toList());
            groups.add(g);
        }
        return groups;
    }

    private Map<String, Object> postDto(Videoupload v, User currentUser) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", v.getId());
        m.put("title", v.getTitle());
        m.put("description", v.getDescription());
        m.put("videoPath", v.getVideoPath());
        m.put("thumbnailPath", v.getThumbnailPath());
        m.put("category", v.getCategory());
        m.put("location", v.getLocation());
        m.put("hashtags", v.getHashtags());
        m.put("fileType", v.getFileType());
        m.put("isReel", v.isReel());
        m.put("likeCount", v.getLikeCount());
        m.put("viewCount", v.getViewCount());
        m.put("uploadTime", v.getUploadTime() == null ? null : v.getUploadTime().toString());
        m.put("isPaidContent", v.isPaidContent());
        m.put("price", v.getPrice());
        m.put("isSubscriberOnly", v.isSubscriberOnly());
        m.put("affiliateLink", v.getAffiliateLink());
        m.put("status", v.getStatus());
        m.put("isDraft", v.isDraft());
        m.put("liked", videoLikeRepository.existsByVideoAndUser(v, currentUser));
        m.put("bookmarked", videoBookmarkRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), v.getId()));
        boolean subLocked = v.isSubscriberOnly()
                && v.getUser() != null && !v.getUser().getId().equals(currentUser.getId())
                && !creatorSubscriptionRepository.existsBySubscriber_IdAndCreator_IdAndEndDateAfter(
                currentUser.getId(), v.getUser().getId(), LocalDateTime.now());
        boolean paidLocked = v.isPaidContent()
                && v.getUser() != null && !v.getUser().getId().equals(currentUser.getId())
                && !paidContentUnlockRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), v.getId());
        m.put("subscriberLocked", subLocked);
        m.put("paidLocked", paidLocked);
        m.put("locked", subLocked || paidLocked);
        if (v.getUser() != null) {
            m.put("creator", creatorSummary(v.getUser()));
        }
        return m;
    }

    private Map<String, Object> storyDto(CreatorStory s, User u) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("mediaPath", s.getMediaPath());
        m.put("fileType", s.getFileType());
        m.put("caption", s.getCaption());
        m.put("uploadTime", s.getUploadTime() == null ? null : s.getUploadTime().toString());
        m.put("userId", u.getId());
        m.put("userName", u.getFullName());
        return m;
    }

    private Map<String, Object> creatorSummary(User u) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", u.getId());
        m.put("name", u.getFullName());
        m.put("profilePhoto", u.getProfilePhoto());
        m.put("verifiedCreator", u.isVerifiedCreator());
        m.put("isPrivate", u.isPrivate());
        m.put("city", u.getCreatorCity());
        m.put("category", u.getCreatorCategory());
        m.put("rating", u.getCreatorRating());
        m.put("reviewCount", u.getCreatorReviewCount());
        m.put("approved", CreatorProfileService.isApprovedCreator(u));
        return m;
    }

    private String performAISafetyScan(String text) {
        if (text == null) return "APPROVED";
        String content = text.toLowerCase();
        String[] flagged = {"violence", "abuse", "hate", "scam", "illegal", "threat", "harass", "kill", "weapons"};
        for (String word : flagged) {
            if (content.contains(word)) return "PENDING_MODERATION";
        }
        return "APPROVED";
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        if (!(u instanceof User user)) return null;
        return userRepository.findById(user.getId()).orElse(user);
    }

    private static boolean contains(String s, String q) {
        return s != null && s.toLowerCase().contains(q);
    }

    private static String str(Object v) { return v == null ? "" : v.toString(); }
    private static Double dbl(Object v) { return v instanceof Number n ? n.doubleValue() : null; }
    private static Long longVal(Object v) {
        if (v instanceof Number n) return n.longValue();
        try { return Long.parseLong(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }

    private static ResponseEntity<Map<String, Object>> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return ResponseEntity.ok(out);
    }
}
