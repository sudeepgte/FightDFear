package in.sp.main.Controller;

import in.sp.main.Entities.MarketplaceMessage;
import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Repository.MarketplaceMessageRepository;
import in.sp.main.Repository.ProviderBookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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

    /**
     * Handles real-time communication for marketplace bookings.
     * topic: /topic/marketplace-chat/{bookingId}
     */
    @MessageMapping("/marketplace-chat/{bookingId}")
    public void handleMessage(@DestinationVariable Long bookingId, @Payload Map<String, Object> message) {
        String type = (String) message.get("type");
        
        // Save chat messages to database
        if ("CHAT".equals(type)) {
            ProviderBooking booking = bookingRepo.findById(bookingId).orElse(null);
            if (booking != null) {
                MarketplaceMessage msg = new MarketplaceMessage(
                    booking, 
                    (String) message.get("content"), 
                    (String) message.get("senderRole")
                );
                messageRepo.save(msg);
            }
        }
        
        // Broadcast the message to the topic
        messagingTemplate.convertAndSend("/topic/marketplace-chat/" + bookingId, message);
    }

    @GetMapping("/marketplace/chat-history/{bookingId}")
    @ResponseBody
    public List<MarketplaceMessage> getChatHistory(@PathVariable Long bookingId) {
        ProviderBooking booking = bookingRepo.findById(bookingId).orElse(null);
        if (booking != null) {
            return messageRepo.findByBookingOrderByTimestampAsc(booking);
        }
        return List.of();
    }
}
