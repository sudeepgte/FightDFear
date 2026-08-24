package in.sp.main.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonChatMessage;
import in.sp.main.Entities.SalonNotification;
import in.sp.main.Repository.SalonChatMessageRepository;
import in.sp.main.Repository.SalonNotificationRepository;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/salon")
public class SalonRealTimeController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private SalonNotificationRepository notificationRepository;

    @Autowired
    private SalonChatMessageRepository chatMessageRepository;
    
    @Autowired
    private SalonRepository salonRepository;
    
    @Autowired
    private UserRepository userRepository;

    // --- REST Endpoints for Initial Fetch ---

    @GetMapping("/notifications")
    public ResponseEntity<List<SalonNotification>> getNotifications(HttpSession session) {
        Salon salon = (Salon) session.getAttribute("loggedSalon");
        if (salon == null) return ResponseEntity.status(401).build();
        
        List<SalonNotification> notifs = notificationRepository.findBySalonIdOrderByTimestampDesc(salon.getId());
        return ResponseEntity.ok(notifs);
    }

    @PostMapping("/notifications/mark-read")
    public ResponseEntity<Void> markNotificationsRead(HttpSession session) {
        Salon salon = (Salon) session.getAttribute("loggedSalon");
        if (salon == null) return ResponseEntity.status(401).build();
        
        List<SalonNotification> unread = notificationRepository.findBySalonIdAndIsReadFalseOrderByTimestampDesc(salon.getId());
        for (SalonNotification n : unread) {
            n.setRead(true);
            notificationRepository.save(n);
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/chat")
    public ResponseEntity<?> getChatMessages(HttpSession session, @org.springframework.web.bind.annotation.RequestParam(required = false) Long salonId) {
        Salon salon = (Salon) session.getAttribute("loggedSalon");
        if (salon != null) {
            List<SalonChatMessage> messages = chatMessageRepository.findBySalonIdOrderByTimestampAsc(salon.getId());
            return ResponseEntity.ok(messages.stream().map(this::toPayload).toList());
        }
        
        in.sp.main.Entities.User user = (in.sp.main.Entities.User) session.getAttribute("user");
        if (user != null && salonId != null) {
            List<SalonChatMessage> messages = chatMessageRepository.findBySalonIdAndUserIdOrderByTimestampAsc(salonId, user.getId());
            return ResponseEntity.ok(messages.stream().map(this::toPayload).toList());
        }
        
        return ResponseEntity.status(401).build();
    }

    private ChatPayload toPayload(SalonChatMessage msg) {
        ChatPayload p = new ChatPayload();
        p.setId(msg.getId());
        if (msg.getSalon() != null) p.setSalonId(msg.getSalon().getId());
        if (msg.getUser() != null) {
            p.setUserId(msg.getUser().getId());
            p.setUserName(msg.getUser().getFullName());
            p.setUserEmail(msg.getUser().getEmail());
        }
        p.setSenderRole(msg.getSenderRole());
        p.setMessage(msg.getMessage());
        if (msg.getTimestamp() != null) {
            p.setTimestamp(msg.getTimestamp().toString());
        }
        return p;
    }

    // --- WebSocket STOMP Endpoints ---

    @MessageMapping("/salon/chat")
    public void processSalonChat(@Payload ChatPayload payload) {
        SalonChatMessage msg = new SalonChatMessage();
        
        salonRepository.findById(payload.getSalonId()).ifPresent(msg::setSalon);
        if (payload.getUserId() != null) {
            userRepository.findById(payload.getUserId()).ifPresent(msg::setUser);
        }
        
        msg.setSenderRole(payload.getSenderRole());
        msg.setMessage(payload.getMessage());
        SalonChatMessage saved = chatMessageRepository.save(msg);
        
        if ("USER".equals(payload.getSenderRole()) && msg.getSalon() != null) {
            SalonNotification notif = new SalonNotification();
            notif.setSalon(msg.getSalon());
            notif.setTitle("New Message from " + (msg.getUser() != null ? msg.getUser().getFullName() : "Client"));
            notif.setMessage(payload.getMessage());
            SalonNotification savedNotif = notificationRepository.save(notif);
            
            // Broadcast notification in real-time
            messagingTemplate.convertAndSend("/topic/salon/notifications/" + msg.getSalon().getId(), savedNotif);
        }
        
        // Broadcast a safe DTO to prevent LazyInitializationException on User entity
        ChatPayload responsePayload = toPayload(saved);
        
        // Broadcast to Salon
        messagingTemplate.convertAndSend("/topic/salon/chat/" + payload.getSalonId(), responsePayload);
    }
    
    public static class ChatPayload {
        private Long id;
        private Long salonId;
        private Long userId;
        private String userName;
        private String userEmail;
        private String senderRole;
        private String message;
        private String timestamp;
        
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public Long getSalonId() { return salonId; }
        public void setSalonId(Long salonId) { this.salonId = salonId; }
        public Long getUserId() { return userId; }
        public void setUserId(Long userId) { this.userId = userId; }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getUserEmail() { return userEmail; }
        public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
        public String getSenderRole() { return senderRole; }
        public void setSenderRole(String senderRole) { this.senderRole = senderRole; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public String getTimestamp() { return timestamp; }
        public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
    }
}
