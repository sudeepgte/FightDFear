package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

        chatService.save(msg);

        // Send via WebSocket
        messagingTemplate.convertAndSend("/topic/messages/" + receiverId, msg);

        return "OK";
    }

}