package in.sp.main.Config;

import in.sp.main.Repository.AdminRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

/**
 * Copies JWT identity into the WebSocket session so STOMP handlers can trust the connection.
 */
@Component
public class JwtHandshakeInterceptor implements HandshakeInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private ServiceProviderRepository providerRepository;

    @Autowired
    private in.sp.main.Repository.SalonRepository salonRepository;

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) {
        if (!(request instanceof ServletServerHttpRequest servletRequest)) {
            return false;
        }
        HttpServletRequest httpRequest = servletRequest.getServletRequest();
        String token = readJwtCookie(httpRequest);
        if (token != null && jwtUtil.validateToken(token)) {
            return authenticateFromJwt(token, attributes);
        }

        /* Session fallback for web users logged in without JWT cookie */
        jakarta.servlet.http.HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof in.sp.main.Entities.User user) {
                String email = user.getEmail();
                if (email == null || email.isBlank()) {
                    email = "user-" + user.getId() + "@session.fightdfear";
                }
                attributes.put("authEmail", email);
                attributes.put("authRole", "USER");
                attributes.put("authUserId", user.getId());
                return true;
            }
        }
        return false;
    }

    private boolean authenticateFromJwt(String token, Map<String, Object> attributes) {
        String email = jwtUtil.extractUsername(token);
        String role = jwtUtil.extractRole(token);
        if (email == null || role == null) {
            return false;
        }

        attributes.put("authEmail", email);
        attributes.put("authRole", role);

        switch (role) {
            case "USER" -> userRepository.findByEmail(email)
                    .ifPresent(u -> attributes.put("authUserId", u.getId()));
            case "ADMIN" -> adminRepository.findByEmail(email)
                    .ifPresent(a -> attributes.put("authUserId", (long) a.getId()));
            case "DOCTOR" -> doctorRepository.findByEmail(email)
                    .ifPresent(d -> attributes.put("authUserId", d.getId()));
            case "PROVIDER" -> providerRepository.findByEmail(email)
                    .ifPresent(p -> attributes.put("authUserId", p.getId()));
            case "SALON" -> {
                in.sp.main.Entities.Salon s = salonRepository.findByUsername(email).orElse(null);
                if (s == null) s = salonRepository.findByEmail(email);
                if (s != null) attributes.put("authUserId", s.getId());
            }
            default -> {
                // Other roles still authenticate by email/role for topic ACLs
            }
        }
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception exception) {
        // no-op
    }

    private static String readJwtCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
        for (Cookie cookie : cookies) {
            if ("JWT_TOKEN".equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
