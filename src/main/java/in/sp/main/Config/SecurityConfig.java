package in.sp.main.Config;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.intercept.RequestAuthorizationContext;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.security.web.csrf.CsrfTokenRequestAttributeHandler;
import org.springframework.security.web.csrf.CsrfTokenRequestHandler;
import org.springframework.security.web.csrf.XorCsrfTokenRequestAttributeHandler;
import org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Base64;
import java.util.function.Supplier;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

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
            "/women-jobs/**",
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
            "/centres/**",
            "/doctors/login",
            "/doctors/logout",
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
            "/lawyer/login",
            "/lawyer/register",
            "/lawyer/register/**",
            "/lawyer/otp/**",
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
            "/host/login",
            "/host/login/**",
            "/host/register",
            "/host/register/**",
            "/fitness",
            "/fitness/**",
            "/fitness/trainer/login",
            "/fitness/trainer/register",
            "/fitness/trainer/register/**",

            "/trainer/**",
            "/trainer/login",
            "/trainer/register",
            "/error",

            "/payment/webhook/razorpay",
            "/actuator/health",
            "/actuator/health/**",
            "/actuator/info"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // Stateless Bearer token requests (Mobile clients) are exempted from CSRF checks
        RequestMatcher bearerAuthMatcher = request -> {
            String header = request.getHeader("Authorization");
            return header != null && header.regionMatches(true, 0, "Bearer ", 0, 7);
        };

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
            .addFilterAfter(new CsrfCookieFilter(), CsrfFilter.class)
            // Session Management & Fixation Protection
            .sessionManagement(session -> session
                .sessionFixation(sf -> sf.migrateSession())
            )
            // Disable default login forms
            .formLogin(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .deleteCookies("JWT_TOKEN", "JSESSIONID")
                .invalidateHttpSession(true)
                .permitAll()
            )
            .exceptionHandling(e -> e
                .authenticationEntryPoint((request, response, authException) -> {
                    String path = request.getRequestURI();
                    log.warn("[SECURITY-AUDIT] event=AUTH_REQUIRED uri={} ip={}",
                            in.sp.main.Util.LogSanitizer.sanitize(path), request.getRemoteAddr());
                    boolean wantsJson = path != null && (path.startsWith("/api/")
                            || path.startsWith("/payment/")
                            || path.startsWith("/chat/send-message")
                            || path.startsWith("/chat/messages-since"));
                    if (wantsJson) {
                        response.setStatus(401);
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\":false,\"error\":\"Unauthorized\"}");
                    } else if (path != null && path.startsWith("/admin/")) {
                        response.sendRedirect("/admin/loginAdmin");
                    } else if (path != null && (
                            path.startsWith("/doctors/dashboard")
                            || path.startsWith("/doctors/profile-completion")
                            || path.equals("/doctors/logout"))) {
                        response.sendRedirect("/doctors/login");
                    } else {
                        response.sendRedirect("/login");
                    }
                })
                .accessDeniedHandler((request, response, accessDeniedException) -> {
                    String path = request.getRequestURI();
                    log.warn("[SECURITY-AUDIT] event=ACCESS_DENIED uri={} ip={}",
                            in.sp.main.Util.LogSanitizer.sanitize(path), request.getRemoteAddr());
                    boolean wantsJson = (path != null && (path.startsWith("/api/")
                            || path.startsWith("/payment/")
                            || path.startsWith("/chat/")))
                            || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                            || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"))
                            || (request.getContentType() != null && request.getContentType().contains("application/json"));
                    if (wantsJson) {
                        response.setStatus(403);
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\":false,\"error\":\"Access denied\"}");
                    } else {
                        response.sendError(403, "Access denied");
                    }
                })
            )
            .cors(Customizer.withDefaults())
            .csrf(csrf -> csrf
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                .csrfTokenRequestHandler(new SpaCsrfTokenRequestHandler())
                .ignoringRequestMatchers(
                    bearerAuthMatcher,
                    request -> {
                        String path = request.getRequestURI();
                        if (path == null) return false;
                        return path.equals("/payment/webhook/razorpay")
                                || path.startsWith("/actuator/")
                                || path.contains("/otp/")
                                || path.endsWith("/register-quick")
                                || path.equals("/login")
                                || path.startsWith("/auth/")
                                || path.startsWith("/api/auth/")
                                || path.endsWith("/login")
                                || path.endsWith("/loginAdmin")
                                || path.endsWith("/register");
                    }
                )
            )
            .headers(headers -> {
                headers.contentTypeOptions(Customizer.withDefaults());
                headers.frameOptions(frame -> frame.sameOrigin());
                headers.referrerPolicy(referrer -> referrer.policy(ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN));
                headers.permissionsPolicy(permissions -> permissions.policy(
                    "camera=(self), microphone=(self), geolocation=(self), payment=*"
                ));
                headers.contentSecurityPolicy(csp -> csp.policyDirectives(
                    "default-src 'self'; " +
                    "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://checkout.razorpay.com https://*.razorpay.com https://maps.googleapis.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
                    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
                    "img-src 'self' data: blob: https:; " +
                    "font-src 'self' data: https://fonts.gstatic.com https://cdnjs.cloudflare.com https://cdn.jsdelivr.net; " +
                    "connect-src 'self' https://api.razorpay.com https://*.razorpay.com https://lumberjack.razorpay.com https://maps.googleapis.com wss: ws:; " +
                    "frame-src 'self' https://api.razorpay.com https://checkout.razorpay.com https://*.razorpay.com; " +
                    "object-src 'none'; " +
                    "base-uri 'self';"
                ));
            });
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

    /**
     * SPA and JSP CSRF Token Request Handler supporting raw header tokens and masked tokens.
     */
    static final class SpaCsrfTokenRequestHandler implements CsrfTokenRequestHandler {
        private final CsrfTokenRequestHandler delegate = new XorCsrfTokenRequestAttributeHandler();

        @Override
        public void handle(HttpServletRequest request, HttpServletResponse response, Supplier<CsrfToken> csrfToken) {
            this.delegate.handle(request, response, csrfToken);
        }

        @Override
        public String resolveCsrfTokenValue(HttpServletRequest request, CsrfToken csrfToken) {
            if (csrfToken == null) {
                return null;
            }
            String rawToken = csrfToken.getToken();

            // 1. Check headers: configured headerName, X-XSRF-TOKEN, X-CSRF-TOKEN
            String header = request.getHeader(csrfToken.getHeaderName());
            if (header == null || header.isBlank()) {
                header = request.getHeader("X-XSRF-TOKEN");
            }
            if (header == null || header.isBlank()) {
                header = request.getHeader("X-CSRF-TOKEN");
            }

            if (header != null && !header.isBlank()) {
                // If header matches the raw unmasked token, return it directly
                if (rawToken != null && header.equals(rawToken)) {
                    return rawToken;
                }
                // Try delegate resolution (handles XOR tokens if headerName matches)
                String resolved = this.delegate.resolveCsrfTokenValue(request, csrfToken);
                String unmasked = unmaskXorToken(header, rawToken);
                if (rawToken != null && rawToken.equals(resolved)) {
                    return resolved;
                }
                // Unmask XOR token directly in case header was sent under an alternate header name
                if (unmasked != null && rawToken != null && rawToken.equals(unmasked)) {
                    return unmasked;
                }
                return header;
            }

            // 2. Check request parameter
            String param = request.getParameter(csrfToken.getParameterName());
            if (param == null || param.isBlank()) {
                param = request.getParameter("_csrf");
            }
            if (param != null && !param.isBlank()) {
                if (rawToken != null && param.equals(rawToken)) {
                    return rawToken;
                }
                String resolved = this.delegate.resolveCsrfTokenValue(request, csrfToken);
                if (rawToken != null && rawToken.equals(resolved)) {
                    return resolved;
                }
                String unmasked = unmaskXorToken(param, rawToken);
                if (unmasked != null && rawToken != null && rawToken.equals(unmasked)) {
                    return unmasked;
                }
                return param;
            }

            return this.delegate.resolveCsrfTokenValue(request, csrfToken);
        }

        private static String unmaskXorToken(String candidate, String rawToken) {
            if (candidate == null || rawToken == null || candidate.isBlank()) {
                return null;
            }
            try {
                byte[] actualBytes;
                try {
                    actualBytes = Base64.getUrlDecoder().decode(candidate);
                } catch (IllegalArgumentException e) {
                    actualBytes = Base64.getDecoder().decode(candidate);
                }
                byte[] tokenBytes = rawToken.getBytes(StandardCharsets.UTF_8);
                int length = tokenBytes.length;
                if (actualBytes.length != length * 2) {
                    return null;
                }
                byte[] randomBytes = Arrays.copyOfRange(actualBytes, 0, length);
                byte[] xoredBytes = Arrays.copyOfRange(actualBytes, length, actualBytes.length);
                byte[] csrfBytes = new byte[length];
                for (int i = 0; i < length; i++) {
                    csrfBytes[i] = (byte) (randomBytes[i] ^ xoredBytes[i]);
                }
                return new String(csrfBytes, StandardCharsets.UTF_8);
            } catch (Exception ignored) {
                return null;
            }
        }
    }

    /**
     * Filter that ensures the XSRF-TOKEN cookie is rendered on responses.
     */
    static final class CsrfCookieFilter extends OncePerRequestFilter {
        @Override
        protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
                throws ServletException, IOException {
            CsrfToken csrfToken = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
            if (csrfToken == null) {
                csrfToken = (CsrfToken) request.getAttribute("_csrf");
            }
            if (csrfToken != null) {
                // Invoking getToken() triggers deferred rendering into cookie
                csrfToken.getToken();
            }
            filterChain.doFilter(request, response);
        }
    }
}
