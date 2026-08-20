package in.sp.main.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.access.intercept.RequestAuthorizationContext;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    /**
     * Paths that must stay public (session-based login is handled in controllers, not Spring Security).
     */
    private static final String[] PUBLIC_URLS = {
            "/",
            "/index.html",
            "/index",
            "/index/**",
            "/heatmap",
            "/map",
            "/features",
            "/features.jsp",
            "/danger-points",
            "/danger-points/**",
            "/login",
            "/login/**",
            "/auth/**",
            "/api/auth/**",
            "/api/glow/provider/register/**",
            "/api/glow/provider/login/**",
            "/api/glow/provider/salon/register-quick",
            "/api/glow/provider/salon/otp/send-email",
            "/api/glow/provider/salon/otp/verify-email",
            "/api/glow/provider/stylist/register-quick",
            "/api/glow/provider/stylist/otp/send-email",
            "/api/glow/provider/stylist/otp/verify-email",
            "/api/marketplace/provider/register/**",
            "/api/marketplace/provider/register-quick",
            "/api/marketplace/provider/otp/send-email",
            "/api/marketplace/provider/otp/verify-email",
            "/api/marketplace/provider/login/**",
            "/api/marketplace/jobs/register-quick",
            "/api/marketplace/jobs/otp/send-email",
            "/api/marketplace/jobs/otp/verify-email",
            "/api/marketplace/jobs/login",
            "/api/entrepreneur/register",
            "/api/entrepreneur/register/**",
            "/api/entrepreneur/register-quick",
            "/api/entrepreneur/otp/send-email",
            "/api/entrepreneur/otp/verify-email",
            "/api/entrepreneur/login",
            "/api/entrepreneur/login/**",
            "/api/investor/register",
            "/api/investor/register/**",
            "/api/investor/register-quick",
            "/api/investor/otp/send-email",
            "/api/investor/otp/verify-email",
            "/api/investor/login",
            "/api/investor/login/**",
            "/api/doctors/provider/register",
            "/api/doctors/provider/register/**",
            "/api/doctors/provider/register-quick",
            "/api/doctors/provider/otp/send-email",
            "/api/doctors/provider/otp/verify-email",
            "/api/doctors/provider/login",
            "/api/doctors/provider/login/**",
            "/api/fitness/trainer/register",
            "/api/fitness/trainer/register/**",
            "/api/fitness/trainer/register-quick",
            "/api/fitness/trainer/otp/send-email",
            "/api/fitness/trainer/otp/verify-email",
            "/api/fitness/trainer/login",
            "/api/fitness/trainer/login/**",
            "/api/women-events/host/register/**",
            "/api/women-events/host/register-quick",
            "/api/women-events/host/otp/send-email",
            "/api/women-events/host/otp/verify-email",
            "/api/women-events/host/login/**",
            "/api/women-products/seller/register/**",
            "/api/women-products/seller/register-quick",
            "/api/women-products/seller/otp/send-email",
            "/api/women-products/seller/otp/verify-email",
            "/api/women-products/seller/login/**",
            "/api/delivery/register-quick",
            "/api/delivery/otp/send-email",
            "/api/delivery/otp/verify-email",
            "/api/delivery/login",
            "/api/delivery/login/**",
            "/api/creator-hub/register-quick",
            "/api/creator-hub/otp/send-email",
            "/api/creator-hub/otp/verify-email",
            "/api/creator-hub/login",
            "/api/creator-hub/login/**",
            "/api/financial-literacy/educator/register-quick",
            "/api/financial-literacy/educator/otp/send-email",
            "/api/financial-literacy/educator/otp/verify-email",
            "/api/financial-literacy/educator/login",
            "/api/financial-literacy/educator/login/**",
            "/api/landing/**",
            "/api/admin/login",
            "/api/admin/login/**",
            "/api/martial-arts/centre/register",
            "/api/martial-arts/centre/register-lite",
            "/api/martial-arts/centre/register-quick",
            "/api/martial-arts/centre/otp/send-email",
            "/api/martial-arts/centre/otp/verify-email",
            "/api/martial-arts/centre/login",
            "/api/martial-arts/admin/login",
            "/users/register",
            "/users/register/**",
            "/admin/loginAdmin",
            "/admin/registerAdmin",
            "/centres/**",
            "/doctors/login",
            "/doctors/register",
            "/doctors/register/**",
            "/salons/login",
            "/salons/register",
            "/salons/register/**",
            "/stylists/login",
            "/stylists/register",
            "/stylists/register/**",
            "/stylist/login",
            "/stylist/register",
            "/stylist/register/**",
            "/marketplace/provider/login",
            "/marketplace/provider/register",
            "/marketplace/provider/register/**",
            "/women-products/**",
            "/contact",
            "/sendMessage",
            "/assets/**",
            "/css/**",
            "/js/**",
            "/images/**",
            "/uploads/**",
            "/siren.mp3",
            "/*.mp3",
            "/sos/respond",
            "/entrepreneur/login",
            "/entrepreneur/register",
            "/entrepreneur/register/**",
            "/investor/login",
            "/investor/register",
            "/investor/register/**",
            "/women-events",
            "/women-events/*",
            "/women-events/host/**",
            "/fitness",
            "/fitness/trainer/login",
            "/fitness/trainer/register",
            "/fitness/trainer/register/**",
            "/error",
            "/payment/webhook/razorpay",
            "/actuator/health",
            "/actuator/health/**",
            "/actuator/info"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/**")
            .authorizeHttpRequests(auth -> auth
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                .requestMatchers("/actuator/prometheus", "/actuator/prometheus/**")
                    .access((authentication, context) -> allowLocalhostOnly(context))
                .requestMatchers(PUBLIC_URLS).permitAll()
                .requestMatchers(request -> {
                    String path = request.getRequestURI();
                    if (path == null) return false;
                    return path.contains("/otp/") || path.endsWith("/register-quick");
                }).permitAll()
                .anyRequest().authenticated())
            // Add JWT filter
            .addFilterBefore(jwtAuthenticationFilter, org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class)
            // Session management is handled by JWT, but we don't strictly enforce stateless because our filter hydrates the session
            // for compatibility with legacy controllers.
            // Disable default login
            .formLogin(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .deleteCookies("JWT_TOKEN")
                .invalidateHttpSession(true)
                .permitAll()
            )
            .exceptionHandling(e -> e.authenticationEntryPoint((request, response, authException) -> {
                String path = request.getRequestURI();
                boolean wantsJson = path != null && (path.startsWith("/api/") || path.startsWith("/payment/"));
                if (wantsJson) {
                    response.setStatus(401);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":false,\"error\":\"Unauthorized\"}");
                } else if (path != null && path.startsWith("/admin/")) {
                    response.sendRedirect("/admin/loginAdmin");
                } else {
                    response.sendRedirect("/login");
                }
            }))
            .cors(c -> {})
            .csrf(AbstractHttpConfigurer::disable);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    private static AuthorizationDecision allowLocalhostOnly(RequestAuthorizationContext context) {
        HttpServletRequest request = context.getRequest();
        String remoteAddr = request.getRemoteAddr();
        boolean localhost = "127.0.0.1".equals(remoteAddr)
                || "::1".equals(remoteAddr)
                || "0:0:0:0:0:0:0:1".equals(remoteAddr);
        return new AuthorizationDecision(localhost);
    }
}
