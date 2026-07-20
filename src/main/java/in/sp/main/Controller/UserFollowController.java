package in.sp.main.Controller;

import java.util.*;
import org.springframework.transaction.annotation.Transactional;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import in.sp.main.Entities.ChatMessage;
import in.sp.main.Entities.Group;
import in.sp.main.Entities.GroupMember;
import in.sp.main.Entities.User;
import in.sp.main.Entities.Videoupload;
import in.sp.main.Repository.ChatMessageRepository;
import in.sp.main.Repository.GroupMemberRepository;
import in.sp.main.Repository.GroupRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.VideoRepository;
import in.sp.main.Repository.VideoUploadRepository;
import in.sp.main.Service.ChatService;
import in.sp.main.Service.UserFollowService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/users")
public class UserFollowController {

    private static final Logger log = LoggerFactory.getLogger(UserFollowController.class);

    @Autowired
    private UserRepository userRepo;
    
    @Autowired
    private ChatMessageRepository chatMessageRepo;
    
    @Autowired
    private VideoRepository videoRepo;

    @Autowired
    private GroupRepository grouprepo;
    
    @Autowired
    private GroupMemberRepository groupMemberRepo;

    @Autowired
    private VideoUploadRepository videouploadRepo;

    @Autowired
    private UserFollowService followService;
    
    @Autowired
    private ChatService chatService;
    
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    private void notifyFollowStateChanged(Long userId) {
        if (userId == null) return;
        Map<String, Object> evt = new HashMap<>();
        evt.put("type", "FOLLOW_STATE_CHANGED");
        evt.put("userId", userId);
        evt.put("pendingRequestCount", followService.getPendingRequestCount(userId));
        evt.put("friendsCount", followService.getFriends(userId).size());
        messagingTemplate.convertAndSend("/topic/follow/" + userId, evt);
    }

    // 🔍 SEARCH USERS + FOLLOWERS + FOLLOWING + REQUESTS
    @GetMapping("/search")
    public String searchUsers(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String tab,
            Model model,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Long currentUserId = currentUser.getId();

        // 🔔 Pending request count
        int requestCount = followService.getPendingRequestCount(currentUserId);

        // 🔍 Search users
        List<User> users = (keyword != null && !keyword.trim().isEmpty())
                ? userRepo.searchUsers(keyword)
                : new ArrayList<>();

        // ❌ Remove self (Java-8 compatible)
        List<User> filteredUsers = new ArrayList<>();
        for (User u : users) {
            if (!u.getId().equals(currentUserId)) {
                filteredUsers.add(u);
            }
        }

        // ✅ Follow status maps
        Map<Long, Boolean> followingStatus = new HashMap<>();
        Map<Long, Boolean> pendingStatus = new HashMap<>();

        List<User> followers = followService.getFollowers(currentUserId);
        List<User> following = followService.getFollowing(currentUserId);
        List<User> followRequests = followService.getPendingRequests(currentUserId);
        List<User> friends = followService.getFriends(currentUserId);

        // Collect all users to check status for
        Set<User> allRelevantUsers = new HashSet<>(filteredUsers);
        allRelevantUsers.addAll(followers);
        allRelevantUsers.addAll(following);
        allRelevantUsers.addAll(followRequests);
        allRelevantUsers.addAll(friends);

        for (User u : allRelevantUsers) {
            followingStatus.put(
                    u.getId(),
                    followService.isAcceptedFollower(currentUserId, u.getId())
            );

            pendingStatus.put(
                    u.getId(),
                    followService.isPendingRequest(currentUserId, u.getId())
            );
        }
        List<Group> groups = groupMemberRepo.findGroupsByUserId(currentUser.getId());
        model.addAttribute("groups", groups);

        // 📦 Model attributes
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("users", filteredUsers);
        model.addAttribute("keyword", keyword);

        model.addAttribute("followingStatus", followingStatus);
        model.addAttribute("pendingStatus", pendingStatus);

        model.addAttribute("followers", followers);
        model.addAttribute("following", following);
        model.addAttribute("followRequests", followRequests);
        model.addAttribute("friends", friends);

        model.addAttribute("requestCount", requestCount);
        String normalizedKeyword = (keyword == null) ? "" : keyword.trim();
        String initialTab;
        if (tab != null && !tab.trim().isEmpty()) {
            initialTab = tab.trim();
        } else if (!normalizedKeyword.isEmpty()) {
            initialTab = "search";
        } else {
            initialTab = "followers";
        }
        model.addAttribute("activeTab", initialTab);

        return "profilechat/user_search";
    }

