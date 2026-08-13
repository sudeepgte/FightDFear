package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Repository.WomenProductRepository;
import in.sp.main.Repository.WomenProductSellerRepository;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

@RestController
@RequestMapping("/api/women-products/seller")
public class MobileWomenProductsSellerAuthController {

    private static final Set<String> ORDER_STATUSES =
            Set.of("PLACED", "CONFIRMED", "SHIPPED", "DELIVERED", "CANCELLED");

    @Autowired
    private WomenProductSellerRepository sellerRepo;
    @Autowired
    private WomenProductRepository productRepo;
    @Autowired
    private WomenProductOrderRepository orderRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String fullName = trim(body == null ? null : body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String phone = trim(body == null ? null : body.get("phone"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        String confirmPassword = body == null ? "" : body.getOrDefault("confirmPassword", "");
        String businessName = trim(body == null ? null : body.get("businessName"));
        String description = trim(body == null ? null : body.get("description"));
        String address = trim(body == null ? null : body.get("address"));

        if (fullName.isBlank() || businessName.isBlank()) {
            return badRequest("fullName and businessName are required");
        }
        if (fullName.length() < WomenProductSeller.FULL_NAME_MIN_LENGTH
                || fullName.length() > WomenProductSeller.FULL_NAME_MAX_LENGTH
                || !fullName.matches(WomenProductSeller.FULL_NAME_PATTERN)) {
            return badRequest("Full Name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed; no numbers).");
        }
        if (businessName.length() < WomenProductSeller.BUSINESS_NAME_MIN_LENGTH
                || businessName.length() > WomenProductSeller.BUSINESS_NAME_MAX_LENGTH
                || !businessName.matches(WomenProductSeller.BUSINESS_NAME_PATTERN)) {
            return badRequest("Business Name must be 2–100 characters and may include letters, numbers, spaces, and & . , ' ( ) - only.");
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        if (!confirmPassword.isBlank()) {
            String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
            if (confirmErr != null) return badRequest(confirmErr);
        }
        if (address.isBlank()) return badRequest("address is required");
        if (sellerRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        // Older clients stuffed shop metadata into address; keep address short and move overflow.
        if (description.isBlank() && address.length() > 240) {
            int cut = address.indexOf('\n');
            if (cut > 0 && cut < 240) {
                description = address.substring(cut + 1).trim();
                address = address.substring(0, cut).trim();
            } else {
                description = address.substring(240).trim();
                address = address.substring(0, 240).trim();
            }
        }

        WomenProductSeller s = new WomenProductSeller();
        s.setFullName(fullName);
        s.setEmail(email);
        s.setPhone(phone.isBlank() ? null : phone);
        s.setPassword(passwordService.encode(password));
        s.setBusinessName(businessName);
        s.setDescription(limit(description, 4000));
        s.setAddress(limit(address, 4000));
        String logoPath = trim(body == null ? null : body.get("logoPath"));
        if (!logoPath.isBlank() && !"mobile-pending".equals(logoPath)) {
            s.setProfilePhotoPath(limit(logoPath, 480));
        }
        s.setIdentityDocPath("mobile-pending");
        s.setVerificationStatus(VerificationStatus.PENDING);
        s.setRating(0.0);
        try {
            sellerRepo.save(s);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(error("Could not save seller: " + ex.getMessage()));
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Await admin verification.");
        res.put("sellerId", s.getId());
        res.put("status", "PENDING");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    private static String limit(String value, int max) {
        if (value == null) return null;
        String t = value.trim();
        if (t.isEmpty()) return null;
        return t.length() <= max ? t : t.substring(0, max);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<WomenProductSeller> opt = sellerRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Seller not found"));
        }
        WomenProductSeller s = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, s.getPassword(), hashed -> {
            s.setPassword(hashed);
            sellerRepo.save(s);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (s.getVerificationStatus() == VerificationStatus.PENDING) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account is pending admin verification"));
        }
        if (s.getVerificationStatus() == VerificationStatus.REJECTED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account has been rejected by admin"));
        }

        session.setAttribute("loggedSeller", s);
        String token = jwtUtil.generateToken(s.getEmail(), "SELLER");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "SELLER");
        res.put("seller", sellerSummary(s));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        s = sellerRepo.findById(s.getId()).orElse(s);

        List<Map<String, Object>> products = productRepo.findBySellerAndDeletedFalseOrderByCreatedAtDesc(s)
                .stream().map(this::productDto).toList();
        List<WomenProductOrder> orders = orderRepo.findBySellerOrderByOrderTimeDesc(s);
        List<Map<String, Object>> orderDtos = orders.stream().map(this::orderDto).toList();

        double totalEarnings = orders.stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .mapToDouble(o -> o.getTotalPrice() != null ? o.getTotalPrice() : 0)
                .sum();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("seller", sellerSummary(s));
        data.put("products", products);
        data.put("orders", orderDtos);
        data.put("totalProducts", products.size());
        data.put("totalOrders", orders.size());
        data.put("totalEarnings", totalEarnings);
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/products")
    @Transactional
    public ResponseEntity<Map<String, Object>> addProduct(@RequestBody Map<String, Object> body, HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();

        String name = trim(Objects.toString(body.get("name"), ""));
        String brand = trim(Objects.toString(body.get("brand"), ""));
        String description = trim(Objects.toString(body.get("description"), ""));
        String category = trim(Objects.toString(body.get("category"), ""));
        double price = parseDouble(body.get("price"), -1);

        if (name.isBlank() || brand.isBlank() || category.isBlank()) {
            return badRequest("name, brand and category are required");
        }
        if (price <= 0) return badRequest("price must be positive");

        WomenProduct p = new WomenProduct();
        p.setName(name);
        p.setBrand(brand);
        p.setDescription(description.isBlank() ? null : description);
        p.setPrice(price);
        p.setOriginalPrice(parseDouble(body.get("originalPrice"), price));
        p.setStock(Math.max(parseInt(body.get("stock"), 0), 0));
        String normalizedCategory = in.sp.main.Entities.WomenProduct.normalizeCategory(category);
        if (normalizedCategory == null) {
            return badRequest("Invalid category. Use: SKINCARE, HAIRCARE, HYGIENE, CLOTHING, ACCESSORIES, WELLNESS, OTHER");
        }
        p.setCategory(normalizedCategory);
        p.setSku(trim(Objects.toString(body.get("sku"), "")));
        p.setWeightSize(trim(Objects.toString(body.get("weightSize"), "")));
        p.setOfferBadge(trim(Objects.toString(body.get("offerBadge"), "")));
        p.setActive(true);
        p.setFeatured(false);
        p.setTrackInventory(true);
        p.setDeleted(false);
        p.setSeller(s);
        productRepo.save(p);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "Product added");
        data.put("product", productDto(p));
        return ResponseEntity.status(HttpStatus.CREATED).body(ok(data));
    }

    @PostMapping("/orders/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateOrderStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();

        WomenProductOrder order = orderRepo.findById(id).orElse(null);
        if (order == null || order.getSeller() == null || !order.getSeller().getId().equals(s.getId())) {
            return badRequest("Order not found");
        }

        String status = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        if (!ORDER_STATUSES.contains(status)) {
            return badRequest("Invalid status. Use: PLACED, CONFIRMED, SHIPPED, DELIVERED, CANCELLED");
        }
        order.setStatus(status);
        orderRepo.save(order);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "Order status updated");
        data.put("order", orderDto(order));
        return ResponseEntity.ok(ok(data));
    }

    private WomenProductSeller requireSeller(HttpSession session) {
        Object s = session == null ? null : session.getAttribute("loggedSeller");
        return s instanceof WomenProductSeller ? (WomenProductSeller) s : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Seller login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        return ResponseEntity.badRequest().body(error(msg));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static double parseDouble(Object value, double fallback) {
        if (value == null) return fallback;
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static int parseInt(Object value, int fallback) {
        if (value == null) return fallback;
        try {
            return Integer.parseInt(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private Map<String, Object> sellerSummary(WomenProductSeller s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("fullName", s.getFullName());
        m.put("email", s.getEmail());
        m.put("phone", s.getPhone());
        m.put("businessName", s.getBusinessName());
        m.put("description", s.getDescription());
        m.put("address", s.getAddress());
        m.put("rating", s.getRating());
        m.put("verificationStatus", s.getVerificationStatus() == null ? null : s.getVerificationStatus().name());
        return m;
    }

    private Map<String, Object> productDto(WomenProduct p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("name", p.getName());
        m.put("brand", p.getBrand());
        m.put("description", p.getDescription());
        m.put("price", p.getPrice());
        m.put("originalPrice", p.getOriginalPrice());
        m.put("stock", p.getStock());
        m.put("category", p.getCategory());
        m.put("sku", p.getSku());
        m.put("active", p.getActive());
        m.put("imagePath", p.getImagePath());
        m.put("createdAt", p.getCreatedAt() == null ? null : p.getCreatedAt().toString());
        return m;
    }

    private Map<String, Object> orderDto(WomenProductOrder o) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", o.getId());
        m.put("quantity", o.getQuantity());
        m.put("totalPrice", o.getTotalPrice());
        m.put("paymentMethod", o.getPaymentMethod());
        m.put("status", o.getStatus());
        m.put("shippingAddress", o.getShippingAddress());
        m.put("orderTime", o.getOrderTime() == null ? null : o.getOrderTime().toString());
        if (o.getProduct() != null) {
            m.put("productId", o.getProduct().getId());
            m.put("productName", o.getProduct().getName());
        }
        if (o.getUser() != null) {
            m.put("buyerName", o.getUser().getFullName());
            m.put("buyerPhone", o.getUser().getPhoneNumber());
        }
        return m;
    }
}
