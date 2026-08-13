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
import in.sp.main.Service.WomenProductSellerProfileService;
import in.sp.main.Service.WomenProductSellerRegistrationService;
import in.sp.main.Service.WomenProductsCareService;
import in.sp.main.Util.MobileValidation;
import in.sp.main.Util.ProductCategories;
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

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            sellerRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "OTP sent to your email");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            sellerRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
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
        String category = ProductCategories.normalize(trim(Objects.toString(body.get("category"), "")));
        double price = parseDouble(body.get("price"), -1);

        if (name.isBlank() || brand.isBlank() || category == null || category.isBlank()) {
            return badRequest("name, brand and category are required");
        }
        if (!ProductCategories.isKnown(category)) {
            return badRequest("Pick a product category from the catalog.");
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

        applyProductFields(p, name, brand, description, category, price, body);

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
        String name = trim(Objects.toString(body.get("name"), p.getName()));
        String brand = trim(Objects.toString(body.get("brand"), p.getBrand()));
        String description = body.get("description") == null
                ? p.getDescription()
                : trim(Objects.toString(body.get("description"), ""));
        String category = ProductCategories.normalize(trim(Objects.toString(
                body.get("category"), p.getCategory() == null ? "" : p.getCategory())));
        double price = parseDouble(body.get("price"), p.getPrice() == null ? -1 : p.getPrice());
        if (name.isBlank() || brand.isBlank() || category == null || category.isBlank()) {
            return badRequest("name, brand and category are required");
        }
        if (!ProductCategories.isKnown(category)) {
            return badRequest("Pick a product category from the catalog.");
        }
        if (price <= 0) return badRequest("price must be positive");
        applyProductFields(p, name, brand, description, category, price, body);
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

        String status = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        if ("SHIPPED".equals(status)) status = "READY_FOR_PICKUP";
        if (!ORDER_STATUSES.contains(status)) {
            return badRequest("Invalid status. Use CONFIRMED, READY_FOR_PICKUP, or CANCELLED.");
        }
        String current = normStatus(order.getStatus());
        boolean allowed = switch (current) {
            case "PLACED" -> "CONFIRMED".equals(status) || "CANCELLED".equals(status);
            case "CONFIRMED" -> "READY_FOR_PICKUP".equals(status) || "CANCELLED".equals(status);
            default -> false;
        };
        if (!allowed) {
            return badRequest("Sellers can confirm, mark packed for pickup, or cancel before a delivery partner is assigned.");
        }
        if ("CANCELLED".equals(status)) {
            restoreStock(order);
            order.setTrackingNote("Cancelled by seller");
        } else if ("CONFIRMED".equals(status)) {
            order.setTrackingNote("Seller confirmed the order");
        } else if ("READY_FOR_PICKUP".equals(status)) {
            order.setTrackingNote("Packed and ready for delivery pickup");
        }
        order.setStatus(status);
        orderRepo.save(order);
        if ("READY_FOR_PICKUP".equals(status)) {
            trackingService.ensureGeocoded(order);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "Order status updated");
        data.put("order", orderDto(order));
        return ResponseEntity.ok(ok(data));
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

    private void applyProductFields(
            WomenProduct p,
            String name,
            String brand,
            String description,
            String category,
            double price,
            Map<String, Object> body) {
        p.setName(name);
        p.setBrand(brand);
        p.setDescription(description == null || description.isBlank() ? null : description);
        p.setPrice(price);
        p.setOriginalPrice(parseDouble(body.get("originalPrice"), price));
        if (body.get("stock") != null) {
            p.setStock(Math.max(parseInt(body.get("stock"), 0), 0));
        } else if (p.getStock() == null) {
            p.setStock(0);
        }
        p.setCategory(category);
        if (body.get("sku") != null) p.setSku(trim(Objects.toString(body.get("sku"), "")));
        if (body.get("weightSize") != null) p.setWeightSize(trim(Objects.toString(body.get("weightSize"), "")));
        if (body.get("offerBadge") != null) p.setOfferBadge(trim(Objects.toString(body.get("offerBadge"), "")));
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
        if (status == null) return "PLACED";
        String s = status.trim().toUpperCase(Locale.ROOT);
        if ("SHIPPED".equals(s) || "PICKED_UP".equals(s)) return "OUT_FOR_DELIVERY";
        return s;
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
        m.put("status", normStatus(o.getStatus()));
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