    // 🔔 Near real-time pending request count (for dashboard badge)
    @GetMapping("/pendingRequestCount")
    @ResponseBody
    public Map<String, Object> pendingRequestCount(HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            res.put("count", 0);
            res.put("error", "LOGIN_REQUIRED");
            return res;
        }
        int count = followService.getPendingRequestCount(currentUser.getId());
        res.put("count", count);
        return res;
    }

    // ➕ FOLLOW USER (creates PENDING request)
    @PostMapping("/follow/{id}")
    public String followUser(@PathVariable("id") Long followedId, 
                             @RequestParam(required = false) String tab,
                             HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        followService.followUser(currentUser.getId(), followedId);
        // 🔴 Real-time: notify receiver that a request arrived
        notifyFollowStateChanged(followedId);
        
        String redirectUrl = "/users/search";
        if (tab != null && !tab.isEmpty()) {
            redirectUrl += "?tab=" + tab;
        }
        return "redirect:" + redirectUrl;
    }

    // ➕ AJAX FOLLOW USER
    @PostMapping("/followAjax/{id}")
    @ResponseBody
    public Map<String, Object> followUserAjax(@PathVariable("id") Long followedId, HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            res.put("error", "LOGIN_REQUIRED");
            return res;
        }

        followService.followUser(currentUser.getId(), followedId);
        notifyFollowStateChanged(followedId);

        // Check if now following or just requested
        if (followService.isAcceptedFollower(currentUser.getId(), followedId)) {
            res.put("status", "FOLLOWING");
        } else if (followService.isPendingRequest(currentUser.getId(), followedId)) {
            res.put("status", "REQUESTED");
        }
        
        // Check if friends
        User followedUser = userRepo.findById(followedId).orElse(null);
        if (followedUser != null) {
            res.put("isFriend", followService.getFriends(currentUser.getId()).contains(followedUser));
        }

        return res;
    }

    // ❌ UNFOLLOW USER
    @PostMapping("/unfollow/{id}")
    public String unfollowUser(@PathVariable("id") Long followedId, HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        try {
            followService.unfollowUser(currentUser.getId(), followedId);
        } catch (Exception e) {
            log.error("Unfollow failed", e);
        }
        // 🔴 Real-time: notify both sides
        notifyFollowStateChanged(currentUser.getId());
        notifyFollowStateChanged(followedId);
        return "redirect:/users/search";
    }

    // ✅ ACCEPT FOLLOW REQUEST
    @PostMapping("/acceptRequest/{id}")
    public String acceptFollowRequest(@PathVariable("id") Long followerId, HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        followService.acceptRequest(currentUser.getId(), followerId);
        // 🔴 Real-time: notify both sides (requests/friends lists change)
        notifyFollowStateChanged(currentUser.getId());
        notifyFollowStateChanged(followerId);
        return "redirect:/users/search?tab=requests";
    }

    // ❌ DECLINE FOLLOW REQUEST
    @PostMapping("/declineRequest/{id}")
    public String declineFollowRequest(@PathVariable("id") Long followerId, HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        followService.declineRequest(currentUser.getId(), followerId);
        // 🔴 Real-time: notify both sides
        notifyFollowStateChanged(currentUser.getId());
        notifyFollowStateChanged(followerId);
        return "redirect:/users/search?tab=requests";
    }

    // 👥 FOLLOWERS PAGE
    @GetMapping("/followers")
    public String getFollowers(Model model, HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        model.addAttribute("followers",
                followService.getFollowers(currentUser.getId()));

        return "profilechat/followers";
    }

    // 👣 FOLLOWING PAGE
    @GetMapping("/following")
    public String getFollowing(Model model, HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        model.addAttribute("following",
                followService.getFollowing(currentUser.getId()));

        return "profilechat/following";
    }
 // 💬 FRIENDS LIST FOR CHAT POPUP
    @GetMapping("/friends/chat")
    @ResponseBody
    public List<Map<String, Object>> getFriendsForChat(HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return Collections.emptyList();

        List<User> friends = followService.getFriends(currentUser.getId());
        System.out.println("Friends count for " + currentUser.getFullName() + " = " + friends.size());
        log.info("Friends fetched for {}: {}", currentUser.getFullName(), friends.size());
        List<Map<String, Object>> response = new ArrayList<>();
        for (User u : friends) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", u.getId());
            map.put("name", u.getFullName());
            map.put("email", u.getEmail());
            response.add(map);
        }

        return response;
    }

    @GetMapping("/search1/{id}")
    public String searchUsers1(
            @PathVariable Long id,
            @RequestParam(required = false) Long videoId,
            Model model,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.getId().equals(id)) {
            return "redirect:/login";
        }

        model.addAttribute("friends", followService.getFriends(id));
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("videoId", videoId); // ⭐ VERY IMPORTANT

        return "friends";
    }
    @PostMapping("/chat/sendReel")
    @ResponseBody
    public String sendReelToChat(
            @RequestParam Long videoId,
            @RequestParam Long receiverId,
            HttpSession session) {

        User sender = (User) session.getAttribute("user");
        if (sender == null) return "ERROR: Not logged in";

        Videoupload video = videouploadRepo.findById(videoId).orElse(null);
        if (video == null) return "ERROR: Video not found";

        User receiver = userRepo.findById(receiverId).orElse(null);
        if (receiver == null) return "ERROR: Receiver not found";

        ChatMessage msg = new ChatMessage();
        msg.setSender(sender);
        msg.setReceiver(receiver);
        msg.setMessage(""); // no text
        msg.setVideoUrl(video.getVideoPath()); // MUST BE FULL PATH or CONTEXT PATH

        chatMessageRepo.save(msg);

        return "OK";
    }

    @GetMapping("/searchs/{id}")
    public String searchUserss(
            @PathVariable Long id,
            @RequestParam(required = false) Long videoId,
            Model model,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.getId().equals(id)) {
            return "redirect:/login";
        }

        model.addAttribute("friends", followService.getFriends(id));
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("videoId", videoId); // ⭐ VERY IMPORTANT

        return "friendse";
    }
    @PostMapping("/groups/create")
    public String createGroup(@RequestParam String groupName,
                              @RequestParam(required = false) List<Long> memberIds,
                              HttpSession session) {

        User creator = (User) session.getAttribute("user");
        if (creator == null) return "redirect:/login";

        // 1️⃣ Create Group
        Group group = new Group();
        group.setName(groupName);
        group.setCreatedBy(creator);

        // 2️⃣ Prepare GroupMember list
        List<GroupMember> groupMembers = new ArrayList<>();

        // Add selected friends (memberIds can be null if no friends selected)
        if (memberIds != null) {
            List<User> friends = userRepo.findAllById(memberIds);
            for (User friend : friends) {
                GroupMember gm = new GroupMember();
                gm.setGroup(group);
                gm.setUser(friend);
                gm.setAdmin(false); // friends are not admin
                groupMembers.add(gm);
            }
        }

        // Add creator as admin
        GroupMember adminMember = new GroupMember();
        adminMember.setGroup(group);
        adminMember.setUser(creator);
        adminMember.setAdmin(true); // creator is admin
        groupMembers.add(adminMember);

        // 3️⃣ Set members in group
        group.setMembers(groupMembers);

        // 4️⃣ Save the group (cascade can save GroupMembers if configured)
        grouprepo.save(group);

        // 5️⃣ Redirect back to user search page
        return "redirect:/users/search";
    }
    @GetMapping("/groups/chat/{groupId}")
    public String openGroupChat(
            @PathVariable Long groupId,
            Model model,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        Group group = grouprepo.findById(groupId).orElse(null);
        if (group == null) return "redirect:/users/search";

        boolean isMember = group.getMembers().stream()
                .anyMatch(m -> m.getUser().getId().equals(currentUser.getId()));
        if (!isMember) return "redirect:/users/search";

        List<ChatMessage> messages =
                chatMessageRepo.findByGroupIdOrderByCreatedAtAsc(groupId);

        // 🔥 NEW PART
        List<User> friends = followService.getFriends(currentUser.getId());

        Set<Long> groupMemberIds = group.getMembers().stream()
                .map(m -> m.getUser().getId())
                .collect(Collectors.toSet());

        model.addAttribute("group", group);
        model.addAttribute("messages", messages);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("friends", friends);
        model.addAttribute("groupMemberIds", groupMemberIds);

        return "profilechat/group_chat";
    }

    @PostMapping("/groups/{groupId}/send")
    public String sendGroupMessage(
            @PathVariable Long groupId,
            @RequestParam String message,
            HttpSession session) {

        User sender = (User) session.getAttribute("user");
        if (sender == null) return "redirect:/login";

        Group group = grouprepo.findById(groupId).orElse(null);
        if (group == null) return "redirect:/users/search";

        ChatMessage msg = new ChatMessage();
        msg.setSender(sender);
        msg.setGroup(group);
        msg.setMessage(message);

        chatMessageRepo.save(msg);

        return "redirect:/users/groups/chat/" + groupId;
    }

    @PostMapping("/groups/{groupId}/add-member")
    public String addMemberToGroup(
            @PathVariable Long groupId,
            @RequestParam Long userId,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        Group group = grouprepo.findById(groupId).orElse(null);
        User user = userRepo.findById(userId).orElse(null);

        if (group == null || user == null)
            return "redirect:/users/search";

        // Prevent duplicate members
        boolean alreadyMember = groupMemberRepo
                .existsByGroupIdAndUserId(groupId, userId);

        if (!alreadyMember) {
            GroupMember gm = new GroupMember();
            gm.setGroup(group);
            gm.setUser(user);
            gm.setAdmin(false);
            groupMemberRepo.save(gm);
        }

        return "redirect:/users/groups/chat/" + groupId;
    }
    

@Transactional
    @PostMapping("/groups/{groupId}/exit")
    public String exitGroup(
            @PathVariable Long groupId,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        // Remove member from group
        groupMemberRepo.deleteByGroupIdAndUserId(
                groupId,
                currentUser.getId()
        );

        return "redirect:/users/search"; // back to groups list
    }
  
}
