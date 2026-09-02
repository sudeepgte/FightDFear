package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Repository.WomenProductRepository;
import in.sp.main.Repository.WomenProductSellerRepository;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.ProductDeliveryTrackingService;
import in.sp.main.Service.WomenProductOrderLifecycleService;
import in.sp.main.Service.WomenProductSellerProfileService;
import in.sp.main.Service.WomenProductSellerRegistrationService;
import in.sp.main.Service.WomenProductsCareService;
import in.sp.main.Util.MobileValidation;
import in.sp.main.Util.WomenProductValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Arrays;
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
            Set.of("PLACED", "CONFIRMED", "READY_FOR_PICKUP", "ASSIGNED",
                    "OUT_FOR_DELIVERY", "SHIPPED", "DELIVERED", "CANCELLED");

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
    @Autowired
    private WomenProductSellerRegistrationService sellerRegistrationService;
    @Autowired
    private WomenProductSellerProfileService sellerProfileService;
    @Autowired
    private FileUploadService fileUploadService;
    @Autowired
    private ProductDeliveryTrackingService trackingService;
    @Autowired
    private WomenProductsCareService productsCareService;
    @Autowired
    private WomenProductOrderLifecycleService orderLifecycle;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody(required = false) Map<String, Object> body) {
        try {
            sellerRegistrationService.sendRegistrationOtp(str(body, "email"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "OTP sent to your email");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        } catch (IllegalStateException ex) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(error(ex.getMessage()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody(required = false) Map<String, Object> body) {
        try {
            sellerRegistrationService.verifyRegistrationOtp(
                    str(body, "email"),
                    str(body, "otp").replaceAll("\\D", ""));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            WomenProductSeller s = sellerRegistrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted,
                    str(body, "businessName"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("sellerId", s.getId());
            res.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                    ? null : s.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", s.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    /**
     * Legacy full registration — kept for older clients.
     */
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
        s.setRating(0.0);
        sellerProfileService.setLifecycleStatus(s, PartnerProfileStatus.REGISTERED);
        try {
            sellerRepo.save(s);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(error("Could not save seller: " + ex.getMessage()));
        }
        sellerProfileService.setLifecycleStatus(s, PartnerProfileStatus.PROFILE_INCOMPLETE);
        sellerProfileService.refreshCompletion(s);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Complete your profile and await admin verification.");
        res.put("sellerId", s.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
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

        if (s.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your seller account has been suspended"));
        }

        PartnerProfileStatus status = s.getPartnerProfileStatus();
        if (status == null) {
            if (s.getVerificationStatus() == VerificationStatus.VERIFIED) {
                sellerProfileService.setLifecycleStatus(s, PartnerProfileStatus.APPROVED);
            } else if (s.getVerificationStatus() == VerificationStatus.REJECTED) {
                sellerProfileService.setLifecycleStatus(s, PartnerProfileStatus.REJECTED);
            } else {
                sellerProfileService.setLifecycleStatus(s, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            sellerProfileService.refreshCompletion(s);
        } else {
            sellerProfileService.refreshCompletion(s);
        }

        session.setAttribute("loggedSeller", s);
        String token = jwtUtil.generateToken(s.getEmail(), "SELLER");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "SELLER");
        res.put("seller", sellerSummary(s));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(s.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                sellerProfileService.isReadyForVerification(s)
                        && s.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        s = sellerRepo.findById(s.getId()).orElse(s);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(sellerProfileService.profilePayload(s));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        s = sellerRepo.findById(s.getId()).orElse(s);
        if (body != null) {
            if (body.get("fullName") != null) s.setFullName(String.valueOf(body.get("fullName")).trim());
            if (body.get("phone") != null) s.setPhone(String.valueOf(body.get("phone")).trim());
            if (body.get("businessName") != null) {
                String v = String.valueOf(body.get("businessName")).trim();
                s.setBusinessName(v.isBlank() ? null : v);
            }
            if (body.get("description") != null) {
                String v = String.valueOf(body.get("description")).trim();
                s.setDescription(v.isBlank() ? null : limit(v, 4000));
            }
            if (body.get("address") != null) {
                String v = String.valueOf(body.get("address")).trim();
                s.setAddress(v.isBlank() ? null : limit(v, 4000));
            }
            if (body.get("profilePhotoPath") != null) {
                String v = String.valueOf(body.get("profilePhotoPath")).trim();
                s.setProfilePhotoPath(v.isBlank() ? null : limit(v, 480));
            }
            if (body.get("identityDocPath") != null) {
                String v = String.valueOf(body.get("identityDocPath")).trim();
                s.setIdentityDocPath(v.isBlank() ? null : limit(v, 480));
            }
            sellerProfileService.applyExtraFields(s, body);
        }
        sellerProfileService.refreshCompletion(s);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(sellerProfileService.profilePayload(s));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        try {
            WomenProductSeller seller = sellerRepo.findById(s.getId()).orElse(s);
            sellerRegistrationService.submitForVerification(seller);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(sellerProfileService.profilePayload(seller));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
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
        data.put("pendingOrders", orders.stream().filter(o -> "PLACED".equals(WomenProductOrderLifecycleService.canonical(o.getStatus()))).count());
        data.put("deliveryPartners", orderLifecycle.listAssignablePartners().stream().map(p -> {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", p.getId());
            row.put("fullName", p.getFullName());
            row.put("phone", p.getPhone());
            return row;
        }).toList());
        data.put("payoutBalance", s.getPayoutBalance());
        data.put("upiId", s.getUpiId() == null ? "" : s.getUpiId());
        data.put("cancelPolicy", WomenProductsCareService.CANCEL_POLICY);
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        try {
            return ResponseEntity.ok(productsCareService.requestSellerPayout(sellerRepo.findById(s.getId()).orElse(s)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/photos")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        s = sellerRepo.findById(s.getId()).orElse(s);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                s.setProfilePhotoPath(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                List<String> existing = new ArrayList<>();
                if (s.getGalleryPhotos() != null && !s.getGalleryPhotos().isBlank()) {
                    existing.addAll(Arrays.asList(s.getGalleryPhotos().split(",")));
                }
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        existing.add(fileUploadService.saveFile(photo));
                    }
                }
                s.setGalleryPhotos(String.join(",", existing.stream().map(String::trim).filter(x -> !x.isEmpty()).toList()));
            }
            sellerRepo.save(s);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.put("profileImageUrl", s.getProfilePhotoPath());
            res.put("galleryPhotos", s.getGalleryPhotos());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(error("Upload failed: " + ex.getMessage()));
        }
    }

    @PostMapping("/orders/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getSeller() == null || !o.getSeller().getId().equals(s.getId())) {
            return badRequest("Order not found");
        }
        o.setCoachNotes(body == null ? "" : body.getOrDefault("coachNotes", ""));
        orderRepo.save(o);
        return ResponseEntity.ok(ok(Map.of("message", "Notes saved", "coachNotes", o.getCoachNotes())));
    }

    @PostMapping("/products")
    @Transactional
    public ResponseEntity<Map<String, Object>> addProduct(@RequestBody Map<String, Object> body, HttpSession session) {
        WomenProductSeller s = requireApprovedSeller(session);
        if (s == null) return unauthorized();
        if (s.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your shop must be approved before you can add products."));
        }

        String name = trim(Objects.toString(body.get("name"), ""));
        String brand = trim(Objects.toString(body.get("brand"), ""));
        String description = trim(Objects.toString(body.get("description"), ""));
        String fullDescription = body.get("fullDescription") == null ? null
                : trim(Objects.toString(body.get("fullDescription"), ""));
        String category = trim(Objects.toString(body.get("category"), ""));
        Double price = parseDoubleOrNull(body.get("price"));
        Double originalPrice = body.containsKey("originalPrice") ? parseDoubleOrNull(body.get("originalPrice")) : null;
        String offerBadge = body.get("offerBadge") == null ? null : trim(Objects.toString(body.get("offerBadge"), ""));
        Integer stock = body.get("stock") == null ? 0 : parseInt(body.get("stock"), Integer.MIN_VALUE);
        if (stock == Integer.MIN_VALUE) return badRequest("Stock quantity must be between 0 and " + WomenProduct.STOCK_MAX + ".");
        Integer lowStockAlertLevel = body.get("lowStockAlertLevel") == null ? 5
                : parseInt(body.get("lowStockAlertLevel"), Integer.MIN_VALUE);
        if (lowStockAlertLevel == Integer.MIN_VALUE) {
            return badRequest("Alert Level must be a non-negative number (0 or greater). Negative values are not allowed.");
        }
        String sku = body.get("sku") == null ? null : trim(Objects.toString(body.get("sku"), ""));
        String weightSize = body.get("weightSize") == null ? null : trim(Objects.toString(body.get("weightSize"), ""));
        String manufacturer = body.get("manufacturer") == null ? null : trim(Objects.toString(body.get("manufacturer"), ""));
        String ingredients = body.get("ingredients") == null ? null : trim(Objects.toString(body.get("ingredients"), ""));
        String benefits = body.get("benefits") == null ? null : trim(Objects.toString(body.get("benefits"), ""));
        String usageInstructions = body.get("usageInstructions") == null ? null
                : trim(Objects.toString(body.get("usageInstructions"), ""));
        String tags = body.get("tags") == null ? null : trim(Objects.toString(body.get("tags"), ""));

        // Images are uploaded via a separate endpoint after create — do not require on JSON create.
        String validationError = WomenProductValidation.validateProductInput(
                name, brand, description, fullDescription, price, originalPrice, offerBadge, stock,
                lowStockAlertLevel, sku, category, weightSize, manufacturer, ingredients, benefits,
                usageInstructions, tags, false, null);
        if (validationError != null) return badRequest(validationError);

        WomenProduct p = new WomenProduct();
        applyValidatedProductFields(p, name, brand, description, fullDescription, price, originalPrice,
                offerBadge, stock, lowStockAlertLevel, sku, category, weightSize, manufacturer,
                ingredients, benefits, usageInstructions, tags);
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

    @PutMapping("/products/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProduct(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        WomenProductSeller s = requireApprovedSeller(session);
        if (s == null) return unauthorized();
        if (s.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your shop must be approved before you can edit products."));
        }
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || p.getDeleted() || p.getSeller() == null || !p.getSeller().getId().equals(s.getId())) {
            return badRequest("Product not found");
        }
        String name = body.get("name") == null ? p.getName() : trim(Objects.toString(body.get("name"), ""));
        String brand = body.get("brand") == null ? p.getBrand() : trim(Objects.toString(body.get("brand"), ""));
        String description = body.get("description") == null
                ? (p.getDescription() == null ? "" : p.getDescription())
                : trim(Objects.toString(body.get("description"), ""));
        String fullDescription = body.get("fullDescription") == null
                ? p.getFullDescription()
                : trim(Objects.toString(body.get("fullDescription"), ""));
        String category = body.get("category") == null
                ? (p.getCategory() == null ? "" : p.getCategory())
                : trim(Objects.toString(body.get("category"), ""));
        Double price = body.get("price") == null ? p.getPrice() : parseDoubleOrNull(body.get("price"));
        Double originalPrice = body.containsKey("originalPrice")
                ? parseDoubleOrNull(body.get("originalPrice"))
                : p.getOriginalPrice();
        String offerBadge = body.get("offerBadge") == null ? p.getOfferBadge()
                : trim(Objects.toString(body.get("offerBadge"), ""));
        Integer stock = body.get("stock") == null ? (p.getStock() == null ? 0 : p.getStock())
                : parseInt(body.get("stock"), Integer.MIN_VALUE);
        if (stock != null && stock == Integer.MIN_VALUE) {
            return badRequest("Stock quantity must be between 0 and " + WomenProduct.STOCK_MAX + ".");
        }
        Integer lowStockAlertLevel = body.get("lowStockAlertLevel") == null
                ? (p.getLowStockAlertLevel() == null ? 5 : p.getLowStockAlertLevel())
                : parseInt(body.get("lowStockAlertLevel"), Integer.MIN_VALUE);
        if (lowStockAlertLevel != null && lowStockAlertLevel == Integer.MIN_VALUE) {
            return badRequest("Alert Level must be a non-negative number (0 or greater). Negative values are not allowed.");
        }
        String sku = body.get("sku") == null ? p.getSku() : trim(Objects.toString(body.get("sku"), ""));
        String weightSize = body.get("weightSize") == null ? p.getWeightSize()
                : trim(Objects.toString(body.get("weightSize"), ""));
        String manufacturer = body.get("manufacturer") == null ? p.getManufacturer()
                : trim(Objects.toString(body.get("manufacturer"), ""));
        String ingredients = body.get("ingredients") == null ? p.getIngredients()
                : trim(Objects.toString(body.get("ingredients"), ""));
        String benefits = body.get("benefits") == null ? p.getBenefits()
                : trim(Objects.toString(body.get("benefits"), ""));
        String usageInstructions = body.get("usageInstructions") == null ? p.getUsageInstructions()
                : trim(Objects.toString(body.get("usageInstructions"), ""));
        String tags = body.get("tags") == null ? p.getTags() : trim(Objects.toString(body.get("tags"), ""));

        String validationError = WomenProductValidation.validateProductInput(
                name, brand, description, fullDescription, price, originalPrice, offerBadge, stock,
                lowStockAlertLevel, sku, category, weightSize, manufacturer, ingredients, benefits,
                usageInstructions, tags, false, null);
        if (validationError != null) return badRequest(validationError);

        applyValidatedProductFields(p, name, brand, description, fullDescription, price, originalPrice,
                offerBadge, stock, lowStockAlertLevel, sku, category, weightSize, manufacturer,
                ingredients, benefits, usageInstructions, tags);
        if (body.get("active") != null) {
            p.setActive(Boolean.parseBoolean(String.valueOf(body.get("active"))));
        }
        productRepo.save(p);
        return ResponseEntity.ok(ok(Map.of("message", "Product updated", "product", productDto(p))));
    }

    @DeleteMapping("/products/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteProduct(@PathVariable Long id, HttpSession session) {
        WomenProductSeller s = requireApprovedSeller(session);
        if (s == null) return unauthorized();
        if (s.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your shop must be approved before you can remove products."));
        }
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || p.getSeller() == null || !p.getSeller().getId().equals(s.getId())) {
            return badRequest("Product not found");
        }
        p.setDeleted(true);
        p.setActive(false);
        productRepo.save(p);
        return ResponseEntity.ok(ok(Map.of("message", "Product removed")));
    }

    @PostMapping(value = "/products/{id}/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadProductImage(
            @PathVariable Long id,
            @RequestParam("image") MultipartFile image,
            HttpSession session) {
        WomenProductSeller s = requireApprovedSeller(session);
        if (s == null) return unauthorized();
        if (s.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your shop must be approved before you can upload images."));
        }
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || p.getDeleted() || p.getSeller() == null || !p.getSeller().getId().equals(s.getId())) {
            return badRequest("Product not found");
        }
        if (image == null || image.isEmpty()) return badRequest("Image is required");
        String imgErr = WomenProductValidation.validateProductImageFile(image);
        if (imgErr != null) return badRequest(imgErr);
        try {
            String path = fileUploadService.saveFile(image);
            p.setImagePath(path);
            productRepo.save(p);
            return ResponseEntity.ok(ok(Map.of("message", "Image uploaded", "product", productDto(p))));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(error("Could not upload image"));
        }
    }

    @PostMapping("/orders/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateOrderStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        WomenProductSeller s = requireApprovedSeller(session);
        if (s == null) return unauthorized();
        if (s.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your shop must be approved before you can manage orders."));
        }

        WomenProductOrder order = orderRepo.findById(id).orElse(null);
        if (order == null || order.getSeller() == null || !order.getSeller().getId().equals(s.getId())) {
            return badRequest("Order not found");
        }

        try {
            WomenProductOrder updated = orderLifecycle.applySellerStatus(order, s, trim(body == null ? null : body.get("status")));
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", "Order status updated");
            data.put("order", orderDto(updated));
            data.put("nextStatuses", WomenProductOrderLifecycleService.sellerNextStatuses(updated.getStatus()));
            return ResponseEntity.ok(ok(data));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/orders/{id}/assign")
    @Transactional
    public ResponseEntity<Map<String, Object>> assignOrder(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        WomenProductSeller s = requireApprovedSeller(session);
        if (s == null) return unauthorized();
        if (s.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your shop must be approved before you can manage orders."));
        }
        WomenProductOrder order = orderRepo.findById(id).orElse(null);
        Long partnerId = null;
        if (body != null && body.get("partnerId") != null) {
            try { partnerId = Long.parseLong(String.valueOf(body.get("partnerId"))); } catch (Exception ignored) {}
        }
        try {
            WomenProductOrder updated = orderLifecycle.assignDeliveryPartner(order, s, partnerId);
            return ResponseEntity.ok(ok(Map.of("message", "Delivery partner assigned", "order", orderDto(updated))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/orders/{id}/track")
    public ResponseEntity<Map<String, Object>> trackOrder(@PathVariable Long id, HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getSeller() == null || !o.getSeller().getId().equals(s.getId())) {
            return badRequest("Order not found");
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.putAll(trackingService.trackPayload(o));
        return ResponseEntity.ok(ok(data));
    }

    private WomenProductSeller requireSeller(HttpSession session) {
        Object s = session == null ? null : session.getAttribute("loggedSeller");
        return s instanceof WomenProductSeller ? (WomenProductSeller) s : null;
    }

    private WomenProductSeller requireApprovedSeller(HttpSession session) {
        WomenProductSeller s = requireSeller(session);
        if (s == null) return null;
        return sellerRepo.findById(s.getId()).orElse(s);
    }

    private void applyValidatedProductFields(
            WomenProduct p,
            String name,
            String brand,
            String description,
            String fullDescription,
            Double price,
            Double originalPrice,
            String offerBadge,
            Integer stock,
            Integer lowStockAlertLevel,
            String sku,
            String category,
            String weightSize,
            String manufacturer,
            String ingredients,
            String benefits,
            String usageInstructions,
            String tags) {
        p.setName(name.trim());
        p.setBrand(brand.trim());
        p.setDescription(description.trim());
        String fd = fullDescription == null ? null : fullDescription.trim();
        p.setFullDescription(fd == null || fd.isEmpty() ? null : fd);
        p.setPrice(price);
        p.setOriginalPrice(originalPrice != null ? originalPrice : price);
        String ob = offerBadge == null ? null : offerBadge.trim();
        p.setOfferBadge(ob == null || ob.isEmpty() ? null : ob);
        p.setStock(stock);
        p.setLowStockAlertLevel(lowStockAlertLevel != null ? lowStockAlertLevel : 5);
        String cleanedSku = sku == null ? null : sku.trim();
        p.setSku(cleanedSku == null || cleanedSku.isEmpty() ? null : cleanedSku);
        String normalizedCategory = WomenProduct.normalizeCategory(category);
        p.setCategory(normalizedCategory != null ? normalizedCategory : category.trim().toUpperCase());
        String ws = weightSize == null ? null : weightSize.trim();
        p.setWeightSize(ws == null || ws.isEmpty() ? null : ws);
        String mfr = manufacturer == null ? null : manufacturer.trim();
        p.setManufacturer(mfr == null || mfr.isEmpty() ? null : mfr);
        String ing = ingredients == null ? null : ingredients.trim();
        p.setIngredients(ing == null || ing.isEmpty() ? null : ing);
        String ben = benefits == null ? null : benefits.trim();
        p.setBenefits(ben == null || ben.isEmpty() ? null : ben);
        String usage = usageInstructions == null ? null : usageInstructions.trim();
        p.setUsageInstructions(usage == null || usage.isEmpty() ? null : usage);
        String tg = tags == null ? null : tags.trim();
        p.setTags(tg == null || tg.isEmpty() ? null : tg);
    }

    private void applyProductFields(
            WomenProduct p,
            String name,
            String brand,
            String description,
            String category,
            double price,
            Map<String, Object> body) {
        // Kept for any legacy call sites; prefer applyValidatedProductFields.
        applyValidatedProductFields(
                p, name, brand, description,
                body.get("fullDescription") == null ? null : trim(Objects.toString(body.get("fullDescription"), "")),
                price,
                body.containsKey("originalPrice") ? parseDoubleOrNull(body.get("originalPrice")) : null,
                body.get("offerBadge") == null ? null : trim(Objects.toString(body.get("offerBadge"), "")),
                body.get("stock") == null ? (p.getStock() == null ? 0 : p.getStock()) : Math.max(parseInt(body.get("stock"), 0), 0),
                body.get("lowStockAlertLevel") == null ? 5 : parseInt(body.get("lowStockAlertLevel"), 5),
                body.get("sku") == null ? null : trim(Objects.toString(body.get("sku"), "")),
                category,
                body.get("weightSize") == null ? null : trim(Objects.toString(body.get("weightSize"), "")),
                body.get("manufacturer") == null ? null : trim(Objects.toString(body.get("manufacturer"), "")),
                body.get("ingredients") == null ? null : trim(Objects.toString(body.get("ingredients"), "")),
                body.get("benefits") == null ? null : trim(Objects.toString(body.get("benefits"), "")),
                body.get("usageInstructions") == null ? null : trim(Objects.toString(body.get("usageInstructions"), "")),
                body.get("tags") == null ? null : trim(Objects.toString(body.get("tags"), "")));
    }

    private static Double parseDoubleOrNull(Object value) {
        if (value == null) return null;
        try {
            return Double.parseDouble(value.toString().trim());
        } catch (Exception e) {
            return null;
        }
    }

    private void restoreStock(WomenProductOrder order) {
        WomenProduct p = order.getProduct();
        if (p == null) return;
        int qty = order.getQuantity() == null ? 0 : order.getQuantity();
        int stock = p.getStock() == null ? 0 : p.getStock();
        p.setStock(stock + Math.max(qty, 0));
        productRepo.save(p);
    }

    private static String normStatus(String status) {
        return WomenProductOrderLifecycleService.canonical(status);
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

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
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
        m.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", WomenProductSellerProfileService.statusLabel(s.getPartnerProfileStatus()));
        m.put("profileCompletionPct", s.getProfileCompletionPct() == null ? 0 : s.getProfileCompletionPct());
        m.put("rejectionReason", s.getRejectionReason());
        m.put("changesRequestedNote", s.getChangesRequestedNote());
        m.put("missingItems", sellerProfileService.missingItems(s));
        m.put("canListProducts", s.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        m.put("canSubmitForVerification",
                sellerProfileService.isReadyForVerification(s)
                        && s.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        WomenProductSellerProfileService.putExtra(m, s);
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
        m.put("weightSize", p.getWeightSize());
        m.put("offerBadge", p.getOfferBadge());
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
        m.put("status", WomenProductOrderLifecycleService.canonical(o.getStatus()));
        m.put("statusLabel", WomenProductOrderLifecycleService.displayLabel(o.getStatus()));
        m.put("nextStatuses", WomenProductOrderLifecycleService.sellerNextStatuses(o.getStatus()));
        m.put("canAssign", WomenProductOrderLifecycleService.canAssign(o));
        m.put("shippingAddress", o.getShippingAddress());
        m.put("orderTime", o.getOrderTime() == null ? null : o.getOrderTime().toString());
        m.put("trackingNote", o.getTrackingNote());
        m.put("coachNotes", o.getCoachNotes());
        m.put("paymentStatus", o.getPaymentStatus());
        m.put("canLiveTrack", ProductDeliveryTrackingService.isLive(o.getStatus()));
        m.put("etaMinutes", o.getEtaMinutes());
        m.put("remainingKm", o.getRemainingKm());
        if (o.getProduct() != null) {
            m.put("productId", o.getProduct().getId());
            m.put("productName", o.getProduct().getName());
            m.put("productImage", o.getProduct().getImagePath());
        }
        if (o.getUser() != null) {
            m.put("buyerName", o.getUser().getFullName());
            m.put("buyerPhone", o.getUser().getPhoneNumber());
        }
        if (o.getDeliveryPartner() != null) {
            m.put("deliveryName", o.getDeliveryPartner().getFullName());
            m.put("deliveryPhone", o.getDeliveryPartner().getPhone());
        }
        return m;
    }
}
