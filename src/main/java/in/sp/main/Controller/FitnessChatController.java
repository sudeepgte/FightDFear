package in.sp.main.Controller;

import in.sp.main.Entities.FitnessChatMessage;
import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.User;
import in.sp.main.Repository.FitnessChatMessageRepository;
import in.sp.main.Repository.FitnessTrainerRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.PushNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/fitness/chat")
public class FitnessChatController {

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private FitnessChatMessageRepository chatMessageRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FitnessTrainerRepository trainerRepository;

    @Autowired
    private in.sp.main.Service.EmailAsyncService emailAsyncService;

    // Helper to get logged in User or Trainer
    private User getSessionUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private FitnessTrainer getSessionTrainer(HttpSession session) {
        return (FitnessTrainer) session.getAttribute("loggedTrainer");
    }

    @GetMapping("/{userId}/{trainerId}")
    public ResponseEntity<?> getChatHistory(@PathVariable Long userId, @PathVariable Long trainerId, HttpSession session) {
        User currentUser = getSessionUser(session);
        FitnessTrainer currentTrainer = getSessionTrainer(session);

        // Security check: Must be either the user or the trainer involved
        if (currentUser == null && currentTrainer == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        if (currentUser != null && !currentUser.getId().equals(userId)) {
            return ResponseEntity.status(403).body("Forbidden");
        }
        if (currentTrainer != null && !currentTrainer.getId().equals(trainerId)) {
            return ResponseEntity.status(403).body("Forbidden");
        }

        List<FitnessChatMessage> messages = chatMessageRepository.findByUser_IdAndTrainer_IdOrderByTimestampAsc(userId, trainerId);
        
        // Map to DTO for safe JSON serialization without circular dependencies
        List<Map<String, Object>> response = messages.stream().map(m -> {
            Map<String, Object> dto = new java.util.HashMap<>();
            dto.put("id", m.getId());
            dto.put("message", m.getMessage());
            dto.put("senderType", m.getSenderType());
            dto.put("timestamp", m.getTimestamp().toString());
            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @PostMapping("/send")
    public ResponseEntity<?> sendMessage(@RequestParam("userId") Long userId, @RequestParam("trainerId") Long trainerId, @RequestParam("message") String message, HttpSession session) {
        User currentUser = getSessionUser(session);
        FitnessTrainer currentTrainer = getSessionTrainer(session);

        if (currentUser == null && currentTrainer == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        User user = userRepository.findById(userId).orElse(null);
        FitnessTrainer trainer = trainerRepository.findById(trainerId).orElse(null);

        if (user == null || trainer == null) {
            return ResponseEntity.badRequest().body("Invalid user or trainer.");
        }

        FitnessChatMessage chatMsg = new FitnessChatMessage();
        chatMsg.setUser(user);
        chatMsg.setTrainer(trainer);
        chatMsg.setMessage(message);

        // Determine if sender is the user or the trainer
        String preview = message.length() > 80 ? message.substring(0, 80) + "..." : message;
        if (currentUser != null && currentUser.getId().equals(userId)) {
            chatMsg.setSenderType("USER");
            if (trainer.getEmail() != null && !trainer.getEmail().isBlank()) {
                try {
                    String subject = "Fight D Fear - New message from " + (user.getFullName() != null ? user.getFullName() : "Trainee");
                    String body = "Hello Coach " + (trainer.getFullName() != null ? trainer.getFullName() : "Trainer") + ",\n\n"
                            + (user.getFullName() != null ? user.getFullName() : "A trainee") + " sent you a message:\n\n"
                            + "\"" + preview + "\"\n\n"
                            + "Please open the Fight D Fear app to view and reply.\n\nThank you,\nFight D Fear Healthcare";
                    emailAsyncService.sendEmailAsync(trainer.getEmail(), subject, body);
                } catch (Exception ignored) {}
            }
        } else if (currentTrainer != null && currentTrainer.getId().equals(trainerId)) {
            chatMsg.setSenderType("TRAINER");
            pushNotificationService.notifyUser(userId, "New Message from Coach " + trainer.getFullName(), message, Map.of("type", "FITNESS_CHAT", "trainerId", trainerId.toString()));
            if (user.getEmail() != null && !user.getEmail().isBlank()) {
                try {
                    String subject = "Fight D Fear - New message from Coach " + trainer.getFullName();
                    String body = "Hello " + (user.getFullName() != null ? user.getFullName() : "Trainee") + ",\n\n"
                            + "Coach " + trainer.getFullName() + " sent you a message:\n\n"
                            + "\"" + preview + "\"\n\n"
                            + "Please open the Fight D Fear app to view and reply.\n\nThank you,\nFight D Fear Healthcare";
                    emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
                } catch (Exception ignored) {}
            }
        } else {
            return ResponseEntity.status(403).body("Forbidden");
        }

        chatMessageRepository.save(chatMsg);
        return ResponseEntity.ok("Message sent");
    }
}
