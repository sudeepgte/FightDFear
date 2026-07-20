package in.sp.main.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import jakarta.servlet.DispatcherType;
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
            "/login",
            "/login/**",
            "/auth/**",
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
            "/ws-chat/**",
            "/ws-sos/**",
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
            "/error"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/**")
            .authorizeHttpRequests(auth -> auth
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                .requestMatchers(PUBLIC_URLS).permitAll()
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
            .exceptionHandling(e -> e.authenticationEntryPoint(new org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint("/login")))
            .csrf(AbstractHttpConfigurer::disable);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
