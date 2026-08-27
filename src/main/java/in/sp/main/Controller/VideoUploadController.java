package in.sp.main.Controller;
 
import in.sp.main.Entities.ChatMessage;
import in.sp.main.Entities.User;

import in.sp.main.Entities.VideoComment;
import in.sp.main.Entities.VideoLike;
import in.sp.main.Entities.VideoReport;
import in.sp.main.Entities.VideoView;
import in.sp.main.Entities.Videoupload;

import in.sp.main.Repository.UserRepository;

import in.sp.main.Repository.VideoCommentRepository;
import in.sp.main.Repository.VideoLikeRepository;
import in.sp.main.Repository.*;

import in.sp.main.Repository.VideoUploadRepository;
import in.sp.main.Service.ChatService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.UserFollowService;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
 
import java.io.IOException;

import java.util.ArrayList;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
 
@Controller

@RequestMapping("/video")

public class VideoUploadController {

    private static final Logger log = LoggerFactory.getLogger(VideoUploadController.class);
	
	@Autowired
	private VideoViewRepository videoViewRepository;
	
	 @Autowired
	    private SimpMessagingTemplate messagingTemplate;
	  @Autowired
	    private ChatService chatService;
 
    @Autowired

    private VideoUploadRepository videoRepository;
    
    @Autowired

    private VideoReportRepository videoReportRepository;
    
    
 
    @Autowired

    private FileUploadService fileUploadService;
    
    @Autowired

    private UserFollowService userService;

    @Autowired

    private VideoCommentRepository videocommentRepository;

    @Autowired

    private UserRepository userRepository;
 
    
    @Autowired

    private VideoLikeRepository videoLikeRepository;
 
    @GetMapping("/upload")
    public String showUploadPage(@RequestParam(value = "isReel", defaultValue = "false") boolean isReel,
                                 HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("isReel", isReel);
        return "uploadvideo1";
    }
    
    @Transactional
    @PostMapping("/deleteUpload")
    public String deleteUserUpload(@RequestParam("videoId") Long videoId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        
        Videoupload video = videoRepository.findById(videoId).orElse(null);
        if (video == null || video.getUser() == null || !video.getUser().getId().equals(user.getId())) {
            redirectAttributes.addFlashAttribute("error", "Not authorized to delete this video.");
            return "redirect:/users/profile1/" + user.getId();
        }
        
        try {
            videoLikeRepository.deleteByVideo(video);
            videoViewRepository.deleteByVideo(video);
            videocommentRepository.deleteByVideoId(videoId);
            videoRepository.delete(video);
            redirectAttributes.addFlashAttribute("message", "Upload deleted successfully.");
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            redirectAttributes.addFlashAttribute("error", "Failed to delete: " + e.getMessage());
        }
        return "redirect:/video/myVideos";

    }

    @PostMapping("/upload")
    public String uploadVideo(@RequestParam("title") String title,
                              @RequestParam("description") String description,
                              @RequestParam("category") String category,
                              @RequestParam(value = "isPrivate", defaultValue = "false") boolean isPrivate,
                              @RequestParam("file") MultipartFile file,
                              @RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
                              @RequestParam(value = "isReel", defaultValue = "false") boolean isReel,
                              HttpSession session,
                              Model model) {
 
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
 
        if (file.isEmpty()) {
            model.addAttribute("error", "Please select a video to upload.");
            model.addAttribute("isReel", isReel);
            return "uploadvideo1";
        }
 
        try {
            String videoPath = fileUploadService.saveFile(file);
            String thumbPath = null;
            if (thumbnail != null && !thumbnail.isEmpty()) {
                thumbPath = fileUploadService.saveFile(thumbnail);
            }
 
            Videoupload video = new Videoupload();
            video.setTitle(title);
            video.setDescription(description);
            video.setVideoPath(videoPath);
            video.setThumbnailPath(thumbPath);
            video.setCategory(category);
            video.setPrivate(isPrivate);
            video.setUser(user);
            video.setReel(isReel);
            
            // Set fileType
            String contentType = file.getContentType();
            if (contentType != null && contentType.startsWith("image/")) {
                video.setFileType("IMAGE");
            } else {
                video.setFileType("VIDEO");
            }
            
            video.setUploadTime(java.time.LocalDateTime.now());
            
            videoRepository.save(video);
            
            // 🔴 Real-time: broadcast new upload to relevant feeds
            Map<String, Object> evt = new HashMap<>();
            evt.put("type", "NEW_UPLOAD");
            evt.put("videoId", video.getId());
            evt.put("isReel", isReel);
            
            if (isReel) {
                messagingTemplate.convertAndSend("/topic/reels", evt);
            } else {
                messagingTemplate.convertAndSend("/topic/userVideos/" + user.getId(), evt);
            }

            return "redirect:" + (isReel ? "/video/reels" : "/video/myVideos");
        } catch (IOException e) {
            model.addAttribute("error", "Error uploading video: " + e.getMessage());
            model.addAttribute("isReel", isReel);
            return "uploadvideo1";
        }
    }

