package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

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

    private User requireUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    @GetMapping("/messages")
    public ResponseEntity<Map<String, Object>> messages(
            @RequestParam Long peerId,
            @RequestParam(required = false) String since,
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
        // Relaxed constraint: Allow if they are following or followed
        boolean allowed = followService.isFollowing(current.getId(), peerId) || 
                          followService.isFollowing(peerId, current.getId());
        if (!allowed) {
            // Still allow if there's already chat history (meaning they chatted before)
            List<ChatMessage> history = chatService.getChatHistory(current, peer);
            if (history.isEmpty()) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("success", false, "error", "Not allowed to chat with this user"));
            }
        }

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

        try {
            org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate = 
                org.springframework.web.context.support.WebApplicationContextUtils
                .getRequiredWebApplicationContext(session.getServletContext())
                .getBean(org.springframework.messaging.simp.SimpMessagingTemplate.class);
            messagingTemplate.convertAndSend("/topic/messages/" + peerId, messageDto(saved));
        } catch (Exception e) {
            // ignore if not configured
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", messageDto(saved));
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
