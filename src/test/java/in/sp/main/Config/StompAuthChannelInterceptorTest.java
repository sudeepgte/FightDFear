package in.sp.main.Config;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.MessageBuilder;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class StompAuthChannelInterceptorTest {

    private final StompAuthChannelInterceptor interceptor = new StompAuthChannelInterceptor();
    private final MessageChannel channel = Mockito.mock(MessageChannel.class);

    private Message<?> createStompMessage(StompCommand command, String destination, Map<String, Object> sessionAttrs) {
        StompHeaderAccessor accessor = StompHeaderAccessor.create(command);
        if (destination != null) {
            accessor.setDestination(destination);
        }
        if (sessionAttrs != null) {
            accessor.setSessionAttributes(sessionAttrs);
        }
        return MessageBuilder.createMessage(new byte[0], accessor.getMessageHeaders());
    }

    @Test
    void allowsSubscribeToOwnCallForUser() {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("authEmail", "user@test.com");
        attrs.put("authRole", "USER");
        attrs.put("authUserId", 8L);

        Message<?> msg = createStompMessage(StompCommand.SUBSCRIBE, "/topic/calls/8", attrs);
        assertNotNull(interceptor.preSend(msg, channel));
    }

    @Test
    void allowsSubscribeToOwnCallForDoctor() {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("authEmail", "doctor@test.com");
        attrs.put("authRole", "DOCTOR");
        attrs.put("authUserId", 8L);

        Message<?> msg = createStompMessage(StompCommand.SUBSCRIBE, "/topic/calls/8", attrs);
        assertNotNull(interceptor.preSend(msg, channel));
    }

    @Test
    void deniesSubscribeToOtherCall() {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("authEmail", "user@test.com");
        attrs.put("authRole", "USER");
        attrs.put("authUserId", 9L);

        Message<?> msg = createStompMessage(StompCommand.SUBSCRIBE, "/topic/calls/8", attrs);
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            interceptor.preSend(msg, channel);
        });
        assertTrue(exception.getMessage().contains("Subscribe denied"));
    }

    @Test
    void deniesUnauthenticatedSubscribe() {
        // Missing session attributes completely -> throws missing session
        Message<?> msg = createStompMessage(StompCommand.SUBSCRIBE, "/topic/calls/8", null);
        assertThrows(IllegalArgumentException.class, () -> {
            interceptor.preSend(msg, channel);
        });
    }

    @Test
    void deniesSessionWithoutEmailOrRole() {
        Map<String, Object> attrs = new HashMap<>();
        attrs.put("authUserId", 8L); // Missing email and role

        Message<?> msg = createStompMessage(StompCommand.SUBSCRIBE, "/topic/calls/8", attrs);
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            interceptor.preSend(msg, channel);
        });
        assertTrue(exception.getMessage().contains("Unauthenticated"));
    }
}
