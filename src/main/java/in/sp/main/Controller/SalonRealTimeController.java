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
    public ResponseEntity<List<SalonChatMessage>> getChatMessages(HttpSession session) {
        Salon salon = (Salon) session.getAttribute("loggedSalon");
        if (salon == null) return ResponseEntity.status(401).build();
        
        List<SalonChatMessage> messages = chatMessageRepository.findBySalonIdOrderByTimestampAsc(salon.getId());
        return ResponseEntity.ok(messages);
    }

    // --- WebSocket STOMP Endpoints ---

    /**
     * Handled incoming message from Salon or User.
     * Payload expected: { "salonId": 1, "userId": 2, "senderRole": "SALON", "message": "Hello!" }
     */
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
        
        // Broadcast to Salon
        messagingTemplate.convertAndSend("/topic/salon/chat/" + payload.getSalonId(), saved);
    }
    
    public static class ChatPayload {
        private Long salonId;
        private Long userId;
        private String senderRole;
        private String message;
        
        public Long getSalonId() { return salonId; }
        public void setSalonId(Long salonId) { this.salonId = salonId; }
        public Long getUserId() { return userId; }
        public void setUserId(Long userId) { this.userId = userId; }
        public String getSenderRole() { return senderRole; }
        public void setSenderRole(String senderRole) { this.senderRole = senderRole; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
}