    // ✅ AJAX upload for modern UX (progress bar + no full page reload)
    @PostMapping(value = "/uploadAjax", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadVideoAjax(@RequestParam("title") String title,
                                                               @RequestParam("description") String description,
                                                               @RequestParam("category") String category,
                                                               @RequestParam(value = "isPrivate", defaultValue = "false") boolean isPrivate,
                                                               @RequestParam("file") MultipartFile file,
                                                               @RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
                                                               @RequestParam(value = "isReel", defaultValue = "false") boolean isReel,
                                                               HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            res.put("error", "LOGIN_REQUIRED");
            return ResponseEntity.status(401).body(res);
        }
        if (file == null || file.isEmpty()) {
            res.put("error", "FILE_REQUIRED");
            return ResponseEntity.badRequest().body(res);
        }

        try {
            String videoPath = fileUploadService.saveFile(file);
            String thumbPath = null;
            if (thumbnail != null && !thumbnail.isEmpty()) {
                thumbPath = fileUploadService.saveFile(thumbnail);
            }

            Videoupload video = new Videoupload();
            video.setTitle(title);
            video.setDescription(description);
            video.setVideoPath(videoPath);
            video.setThumbnailPath(thumbPath);
            video.setCategory(category);
            video.setPrivate(isPrivate);
            video.setUser(user);
            video.setReel(isReel); // Set the isReel flag
            
            String contentType = file.getContentType();
            if (contentType != null && contentType.startsWith("image/")) {
                video.setFileType("IMAGE");
            } else {
                video.setFileType("VIDEO");
            }
            
            video.setUploadTime(LocalDateTime.now());
            videoRepository.save(video);

            Map<String, Object> evt = new HashMap<>();
            evt.put("type", "NEW_UPLOAD");
            evt.put("videoId", video.getId());
            evt.put("isReel", isReel); // Include isReel in the event
            
            if (isReel) {
                messagingTemplate.convertAndSend("/topic/reels", evt);
            } else {
                messagingTemplate.convertAndSend("/topic/userVideos/" + user.getId(), evt);
            }

            res.put("ok", true);
            res.put("videoId", video.getId());
            res.put("redirect", isReel ? "/video/reels" : "/video/myVideos"); // Corrected redirect
            return ResponseEntity.ok(res);
        } catch (IOException e) {
            res.put("error", "UPLOAD_FAILED");
            res.put("message", e.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }
    private String fileType;    // VIDEO or IMAGE

    @GetMapping("/myVideos")
    public String viewMyVideos(HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) return "redirect:/login";

        User currentUser = userRepository.findById(sessionUser.getId()).orElse(null);
        if (currentUser == null) return "redirect:/login";

        List<Videoupload> myUploads = videoRepository.findByUser_Id(currentUser.getId()).stream()
            .filter(v -> !v.isBlocked())
            .sorted((a, b) -> {
                if (a.getUploadTime() == null && b.getUploadTime() == null) return 0;
                if (a.getUploadTime() == null) return 1;
                if (b.getUploadTime() == null) return -1;
                return b.getUploadTime().compareTo(a.getUploadTime());
            })
            .collect(java.util.stream.Collectors.toList());

        model.addAttribute("videos", myUploads);
        model.addAttribute("user", currentUser);
        return "myVideos";
    }
 
 
    // 🎞 Reels Feed
    @Transactional(readOnly = true)
    @GetMapping("/reels")
    public String viewReels(HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) return "redirect:/login";

        try {
            User currentUser = userRepository.findById(sessionUser.getId()).orElse(null);
            if (currentUser == null) return "redirect:/login";

            List<Videoupload> allReels = videoRepository.findFeedReels();

            List<Videoupload> videos = allReels.stream()
                .filter(v -> isReelVisibleInFeed(v, currentUser))
                .collect(java.util.stream.Collectors.toList());

            log.info("Reels feed for user {}: {} visible of {} total",
                    currentUser.getId(), videos.size(), allReels.size());

            Map<Long, Boolean> likedMap = new HashMap<>();
            Map<Long, String> followStatusMap = new HashMap<>();
            Map<Long, List<VideoComment>> commentsByVideoId = new HashMap<>();
            Map<Long, List<VideoComment>> repliesByCommentId = new HashMap<>();

            for (Videoupload v : videos) {
                try {
                    boolean liked = videoLikeRepository.existsByVideoAndUser(v, currentUser);
                    v.setLikedByCurrentUser(liked);

                    List<VideoComment> topLevelComments = new ArrayList<>();
                    for (VideoComment comment : videocommentRepository.findTopLevelWithUserByVideoId(v.getId())) {
                        topLevelComments.add(comment);
                        repliesByCommentId.put(
                                comment.getId(),
                                videocommentRepository.findRepliesWithUserByParentId(comment.getId()));
                    }
                    commentsByVideoId.put(v.getId(), topLevelComments);

                    User uploader = v.getUser();
                    if (uploader != null && !uploader.getId().equals(currentUser.getId())) {
                        if (userService.isAcceptedFollower(currentUser.getId(), uploader.getId())) {
                            followStatusMap.put(uploader.getId(), "FOLLOWING");
                        } else if (userService.isPendingRequest(currentUser.getId(), uploader.getId())) {
                            followStatusMap.put(uploader.getId(), "REQUESTED");
                        } else {
                            followStatusMap.put(uploader.getId(), "FOLLOW");
                        }
                    }
                } catch (Exception perVideoEx) {
                    log.warn("Skipping metadata for reel {}: {}", v.getId(), perVideoEx.getMessage());
                    commentsByVideoId.putIfAbsent(v.getId(), java.util.Collections.emptyList());
                }
            }

            model.addAttribute("videos", videos);
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("user", currentUser);
            model.addAttribute("likedMap", likedMap);
            model.addAttribute("followStatusMap", followStatusMap);
            model.addAttribute("commentsByVideoId", commentsByVideoId);
            model.addAttribute("repliesByCommentId", repliesByCommentId);
            model.addAttribute("friends", userService.getFriends(currentUser.getId()));
            model.addAttribute("unreadBroadcastCount", 0L);
        } catch (Exception ex) {
            log.error("Failed to load reels feed", ex);
            model.addAttribute("videos", java.util.Collections.emptyList());
            model.addAttribute("currentUser", sessionUser);
            model.addAttribute("user", sessionUser);
            model.addAttribute("likedMap", java.util.Collections.emptyMap());
            model.addAttribute("followStatusMap", java.util.Collections.emptyMap());
            model.addAttribute("commentsByVideoId", java.util.Collections.emptyMap());
            model.addAttribute("repliesByCommentId", java.util.Collections.emptyMap());
            model.addAttribute("friends", java.util.Collections.emptyList());
            model.addAttribute("unreadBroadcastCount", 0L);
        }
        return "reels";
    }


