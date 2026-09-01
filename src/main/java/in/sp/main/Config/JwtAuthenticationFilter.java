package in.sp.main.Config;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

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
    private MartialArtsCenterRepository centreRepository;
    
    @Autowired
    private SalonRepository salonRepository;
    
    @Autowired
    private StylistRepository stylistRepository;
    
    @Autowired
    private WomenProductSellerRepository sellerRepository;

    @Autowired
    private EventHostRepository eventHostRepository;

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private FitnessTrainerRepository fitnessTrainerRepository;

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    @Autowired
    private FinancialEducatorRepository financialEducatorRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String token = extractBearerToken(request);
        if (token == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("JWT_TOKEN".equals(cookie.getName())) {
                        token = cookie.getValue();
                        break;
                    }
                }
            }
        }

        if (token != null && jwtUtil.validateToken(token)) {
            String email = jwtUtil.extractUsername(token);
            String role = jwtUtil.extractRole(token);

            if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                // Create Spring Security Authentication
                UserDetails userDetails = User.withUsername(email).password("").roles(role).build();
                UsernamePasswordAuthenticationToken authToken = 
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);

                // Hydrate traditional HttpSession so legacy controllers keep working
                HttpSession session = request.getSession(true);
                hydrateSession(session, email, role);
            }
        }

        /* Web pages use HttpSession; REST chat APIs need SecurityContext too. */
        if (SecurityContextHolder.getContext().getAuthentication() == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object sessionUser = session.getAttribute("user");
                if (sessionUser instanceof in.sp.main.Entities.User appUser) {
                    String principal = appUser.getEmail();
                    if (principal == null || principal.isBlank()) {
                        principal = "user-" + appUser.getId() + "@session.fightdfear";
                    }
                    UserDetails userDetails = User.withUsername(principal).password("").roles("USER").build();
                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    Object sessionAdmin = session.getAttribute("admin");
                    if (sessionAdmin instanceof Admin adminUser) {
                        String principal = adminUser.getEmail();
                        if (principal == null || principal.isBlank()) {
                            principal = "admin-" + adminUser.getId() + "@session.fightdfear";
                        }
                        UserDetails userDetails = User.withUsername(principal).password("").roles("ADMIN").build();
                        UsernamePasswordAuthenticationToken authToken =
                                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                        authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authToken);
                    }
                }
            }
        }

        filterChain.doFilter(request, response);
    }

    /** Prefer Authorization: Bearer for native / Flutter clients; fall back to JWT_TOKEN cookie. */
    private String extractBearerToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.regionMatches(true, 0, "Bearer ", 0, 7)) {
            String value = header.substring(7).trim();
            return value.isEmpty() ? null : value;
        }
        return null;
    }

    private void hydrateSession(HttpSession session, String email, String role) {
        if ("USER".equals(role)) {
            if (session.getAttribute("user") == null) {
                userRepository.findByEmail(email).ifPresent(u -> session.setAttribute("user", u));
            }
        } else if ("ADMIN".equals(role)) {
            if (session.getAttribute("admin") == null) {
                adminRepository.findByEmailIgnoreCase(email)
                        .or(() -> adminRepository.findByEmail(email))
                        .ifPresent(a -> session.setAttribute("admin", a));
            }
        } else if ("DOCTOR".equals(role)) {
            if (session.getAttribute("loggedDoctor") == null) {
                doctorRepository.findByEmail(email).ifPresent(d -> session.setAttribute("loggedDoctor", d));
            }
        } else if ("PROVIDER".equals(role)) {
            if (session.getAttribute("loggedProvider") == null) {
                providerRepository.findByEmail(email).ifPresent(p -> session.setAttribute("loggedProvider", p));
            }
        } else if ("CENTRE".equals(role)) {
            if (session.getAttribute("loggedCentre") == null) {
                centreRepository.findByEmail(email).ifPresent(c -> session.setAttribute("loggedCentre", c));
            }
        } else if ("SALON".equals(role)) {
            if (session.getAttribute("loggedSalon") == null) {
                salonRepository.findByUsername(email).ifPresent(s -> session.setAttribute("loggedSalon", s));
                if (session.getAttribute("loggedSalon") == null) {
                    Salon byEmail = salonRepository.findByEmail(email);
                    if (byEmail != null) session.setAttribute("loggedSalon", byEmail);
                }
            }
        } else if ("STYLIST".equals(role)) {
            if (session.getAttribute("loggedStylist") == null) {
                stylistRepository.findByEmail(email).ifPresent(s -> session.setAttribute("loggedStylist", s));
            }
        } else if ("SELLER".equals(role)) {
            if (session.getAttribute("loggedSeller") == null) {
                sellerRepository.findByEmail(email).ifPresent(s -> session.setAttribute("loggedSeller", s));
            }
        } else if ("HOST".equals(role)) {
            if (session.getAttribute("loggedHost") == null) {
                eventHostRepository.findByEmail(email).ifPresent(h -> session.setAttribute("loggedHost", h));
            }
        } else if ("ENTREPRENEUR".equals(role)) {
            if (session.getAttribute("loggedEntrepreneur") == null) {
                entrepreneurRepository.findByEmail(email).ifPresent(e -> session.setAttribute("loggedEntrepreneur", e));
            }
        } else if ("INVESTOR".equals(role)) {
            if (session.getAttribute("loggedInvestor") == null) {
                investorRepository.findByEmail(email).ifPresent(i -> session.setAttribute("loggedInvestor", i));
            }
        } else if ("TRAINER".equals(role)) {
            if (session.getAttribute("loggedTrainer") == null) {
                fitnessTrainerRepository.findByEmail(email).ifPresent(t -> session.setAttribute("loggedTrainer", t));
            }
        } else if ("DELIVERY".equals(role)) {
            if (session.getAttribute("loggedDelivery") == null) {
                deliveryPartnerRepository.findByEmail(email).ifPresent(d -> session.setAttribute("loggedDelivery", d));
            }
        } else if ("EDUCATOR".equals(role)) {
            if (session.getAttribute("loggedEducator") == null) {
                financialEducatorRepository.findByEmail(email).ifPresent(ed -> session.setAttribute("loggedEducator", ed));
            }
        }
    }
}
