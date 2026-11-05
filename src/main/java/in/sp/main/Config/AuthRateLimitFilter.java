package in.sp.main.Config;

import in.sp.main.Service.RateLimitService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Duration;

/**
 * IP-based throttle on authentication POSTs (login / register / OTP) so credential
 * stuffing cannot bypass per-account lockouts by rotating emails.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 20)
public class AuthRateLimitFilter extends OncePerRequestFilter {

    private static final int LIMIT = 60;
    private static final Duration WINDOW = Duration.ofMinutes(15);

    private final RateLimitService rateLimitService;

    public AuthRateLimitFilter(RateLimitService rateLimitService) {
        this.rateLimitService = rateLimitService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        if (isAuthPost(request) && !rateLimitService.tryAcquire(bucketKey(request), LIMIT, WINDOW)) {
            response.setStatus(429);
            response.setHeader("Retry-After", "900");
            String path = request.getRequestURI();
            boolean json = path != null && (path.startsWith("/api/")
                    || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                    || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json")));
            if (json) {
                response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                response.getWriter().write("{\"success\":false,\"error\":\"Too many requests. Please try again later.\"}");
            } else {
                response.setContentType(MediaType.TEXT_PLAIN_VALUE);
                response.getWriter().write("Too many requests. Please try again later.");
            }
            return;
        }
        filterChain.doFilter(request, response);
    }

    private static String bucketKey(HttpServletRequest request) {
        String ip = request.getRemoteAddr();
        return "auth-ip:" + (ip == null || ip.isBlank() ? "unknown" : ip);
    }

    private static boolean isAuthPost(HttpServletRequest request) {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return false;
        }
        String path = request.getRequestURI();
        if (path == null || path.isBlank()) {
            return false;
        }
        String lower = path.toLowerCase();
        if (lower.contains("/webhook")) {
            return false;
        }
        return lower.contains("/login")
                || lower.contains("/register")
                || lower.contains("/otp/")
                || lower.startsWith("/auth/")
                || lower.startsWith("/api/auth/");
    }
}