    // ❤ Like Video
	/*
	 * @PostMapping("/like")
	 * 
	 * public String likeVideo(@RequestParam("videoId") Long videoId) {
	 * 
	 * Videoupload video = videoRepository.findById(videoId).orElse(null);
	 * 
	 * if (video != null) {
	 * 
	 * video.setLikeCount(video.getLikeCount() + 1);
	 * 
	 * videoRepository.save(video);
	 * 
	 * }
	 * 
	 * return "redirect:/video/reels";
	 * 
	 * }
	 */
    // 🔁 Share Video

	/*

	 * @PostMapping("/share") public String shareVideo(@RequestParam("videoId") Long

	 * videoId) { Videoupload video =

	 * videoRepository.findById(videoId).orElse(null); if (video != null) {

	 * video.setShareCount(video.getShareCount() + 1); videoRepository.save(video);

	 * } return "redirect:/video/reels"; }

	 */
 
    // 🔁 Share modal

    @Transactional

    @GetMapping("/share/{videoId}")

    public String showShareModal(@PathVariable Long videoId, HttpSession session, Model model) {

        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) return "redirect:/login";
 
        User fullUser = userRepository.findById(sessionUser.getId()).orElse(null);

        if (fullUser != null) {

            fullUser.getFollowers().size();

            fullUser.getFollowing().size();

        }
 
