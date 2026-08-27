package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.ChatMessage;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.ChatService;

import jakarta.servlet.http.HttpSession;
import org.springframework.messaging.simp.SimpMessagingTemplate;


@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private UserRepository userRepo;
    

    @Autowired
    private in.sp.main.Service.UserFollowService followService;

    @Autowired
    private in.sp.main.Repository.DoctorChatRepository doctorChatRepo;

    @Autowired
    private in.sp.main.Repository.ChatMessageRepository chatMessageRepo;

    // WebRTC Signaling — sender from authenticated principal only
    @MessageMapping("/webrtc.signal")
    public void handleWebRTCSignal(@Payload Map<String, Object> signal,
                                   org.springframework.messaging.simp.stomp.StompHeaderAccessor accessor) {
        if (accessor.getUser() == null) {
            return;
        }
        String email = accessor.getUser().getName();
        User sender = userRepo.findByEmail(email).orElse(null);
        if (sender == null) {
            return;
        }
        Object receiverId = signal.get("receiverId");
        if (receiverId == null) {
            return;
        }
        signal.put("fromId", sender.getId());
        signal.put("fromName", sender.getFullName());
        messagingTemplate.convertAndSend("/topic/calls/" + receiverId, signal);
    }

    // Show all users to start chat
    @GetMapping("/users")
    public String showUsers(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Fetch contacts the user has actively chatted with
        List<User> userContacts = chatMessageRepo.findChatContacts(currentUser.getId());
        List<in.sp.main.Entities.Doctor> doctorContacts = doctorChatRepo.findChattedDoctorsByUser(currentUser.getId());
        
        model.addAttribute("users", userContacts);
        model.addAttribute("doctors", doctorContacts);
        return "chat_users";
    }

    // Chat window between two users
    @GetMapping("/window/{receiverId}")
    public String openChatWindow(@PathVariable Long receiverId, Model model, HttpSession session) {
        User sender = (User) session.getAttribute("user");
        if (sender == null) return "redirect:/login";

        User receiver = userRepo.findById(receiverId).orElse(null);
        if (receiver == null) return "redirect:/chat/users";
        if (!followService.getFriends(sender.getId()).stream().anyMatch(f -> f.getId().equals(receiverId))) {
            return "redirect:/chat/users";
        }

        chatService.markAsRead(receiverId, sender.getId());
        List<ChatMessage> messages = chatService.getChatHistory(sender, receiver);
        model.addAttribute("receiver", receiver);
        model.addAttribute("messages", messages);
        return "chat_window";
    }

    // Video call window
    @GetMapping("/video-call/{receiverId}")
    public String openVideoCall(@PathVariable Long receiverId, 
                                @RequestParam(required = false) boolean notify,
                                Model model, HttpSession session) {
        User sender = (User) session.getAttribute("user");
        if (sender == null) return "redirect:/login";

        User receiver = userRepo.findById(receiverId).orElse(null);
        if (receiver == null) return "redirect:/chat/users";

        String roomName = "fdf-video-" + Math.min(sender.getId(), receiver.getId()) + "-" + Math.max(sender.getId(), receiver.getId());
        
        if (notify) {
            // 🔴 Notify receiver via WebSocket only if notify=true
            Map<String, Object> callInfo = new HashMap<>();
            callInfo.put("type", "INCOMING_CALL");
            callInfo.put("fromId", sender.getId());
            callInfo.put("fromName", sender.getFullName());
            callInfo.put("roomName", roomName);
            callInfo.put("audioOnly", false);
            messagingTemplate.convertAndSend("/topic/calls/" + receiverId, callInfo);
        }

        model.addAttribute("receiver", receiver);
        model.addAttribute("roomName", roomName);
        model.addAttribute("displayName", sender.getFullName());
        model.addAttribute("audioOnly", false);
        return "chat_call";
    }

    @GetMapping("/call/{receiverId}")
    public String openVoiceCall(@PathVariable Long receiverId, 
                                @RequestParam(required = false) boolean notify,
                                Model model, HttpSession session) {
        User sender = (User) session.getAttribute("user");
        if (sender == null) return "redirect:/login";

        User receiver = userRepo.findById(receiverId).orElse(null);
        if (receiver == null) return "redirect:/chat/users";

        String roomName = "fdf-call-" + Math.min(sender.getId(), receiver.getId()) + "-" + Math.max(sender.getId(), receiver.getId());

        if (notify) {
            // 🔴 Notify receiver via WebSocket only if notify=true
            Map<String, Object> callInfo = new HashMap<>();
            callInfo.put("type", "INCOMING_CALL");
            callInfo.put("fromId", sender.getId());
            callInfo.put("fromName", sender.getFullName());
            callInfo.put("roomName", roomName);
            callInfo.put("audioOnly", true);
            messagingTemplate.convertAndSend("/topic/calls/" + receiverId, callInfo);
        }

        model.addAttribute("receiver", receiver);
        model.addAttribute("roomName", roomName);
        model.addAttribute("displayName", sender.getFullName());
        model.addAttribute("audioOnly", true);
        return "chat_call";
    }

    // Send message
   

    @PostMapping("/sendReel")
    @ResponseBody
    public String sendReel(@RequestParam Long receiverId,
                           @RequestParam String videoUrl,
                           HttpSession session) {

        User sender = (User) session.getAttribute("user");
        if (sender == null) return "NOT_LOGGED_IN";

        User receiver = userRepo.findById(receiverId).orElse(null);
        if (receiver == null) return "USER_NOT_FOUND";

        ChatMessage msg = new ChatMessage();
        msg.setSender(sender);
        msg.setReceiver(receiver);
        msg.setVideoUrl(videoUrl);
        msg.setTimestamp(LocalDateTime.now());

        msg = chatService.save(msg);
        Map<String, Object> payload = chatService.toWirePayload(msg, sender, receiver);
        messagingTemplate.convertAndSend("/topic/messages/" + receiverId, payload);
        messagingTemplate.convertAndSend("/topic/messages/" + sender.getId(), payload);

        return "OK";
    }

    /** Reliable HTTP send — works even when WebSocket is disconnected (emoji-safe UTF-8). */
    @PostMapping(value = "/send-message", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> apiSend(@RequestBody Map<String, Object> body,
                                                       HttpSession session) {
        User sender = (User) session.getAttribute("user");
        if (sender == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Not logged in"));
        }

        Object receiverObj = body == null ? null : body.get("receiverId");
        Object messageObj = body == null ? null : body.get("message");
        if (receiverObj == null || messageObj == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "receiverId and message are required"));
        }

        Long receiverId;
        try {
            receiverId = Long.valueOf(String.valueOf(receiverObj));
        } catch (NumberFormatException ex) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "Invalid receiverId"));
        }

        User receiver = userRepo.findById(receiverId).orElse(null);
        if (receiver == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "Receiver not found"));
        }

        if (!canChat(sender, receiver)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "error", "You can only chat with friends"));
        }

        Map<String, Object> payload = chatService.deliverUserMessage(sender, receiver, String.valueOf(messageObj));
        if (payload == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "Message is empty"));
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", payload);
        return ResponseEntity.ok(res);
    }

    /** Poll new messages for a chat (backup when WebSocket misses a push). */
    @GetMapping(value = "/messages-since/{otherUserId}", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> apiPollMessages(@PathVariable Long otherUserId,
                                                                 @RequestParam(required = false) String since,
                                                                 HttpSession session) {
        User me = (User) session.getAttribute("user");
        if (me == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Not logged in"));
        }

        User other = userRepo.findById(otherUserId).orElse(null);
        if (other == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "error", "User not found"));
        }

        LocalDateTime sinceTime = LocalDateTime.now().minusHours(24);
        if (since != null && !since.isBlank()) {
            try {
                sinceTime = LocalDateTime.parse(since.replace(" ", "T").substring(0, Math.min(19, since.length())));
                sinceTime = sinceTime.minusSeconds(1);
            } catch (DateTimeParseException ignored) {
                // keep default window
            }
        }

        List<ChatMessage> rows = chatService.getMessagesSince(me, other, sinceTime);
        List<Map<String, Object>> items = new ArrayList<>();
        for (ChatMessage row : rows) {
            User sender = row.getSender();
            User receiver = row.getReceiver();
            if (sender == null || receiver == null) continue;
            items.add(chatService.toWirePayload(row, sender, receiver));
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("messages", items);
        return ResponseEntity.ok(res);
    }

    private boolean canChat(User sender, User receiver) {
        if (sender == null || receiver == null) {
            return false;
        }
        boolean friends = followService.getFriends(sender.getId()).stream()
                .anyMatch(f -> f.getId().equals(receiver.getId()));
        if (friends) {
            return true;
        }
        return !chatService.getChatHistory(sender, receiver).isEmpty();
    }

}