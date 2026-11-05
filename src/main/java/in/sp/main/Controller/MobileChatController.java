package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import in.sp.main.Entities.UserFollow;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import in.sp.main.Entities.ChatMessage;
import in.sp.main.Entities.CreatorNotification;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.ChatService;
import in.sp.main.Service.UserFollowService;
import jakarta.servlet.http.HttpSession;

/**
 * REST chat APIs for mobile/web clients. Use as polling fallback when WebSocket reconnect fails.
 */
@RestController
@RequestMapping("/api/chat")
public class MobileChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private in.sp.main.Repository.ChatMessageRepository chatMessageRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserFollowService followService;

    @Autowired
    private in.sp.main.Repository.CreatorNotificationRepository creatorNotificationRepository;

    @Autowired(required = false)
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @Autowired
    private in.sp.main.Repository.UserFollowRepository userFollowRepository;

    @Autowired
    private in.sp.main.Service.EmailAsyncService emailAsyncService;

    private User requireUser(HttpSession session) {
        User u = session == null ? null : (User) session.getAttribute("user");
        if (u != null) return u;
        try {
            org.springframework.security.core.Authentication auth = 
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
                String email = auth.getName();
                u = userRepository.findByEmail(email).orElse(null);
                if (u != null && session != null) {
                    session.setAttribute("user", u);
                }
                return u;
            }
        } catch (Exception ignored) {}
        return null;
    }

    @GetMapping("/inbox")
    public ResponseEntity<Map<String, Object>> inbox(HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }

        List<UserFollow> myFollows = userFollowRepository.findByFollower(currentUser);
        List<UserFollow> followsMe = userFollowRepository.findByFollowed_IdAndAcceptedTrue(currentUser.getId());

        Set<User> chatUsersSet = new LinkedHashSet<>();
        Set<Long> followingIds = new HashSet<>();

        for (UserFollow uf : myFollows) {
            if (uf.getFollowed() != null && !uf.getFollowed().getId().equals(currentUser.getId())) {
                chatUsersSet.add(uf.getFollowed());
                followingIds.add(uf.getFollowed().getId());
            }
        }
        for (UserFollow uf : followsMe) {
            if (uf.getFollower() != null && !uf.getFollower().getId().equals(currentUser.getId())) {
                chatUsersSet.add(uf.getFollower());
                followingIds.add(uf.getFollower().getId());
            }
        }

        List<User> chatContacts = chatMessageRepository.findChatContacts(currentUser.getId());
        if (chatContacts == null) chatContacts = Collections.emptyList();

        Set<User> messageRequestsSet = new LinkedHashSet<>();
        for (User contact : chatContacts) {
            if (contact.getId().equals(currentUser.getId())) continue;
            if (followingIds.contains(contact.getId())) {
                chatUsersSet.add(contact);
            } else {
                messageRequestsSet.add(contact);
            }
        }

        Map<Long, Long> unreadCounts = new HashMap<>();
        try {
            List<Object[]> unreadList = chatMessageRepository.countUnreadBySender(currentUser.getId());
            if (unreadList != null) {
                for (Object[] row : unreadList) {
                    if (row != null && row.length >= 2 && row[0] != null && row[1] != null) {
                        unreadCounts.put(((Number) row[0]).longValue(), ((Number) row[1]).longValue());
                    }
                }
            }
        } catch (Exception ignored) {}

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("chatUsers", chatUsersSet.stream().map(u -> chatUserDto(u, unreadCounts, followingIds)).collect(Collectors.toList()));
        response.put("messageRequests", messageRequestsSet.stream().map(u -> chatUserDto(u, unreadCounts, followingIds)).collect(Collectors.toList()));
        response.put("followingIds", new ArrayList<>(followingIds));
        response.put("unreadCounts", unreadCounts);
        return ResponseEntity.ok(response);
    }

    private Map<String, Object> chatUserDto(User u, Map<Long, Long> unreadCounts, Set<Long> followingIds) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", u.getId());
        m.put("fullName", u.getFullName());
        m.put("name", u.getFullName());
        m.put("profilePhoto", u.getProfilePhoto());
        m.put("handle", u.getCreatorHandle());
        m.put("unreadCount", unreadCounts.getOrDefault(u.getId(), 0L));
        m.put("isFollowing", followingIds.contains(u.getId()));
        return m;
    }

    @GetMapping("/user-info")
    public ResponseEntity<Map<String, Object>> userInfo(@RequestParam("userId") Long userId) {
        User u = userRepository.findById(userId).orElse(null);
        if (u == null) {
            return ResponseEntity.notFound().build();
        }
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", u.getId());
        map.put("fullName", u.getFullName());
        map.put("profilePhoto", u.getProfilePhoto());
        return ResponseEntity.ok(map);
    }

    @GetMapping("/messages")
    public ResponseEntity<Map<String, Object>> messages(
            @RequestParam("peerId") Long peerId,
            @RequestParam(value = "since", required = false) String since,
            HttpSession session) {
        User current = requireUser(session);
        if (current == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        User peer = userRepository.findById(peerId).orElse(null);
        if (peer == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Peer not found"));
        }

        // Mark incoming messages as read when opening conversation
        try {
            chatService.markAsRead(peerId, current.getId());
        } catch (Exception e) {}

        List<ChatMessage> messages;
        if (since != null && !since.isBlank()) {
            LocalDateTime sinceTime;
            try {
                sinceTime = LocalDateTime.parse(since);
            } catch (DateTimeParseException ex) {
                return ResponseEntity.badRequest()
                        .body(Map.of("success", false, "error", "Invalid since timestamp (ISO-8601 expected)"));
            }
            messages = chatService.getMessagesSince(current, peer, sinceTime);
        } else {
            messages = chatService.getChatHistory(current, peer);
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("peerId", peerId);
        response.put("messages", messages.stream().map(this::messageDto).collect(Collectors.toList()));
        response.put("pollIntervalSeconds", 5);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/send")
    public ResponseEntity<Map<String, Object>> send(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User current = requireUser(session);
        if (current == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        Object peerRaw = body.get("peerId");
        Object messageRaw = body.get("message");
        if (peerRaw == null || messageRaw == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "peerId and message are required"));
        }
        Long peerId = Long.valueOf(peerRaw.toString());
        String message = messageRaw.toString().trim();
        if (message.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "message is required"));
        }
        User peer = userRepository.findById(peerId).orElse(null);
        if (peer == null) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Peer not found"));
        }

        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSender(current);
        chatMessage.setReceiver(peer);
        chatMessage.setMessage(message);
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setReadStatus(false);
        ChatMessage saved = chatService.save(chatMessage);

        boolean receiverFollowsSender = userFollowRepository.existsByFollower_IdAndFollowed_Id(peerId, current.getId())
                || userFollowRepository.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(current.getId(), peerId);

        Map<String, Object> wireDto = messageDto(saved);
        wireDto.put("isFollowed", receiverFollowsSender);

        try {
            org.springframework.messaging.simp.SimpMessagingTemplate template = this.messagingTemplate;
            if (template == null && session != null) {
                template = org.springframework.web.context.support.WebApplicationContextUtils
                    .getRequiredWebApplicationContext(session.getServletContext())
                    .getBean(org.springframework.messaging.simp.SimpMessagingTemplate.class);
            }

            if (template != null) {
                // Broadcast real-time message to receiver
                template.convertAndSend("/topic/messages/" + peerId, wireDto);

                // If receiver follows sender, record notification and alert bell
                if (receiverFollowsSender) {
                    CreatorNotification notif = new CreatorNotification();
                    notif.setUser(peer);
                    notif.setSender(current);
                    notif.setType("CHAT_MESSAGE");
                    String preview = message.length() > 60 ? message.substring(0, 57) + "..." : message;
                    notif.setMessage(current.getFullName() + ": " + preview);
                    notif.setCreatedAt(LocalDateTime.now());
                    notif.setRead(false);
                    creatorNotificationRepository.save(notif);

                    try {
                        Map<String, Object> notifAlert = new HashMap<>();
                        notifAlert.put("type", "CHAT_MESSAGE");
                        notifAlert.put("title", "New message from " + current.getFullName());
                        notifAlert.put("message", current.getFullName() + ": " + preview);
                        notifAlert.put("senderName", current.getFullName());
                        notifAlert.put("senderPhoto", current.getProfilePhoto());
                        notifAlert.put("peerId", current.getId());
                        template.convertAndSend("/topic/follow/" + peerId, notifAlert);
                    } catch (Exception ignored) {}
                }
            }
        } catch (Exception e) {
            System.err.println("Failed to broadcast chat STOMP message: " + e.getMessage());
        }

        if (peer.getEmail() != null && !peer.getEmail().isBlank()) {
            try {
                String preview = message.length() > 80 ? message.substring(0, 80) + "..." : message;
                String senderName = current.getFullName() != null ? current.getFullName() : "A member";
                String subject = "Fight D Fear - New message from " + senderName;
                String emailBody = "Hello " + (peer.getFullName() != null ? peer.getFullName() : "Member") + ",\n\n"
                        + senderName + " sent you a new message:\n\n"
                        + "\"" + preview + "\"\n\n"
                        + "Please open the Fight D Fear app or website to view and reply.\n\nThank you,\nFight D Fear Healthcare";
                emailAsyncService.sendEmailAsync(peer.getEmail(), subject, emailBody);
            } catch (Exception ignored) {}
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", wireDto);
        return ResponseEntity.ok(response);
    }

    private Map<String, Object> messageDto(ChatMessage message) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", message.getId());
        dto.put("message", message.getMessage());
        dto.put("videoUrl", message.getVideoUrl());
        dto.put("readStatus", message.isReadStatus());
        dto.put("timestamp", message.getTimestamp() == null ? null : message.getTimestamp().toString());
        if (message.getSender() != null) {
            dto.put("senderId", message.getSender().getId());
            dto.put("senderName", message.getSender().getFullName());
            dto.put("senderPhoto", message.getSender().getProfilePhoto());
        }
        if (message.getReceiver() != null) {
            dto.put("receiverId", message.getReceiver().getId());
            dto.put("receiverName", message.getReceiver().getFullName());
        }
        return dto;
    }

    @PostMapping("/upload")
    public ResponseEntity<Map<String, Object>> uploadFile(@RequestParam("file") org.springframework.web.multipart.MultipartFile file, HttpSession session) {
        User current = requireUser(session);
        if (current == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Unauthorized"));
        }
        try {
            in.sp.main.Service.FileUploadService fileUploadService = org.springframework.web.context.support.WebApplicationContextUtils
                .getRequiredWebApplicationContext(session.getServletContext())
                .getBean(in.sp.main.Service.FileUploadService.class);
            String url = fileUploadService.saveFile(file);
            return ResponseEntity.ok(Map.of("success", true, "url", url));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    @PostMapping("/delete/{msgId}")
    public ResponseEntity<Map<String, Object>> deleteMessage(@PathVariable Long msgId, @RequestParam("type") String type, HttpSession session) {
        User current = requireUser(session);
        if (current == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        try {
            Optional<ChatMessage> optMsg = chatMessageRepository.findById(msgId);
            if (optMsg.isPresent()) {
                ChatMessage msg = optMsg.get();
                boolean isSender = msg.getSender().getId().equals(current.getId());
                boolean isReceiver = msg.getReceiver().getId().equals(current.getId());
                
                if (!isSender && !isReceiver) return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
                
                if ("me".equals(type)) {
                    if (isSender) msg.setDeletedForSender(true);
                    if (isReceiver) msg.setDeletedForReceiver(true);
                } else if ("everyone".equals(type) && isSender) {
                    msg.setDeletedForSender(true);
                    msg.setDeletedForReceiver(true);
                    msg.setMessage("[DELETED]");
                    msg.setVideoUrl(null);
                    msg.setVideoPath(null);
                    
                    try {
                        org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate = 
                            org.springframework.web.context.support.WebApplicationContextUtils
                            .getRequiredWebApplicationContext(session.getServletContext())
                            .getBean(org.springframework.messaging.simp.SimpMessagingTemplate.class);
                        Map<String, Object> delMsg = new HashMap<>();
                        delMsg.put("action", "DELETE");
                        delMsg.put("id", msg.getId());
                        messagingTemplate.convertAndSend("/topic/messages/" + msg.getReceiver().getId(), delMsg);
                        messagingTemplate.convertAndSend("/topic/messages/" + msg.getSender().getId(), delMsg);
                    } catch (Exception e) {}
                }
                chatMessageRepository.save(msg);
                return ResponseEntity.ok(Map.of("success", true));
            }
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Message not found"));
        } catch(Exception e){
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.toString()));
        }
    }
}