        Videoupload video = videoRepository.findById(videoId).orElse(null);

        model.addAttribute("video", video);

        model.addAttribute("user", fullUser);
 
        return "share_modal";

    }
 
    // ✅ Share action

    @PostMapping("/share/send")
    @ResponseBody
    public void shareVideoWithUser(@RequestParam Long videoId,
                                   @RequestParam Long receiverId,
                                   HttpSession session) {

        User sender = (User) session.getAttribute("user");
        if (sender == null) return;

        User receiver = userRepository.findById(receiverId).orElse(null);
        Videoupload video = videoRepository.findById(videoId).orElse(null);

        if (receiver == null || video == null) return;

        // Update share count
        video.setShareCount(video.getShareCount() + 1);
        videoRepository.save(video);

        // Create chat message
        ChatMessage msg = new ChatMessage();
        msg.setSender(sender);
        msg.setReceiver(receiver);
        msg.setVideoUrl(video.getVideoPath()); // Send video path
        msg.setTimestamp(LocalDateTime.now());

        chatService.save(msg);

        // Send real-time to receiver
        messagingTemplate.convertAndSend("/topic/messages/" + receiver.getId(), msg);

        // Send to sender too (so sender sees it immediately)
        messagingTemplate.convertAndSend("/topic/messages/" + sender.getId(), msg);
    }

	/*
	 * @PostMapping("/comment")
	 * 
	 * public String addComment(@RequestParam("videoId") Long videoId,
	 * 
	 * @RequestParam("commentText") String text,
	 * 
	 * HttpSession session) {
	 * 
	 * Videoupload video = videoRepository.findById(videoId).orElse(null);
	 * 
	 * if (video == null) return "redirect:/video/reels";
	 * 
	 * // ✅ Get the logged-in user from session
	 * 
	 * User loggedUser = (User) session.getAttribute("user");
	 * 
	 * // If no user is logged in, redirect to login page
	 * 
	 * if (loggedUser == null) {
	 * 
	 * return "redirect:/login";
	 * 
	 * }
	 * 
	 * // ✅ Create new comment and attach the session user’s name
	 * 
	 * VideoComment comment = new VideoComment();
	 * 
	 * comment.setUser(loggedUser); // or getEmail(), depending on what you want
	 * displayed
	 * 
	 * comment.setText(text);
	 * 
	 * comment.setCommentedAt(LocalDateTime.now());
	 * 
	 * comment.setVideo(video);
	 * 
	 * videocommentRepository.save(comment);
	 * 
	 * return "redirect:/video/reels";
	 * 
	 * }
	 */

