package in.sp.main.Controller;

import in.sp.main.Entities.MarketplaceMessage;
import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.User;
import in.sp.main.Repository.MarketplaceMessageRepository;
import in.sp.main.Repository.ProviderBookingRepository;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class MarketplaceCommController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private MarketplaceMessageRepository messageRepo;

    @Autowired
    private ProviderBookingRepository bookingRepo;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ServiceProviderRepository providerRepository;

    @MessageMapping("/marketplace-chat/{bookingId}")
    public void handleMessage(@DestinationVariable Long bookingId,
                              @Payload Map<String, Object> message,
                              StompHeaderAccessor accessor) {
        if (accessor.getUser() == null) {
            return;
        }
        ProviderBooking booking = bookingRepo.findById(bookingId).orElse(null);
        if (booking == null) {
            return;
        }

        String email = accessor.getUser().getName();
        String senderRole = resolveSenderRole(email, booking);
        if (senderRole == null) {
            return; // not a participant
        }

        if ("CHAT".equals(message.get("type"))) {
            MarketplaceMessage msg = new MarketplaceMessage(
                    booking,
                    (String) message.get("content"),
                    senderRole
            );
            messageRepo.save(msg);
        }

        message.put("senderRole", senderRole);
        messagingTemplate.convertAndSend("/topic/marketplace-chat/" + bookingId, message);
    }

    @GetMapping("/marketplace/chat-history/{bookingId}")
    @ResponseBody
    public List<Map<String, Object>> getChatHistory(@PathVariable Long bookingId, HttpSession session) {
        ProviderBooking booking = bookingRepo.findById(bookingId).orElse(null);
        if (booking == null) {
            return Collections.emptyList();
        }
        if (!isSessionParticipant(session, booking)) {
            return Collections.emptyList();
        }
        List<MarketplaceMessage> messages = messageRepo.findByBookingOrderByTimestampAsc(booking);
        List<Map<String, Object>> result = new ArrayList<>();
        for (MarketplaceMessage msg : messages) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", msg.getId());
            row.put("content", msg.getContent());
            row.put("senderRole", msg.getSenderRole());
            row.put("timestamp", msg.getTimestamp() != null ? msg.getTimestamp().getTime() : null);
            result.add(row);
        }
        return result;
    }

    private String resolveSenderRole(String email, ProviderBooking booking) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null && booking.getUser() != null && booking.getUser().getId().equals(user.getId())) {
            return "USER";
        }
        ServiceProvider provider = providerRepository.findByEmail(email).orElse(null);
        if (provider != null && booking.getProvider() != null
                && booking.getProvider().getId().equals(provider.getId())) {
            return "PROVIDER";
        }
        return null;
    }

    private boolean isSessionParticipant(HttpSession session, ProviderBooking booking) {
        User user = (User) session.getAttribute("user");
        if (user != null && booking.getUser() != null && booking.getUser().getId().equals(user.getId())) {
            return true;
        }
        ServiceProvider provider = (ServiceProvider) session.getAttribute("loggedProvider");
        return provider != null && booking.getProvider() != null
                && booking.getProvider().getId().equals(provider.getId());
    }
}
