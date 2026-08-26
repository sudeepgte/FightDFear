package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.ChatMessage;
import in.sp.main.Entities.User;
import in.sp.main.Entities.Videoupload;
import in.sp.main.Repository.ChatMessageRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.VideoUploadRepository;

@Service
public class ChatService {

    @Autowired
    private ChatMessageRepository chatRepo;
    
    @Autowired
    private UserRepository userRepo;
    
    @Autowired
    private VideoUploadRepository videoRepo;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    /**
     * Saves a user-to-user text message and pushes it to both participants over STOMP.
     * Returns the wire payload (UTF-8 safe for emoji).
     */
    @Transactional
    public Map<String, Object> deliverUserMessage(User sender, User receiver, String messageText) {
        if (sender == null || receiver == null || messageText == null) {
            return null;
        }
        String text = messageText.trim();
        if (text.isEmpty()) {
            return null;
        }

        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSender(sender);
        chatMessage.setReceiver(receiver);
        chatMessage.setMessage(text);
        chatMessage.setMessageType("TEXT");
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setReadStatus(false);
        chatMessage = chatRepo.save(chatMessage);

        Map<String, Object> payload = toWirePayload(chatMessage, sender, receiver);
        messagingTemplate.convertAndSend("/topic/messages/" + receiver.getId(), payload);
        messagingTemplate.convertAndSend("/topic/messages/" + sender.getId(), payload);
        return payload;
    }

    public Map<String, Object> toWirePayload(ChatMessage chatMessage, User sender, User receiver) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", chatMessage.getId());
        payload.put("message", chatMessage.getMessage());
        payload.put("videoUrl", chatMessage.getVideoUrl());
        payload.put("readStatus", chatMessage.isReadStatus());
        payload.put("timestamp", chatMessage.getTimestamp() == null
                ? LocalDateTime.now().toString()
                : chatMessage.getTimestamp().toString());

        Map<String, Object> senderMap = new HashMap<>();
        senderMap.put("id", sender.getId());
        senderMap.put("fullName", sender.getFullName());
        payload.put("sender", senderMap);

        Map<String, Object> receiverMap = new HashMap<>();
        receiverMap.put("id", receiver.getId());
        receiverMap.put("fullName", receiver.getFullName());
        payload.put("receiver", receiverMap);
        return payload;
    }

    public void sendMessage(User sender, User receiver, String message) {
        ChatMessage chat = new ChatMessage();
        chat.setSender(sender);
        chat.setReceiver(receiver);
        chat.setMessage(message);
        chatRepo.save(chat);
    }

    public List<ChatMessage> getChatHistory(User user1, User user2) {
        return chatRepo.findChatHistory(user1.getId(), user2.getId());
    }

    public List<ChatMessage> getMessagesSince(User user1, User user2, LocalDateTime since) {
        return chatRepo.findMessagesSince(user1.getId(), user2.getId(), since);
    }

    public ChatMessage save(ChatMessage message) {
        return chatRepo.save(message);
    }

    @Transactional
    public void markAsRead(Long senderId, Long receiverId) {
        chatRepo.markMessagesAsRead(senderId, receiverId);
    }

    public void sendReel(Long senderId, Long receiverId, Long videoId) {
        Videoupload video = videoRepo.findById(videoId).orElseThrow();

        User sender = userRepo.findById(senderId).orElseThrow();
        User receiver = userRepo.findById(receiverId).orElseThrow();

        ChatMessage msg = new ChatMessage();
        msg.setSender(sender);               // ✅ User object
        msg.setReceiver(receiver);           // ✅ User object
        msg.setMessage("");                // optional for video
        msg.setVideoUrl(video.getVideoPath()); // ✅ matches entity
        chatRepo.save(msg);


        chatRepo.save(msg);
    }

}