// 💬 View all comments of a video

    @GetMapping("/comments/{videoId}")

    public String viewComments(@PathVariable Long videoId,

                               HttpSession session,

                               Model model) {
 
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) return "redirect:/login";
 
        Videoupload video = videoRepository.findById(videoId).orElse(null);

        if (video == null) return "redirect:/video/reels";
        
        // Privacy check: If user is private, only accepted followers (or self) can see comments
        User uploader = video.getUser();
        if (uploader != null && uploader.isPrivate() && !uploader.getId().equals(loggedUser.getId())) {
            if (!userService.isAcceptedFollower(loggedUser.getId(), uploader.getId())) {
                return "redirect:/video/reels"; // Access denied
            }
        }
 
        List<VideoComment> comments =

                videocommentRepository.findByVideo_Id(videoId);
 
        model.addAttribute("video", video);

        model.addAttribute("comments", comments);
 
        return "video_comments"; // JSP name

    }
    @PostMapping({"/like", "/video/like"})
    @ResponseBody
    public Map<String, Object> likeVideo(
            @RequestParam Long videoId,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        Map<String, Object> res = new HashMap<>();

        if (user == null) {
            res.put("error", "LOGIN_REQUIRED");
            return res;
        }

        Videoupload video = videoRepository.findById(videoId).orElse(null);

        if (video == null) return res;

        // Privacy Check: If uploader is private, only accepted followers (or self) can like
        User uploader = video.getUser();
        if (uploader != null && uploader.isPrivate() && !uploader.getId().equals(user.getId())) {
            if (!userService.isAcceptedFollower(user.getId(), uploader.getId())) {
                res.put("error", "ACCESS_DENIED");
                return res;
            }
        }

        Optional<VideoLike> existing =
                videoLikeRepository.findByVideoAndUser(video, user);

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
        videoRepository.save(video);

        res.put("liked", liked);
        res.put("likeCount", likeCount);

        // 🔴 Real-time: broadcast like count update (all viewers + uploader's myVideos page)
        Map<String, Object> evt = new HashMap<>();
        evt.put("type", "LIKE_UPDATED");
        evt.put("videoId", video.getId());
        evt.put("likeCount", likeCount);
        messagingTemplate.convertAndSend("/topic/reels", evt);
        if (video.getUser() != null) {
            messagingTemplate.convertAndSend("/topic/userVideos/" + video.getUser().getId(), evt);
        }
        return res;
    }

    @PostMapping("/comment")
    @ResponseBody
    public Map<String, Object> addComment(
            @RequestParam("videoId") Long videoId,
            @RequestParam("commentText") String text,
            @RequestParam(value = "parentId", required = false) Long parentId, // optional parent
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        Videoupload video = videoRepository.findById(videoId).orElse(null);
        if (video == null) {
            response.put("error", "Video not found");
            return response;
        }

        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) {
            response.put("error", "NOT_LOGGED_IN");
            return response;
        }

        // Privacy Check: If uploader is private, only accepted followers (or self) can comment
        User uploader = video.getUser();
        if (uploader != null && uploader.isPrivate() && !uploader.getId().equals(loggedUser.getId())) {
            if (!userService.isAcceptedFollower(loggedUser.getId(), uploader.getId())) {
                response.put("error", "ACCESS_DENIED");
                return response;
            }
        }

        VideoComment comment = new VideoComment();
        comment.setUser(loggedUser);
        comment.setText(text);
        comment.setCommentedAt(LocalDateTime.now());
        comment.setVideo(video);

        // ✅ Set parent comment if replying
        if (parentId != null) {
            VideoComment parentComment = videocommentRepository.findById(parentId).orElse(null);
            if (parentComment != null) {
                comment.setParent(parentComment);
            }
        }

        videocommentRepository.save(comment);

        // Response data
        response.put("id", comment.getId());
        response.put("user", loggedUser.getFullName());
        response.put("text", comment.getText());
        response.put("parentId", parentId); // to know if it's a reply

        // 🔴 Real-time: broadcast that comments changed (others can refresh comment list)
        Map<String, Object> evt = new HashMap<>();
        evt.put("type", "COMMENT_ADDED");
        evt.put("videoId", video.getId());
        messagingTemplate.convertAndSend("/topic/reels", evt);
        if (video.getUser() != null) {
            messagingTemplate.convertAndSend("/topic/userVideos/" + video.getUser().getId(), evt);
        }

        return response;
    }

    @PostMapping("/view")
    @ResponseBody
    public Map<String, Object> addView(
            @RequestParam Long videoId,
            HttpSession session) {

        Map<String, Object> res = new HashMap<>();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            res.put("error", "LOGIN_REQUIRED");
            return res;
        }

        Videoupload video = videoRepository.findById(videoId).orElse(null);
        if (video == null) return res;

        // Privacy Check: If uploader is private, only accepted followers (or self) can view
        User uploader = video.getUser();
        if (uploader != null && uploader.isPrivate() && !uploader.getId().equals(user.getId())) {
            if (!userService.isAcceptedFollower(user.getId(), uploader.getId())) {
                res.put("error", "ACCESS_DENIED");
                return res;
            }
        }

        // ✅ Prevent duplicate view
        if (!videoViewRepository.existsByVideoAndUser(video, user)) {

            VideoView view = new VideoView();
            view.setUser(user);
            view.setVideo(video);
            view.setViewedAt(LocalDateTime.now());

            videoViewRepository.save(view);

            int viewCount = videoViewRepository.countByVideo(video);
            video.setViewCount(viewCount);
            videoRepository.save(video);

            // 💰 Earn Coins Logic
            int currentPoints = (user.getRewardPoints() != null) ? user.getRewardPoints() : 0;
            user.setRewardPoints(currentPoints + 10);
            userRepository.save(user);
            session.setAttribute("user", user); // Update session user

            res.put("viewed", true);
            res.put("viewCount", viewCount);
            res.put("rewardPoints", user.getRewardPoints()); // Send back updated points

            // 🔴 Real-time: broadcast view count update
            Map<String, Object> evt = new HashMap<>();
            evt.put("type", "VIEW_UPDATED");
            evt.put("videoId", video.getId());
            evt.put("viewCount", viewCount);
            messagingTemplate.convertAndSend("/topic/reels", evt);
            if (video.getUser() != null) {
                messagingTemplate.convertAndSend("/topic/userVideos/" + video.getUser().getId(), evt);
            }
        } else {
            res.put("viewed", false);
        }

        return res;
    }
    
    @PostMapping("/video/report")
    @ResponseBody
    @Transactional
    public String reportVideo(@RequestParam Long videoId, 
                              @RequestParam String reason, 
                              HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "LOGIN_REQUIRED";

        Videoupload video = videoRepository.findById(videoId).orElse(null);
        if (video == null) return "VIDEO_NOT_FOUND";

        VideoReport report = new VideoReport();
        report.setVideo(video);
        report.setReportedBy(user);
        report.setReason(reason);

        videoReportRepository.saveAndFlush(report); // <--- flush ensures DB write
        System.out.println("Reported Video ID: " + video.getId() + " by " + user.getFullName());

        return "SUCCESS";
    }

    /** Public reels feed — show every non-blocked reel unless marked private (owner always sees theirs). */
    private boolean isReelVisibleInFeed(Videoupload reel, User viewer) {
        if (reel == null || viewer == null) {
            return false;
        }
        User uploader = reel.getUser();
        if (uploader == null) {
            return false;
        }
        boolean isOwner = uploader.getId().equals(viewer.getId());
        if (isOwner) {
            return true;
        }
        if (reel.isDraft() || reel.isPrivate()) {
            return false;
        }
        return true;
    }

}
 



