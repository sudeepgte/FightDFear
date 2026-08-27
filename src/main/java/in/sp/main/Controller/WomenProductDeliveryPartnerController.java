package in.sp.main.Controller;

import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.DeliveryPartnerRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.WomenProductOrderLifecycleService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/women-products/delivery")
public class WomenProductDeliveryPartnerController {

    @Autowired
    private DeliveryPartnerRepository deliveryRepo;
    @Autowired
    private WomenProductOrderRepository orderRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private WomenProductOrderLifecycleService orderLifecycle;

    @GetMapping("/register")
    public String registerPage() {
        return "women-products/delivery-register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String fullName,
                           @RequestParam String email,
                           @RequestParam String phone,
                           @RequestParam String password,
                           @RequestParam(required = false) String address,
                           @RequestParam(required = false) String city,
                           Model model,
                           RedirectAttributes ra) {
        String cleanedEmail = email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
        String cleanedName = fullName == null ? "" : fullName.trim();
        String cleanedPhone = phone == null ? "" : phone.trim();
        if (cleanedName.length() < WomenProductSeller.FULL_NAME_MIN_LENGTH
                || cleanedName.length() > WomenProductSeller.FULL_NAME_MAX_LENGTH
                || !cleanedName.matches(WomenProductSeller.FULL_NAME_PATTERN)) {
            model.addAttribute("error",
                    "Full Name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed; no numbers).");
            return "women-products/delivery-register";
        }
        String emailErr = in.sp.main.Util.MobileValidation.requireEmail(cleanedEmail);
        if (emailErr != null) {
            model.addAttribute("error", emailErr.endsWith(".") ? emailErr : emailErr + ".");
            return "women-products/delivery-register";
        }
        if (!cleanedPhone.matches("^[6-9]\\d{9}$")) {
            model.addAttribute("error", "Enter a valid 10-digit Indian mobile number.");
            return "women-products/delivery-register";
        }
        String passErr = in.sp.main.Util.MobileValidation.requirePassword(password);
        if (passErr != null) {
            model.addAttribute("error", passErr.endsWith(".") ? passErr : passErr + ".");
            return "women-products/delivery-register";
        }
        if (deliveryRepo.findByEmail(cleanedEmail).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "women-products/delivery-register";
        }
        DeliveryPartner p = new DeliveryPartner();
        p.setFullName(cleanedName);
        p.setEmail(cleanedEmail);
        p.setPhone(cleanedPhone);
        p.setPassword(passwordService.encode(password));
        p.setAddress(address == null ? null : address.trim());
        p.setCity(city == null ? null : city.trim());
        p.setSuspended(false);
        p.setVerificationStatus(VerificationStatus.PENDING);
        p.setPartnerProfileStatus(PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        p.setRating(0.0);
        deliveryRepo.save(p);
        ra.addFlashAttribute("success",
                "Registration submitted. An admin will verify your account before you can take deliveries.");
        return "redirect:/women-products/delivery/register";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "women-products/delivery-login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        HttpServletResponse response,
                        Model model) {
        String cleanedEmail = email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
        Optional<DeliveryPartner> opt = deliveryRepo.findByEmail(cleanedEmail);
        if (opt.isEmpty()) {
            model.addAttribute("error", "Delivery partner not found.");
            return "women-products/delivery-login";
        }
        DeliveryPartner p = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            deliveryRepo.save(p);
        });
        if (!ok) {
            model.addAttribute("error", "Invalid password.");
            return "women-products/delivery-login";
        }
        if (p.isSuspended() || p.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            model.addAttribute("error", "Your delivery account has been suspended.");
            return "women-products/delivery-login";
        }
        session.setAttribute("loggedDelivery", p);
        String token = jwtUtil.generateToken(p.getEmail(), "DELIVERY");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60);
        response.addCookie(cookie);
        return "redirect:/women-products/delivery/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return "redirect:/women-products/delivery/login";
        p = deliveryRepo.findById(p.getId()).orElse(p);

        List<WomenProductOrder> mine = orderRepo.findByDeliveryPartnerOrderByOrderTimeDesc(p);
        List<WomenProductOrder> pickup = mine.stream()
                .filter(o -> "ASSIGNED".equals(WomenProductOrderLifecycleService.canonical(o.getStatus())))
                .collect(Collectors.toList());
        List<WomenProductOrder> active = mine.stream()
                .filter(o -> {
                    String st = WomenProductOrderLifecycleService.canonical(o.getStatus());
                    return "PICKED_UP".equals(st) || "IN_TRANSIT".equals(st)
                            || "SHIPPED".equals(st) || "OUT_FOR_DELIVERY".equals(st);
                })
                .collect(Collectors.toList());
        List<WomenProductOrder> delivered = mine.stream()
                .filter(o -> "DELIVERED".equals(WomenProductOrderLifecycleService.canonical(o.getStatus())))
                .collect(Collectors.toList());

        java.util.Map<Long, java.util.List<String>> nextStatuses = new java.util.HashMap<>();
        for (WomenProductOrder o : mine) {
            nextStatuses.put(o.getId(),
                    WomenProductOrderLifecycleService.deliveryNextStatuses(o.getStatus()));
        }

        model.addAttribute("partner", p);
        model.addAttribute("assigned", mine);
        model.addAttribute("pickupOrders", pickup);
        model.addAttribute("activeDeliveries", active);
        model.addAttribute("deliveredOrders", delivered);
        model.addAttribute("nextStatuses", nextStatuses);
        model.addAttribute("approved", WomenProductOrderLifecycleService.isEligibleDeliveryPartner(p));
        return "women-products/delivery-dashboard";
    }

    @PostMapping("/orders/{id}/status")
    public String updateStatus(@PathVariable Long id,
                               @RequestParam String status,
                               HttpSession session,
                               RedirectAttributes ra) {
        DeliveryPartner p = requirePartner(session);
        if (p == null) return "redirect:/women-products/delivery/login";
        p = deliveryRepo.findById(p.getId()).orElse(p);
        if (!WomenProductOrderLifecycleService.isEligibleDeliveryPartner(p)) {
            ra.addFlashAttribute("error", "Your profile must be approved before you can update deliveries.");
            return "redirect:/women-products/delivery/dashboard";
        }
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        try {
            orderLifecycle.applyDeliveryStatus(o, p, status);
            ra.addFlashAttribute("message", "Delivery status updated.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Could not update status.");
        }
        return "redirect:/women-products/delivery/dashboard";
    }

    private DeliveryPartner requirePartner(HttpSession session) {
        Object s = session == null ? null : session.getAttribute("loggedDelivery");
        return s instanceof DeliveryPartner ? (DeliveryPartner) s : null;
    }
}
