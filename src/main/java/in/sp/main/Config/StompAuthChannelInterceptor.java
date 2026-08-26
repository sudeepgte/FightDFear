package in.sp.main.Config;

import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import java.security.Principal;
import java.util.List;
import java.util.Map;

/**
 * Requires authenticated STOMP CONNECT and restricts sensitive topic subscriptions.
 */
@Component
public class StompAuthChannelInterceptor implements ChannelInterceptor {

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
        if (accessor == null) {
            return message;
        }

        StompCommand command = accessor.getCommand();
        if (command == null) {
            return message;
        }

        Map<String, Object> attrs = accessor.getSessionAttributes();
        if (attrs == null) {
            throw new IllegalArgumentException("WebSocket session missing");
        }

        String email = (String) attrs.get("authEmail");
        String role = (String) attrs.get("authRole");
        Object userIdObj = attrs.get("authUserId");

        if (command == StompCommand.CONNECT) {
            if (email == null || role == null) {
                throw new IllegalArgumentException("Unauthenticated WebSocket CONNECT");
            }
            Principal principal = new UsernamePasswordAuthenticationToken(
                    email,
                    null,
                    List.of(new SimpleGrantedAuthority("ROLE_" + role))
            );
            accessor.setUser(principal);
            return message;
        }

        if (email == null || role == null) {
            throw new IllegalArgumentException("Unauthenticated STOMP frame");
        }

        if (command == StompCommand.SUBSCRIBE) {
            String destination = accessor.getDestination();
            if (destination != null && !isSubscribeAllowed(destination, role, userIdObj)) {
                throw new IllegalArgumentException("Subscribe denied: " + destination);
            }
        }

        if (command == StompCommand.SEND) {
            String destination = accessor.getDestination();
            // Application destinations are under /app — require auth only (handler does ownership)
            if (destination != null && destination.startsWith("/topic/")) {
                throw new IllegalArgumentException("Clients may not SEND directly to /topic");
            }
        }

        return message;
    }

    private boolean isSubscribeAllowed(String destination, String role, Object userIdObj) {
        if ("ADMIN".equals(role)) {
            return true;
        }

        Long userId = null;
        if (userIdObj instanceof Number n) {
            userId = n.longValue();
        }

        // Public-ish feed topics for logged-in users
        if (destination.startsWith("/topic/reels")
                || destination.startsWith("/topic/volunteer-alerts")) {
            return true;
        }

        Long followUserId = extractTrailingId(destination, "/topic/follow/");
        if (followUserId != null) {
            return userId != null && userId.equals(followUserId);
        }

        if (destination.startsWith("/topic/admin-sos")) {
            return "ADMIN".equals(role);
        }

        Long destUserId = extractTrailingId(destination, "/topic/messages/");
        if (destUserId != null) {
            return userId != null && userId.equals(destUserId) && "USER".equals(role);
        }

        destUserId = extractTrailingId(destination, "/topic/calls/");
        if (destUserId != null) {
            return userId != null && userId.equals(destUserId);
        }

        destUserId = extractTrailingId(destination, "/topic/sos-updates/user-");
        if (destUserId != null) {
            return userId != null && userId.equals(destUserId) && "USER".equals(role);
        }

        destUserId = extractTrailingId(destination, "/topic/userVideos/");
        if (destUserId != null) {
            return userId != null && userId.equals(destUserId);
        }

        Long doctorId = extractTrailingId(destination, "/topic/doctor-chat/");
        if (doctorId != null) {
            if ("DOCTOR".equals(role)) {
                return userId != null && userId.equals(doctorId);
            }
            return "USER".equals(role); // patient may listen to their doctor's chat topic
        }

        if (destination.startsWith("/topic/marketplace-chat/")) {
            return "USER".equals(role) || "PROVIDER".equals(role);
        }

        Long salonDestId = extractTrailingId(destination, "/topic/salon/chat/");
        if (salonDestId != null) {
            if ("SALON".equals(role)) {
                return userId != null && userId.equals(salonDestId);
            }
            return "USER".equals(role);
        }
        
        Long salonNotifId = extractTrailingId(destination, "/topic/salon/notifications/");
        if (salonNotifId != null) {
            return "SALON".equals(role) && userId != null && userId.equals(salonNotifId);
        }

        // Deny unknown sensitive topics by default
        return false;
    }

    private static Long extractTrailingId(String destination, String prefix) {
        if (!destination.startsWith(prefix)) {
            return null;
        }
        String tail = destination.substring(prefix.length());
        try {
            return Long.parseLong(tail);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
