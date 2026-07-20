package in.sp.main.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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