package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/creator-hub")
public class CreatorHubController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VideoUploadRepository videoUploadRepository;

    @Autowired
    private VideoReportRepository videoReportRepository;

    @Autowired
    private VideoViewRepository videoViewRepository;

    @Autowired
    private CreatorStoryRepository creatorStoryRepository;

    @Autowired
    private CreatorNotificationRepository creatorNotificationRepository;

    @Autowired
    private VideoBookmarkRepository videoBookmarkRepository;

    @Autowired
    private UserBlockRepository userBlockRepository;

    @Autowired
    private BrandCollaborationRepository brandCollaborationRepository;

    @Autowired
    private BrandCollabApplicationRepository brandCollabApplicationRepository;

    @Autowired
    private TipTransactionRepository tipTransactionRepository;

    @Autowired
    private CreatorSubscriptionRepository creatorSubscriptionRepository;

    @Autowired
    private PaidContentUnlockRepository paidContentUnlockRepository;

    @Autowired
    private CreatorCashoutRepository creatorCashoutRepository;

    @Autowired
    private VideoLikeRepository videoLikeRepository;

    @Autowired
    private VideoCommentRepository videoCommentRepository;

    @Autowired
    private UserFollowRepository userFollowRepository;

    @Autowired
    private FileUploadService fileUploadService;

    private final String[] CREATOR_CATEGORIES = {
        "Safety Awareness", "Entrepreneurship", "Financial Literacy", "Skill Development", "Inspirational", "Entertainment"
    };

    // Get current logged in user helper
    private User getSessionUser(HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return null;
        return userRepository.findById(u.getId()).orElse(null);
    }

    // AI Safety scan for auto moderation
    private String performAISafetyScan(String text) {
        if (text == null) return "APPROVED";
        String content = text.toLowerCase();
        String[] flagged = {"violence", "abuse", "hate", "scam", "illegal", "threat", "harass", "kill", "weapons"};
        for (String word : flagged) {
            if (content.contains(word)) {
                return "PENDING_MODERATION";
            }
        }
        return "APPROVED";
    }

    // MAIN FEED
    @GetMapping
    public String showFeed(HttpSession session, Model model, 
                           @RequestParam(required = false) String search,
                           @RequestParam(required = false) String category) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        // Filter block relationships
        List<Long> blockedUserIds = userBlockRepository.findByUser_Id(currentUser.getId())
                .stream().map(ub -> ub.getBlockedUser().getId()).collect(Collectors.toList());

        // Fetch all active content (reels, long videos, images)
        List<Videoupload> allContent = videoUploadRepository.findAll().stream()
                .filter(v -> !v.isBlocked() && !v.isDraft() && "APPROVED".equals(v.getStatus()))
                .filter(v -> !blockedUserIds.contains(v.getUser().getId())) // Exclude blocked users
                .collect(Collectors.toList());

        // Filter by uploader profile privacy
        allContent = allContent.stream().filter(v -> {
            User uploader = v.getUser();
            if (uploader.getId().equals(currentUser.getId())) return true;
            if (!uploader.isPrivate()) return true;
            return userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(currentUser.getId(), uploader.getId());
        }).collect(Collectors.toList());

        // Perform search or category filters
        if (search != null && !search.trim().isEmpty()) {
            String query = search.toLowerCase();
            allContent = allContent.stream().filter(v -> 
                (v.getTitle() != null && v.getTitle().toLowerCase().contains(query)) ||
                (v.getDescription() != null && v.getDescription().toLowerCase().contains(query)) ||
                (v.getHashtags() != null && v.getHashtags().toLowerCase().contains(query))
            ).collect(Collectors.toList());
        }

        if (category != null && !category.trim().isEmpty()) {
            allContent = allContent.stream().filter(v -> 
                category.equalsIgnoreCase(v.getCategory())
            ).collect(Collectors.toList());
        }

        // Sort by upload time desc
        allContent.sort((a, b) -> b.getUploadTime().compareTo(a.getUploadTime()));

        // Enrich with like, bookmark, subscriber and unlock information
        for (Videoupload v : allContent) {
            v.setLikedByCurrentUser(videoLikeRepository.existsByVideoAndUser(v, currentUser));
            
            // Check bookmark
            boolean isBookmarked = videoBookmarkRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), v.getId());
            model.addAttribute("bookmarked_" + v.getId(), isBookmarked);

            // Check subscription requirements
            boolean subscriberOnlyLocked = v.isSubscriberOnly() 
                && !v.getUser().getId().equals(currentUser.getId())
                && !creatorSubscriptionRepository.existsBySubscriber_IdAndCreator_IdAndEndDateAfter(currentUser.getId(), v.getUser().getId(), LocalDateTime.now());
            model.addAttribute("subLocked_" + v.getId(), subscriberOnlyLocked);

            // Check paid content unlock requirements
            boolean paidLocked = v.isPaidContent()
                && !v.getUser().getId().equals(currentUser.getId())
                && !paidContentUnlockRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), v.getId());
            model.addAttribute("paidLocked_" + v.getId(), paidLocked);
        }

        // Fetch Stories (last 24 hours, not expired)
        LocalDateTime twentyFourHoursAgo = LocalDateTime.now().minusHours(24);
        List<CreatorStory> activeStories = creatorStoryRepository.findByIsDraftFalseAndUploadTimeAfter(twentyFourHoursAgo)
                .stream()
                .filter(s -> !blockedUserIds.contains(s.getUser().getId()))
                .filter(s -> {
                    User uploader = s.getUser();
                    if (uploader.getId().equals(currentUser.getId())) return true;
                    if (!uploader.isPrivate()) return true;
                    return userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(currentUser.getId(), uploader.getId());
                })
                .collect(Collectors.toList());

        // Group active stories by User
        Map<User, List<CreatorStory>> storiesByUser = activeStories.stream()
                .collect(Collectors.groupingBy(CreatorStory::getUser));

        // Get notifications count
        int unreadNotifCount = creatorNotificationRepository.countByUser_IdAndIsReadFalse(currentUser.getId());

        model.addAttribute("feedContent", allContent);
        model.addAttribute("storiesByUser", storiesByUser);
        model.addAttribute("categories", CREATOR_CATEGORIES);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("searchQuery", search);
        model.addAttribute("unreadNotifCount", unreadNotifCount);
        model.addAttribute("currentUser", currentUser);

        // Sidebar content: Trending Videos (highest viewCount)
        List<Videoupload> trending = videoUploadRepository.findAll().stream()
                .filter(v -> !v.isBlocked() && !v.isDraft() && "APPROVED".equals(v.getStatus()))
                .sorted((a, b) -> Integer.compare(b.getViewCount(), a.getViewCount()))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("trending", trending);

        // Recommended creators
        List<User> creators = userRepository.findAll().stream()
                .filter(u -> u.isVerifiedCreator() && !u.getId().equals(currentUser.getId()))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("recommendedCreators", creators);

        return "creatorHubFeed";
    }

    @GetMapping("/comments-api")
    @ResponseBody
    public List<Map<String, Object>> getCommentsApi(@RequestParam Long videoId) {
        List<VideoComment> list = videoCommentRepository.findByVideo_Id(videoId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (VideoComment c : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", c.getId());
            map.put("text", c.getText());
            map.put("username", c.getUser() != null ? c.getUser().getFullName() : "Anonymous User");
            result.add(map);
        }
        return result;
    }

    // UPLOAD CONTENT PAGE
    @GetMapping("/upload")
    public String showUploadForm(HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        model.addAttribute("categories", CREATOR_CATEGORIES);
        return "creatorHubUpload";
    }

    @PostMapping("/upload")
    public String handleUpload(@RequestParam String title,
                               @RequestParam String description,
                               @RequestParam String category,
                               @RequestParam String uploadType, // REEL, LONG_VIDEO, IMAGE, STORY
                               @RequestParam(required = false) String location,
                               @RequestParam(required = false) String hashtags,
                               @RequestParam(defaultValue = "false") boolean isDraft,
                               @RequestParam(defaultValue = "false") boolean isPaidContent,
                               @RequestParam(defaultValue = "0.0") Double price,
                               @RequestParam(defaultValue = "false") boolean isSubscriberOnly,
                               @RequestParam(required = false) String affiliateLink,
                               @RequestParam("file") MultipartFile file,
                               @RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please upload a media file!");
            return "redirect:/creator-hub/upload";
        }

        try {
            String mediaPath = fileUploadService.saveFile(file);
            String thumbPath = null;
            if (thumbnail != null && !thumbnail.isEmpty()) {
                thumbPath = fileUploadService.saveFile(thumbnail);
            }

            // Run mock AI Safety Moderation Scan on Title & Description
            String textToModer = title + " " + description + " " + hashtags;
            String safetyStatus = performAISafetyScan(textToModer);

            if ("STORY".equalsIgnoreCase(uploadType)) {
                CreatorStory story = new CreatorStory();
                story.setUser(currentUser);
                story.setMediaPath(mediaPath);
                story.setFileType(file.getContentType() != null && file.getContentType().startsWith("video") ? "VIDEO" : "IMAGE");
                story.setCaption(description);
                story.setDraft(isDraft);
                story.setPrivate(currentUser.isPrivate());
                creatorStoryRepository.save(story);
                
                if ("PENDING_MODERATION".equals(safetyStatus)) {
                    redirectAttributes.addFlashAttribute("warning", "Your story has been saved but is pending AI safety review due to sensitive words.");
                } else {
                    redirectAttributes.addFlashAttribute("success", "Story uploaded successfully!");
                }
            } else {
                // Post, Reel, or Long Video
                Videoupload video = new Videoupload();
                video.setUser(currentUser);
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
                video.setFileType(file.getContentType() != null && file.getContentType().startsWith("video") ? "VIDEO" : "IMAGE");
                video.setReel("REEL".equalsIgnoreCase(uploadType));
                video.setUploadTime(LocalDateTime.now());
                video.setStatus(safetyStatus);

                videoUploadRepository.save(video);

                if ("PENDING_MODERATION".equals(safetyStatus)) {
                    redirectAttributes.addFlashAttribute("warning", "Content uploaded! Note: Undergoing AI safety checks before showing in public feeds.");
                } else {
                    redirectAttributes.addFlashAttribute("success", "Content published successfully!");
                }
            }

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "File upload failed: " + e.getMessage());
            return "redirect:/creator-hub/upload";
        }

        return "redirect:/creator-hub";
    }

    // CREATOR PROFILE
    @GetMapping("/creator/{id}")
    public String showCreatorProfile(@PathVariable Long id, HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        User creator = userRepository.findById(id).orElse(null);
        if (creator == null) return "redirect:/creator-hub";

        // Check blocks
        boolean blocked = userBlockRepository.existsByUser_IdAndBlockedUser_Id(currentUser.getId(), creator.getId())
                || userBlockRepository.existsByUser_IdAndBlockedUser_Id(creator.getId(), currentUser.getId());
        if (blocked) {
            model.addAttribute("blocked", true);
            return "creatorProfile";
        }

        // Follow stats
        int followersCount = userFollowRepository.findByFollowed(creator).size();
        int followingCount = userFollowRepository.findByFollower(creator).size();
        boolean isFollowing = userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(currentUser.getId(), creator.getId());
        boolean isRequested = userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedFalse(currentUser.getId(), creator.getId());

        // Check monthly subscription status
        boolean isSubscribed = creatorSubscriptionRepository.existsBySubscriber_IdAndCreator_IdAndEndDateAfter(currentUser.getId(), creator.getId(), LocalDateTime.now());

        // Fetch uploads
        List<Videoupload> uploads = videoUploadRepository.findByUser_Id(creator.getId()).stream()
                .filter(v -> !v.isBlocked() && !v.isDraft() && "APPROVED".equals(v.getStatus()))
                .collect(Collectors.toList());

        // Active stories
        LocalDateTime twentyFourHoursAgo = LocalDateTime.now().minusHours(24);
        List<CreatorStory> stories = creatorStoryRepository.findByUser_IdAndIsDraftFalseAndUploadTimeAfter(creator.getId(), twentyFourHoursAgo);

        // Enrich items
        for (Videoupload v : uploads) {
            v.setLikedByCurrentUser(videoLikeRepository.existsByVideoAndUser(v, currentUser));
            boolean isBookmarked = videoBookmarkRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), v.getId());
            model.addAttribute("bookmarked_" + v.getId(), isBookmarked);

            boolean subLocked = v.isSubscriberOnly() && !creator.getId().equals(currentUser.getId()) && !isSubscribed;
            model.addAttribute("subLocked_" + v.getId(), subLocked);

            boolean paidLocked = v.isPaidContent() && !creator.getId().equals(currentUser.getId()) && !paidContentUnlockRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), v.getId());
            model.addAttribute("paidLocked_" + v.getId(), paidLocked);
        }

        model.addAttribute("creator", creator);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("followersCount", followersCount);
        model.addAttribute("followingCount", followingCount);
        model.addAttribute("isFollowing", isFollowing);
        model.addAttribute("isRequested", isRequested);
        model.addAttribute("isSubscribed", isSubscribed);
        model.addAttribute("uploads", uploads);
        model.addAttribute("stories", stories);

        return "creatorProfile";
    }

    // SOCIAL INTERACTIONS & ENGAGEMENTS
    @PostMapping("/creator/follow/{id}")
    @ResponseBody
    @Transactional
    public Map<String, Object> toggleFollow(@PathVariable Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        User creator = userRepository.findById(id).orElse(null);
        if (creator == null) {
            response.put("error", "CREATOR_NOT_FOUND");
            return response;
        }

        Optional<UserFollow> existing = userFollowRepository.findRelation(currentUser, creator);
        if (existing.isPresent()) {
            userFollowRepository.delete(existing.get());
            response.put("status", "UNFOLLOWED");
        } else {
            UserFollow uf = new UserFollow();
            uf.setFollower(currentUser);
            uf.setFollowed(creator);
            // If creator is private, require approval
            uf.setAccepted(!creator.isPrivate());
            userFollowRepository.save(uf);

            // Send notification
            CreatorNotification notif = new CreatorNotification();
            notif.setUser(creator);
            notif.setSender(currentUser);
            notif.setType("FOLLOW");
            notif.setMessage(currentUser.getFullName() + (creator.isPrivate() ? " requested to follow you." : " started following you."));
            creatorNotificationRepository.save(notif);

            response.put("status", creator.isPrivate() ? "REQUESTED" : "FOLLOWED");
        }

        return response;
    }

    // TIP CREATOR
    @PostMapping("/creator/tip")
    @ResponseBody
    @Transactional
    public Map<String, Object> tipCreator(@RequestParam Long creatorId, 
                                          @RequestParam Double amount, 
                                          @RequestParam(required = false) String message,
                                          HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        User creator = userRepository.findById(creatorId).orElse(null);
        if (creator == null) {
            response.put("error", "CREATOR_NOT_FOUND");
            return response;
        }

        if (amount <= 0) {
            response.put("error", "INVALID_AMOUNT");
            return response;
        }

        if (currentUser.getWalletBalance() < amount) {
            response.put("error", "INSUFFICIENT_FUNDS");
            return response;
        }

        // Deduct from sender
        currentUser.setWalletBalance(currentUser.getWalletBalance() - amount);
        userRepository.save(currentUser);

        // Add to creator
        creator.setWalletBalance(creator.getWalletBalance() + amount);
        userRepository.save(creator);

        // Log Tip transaction
        TipTransaction tip = new TipTransaction();
        tip.setSender(currentUser);
        tip.setReceiver(creator);
        tip.setAmount(amount);
        tip.setMessage(message);
        tipTransactionRepository.save(tip);

        // Notify creator
        CreatorNotification notif = new CreatorNotification();
        notif.setUser(creator);
        notif.setSender(currentUser);
        notif.setType("MONEY_RECEIVED");
        notif.setMessage("You received a tip of Rs. " + amount + " from " + currentUser.getFullName() + ". Message: " + (message != null ? message : "None"));
        creatorNotificationRepository.save(notif);

        // Sync session user balance
        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("newBalance", currentUser.getWalletBalance());
        return response;
    }

    // MONTHLY SUBSCRIBE
    @PostMapping("/creator/subscribe")
    @ResponseBody
    @Transactional
    public Map<String, Object> subscribeToCreator(@RequestParam Long creatorId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        User creator = userRepository.findById(creatorId).orElse(null);
        if (creator == null) {
            response.put("error", "CREATOR_NOT_FOUND");
            return response;
        }

        Double price = creator.getCreatorSubscriptionPrice();
        if (price == null || price <= 0) {
            response.put("error", "SUBSCRIPTION_NOT_ENABLED");
            return response;
        }

        if (currentUser.getWalletBalance() < price) {
            response.put("error", "INSUFFICIENT_FUNDS");
            return response;
        }

        // Check existing
        Optional<CreatorSubscription> opt = creatorSubscriptionRepository.findBySubscriber_IdAndCreator_Id(currentUser.getId(), creator.getId());
        CreatorSubscription sub = opt.orElseGet(CreatorSubscription::new);
        sub.setSubscriber(currentUser);
        sub.setCreator(creator);
        sub.setStartDate(LocalDateTime.now());
        sub.setEndDate(LocalDateTime.now().plusMonths(1));
        sub.setAmountPaid(price);
        creatorSubscriptionRepository.save(sub);

        // Deduct/Add balances
        currentUser.setWalletBalance(currentUser.getWalletBalance() - price);
        userRepository.save(currentUser);

        creator.setWalletBalance(creator.getWalletBalance() + price);
        userRepository.save(creator);

        // Notification
        CreatorNotification notif = new CreatorNotification();
        notif.setUser(creator);
        notif.setSender(currentUser);
        notif.setType("MONEY_RECEIVED");
        notif.setMessage(currentUser.getFullName() + " subscribed to your creator profile for Rs. " + price);
        creatorNotificationRepository.save(notif);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("newBalance", currentUser.getWalletBalance());
        return response;
    }

    // UNLOCK PAID EDUCATIONAL CONTENT
    @PostMapping("/creator/unlock")
    @ResponseBody
    @Transactional
    public Map<String, Object> unlockPaidContent(@RequestParam Long videoId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video == null) {
            response.put("error", "VIDEO_NOT_FOUND");
            return response;
        }

        if (paidContentUnlockRepository.existsByUser_IdAndVideo_Id(currentUser.getId(), videoId)) {
            response.put("success", true); // Already unlocked
            return response;
        }

        Double price = video.getPrice();
        if (currentUser.getWalletBalance() < price) {
            response.put("error", "INSUFFICIENT_FUNDS");
            return response;
        }

        // Deduct balance
        currentUser.setWalletBalance(currentUser.getWalletBalance() - price);
        userRepository.save(currentUser);

        // Add creator balance
        User creator = video.getUser();
        creator.setWalletBalance(creator.getWalletBalance() + price);
        userRepository.save(creator);

        // Save unlock record
        PaidContentUnlock unlock = new PaidContentUnlock();
        unlock.setUser(currentUser);
        unlock.setVideo(video);
        unlock.setAmountPaid(price);
        paidContentUnlockRepository.save(unlock);

        // Notification
        CreatorNotification notif = new CreatorNotification();
        notif.setUser(creator);
        notif.setSender(currentUser);
        notif.setType("MONEY_RECEIVED");
        notif.setMessage(currentUser.getFullName() + " unlocked your course: " + video.getTitle() + " for Rs. " + price);
        creatorNotificationRepository.save(notif);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("newBalance", currentUser.getWalletBalance());
        return response;
    }

    // SAVE/BOOKMARK VIDEO
    @PostMapping("/video/bookmark")
    @ResponseBody
    @Transactional
    public Map<String, Object> toggleBookmark(@RequestParam Long videoId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video == null) {
            response.put("error", "VIDEO_NOT_FOUND");
            return response;
        }

        Optional<VideoBookmark> existing = videoBookmarkRepository.findByUser_IdAndVideo_Id(currentUser.getId(), videoId);
        if (existing.isPresent()) {
            videoBookmarkRepository.delete(existing.get());
            response.put("bookmarked", false);
        } else {
            VideoBookmark vb = new VideoBookmark();
            vb.setUser(currentUser);
            vb.setVideo(video);
            videoBookmarkRepository.save(vb);
            response.put("bookmarked", true);
        }

        return response;
    }

    // VIEW COUNT INCREMENT AND EARN POINTS (REWARDS PROGRAM)
    @PostMapping("/video/view-inc")
    @ResponseBody
    @Transactional
    public Map<String, Object> incrementView(@RequestParam Long videoId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        
        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video == null) {
            response.put("error", "VIDEO_NOT_FOUND");
            return response;
        }

        // Increment overall view count
        video.setViewCount(video.getViewCount() + 1);
        videoUploadRepository.save(video);

        // Creator rewards: give points to creator for video engagement
        User creator = video.getUser();
        if (creator != null) {
            int pointsEarned = 10; // 10 points per view
            creator.setRewardPoints((creator.getRewardPoints() == null ? 0 : creator.getRewardPoints()) + pointsEarned);
            userRepository.save(creator);

            // Notify creator on landmark milestones (like every 100 views)
            if (video.getViewCount() % 100 == 0) {
                CreatorNotification landmark = new CreatorNotification();
                landmark.setUser(creator);
                landmark.setType("LANDMARK");
                landmark.setMessage("Your video \"" + video.getTitle() + "\" hit " + video.getViewCount() + " views! Keep creating!");
                creatorNotificationRepository.save(landmark);
            }
        }

        response.put("success", true);
        response.put("viewCount", video.getViewCount());
        return response;
    }

    // CREATOR STUDIO DASHBOARD
    @GetMapping("/dashboard")
    public String showCreatorDashboard(HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        // Fetch user uploads (include drafts)
        List<Videoupload> myUploads = videoUploadRepository.findByUser_Id(currentUser.getId());

        // Sort: Drafts and published
        List<Videoupload> drafts = myUploads.stream().filter(Videoupload::isDraft).collect(Collectors.toList());
        List<Videoupload> published = myUploads.stream().filter(v -> !v.isDraft()).collect(Collectors.toList());

        // Calculate analytics
        int totalViews = published.stream().mapToInt(Videoupload::getViewCount).sum();
        int totalLikes = published.stream().mapToInt(v -> v.getLikeCount()).sum();

        // Calculate estimated ad revenue share: Rs. 0.05 per view
        int unclaimedViews = Math.max(0, totalViews - currentUser.getAdViewsClaimed());
        Double estAdRevenue = unclaimedViews * 0.05;

        // Fetch cashouts list
        List<CreatorCashout> cashouts = creatorCashoutRepository.findByCreator_Id(currentUser.getId());

        // Brand Collaborations listings
        List<BrandCollaboration> brandCampaigns = brandCollaborationRepository.findByStatus("ACTIVE");

        // Applications applied by this creator
        List<BrandCollabApplication> myCollabApps = brandCollabApplicationRepository.findByCreator_Id(currentUser.getId());

        // Blocked users
        List<UserBlock> blockedUsers = userBlockRepository.findByUser_Id(currentUser.getId());

        // Active subscribers count
        int subscriberCount = creatorSubscriptionRepository.countByCreator_IdAndEndDateAfter(currentUser.getId(), LocalDateTime.now());

        // Tips received log
        List<TipTransaction> tipsReceived = tipTransactionRepository.findByReceiver_Id(currentUser.getId());
        Double totalTipsAmount = tipsReceived.stream().mapToDouble(TipTransaction::getAmount).sum();

        model.addAttribute("user", currentUser);
        model.addAttribute("drafts", drafts);
        model.addAttribute("published", published);
        model.addAttribute("totalViews", totalViews);
        model.addAttribute("totalLikes", totalLikes);
        model.addAttribute("estAdRevenue", estAdRevenue);
        model.addAttribute("unclaimedViews", unclaimedViews);
        model.addAttribute("cashouts", cashouts);
        model.addAttribute("brandCampaigns", brandCampaigns);
        model.addAttribute("myCollabApps", myCollabApps);
        model.addAttribute("blockedUsers", blockedUsers);
        model.addAttribute("subscriberCount", subscriberCount);
        model.addAttribute("tipsReceived", tipsReceived);
        model.addAttribute("totalTipsAmount", totalTipsAmount);
        model.addAttribute("categories", CREATOR_CATEGORIES);

        return "creatorStudio";
    }

    // REDEEM/CASHOUT REWARD POINTS
    @PostMapping("/dashboard/cashout")
    @ResponseBody
    @Transactional
    public Map<String, Object> requestCashout(@RequestParam int points, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        if (points < 100) {
            response.put("error", "MINIMUM_100_POINTS");
            return response;
        }

        if (currentUser.getRewardPoints() == null || currentUser.getRewardPoints() < points) {
            response.put("error", "INSUFFICIENT_POINTS");
            return response;
        }

        // Deduct points immediately
        currentUser.setRewardPoints(currentUser.getRewardPoints() - points);
        userRepository.save(currentUser);

        // Convert rate: 100 points = Rs. 10
        Double amount = (points / 100.0) * 10.0;

        // Log cashout request
        CreatorCashout cashout = new CreatorCashout();
        cashout.setCreator(currentUser);
        cashout.setPoints(points);
        cashout.setAmount(amount);
        cashout.setStatus("PENDING");
        creatorCashoutRepository.save(cashout);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("remainingPoints", currentUser.getRewardPoints());
        response.put("amount", amount);
        return response;
    }

    // CLAIM AD REVENUE SHARE
    @PostMapping("/dashboard/claim-ad-revenue")
    @ResponseBody
    @Transactional
    public Map<String, Object> claimAdRevenue(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        // Fetch user uploads
        List<Videoupload> published = videoUploadRepository.findByUser_Id(currentUser.getId()).stream()
                .filter(v -> !v.isDraft()).collect(Collectors.toList());

        int totalViews = published.stream().mapToInt(Videoupload::getViewCount).sum();
        int unclaimedViews = Math.max(0, totalViews - currentUser.getAdViewsClaimed());

        if (unclaimedViews <= 0) {
            response.put("error", "NO_AD_REVENUE_TO_CLAIM");
            return response;
        }

        Double claimAmount = unclaimedViews * 0.05;

        // Update User
        currentUser.setAdViewsClaimed(totalViews);
        Double currentBalance = currentUser.getWalletBalance();
        if (currentBalance == null) {
            currentBalance = 0.0;
        }
        currentUser.setWalletBalance(currentBalance + claimAmount);
        userRepository.save(currentUser);

        // System notification
        CreatorNotification system = new CreatorNotification();
        system.setUser(currentUser);
        system.setType("MONEY_RECEIVED");
        system.setMessage("Successfully claimed Ad Revenue share: Rs. " + claimAmount + " added to your wallet balance.");
        creatorNotificationRepository.save(system);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("claimedAmount", claimAmount);
        response.put("newBalance", currentUser.getWalletBalance());
        return response;
    }

    // TOGGLE PRIVACY CONTROL
    @PostMapping("/dashboard/toggle-privacy")
    @ResponseBody
    @Transactional
    public Map<String, Object> togglePrivacy(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        currentUser.setPrivate(!currentUser.isPrivate());
        userRepository.save(currentUser);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("isPrivate", currentUser.isPrivate());
        return response;
    }

    // SET SUBSCRIPTION PRICE
    @PostMapping("/dashboard/subscription-price")
    @ResponseBody
    @Transactional
    public Map<String, Object> setSubscriptionPrice(@RequestParam Double price, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        if (price < 0) {
            response.put("error", "INVALID_PRICE");
            return response;
        }

        currentUser.setCreatorSubscriptionPrice(price);
        userRepository.save(currentUser);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("price", price);
        return response;
    }

    // SET AFFILIATE LINK/CODE
    @PostMapping("/dashboard/affiliate-code")
    @ResponseBody
    @Transactional
    public Map<String, Object> setAffiliateCode(@RequestParam String code, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        currentUser.setCreatorAffiliateCode(code);
        userRepository.save(currentUser);

        session.setAttribute("user", currentUser);

        response.put("success", true);
        response.put("code", code);
        return response;
    }

    // BLOCK CREATOR OR USER
    @PostMapping("/creator/block")
    @ResponseBody
    @Transactional
    public Map<String, Object> blockUser(@RequestParam Long blockedUserId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        User blockedUser = userRepository.findById(blockedUserId).orElse(null);
        if (blockedUser == null) {
            response.put("error", "USER_NOT_FOUND");
            return response;
        }

        if (userBlockRepository.existsByUser_IdAndBlockedUser_Id(currentUser.getId(), blockedUserId)) {
            response.put("error", "ALREADY_BLOCKED");
            return response;
        }

        UserBlock block = new UserBlock();
        block.setUser(currentUser);
        block.setBlockedUser(blockedUser);
        userBlockRepository.save(block);

        // Remove any follower relations
        Optional<UserFollow> f1 = userFollowRepository.findRelation(currentUser, blockedUser);
        f1.ifPresent(userFollowRepository::delete);
        Optional<UserFollow> f2 = userFollowRepository.findRelation(blockedUser, currentUser);
        f2.ifPresent(userFollowRepository::delete);

        response.put("success", true);
        return response;
    }

    // UNBLOCK USER
    @PostMapping("/dashboard/unblock")
    @ResponseBody
    @Transactional
    public Map<String, Object> unblockUser(@RequestParam Long blockedUserId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        Optional<UserBlock> block = userBlockRepository.findByUser_IdAndBlockedUser_Id(currentUser.getId(), blockedUserId);
        if (block.isPresent()) {
            userBlockRepository.delete(block.get());
            response.put("success", true);
        } else {
            response.put("error", "NOT_BLOCKED");
        }

        return response;
    }

    // REPORT VIDEO/CONTENT
    @PostMapping("/creator/report")
    @ResponseBody
    @Transactional
    public Map<String, Object> reportContent(@RequestParam Long videoId, @RequestParam String reason, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video == null) {
            response.put("error", "VIDEO_NOT_FOUND");
            return response;
        }

        VideoReport report = new VideoReport();
        report.setVideo(video);
        report.setReportedBy(currentUser);
        report.setReason(reason);
        videoReportRepository.save(report);

        // Increment points for report submission as safety awareness point
        currentUser.setRewardPoints((currentUser.getRewardPoints() == null ? 0 : currentUser.getRewardPoints()) + 5);
        userRepository.save(currentUser);
        session.setAttribute("user", currentUser);

        response.put("success", true);
        return response;
    }

    // APPLY TO BRAND COLLABORATION
    @PostMapping("/collab/apply")
    @ResponseBody
    @Transactional
    public Map<String, Object> applyForCollab(@RequestParam Long campaignId, @RequestParam String pitch, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            response.put("error", "LOGIN_REQUIRED");
            return response;
        }

        BrandCollaboration collab = brandCollaborationRepository.findById(campaignId).orElse(null);
        if (collab == null) {
            response.put("error", "CAMPAIGN_NOT_FOUND");
            return response;
        }

        if (brandCollabApplicationRepository.existsByCollaboration_IdAndCreator_Id(campaignId, currentUser.getId())) {
            response.put("error", "ALREADY_APPLIED");
            return response;
        }

        BrandCollabApplication app = new BrandCollabApplication();
        app.setCollaboration(collab);
        app.setCreator(currentUser);
        app.setPitch(pitch);
        app.setStatus("PENDING");
        brandCollabApplicationRepository.save(app);

        response.put("success", true);
        return response;
    }

    // DELETE UPLOAD OR DRAFT
    @PostMapping("/dashboard/deleteUpload")
    @Transactional
    public String deleteUpload(@RequestParam Long videoId, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video != null && video.getUser().getId().equals(currentUser.getId())) {
            // Clear related objects
            videoLikeRepository.deleteByVideo(video);
            videoViewRepository.deleteByVideo(video);
            videoCommentRepository.deleteByVideoId(videoId);
            videoUploadRepository.delete(video);
            redirectAttributes.addFlashAttribute("success", "Content deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Unauthorized or video not found.");
        }

        return "redirect:/creator-hub/dashboard";
    }

    // DRAFT TO PUBLISH
    @PostMapping("/dashboard/publishDraft")
    @Transactional
    public String publishDraft(@RequestParam Long videoId, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video != null && video.getUser().getId().equals(currentUser.getId())) {
            video.setDraft(false);
            video.setUploadTime(LocalDateTime.now());
            videoUploadRepository.save(video);
            redirectAttributes.addFlashAttribute("success", "Draft published successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Unauthorized or video not found.");
        }

        return "redirect:/creator-hub/dashboard";
    }

    // NOTIFICATIONS PANEL
    @GetMapping("/notifications")
    public String showNotifications(HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        List<CreatorNotification> notifs = creatorNotificationRepository.findByUser_IdOrderByCreatedAtDesc(currentUser.getId());
        model.addAttribute("notifications", notifs);

        // Mark all as read
        for (CreatorNotification n : notifs) {
            if (!n.isRead()) {
                n.setRead(true);
                creatorNotificationRepository.save(n);
            }
        }

        return "creatorNotifications";
    }

    // ADMIN PANEL INSIDE CREATOR HUB
    @GetMapping("/admin")
    public String showHubAdmin(HttpSession session, Model model) {
        // Simple security: Check if admin is in session
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/login"; // Must be admin
        }

        // Moderation Queue (videos/reels pending moderation check)
        List<Videoupload> moderationQueue = videoUploadRepository.findAll().stream()
                .filter(v -> "PENDING_MODERATION".equals(v.getStatus()))
                .collect(Collectors.toList());

        // Reported Content list
        List<VideoReport> reports = videoReportRepository.findAll();

        // Creator Verification Requests (users not verified creator yet, showing all for badge management)
        List<User> creatorsVerificationList = userRepository.findAll().stream()
                .filter(u -> !u.isVerifiedCreator() && u.getRewardPoints() != null && u.getRewardPoints() > 100)
                .collect(Collectors.toList());

        // Approved creators (to allow un-badge)
        List<User> verifiedCreators = userRepository.findAll().stream()
                .filter(User::isVerifiedCreator)
                .collect(Collectors.toList());

        // Cash-out redemption requests
        List<CreatorCashout> cashoutRequests = creatorCashoutRepository.findByStatus("PENDING");

        // All Brand Collaborations
        List<BrandCollaboration> campaigns = brandCollaborationRepository.findAll();

        model.addAttribute("moderationQueue", moderationQueue);
        model.addAttribute("reports", reports);
        model.addAttribute("creatorsVerificationList", creatorsVerificationList);
        model.addAttribute("verifiedCreators", verifiedCreators);
        model.addAttribute("cashoutRequests", cashoutRequests);
        model.addAttribute("campaigns", campaigns);

        return "creatorAdminPanel";
    }

    // ADMIN APPROVE/REJECT CONTENT
    @PostMapping("/admin/approve")
    @ResponseBody
    @Transactional
    public Map<String, Object> adminApproveContent(@RequestParam Long videoId, @RequestParam boolean approve) {
        Map<String, Object> response = new HashMap<>();
        Videoupload video = videoUploadRepository.findById(videoId).orElse(null);
        if (video != null) {
            if (approve) {
                video.setStatus("APPROVED");
                video.setBlocked(false);
            } else {
                video.setStatus("BLOCKED");
                video.setBlocked(true);
            }
            videoUploadRepository.save(video);
            
            // Notify creator
            CreatorNotification system = new CreatorNotification();
            system.setUser(video.getUser());
            system.setType("SYSTEM");
            system.setMessage("Your uploaded content \"" + video.getTitle() + "\" was " + (approve ? "approved" : "rejected & blocked") + " by the Safety Moderation Board.");
            creatorNotificationRepository.save(system);

            response.put("success", true);
        } else {
            response.put("error", "CONTENT_NOT_FOUND");
        }
        return response;
    }

    // ADMIN DELETE REPORTED VIDEO
    @PostMapping("/admin/delete-reported")
    @ResponseBody
    @Transactional
    public Map<String, Object> adminDeleteReported(@RequestParam Long reportId) {
        Map<String, Object> response = new HashMap<>();
        VideoReport report = videoReportRepository.findById(reportId).orElse(null);
        if (report != null) {
            Videoupload video = report.getVideo();
            if (video != null) {
                videoLikeRepository.deleteByVideo(video);
                videoViewRepository.deleteByVideo(video);
                videoCommentRepository.deleteByVideoId(video.getId());
                videoUploadRepository.delete(video);
            }
            videoReportRepository.delete(report);
            response.put("success", true);
        } else {
            response.put("error", "REPORT_NOT_FOUND");
        }
        return response;
    }

    // ADMIN VERIFY CREATOR BADGE
    @PostMapping("/admin/verify")
    @ResponseBody
    @Transactional
    public Map<String, Object> adminVerifyCreator(@RequestParam Long creatorId, @RequestParam boolean verify) {
        Map<String, Object> response = new HashMap<>();
        User creator = userRepository.findById(creatorId).orElse(null);
        if (creator != null) {
            creator.setVerifiedCreator(verify);
            userRepository.save(creator);

            // Notify creator
            CreatorNotification system = new CreatorNotification();
            system.setUser(creator);
            system.setType("SYSTEM");
            system.setMessage(verify ? "Congratulations! You have been awarded the Verified Women Creator Badge!" : "Your Verified Creator status was retracted.");
            creatorNotificationRepository.save(system);

            response.put("success", true);
        } else {
            response.put("error", "CREATOR_NOT_FOUND");
        }
        return response;
    }

    // ADMIN PROCESS CASHOUT REQUEST
    @PostMapping("/admin/cashout")
    @ResponseBody
    @Transactional
    public Map<String, Object> adminProcessCashout(@RequestParam Long cashoutId, @RequestParam boolean approve) {
        Map<String, Object> response = new HashMap<>();
        CreatorCashout cashout = creatorCashoutRepository.findById(cashoutId).orElse(null);
        if (cashout != null && "PENDING".equals(cashout.getStatus())) {
            cashout.setStatus(approve ? "APPROVED" : "REJECTED");
            cashout.setProcessedAt(LocalDateTime.now());
            creatorCashoutRepository.save(cashout);

            User creator = cashout.getCreator();
            if (approve) {
                // Add money to wallet
                creator.setWalletBalance(creator.getWalletBalance() + cashout.getAmount());
                userRepository.save(creator);
            } else {
                // Refund points
                creator.setRewardPoints((creator.getRewardPoints() == null ? 0 : creator.getRewardPoints()) + cashout.getPoints());
                userRepository.save(creator);
            }

            // Notify creator
            CreatorNotification system = new CreatorNotification();
            system.setUser(creator);
            system.setType("SYSTEM");
            system.setMessage("Your cashout request of Rs. " + cashout.getAmount() + " (for " + cashout.getPoints() + " points) was " + (approve ? "approved and credited to your wallet balance." : "rejected. Your points have been refunded."));
            creatorNotificationRepository.save(system);

            response.put("success", true);
        } else {
            response.put("error", "REQUEST_NOT_FOUND_OR_PROCESSED");
        }
        return response;
    }

    // ADMIN CREATE BRAND CAMPAIGN
    @PostMapping("/admin/create-campaign")
    public String adminCreateCampaign(@RequestParam String brandName,
                                      @RequestParam String campaignTitle,
                                      @RequestParam String description,
                                      @RequestParam Double payRate,
                                      RedirectAttributes redirectAttributes) {
        BrandCollaboration campaign = new BrandCollaboration();
        campaign.setBrandName(brandName);
        campaign.setCampaignTitle(campaignTitle);
        campaign.setDescription(description);
        campaign.setPayRate(payRate);
        campaign.setStatus("ACTIVE");
        brandCollaborationRepository.save(campaign);

        redirectAttributes.addFlashAttribute("success", "Sponsorship Campaign created successfully!");
        return "redirect:/creator-hub/admin";
    }
}
