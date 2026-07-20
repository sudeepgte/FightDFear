package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.ChatMessage;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.ChatService;
import in.sp.main.Service.ContactMessageService;
import jakarta.servlet.http.HttpServletRequest;

import java.time.LocalDateTime;

@Controller
public class ContactController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private ContactMessageService contactMessageService;

    @Value("${spring.mail.username:}")
    private String adminEmail;

    @GetMapping("/contact")
    public String showContactPage(Model model) {
        model.addAttribute("pageTitle", "Contact Us");
        return "index/contact";
    }

    @GetMapping("/sendMessage")
    public String handleGetSendMessage() {
        return "redirect:/contact";
    }

    @PostMapping("/sendMessage")
    public Object sendMessage(@RequestParam(required = false) String name,
                              @RequestParam(required = false) String email,
                              @RequestParam(required = false) String subject,
                              @RequestParam(required = false) String message,
                              HttpServletRequest request,
                              RedirectAttributes redirectAttributes) {
        String trimmedEmail = email != null ? email.trim() : "";
        // Improved email validation regex
        if (trimmedEmail.isEmpty() || !trimmedEmail.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            return contactResponse(request, redirectAttributes, false, "Invalid email format.");
        }
        if (name == null || name.isBlank() || subject == null || subject.isBlank()
                || message == null || message.isBlank()) {
            return contactResponse(request, redirectAttributes, false, "Please fill in all fields.");
        }

        try {
            contactMessageService.save(name.trim(), trimmedEmail, subject.trim(), message.trim());
            try {
                if (adminEmail != null && !adminEmail.isBlank()) {
                    SimpleMailMessage mail = new SimpleMailMessage();
                    mail.setTo(adminEmail);
                    mail.setSubject("Fight D Fear Contact: " + subject.trim());
                    mail.setText("From: " + name.trim() + "\nEmail: " + trimmedEmail
                            + "\n\nMessage:\n" + message.trim());
                    mailSender.send(mail);
                }
            } catch (Exception mailEx) {
                // Stored for admin inbox; email is best-effort only
            }
            return contactResponse(request, redirectAttributes, true, "Your message has been sent!");
        } catch (Exception e) {
            return contactResponse(request, redirectAttributes, false, "Failed to send message. Try again later.");
        }
    }

    private Object contactResponse(HttpServletRequest request,
                                 RedirectAttributes redirectAttributes,
                                 boolean ok,
                                 String msg) {
        if (isAjax(request)) {
            if (ok) {
                return ResponseEntity.ok("OK");
            }
            return ResponseEntity.badRequest().body(msg);
        }
        if (ok) {
            redirectAttributes.addFlashAttribute("success", msg);
        } else {
            redirectAttributes.addFlashAttribute("error", msg);
        }
        return "redirect:/contact";
    }

    private static boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
    }

    @MessageMapping("/chat.send")
    public void send(@Payload ChatMessage chatMessage) {
        in.sp.main.Entities.User sender = userRepo.findById(chatMessage.getSender().getId()).orElse(null);
        in.sp.main.Entities.User receiver = userRepo.findById(chatMessage.getReceiver().getId()).orElse(null);

        if (sender != null && receiver != null) {
            chatMessage.setSender(sender);
            chatMessage.setReceiver(receiver);
            chatMessage.setTimestamp(LocalDateTime.now());
            chatMessage.setReadStatus(false);

            chatService.save(chatMessage);

            java.util.Map<String, Object> payload = new java.util.HashMap<>();
            payload.put("id", chatMessage.getId());
            payload.put("message", chatMessage.getMessage());
            payload.put("videoUrl", chatMessage.getVideoUrl());
            payload.put("timestamp", chatMessage.getTimestamp().toString());

            java.util.Map<String, Object> senderMap = new java.util.HashMap<>();
            senderMap.put("id", sender.getId());
            senderMap.put("fullName", sender.getFullName());
            payload.put("sender", senderMap);

            java.util.Map<String, Object> receiverMap = new java.util.HashMap<>();
            receiverMap.put("id", receiver.getId());
            receiverMap.put("fullName", receiver.getFullName());
            payload.put("receiver", receiverMap);

            messagingTemplate.convertAndSend("/topic/messages/" + receiver.getId(), payload);
            messagingTemplate.convertAndSend("/topic/messages/" + sender.getId(), payload);
        }
    }
}

