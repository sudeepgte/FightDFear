package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Util.ProductCategories;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/women-products")
public class WomenProductController {

    @Autowired private WomenProductSellerRepository sellerRepo;
    @Autowired private WomenProductRepository productRepo;
    @Autowired private WomenProductOrderRepository orderRepo;
    @Autowired private WomenCartItemRepository cartRepo;
    @Autowired private WomenWishlistItemRepository wishlistRepo;
    @Autowired
    private FileUploadService fileUploadService;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;
    @Autowired private WomenReturnRequestRepository returnRepo;

    @Autowired
    private in.sp.main.Service.PasswordService passwordService;

    @Autowired
    private in.sp.main.Service.WomenProductDeliveryService deliveryService;

    @Autowired
    private in.sp.main.Service.WomenProductsCareService productsCareService;

    @Autowired
    private in.sp.main.Service.WomenProductOrderLifecycleService orderLifecycle;

    @Autowired
    private in.sp.main.Service.DoctorPaymentService doctorPaymentService;

    private static final String BUY_NOW_PRODUCT_ID = "wpBuyNowProductId";
    private static final String BUY_NOW_QTY = "wpBuyNowQty";
    private static final String JUST_PLACED_ORDER_IDS = "wpJustPlacedOrderIds";

    // ══════════════════════════════════════
    // SELLER: Register + Login
    // ══════════════════════════════════════
    @GetMapping("/seller/register")
    public String sellerRegisterPage() {
        return "women-products/seller-register";
    }

    @PostMapping("/seller/register")
    public String sellerRegister(@RequestParam String fullName,
                                 @RequestParam String email,
                                 @RequestParam String phone,
                                 @RequestParam String password,
                                 @RequestParam(required = false) String confirmPassword,
                                 @RequestParam String businessName,
                                 @RequestParam(required = false) String description,
                                 @RequestParam String address,
                                 @RequestParam(required = false) String city,
                                 @RequestParam(required = false) Boolean acceptedTerms,
                                 @RequestParam("profilePhoto") MultipartFile profilePhoto,
                                 @RequestParam("identityDoc") MultipartFile identityDoc,
                                 Model model,
                                 RedirectAttributes ra) {
        if (email == null || email.trim().isEmpty()) {
            model.addAttribute("error", "Email is required.");
            return "women-products/seller-register";
        }
        String cleanedEmail = email.trim().toLowerCase();
        if (!cleanedEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            model.addAttribute("error", "Enter a valid email address.");
            return "women-products/seller-register";
        }
        if (sellerRepo.findByEmail(cleanedEmail).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "women-products/seller-register";
        }

        String cleanedFullName = fullName == null ? "" : fullName.trim();
        if (cleanedFullName.length() < WomenProductSeller.FULL_NAME_MIN_LENGTH
                || cleanedFullName.length() > WomenProductSeller.FULL_NAME_MAX_LENGTH
                || !cleanedFullName.matches(WomenProductSeller.FULL_NAME_PATTERN)) {
            model.addAttribute("error",
                    "Full Name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed; no numbers).");
            return "women-products/seller-register";
        }

        String cleanedBusinessName = businessName == null ? "" : businessName.trim();
        String businessNameError = validateBusinessName(cleanedBusinessName);
        if (businessNameError != null) {
            model.addAttribute("error", businessNameError);
            return "women-products/seller-register";
        }

        String cleanedPhone = phone == null ? "" : phone.trim();
        if (!cleanedPhone.matches("^[6-9]\\d{9}$")) {
            model.addAttribute("error", "Enter a valid 10-digit Indian mobile number.");
            return "women-products/seller-register";
        }
        if (sellerRepo.findByPhone(cleanedPhone).isPresent()) {
            model.addAttribute("error", "This mobile number is already registered.");
            return "women-products/seller-register";
        }

        String passErr = in.sp.main.Util.MobileValidation.requirePassword(password);
        if (passErr != null) {
            model.addAttribute("error", passErr);
            return "women-products/seller-register";
        }
        String confirmErr = in.sp.main.Util.MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) {
            model.addAttribute("error", confirmErr);
            return "women-products/seller-register";
        }
        if (!Boolean.TRUE.equals(acceptedTerms)) {
            model.addAttribute("error", "Please accept the Terms and Privacy Policy.");
            return "women-products/seller-register";
        }

        String cleanedAddress = address == null ? "" : address.trim();
        if (cleanedAddress.length() < WomenProductSeller.ADDRESS_MIN_LENGTH
                || cleanedAddress.length() > WomenProductSeller.ADDRESS_MAX_LENGTH) {
            model.addAttribute("error", "Please enter a complete address (at least 10 characters).");
            return "women-products/seller-register";
        }
        try {
            WomenProductSeller s = new WomenProductSeller();
            s.setFullName(cleanedFullName);
            s.setEmail(cleanedEmail);
            s.setPhone(cleanedPhone);
            s.setPassword(passwordService.encode(password));
            s.setBusinessName(cleanedBusinessName);
            s.setDescription(description);
            s.setAddress(cleanedAddress);
            if (city != null && !city.trim().isBlank()) {
                s.setCity(city.trim());
            }
            if (profilePhoto == null || profilePhoto.isEmpty() || identityDoc == null || identityDoc.isEmpty()) {
                model.addAttribute("error", "Profile photo and identity proof are required.");
                return "women-products/seller-register";
            }
            s.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            s.setIdentityDocPath(fileUploadService.saveFile(identityDoc));
            s.setVerificationStatus(VerificationStatus.PENDING);
            sellerRepo.save(s);
            ra.addFlashAttribute("success",
                    "Your seller account is awaiting approval. You can sign in after admin verification.");
            return "redirect:/women-products/seller/register";
        } catch (IOException e) {
            model.addAttribute("error", "Registration failed: could not upload files. Please try again.");
            return "women-products/seller-register";
        } catch (Exception e) {
            model.addAttribute("error", "Registration failed. Please check your details and try again.");
            return "women-products/seller-register";
        }
    }

    private static String validateBusinessName(String cleanedBusinessName) {
        if (cleanedBusinessName == null || cleanedBusinessName.isEmpty()) {
            return "Business Name is required.";
        }
        if (cleanedBusinessName.length() < WomenProductSeller.BUSINESS_NAME_MIN_LENGTH
                || cleanedBusinessName.length() > WomenProductSeller.BUSINESS_NAME_MAX_LENGTH
                || !cleanedBusinessName.matches(WomenProductSeller.BUSINESS_NAME_PATTERN)) {
            return "Business Name must be 2–100 characters, start with a letter or number, and may include spaces and & . , ' ( ) - only.";
        }
        return null;
    }

    @GetMapping("/seller/login")
    public String sellerLoginPage() {
        return "women-products/seller-login";
    }

    @PostMapping("/seller/login")
    public String loginSeller(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              jakarta.servlet.http.HttpServletResponse response,
                              Model model) {
        Optional<WomenProductSeller> sOpt = sellerRepo.findByEmail(email == null ? "" : email.trim().toLowerCase());
        if (sOpt.isEmpty()) { model.addAttribute("error", "Invalid email or password."); return "women-products/seller-login"; }
        WomenProductSeller s = sOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, s.getPassword(), hashed -> {
            s.setPassword(hashed);
            sellerRepo.save(s);
        });
        if (!ok) { model.addAttribute("error", "Invalid email or password."); return "women-products/seller-login"; }
        if (s.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            model.addAttribute("error", "Your seller account has been suspended.");
            return "women-products/seller-login";
        }
        if (s.getVerificationStatus() == VerificationStatus.PENDING) {
            model.addAttribute("error", "Your seller account is awaiting approval.");
            return "women-products/seller-login";
        }
        if (s.getVerificationStatus() == VerificationStatus.REJECTED) {
            model.addAttribute("error", "Your account has been rejected by admin.");
            return "women-products/seller-login";
        }
        session.setAttribute("loggedSeller", s);
        
        // Generate JWT and add to response
        String token = jwtUtil.generateToken(s.getEmail(), "SELLER");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
        response.addCookie(cookie);
        
        return "redirect:/women-products/seller/dashboard";
    }

    @GetMapping("/seller/logout")
    public String sellerLogout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.removeAttribute("loggedSeller");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", "");
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        return "redirect:/women-products/seller/login";
    }

    // ══════════════════════════════════════
    // SELLER: Dashboard
    // ══════════════════════════════════════
    @GetMapping("/seller/dashboard")
    public String sellerDashboard(@RequestParam(defaultValue = "overview") String section,
                                  @RequestParam(required = false) String orderStatus,
                                  HttpSession session, Model model) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        s = sellerRepo.findById(s.getId()).orElse(s);

        List<WomenProduct> products = productRepo.findBySellerAndDeletedFalseOrderByCreatedAtDesc(s);
        List<WomenProductOrder> orders = orderRepo.findBySellerOrderByOrderTimeDesc(s);

        double totalEarnings = orders.stream()
                .filter(o -> !"CANCELLED".equals(in.sp.main.Service.WomenProductOrderLifecycleService.canonical(o.getStatus())))
                .mapToDouble(o -> o.getTotalPrice() != null ? o.getTotalPrice() : 0)
                .sum();

        long activeProducts = products.stream().filter(p -> Boolean.TRUE.equals(p.getActive())).count();
        long outOfStock = products.stream().filter(WomenProduct::isOutOfStock).count();
        long lowStock = products.stream().filter(WomenProduct::isLowStock).count();
        long pendingOrders = orders.stream().filter(o -> {
            String st = in.sp.main.Service.WomenProductOrderLifecycleService.canonical(o.getStatus());
            return "PLACED".equals(st);
        }).count();
        long processingOrders = orders.stream().filter(o -> {
            String st = in.sp.main.Service.WomenProductOrderLifecycleService.canonical(o.getStatus());
            return "CONFIRMED".equals(st) || "PROCESSING".equals(st) || "PACKED".equals(st)
                    || "READY_FOR_PICKUP".equals(st) || "ASSIGNED".equals(st)
                    || "PICKED_UP".equals(st) || "IN_TRANSIT".equals(st)
                    || "SHIPPED".equals(st) || "OUT_FOR_DELIVERY".equals(st);
        }).count();
        long deliveredOrders = orders.stream().filter(o ->
                "DELIVERED".equals(in.sp.main.Service.WomenProductOrderLifecycleService.canonical(o.getStatus()))).count();
        long cancelledOrders = orders.stream().filter(o ->
                "CANCELLED".equals(in.sp.main.Service.WomenProductOrderLifecycleService.canonical(o.getStatus()))).count();

        String filter = orderStatus == null ? "" : orderStatus.trim().toUpperCase();
        List<WomenProductOrder> visibleOrders = orders;
        if (!filter.isBlank()) {
            visibleOrders = orders.stream()
                    .filter(o -> filter.equals(in.sp.main.Service.WomenProductOrderLifecycleService.canonical(o.getStatus())))
                    .toList();
        }

        Map<Long, List<String>> nextSellerStatuses = new HashMap<>();
        for (WomenProductOrder o : visibleOrders) {
            nextSellerStatuses.put(o.getId(),
                    in.sp.main.Service.WomenProductOrderLifecycleService.sellerNextStatuses(o.getStatus()));
        }

        List<WomenReturnRequest> returns = returnRepo.findBySellerOrderByRequestTimeDesc(s);

        model.addAttribute("seller", s);
        model.addAttribute("products", products);
        model.addAttribute("orders", visibleOrders);
        model.addAttribute("orderStatusFilter", filter);
        model.addAttribute("nextSellerStatuses", nextSellerStatuses);
        model.addAttribute("returns", returns);
        model.addAttribute("section", section);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("totalOrders", orders.size());
        model.addAttribute("totalProducts", products.size());
        model.addAttribute("activeProducts", activeProducts);
        model.addAttribute("outOfStockProducts", outOfStock);
        model.addAttribute("lowStockProducts", lowStock);
        model.addAttribute("outOfStockCount", outOfStock);
        model.addAttribute("lowStockCount", lowStock);
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("processingOrders", processingOrders);
        model.addAttribute("deliveredOrders", deliveredOrders);
        model.addAttribute("cancelledOrders", cancelledOrders);
        return "women-products/seller-dashboard";
    }

    @PostMapping("/seller/profile/update")
    public String updateSellerProfile(@RequestParam String fullName,
                                     @RequestParam String businessName,
                                     @RequestParam String phone,
                                     @RequestParam String address,
                                     @RequestParam(required = false) String category,
                                     @RequestParam(required = false) String serviceArea,
                                     @RequestParam(required = false) String description,
                                     @RequestParam(required = false) String qualification,
                                     @RequestParam(required = false) String experience,
                                     @RequestParam(required = false) String availableDays,
                                     @RequestParam(required = false) String workingHoursFrom,
                                     @RequestParam(required = false) String workingHoursTo,
                                     @RequestParam(required = false) String languagesSpoken,
                                     @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
                                     HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        
        try {
            WomenProductSeller existing = sellerRepo.findById(s.getId()).orElse(null);
            if (existing != null) {

                String cleanedFullName = fullName == null ? "" : fullName.trim();
                if (cleanedFullName.length() < WomenProductSeller.FULL_NAME_MIN_LENGTH
                        || cleanedFullName.length() > WomenProductSeller.FULL_NAME_MAX_LENGTH
                        || !cleanedFullName.matches(WomenProductSeller.FULL_NAME_PATTERN)) {
                    ra.addFlashAttribute("error",
                            "Full Name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed; no numbers).");
                    return "redirect:/women-products/seller/dashboard?section=profile";
                }
                String cleanedBusinessName = businessName == null ? "" : businessName.trim();
                String businessNameError = validateBusinessName(cleanedBusinessName);
                if (businessNameError != null) {
                    ra.addFlashAttribute("error", businessNameError);
                    return "redirect:/women-products/seller/dashboard?section=profile";
                }
                String cleanedPhone = phone == null ? "" : phone.trim();
                if (!cleanedPhone.matches(WomenProductSeller.PHONE_PATTERN)) {
                    ra.addFlashAttribute("error", "Phone number must be exactly 10 digits.");
                    return "redirect:/women-products/seller/dashboard?section=profile";
                }
                String cleanedAddress = address == null ? "" : address.trim();
                if (cleanedAddress.length() < WomenProductSeller.ADDRESS_MIN_LENGTH
                        || cleanedAddress.length() > WomenProductSeller.ADDRESS_MAX_LENGTH) {
                    ra.addFlashAttribute("error",
                            "Business Address must be between " + WomenProductSeller.ADDRESS_MIN_LENGTH
                                    + " and " + WomenProductSeller.ADDRESS_MAX_LENGTH + " characters.");
                    return "redirect:/women-products/seller/dashboard?section=profile";
                }
                String cleanedDescription = description == null ? "" : description.trim();
                if (cleanedDescription.length() > WomenProductSeller.DESCRIPTION_MAX_LENGTH) {
                    ra.addFlashAttribute("error",
                            "Business Description must be at most "
                                    + WomenProductSeller.DESCRIPTION_MAX_LENGTH + " characters.");
                    return "redirect:/women-products/seller/dashboard?section=profile";
                }
                if (profilePhoto != null && !profilePhoto.isEmpty()) {
                    String photoErr = fileUploadService.validatePngOrJpegImage(profilePhoto, 5L * 1024 * 1024);
                    if (photoErr != null) {
                        ra.addFlashAttribute("error", photoErr.replace("Profile photo", "Profile photo"));
                        return "redirect:/women-products/seller/dashboard?section=profile";
                    }
                }

                existing.setFullName(cleanedFullName);
                existing.setBusinessName(cleanedBusinessName);
                existing.setPhone(cleanedPhone);
                existing.setAddress(cleanedAddress);
                existing.setDescription(cleanedDescription.isEmpty() ? null : cleanedDescription);
                existing.setCategory(category != null ? category.trim() : "");
                existing.setServiceArea(serviceArea != null ? serviceArea.trim() : "");
                existing.setQualification(qualification != null ? qualification.trim() : "");
                existing.setExperience(experience != null ? experience.trim() : "");
                existing.setAvailableDays(availableDays != null ? availableDays.trim() : "");
                existing.setWorkingHoursFrom(workingHoursFrom != null ? workingHoursFrom.trim() : "");
                existing.setWorkingHoursTo(workingHoursTo != null ? workingHoursTo.trim() : "");
                existing.setLanguagesSpoken(languagesSpoken != null ? languagesSpoken.trim() : "");

                
                if (profilePhoto != null && !profilePhoto.isEmpty()) {
                    String originalFilename = profilePhoto.getOriginalFilename();
                    if (originalFilename != null) {
                        String lower = originalFilename.toLowerCase();
                        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp")) {
                            existing.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
                        } else {
                            ra.addFlashAttribute("error", "Invalid photo format. Please upload JPG, JPEG, PNG or WEBP.");
                            return "redirect:/women-products/seller/dashboard?section=profile";
                        }
                    }
                }
                
                sellerRepo.save(existing);
                session.setAttribute("loggedSeller", existing);
                ra.addFlashAttribute("message", "Profile updated successfully!");
            }
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to update profile photo.");
        }
        return "redirect:/women-products/seller/dashboard?section=profile";
    }

    @PostMapping("/seller/products/add")
    public String addProduct(@RequestParam String name,
                             @RequestParam(required = false) String brand,
                             @RequestParam(required = false) String description,
                             @RequestParam(required = false) String fullDescription,
                             @RequestParam Double price,
                             @RequestParam(required = false) Double originalPrice,
                             @RequestParam(required = false) String offerBadge,
                             @RequestParam Integer stock,
                             @RequestParam(required = false, defaultValue = "5") Integer lowStockAlertLevel,
                             @RequestParam(required = false) String sku,
                             @RequestParam String category,
                             @RequestParam(required = false) String weightSize,
                             @RequestParam(required = false) String manufacturer,
                             @RequestParam(required = false) String ingredients,
                             @RequestParam(required = false) String benefits,
                             @RequestParam(required = false) String usageInstructions,
                             @RequestParam(required = false) String tags,
                             @RequestParam(required = false, defaultValue = "true") Boolean active,
                             @RequestParam(required = false, defaultValue = "false") Boolean featured,
                             @RequestParam(required = false, defaultValue = "true") Boolean trackInventory,
                             @RequestParam(value = "images", required = false) java.util.List<MultipartFile> images,
                             HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";

        String validationError = validateProductInput(name, brand, description, fullDescription, price,
                originalPrice, offerBadge, stock, lowStockAlertLevel, sku, category, weightSize,
                manufacturer, ingredients, benefits, usageInstructions, tags, true, images);
        if (validationError != null) {
            ra.addFlashAttribute("error", validationError);
            return "redirect:/women-products/seller/dashboard?section=products";
        }

        try {
            WomenProduct p = new WomenProduct();

            applyProductFields(p, name, brand, description, fullDescription, price, originalPrice,
                    offerBadge, stock, lowStockAlertLevel, sku, category, weightSize, manufacturer,
                    ingredients, benefits, usageInstructions, tags, active, featured, trackInventory);
            if (p.getDiscountPercent() > 0
                    && (p.getOfferBadge() == null || p.getOfferBadge().isBlank() || p.getOfferBadge().trim().endsWith("% OFF"))) {
                p.setOfferBadge(p.getDiscountPercent() + "% OFF");
            }
            p.setSeller(s);
            applyProductImages(p, images, false);
            productRepo.save(p);
            ra.addFlashAttribute("message", "Product added successfully!");
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to upload image. Please try again with a valid JPG/PNG file.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Could not add product. Please check your details and try again.");
        }
        return "redirect:/women-products/seller/dashboard?section=products";
    }

    @PostMapping({"/seller/products/{id}/edit", "/seller/products/edit", "/seller/products//edit"})
    public String editProduct(@PathVariable(required = false) Long id,
                              @RequestParam(required = false) Long productId,
                              @RequestParam(required = false) String name,
                              @RequestParam(required = false) String brand,
                              @RequestParam(required = false) String description,
                              @RequestParam(required = false) String fullDescription,
                              @RequestParam(required = false) Double price,
                              @RequestParam(required = false) Double originalPrice,
                              @RequestParam(required = false) String offerBadge,
                              @RequestParam(required = false) Integer stock,
                              @RequestParam(required = false, defaultValue = "5") Integer lowStockAlertLevel,
                              @RequestParam(required = false) String sku,
                              @RequestParam(required = false) String category,
                              @RequestParam(required = false) String weightSize,
                              @RequestParam(required = false) String manufacturer,
                              @RequestParam(required = false) String ingredients,
                              @RequestParam(required = false) String benefits,
                              @RequestParam(required = false) String usageInstructions,
                              @RequestParam(required = false) String tags,
                              @RequestParam(required = false, defaultValue = "true") Boolean active,
                              @RequestParam(required = false, defaultValue = "false") Boolean featured,
                              @RequestParam(required = false, defaultValue = "true") Boolean trackInventory,
                              @RequestParam(value = "images", required = false) java.util.List<MultipartFile> images,
                              HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";

        Long targetId = (id != null) ? id : productId;
        if (targetId == null) {
            ra.addFlashAttribute("error", "Invalid or missing Product ID.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }

        WomenProduct p = productRepo.findById(targetId).orElse(null);
        if (p == null || !p.getSeller().getId().equals(s.getId())) {
            ra.addFlashAttribute("error", "Product not found or unauthorized.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }

        String validationError = validateProductInput(name, brand, description, fullDescription, price,
                originalPrice, offerBadge, stock, lowStockAlertLevel, sku, category, weightSize,
                manufacturer, ingredients, benefits, usageInstructions, tags, false, images);
        if (validationError != null) {
            ra.addFlashAttribute("error", validationError);
            return "redirect:/women-products/seller/dashboard?section=products";
        }

        applyProductFields(p, name, brand, description, fullDescription, price, originalPrice,
                offerBadge, stock, lowStockAlertLevel, sku, category, weightSize, manufacturer,
                ingredients, benefits, usageInstructions, tags, active, featured, trackInventory);

        try {
            applyProductImages(p, images, true);
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to upload new image. Other product details were not saved.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        productRepo.save(p);
        ra.addFlashAttribute("message", "Product updated successfully!");
        return "redirect:/women-products/seller/dashboard?section=products";
    }
    private static String trimToNull(String value) {
        if (value == null) return null;
        String t = value.trim();
        return t.isEmpty() ? null : t;
    }

    private static String validateProductInput(String name, String brand, String description,
                                               String fullDescription, Double price, Double originalPrice,
                                               String offerBadge, Integer stock, Integer lowStockAlertLevel,
                                               String sku, String category, String weightSize,
                                               String manufacturer, String ingredients, String benefits,
                                               String usageInstructions, String tags,
                                               boolean requireImages, java.util.List<MultipartFile> images) {
        String cleanedName = name == null ? "" : name.trim();
        if (cleanedName.length() < WomenProduct.NAME_MIN_LENGTH
                || cleanedName.length() > WomenProduct.NAME_MAX_LENGTH) {
            return "Product Name must be between " + WomenProduct.NAME_MIN_LENGTH
                    + " and " + WomenProduct.NAME_MAX_LENGTH + " characters.";
        }

        String cleanedBrand = brand == null ? "" : brand.trim();
        if (cleanedBrand.isEmpty() || cleanedBrand.length() > WomenProduct.BRAND_MAX_LENGTH) {
            return "Brand is required (max " + WomenProduct.BRAND_MAX_LENGTH + " characters).";
        }

        if (category == null || category.trim().isEmpty() || !WomenProduct.isAllowedCategory(category)) {
            return "Please select a valid product category.";
        }

        String cleanedDescription = description == null ? "" : description.trim();
        if (cleanedDescription.isEmpty()) {
            return "Short Description is required.";
        }
        if (cleanedDescription.length() > WomenProduct.SHORT_DESCRIPTION_MAX_LENGTH) {
            return "Short Description must be at most "
                    + WomenProduct.SHORT_DESCRIPTION_MAX_LENGTH + " characters.";
        }

        if (fullDescription != null && fullDescription.trim().length() > WomenProduct.FULL_DESCRIPTION_MAX_LENGTH) {
            return "Full Description must be at most "
                    + WomenProduct.FULL_DESCRIPTION_MAX_LENGTH + " characters.";
        }

        if (price == null || price <= 0 || price > WomenProduct.PRICE_MAX) {
            return "Selling price must be greater than 0 and at most " + (long) WomenProduct.PRICE_MAX + ".";
        }
        if (originalPrice != null) {
            if (originalPrice <= 0 || originalPrice > WomenProduct.PRICE_MAX) {
                return "MRP must be greater than 0 when provided.";
            }
            if (originalPrice < price) {
                return "MRP cannot be less than the selling price.";
            }
        }

        if (offerBadge != null && offerBadge.trim().length() > WomenProduct.OFFER_BADGE_MAX_LENGTH) {
            return "Offer Badge must be at most " + WomenProduct.OFFER_BADGE_MAX_LENGTH + " characters.";
        }

        if (stock == null || stock < 0 || stock > WomenProduct.STOCK_MAX) {
            return "Stock quantity must be between 0 and " + WomenProduct.STOCK_MAX + ".";
        }
        if (lowStockAlertLevel == null
                || lowStockAlertLevel < WomenProduct.ALERT_LEVEL_MIN
                || lowStockAlertLevel > WomenProduct.ALERT_LEVEL_MAX) {
            return "Alert Level must be a non-negative number (0 or greater). Negative values are not allowed.";
        }

        if (sku != null && !sku.trim().isEmpty()) {
            String cleanedSku = sku.trim();
            if (cleanedSku.length() > WomenProduct.SKU_MAX_LENGTH || !cleanedSku.matches("^[A-Za-z0-9_-]+$")) {
                return "SKU must be at most " + WomenProduct.SKU_MAX_LENGTH
                        + " characters and use only letters, numbers, hyphens, or underscores.";
            }
        }

        if (weightSize != null && weightSize.trim().length() > WomenProduct.WEIGHT_SIZE_MAX_LENGTH) {
            return "Weight/Size must be at most " + WomenProduct.WEIGHT_SIZE_MAX_LENGTH + " characters.";
        }
        if (manufacturer != null && manufacturer.trim().length() > WomenProduct.MANUFACTURER_MAX_LENGTH) {
            return "Manufacturer must be at most " + WomenProduct.MANUFACTURER_MAX_LENGTH + " characters.";
        }
        if (ingredients != null && ingredients.trim().length() > WomenProduct.INGREDIENTS_MAX_LENGTH) {
            return "Ingredients must be at most " + WomenProduct.INGREDIENTS_MAX_LENGTH + " characters.";
        }
        if (benefits != null && benefits.trim().length() > WomenProduct.BENEFITS_MAX_LENGTH) {
            return "Benefits must be at most " + WomenProduct.BENEFITS_MAX_LENGTH + " characters.";
        }
        if (usageInstructions != null && usageInstructions.trim().length() > WomenProduct.USAGE_MAX_LENGTH) {
            return "Usage Instructions must be at most " + WomenProduct.USAGE_MAX_LENGTH + " characters.";
        }
        if (tags != null && tags.trim().length() > WomenProduct.TAGS_MAX_LENGTH) {
            return "Tags must be at most " + WomenProduct.TAGS_MAX_LENGTH + " characters.";
        }

        java.util.List<MultipartFile> uploaded = nonEmptyImages(images);
        if (requireImages && uploaded.isEmpty()) {
            return "At least one product image is required.";
        }
        if (uploaded.size() > WomenProduct.MAX_PRODUCT_IMAGES) {
            return "You can upload at most " + WomenProduct.MAX_PRODUCT_IMAGES + " images per product.";
        }
        for (MultipartFile img : uploaded) {
            String contentType = img.getContentType();
            if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                return "Only image files (JPG/PNG) are allowed for product photos.";
            }
            if (img.getSize() > 5L * 1024 * 1024) {
                return "Each product image must be 5MB or smaller.";
            }
        }
        return null;
    }

    private static java.util.List<MultipartFile> nonEmptyImages(java.util.List<MultipartFile> images) {
        java.util.List<MultipartFile> uploaded = new ArrayList<>();
        if (images == null) return uploaded;
        for (MultipartFile img : images) {
            if (img != null && !img.isEmpty()) {
                uploaded.add(img);
            }
        }
        return uploaded;
    }

    private static void applyProductFields(WomenProduct p, String name, String brand, String description,
                                           String fullDescription, Double price, Double originalPrice,
                                           String offerBadge, Integer stock, Integer lowStockAlertLevel,
                                           String sku, String category, String weightSize,
                                           String manufacturer, String ingredients, String benefits,
                                           String usageInstructions, String tags,
                                           Boolean active, Boolean featured, Boolean trackInventory) {
        p.setName(name.trim());
        p.setBrand(brand.trim());
        p.setDescription(description.trim());
        p.setFullDescription(trimToNull(fullDescription));
        p.setPrice(price);
        p.setOriginalPrice(originalPrice != null ? originalPrice : price);
        p.setOfferBadge(trimToNull(offerBadge));
        p.setStock(stock);
        p.setLowStockAlertLevel(lowStockAlertLevel != null ? lowStockAlertLevel : 5);
        p.setSku(trimToNull(sku));
        String normalizedCategory = WomenProduct.normalizeCategory(category);
        p.setCategory(normalizedCategory != null ? normalizedCategory : category.trim().toUpperCase());
        p.setWeightSize(trimToNull(weightSize));
        p.setManufacturer(trimToNull(manufacturer));
        p.setIngredients(trimToNull(ingredients));
        p.setBenefits(trimToNull(benefits));
        p.setUsageInstructions(trimToNull(usageInstructions));
        p.setTags(trimToNull(tags));
        p.setActive(active == null || active);
        p.setFeatured(Boolean.TRUE.equals(featured));
        p.setTrackInventory(trackInventory == null || trackInventory);
    }

    private void applyProductImages(WomenProduct p, java.util.List<MultipartFile> images, boolean keepExisting) throws IOException {
        java.util.List<MultipartFile> uploaded = nonEmptyImages(images);
        if (uploaded.isEmpty()) {
            if (!keepExisting && (p.getImagePath() == null || p.getImagePath().isEmpty())) {
                throw new IOException("Product image is required.");
            }
            return;
        }

        // First image is the primary catalog image; remaining images are gallery extras.
        p.setImagePath(fileUploadService.saveFile(uploaded.get(0)));
        if (uploaded.size() == 1) {
            if (!keepExisting) {
                p.setAdditionalImagePaths(null);
            }
            return;
        }

        StringBuilder additionalPaths = new StringBuilder();
        for (int i = 1; i < uploaded.size(); i++) {
            if (additionalPaths.length() > 0) additionalPaths.append(",");
            additionalPaths.append(fileUploadService.saveFile(uploaded.get(i)));
        }
        p.setAdditionalImagePaths(additionalPaths.toString());
    }

    static String toPublicUploadPath(String stored) {
        return WomenProduct.toPublicUploadPath(stored);
    }

    private static java.util.List<String> splitAdditionalImages(String additionalImagePaths) {
        java.util.List<String> urls = new ArrayList<>();
        if (additionalImagePaths == null || additionalImagePaths.isBlank()) return urls;
        for (String part : additionalImagePaths.split(",")) {
            String url = toPublicUploadPath(part);
            if (url != null && !url.isBlank()) urls.add(url);
        }
        return urls;
    }

    @GetMapping({"/seller/products/{id}/edit", "/seller/products/edit", "/seller/products//edit"})

    public String editProductGet() {
        return "redirect:/women-products/seller/dashboard?section=products";
    }

    @PostMapping("/seller/products/{id}/delete")
    public String deleteProduct(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p != null && p.getSeller().getId().equals(s.getId())) {
            cartRepo.deleteByProduct_Id(id);
            wishlistRepo.deleteByProduct_Id(id);
            boolean hasOrders = orderRepo.findByProduct_IdOrderByOrderTimeDesc(id).size() > 0;
            if (hasOrders) {
                p.setActive(false);
                p.setDeleted(true);
                productRepo.save(p);
            } else {
                productRepo.delete(p);
            }
            ra.addFlashAttribute("message", "Product deleted successfully!");
        }
        return "redirect:/women-products/seller/dashboard?section=products";
    }

    @PostMapping("/seller/orders/{id}/status")
    public String updateOrderStatus(@PathVariable Long id, @RequestParam String status,
                                    HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        try {
            orderLifecycle.applySellerStatus(o, sellerRepo.findById(s.getId()).orElse(s), status);
            ra.addFlashAttribute("message", "Order status updated.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Could not update order status.");
        }
        return "redirect:/women-products/seller/dashboard?section=orders";
    }

    @PostMapping("/seller/orders/{id}/status/ajax")
    @ResponseBody
    public Map<String, Object> updateOrderStatusAjax(@PathVariable Long id, @RequestParam String status,
                                                      HttpSession session) {
        Map<String, Object> resp = new HashMap<>();
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) { resp.put("status", "ERROR"); resp.put("message", "Not logged in"); return resp; }
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        try {
            WomenProductOrder updated = orderLifecycle.applySellerStatus(o, sellerRepo.findById(s.getId()).orElse(s), status);
            resp.put("status", "SUCCESS");
            resp.put("newStatus", updated.getStatus());
            resp.put("orderId", updated.getId());
            resp.put("label", in.sp.main.Service.WomenProductOrderLifecycleService.displayLabel(updated.getStatus()));
            resp.put("nextStatuses", in.sp.main.Service.WomenProductOrderLifecycleService.sellerNextStatuses(updated.getStatus()));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            resp.put("status", "ERROR");
            resp.put("message", ex.getReason() != null ? ex.getReason() : "Could not update order status.");
        }
        return resp;
    }

    @PostMapping("/seller/orders/{id}/assign")
    public String assignDeliveryPartner(@PathVariable Long id, @RequestParam Long partnerId,
                                        HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        try {
            orderLifecycle.assignDeliveryPartner(o, sellerRepo.findById(s.getId()).orElse(s), partnerId);
            ra.addFlashAttribute("message", "Delivery partner assigned.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Could not assign delivery partner.");
        }
        return "redirect:/women-products/seller/dashboard?section=orders";
    }

    @PostMapping("/seller/products/{id}/stock")
    public String updateProductStock(@PathVariable Long id, @RequestParam Integer stock,
                                     HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || p.getDeleted() || p.getSeller() == null || !p.getSeller().getId().equals(s.getId())) {
            ra.addFlashAttribute("error", "Product not found.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        try {
            orderLifecycle.applyStockUpdate(p, stock == null ? -1 : stock);
            ra.addFlashAttribute("message", "Stock updated.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Invalid stock quantity.");
        }
        return "redirect:/women-products/seller/dashboard?section=products";
    }

    @PostMapping("/seller/returns/{id}/status")
    public String updateReturnStatus(@PathVariable Long id, @RequestParam String status,
                                     @RequestParam(required = false, defaultValue = "returns") String section,
                                     HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        WomenReturnRequest r = returnRepo.findById(id).orElse(null);
        if (r != null && r.getSeller().getId().equals(s.getId())) {
            r.setStatus(status);
            returnRepo.save(r);
            ra.addFlashAttribute("message", "Return/Exchange status updated.");
        }
        return "redirect:/women-products/seller/dashboard?section=" + section;
    }

    // ══════════════════════════════════════
    // SELLER: Shop Preview (seller's own catalog)
    // ══════════════════════════════════════
    @GetMapping("/seller/shop-preview")
    public String sellerShopPreview(@RequestParam(required = false) String category,
                                    HttpSession session, Model model) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        s = sellerRepo.findById(s.getId()).orElse(s);

        List<WomenProduct> products = productRepo.findBySellerAndDeletedFalseOrderByCreatedAtDesc(s).stream()
                .filter(p -> Boolean.TRUE.equals(p.getActive()))
                .filter(p -> {
                    String normalized = WomenProduct.normalizeCategory(category);
                    return normalized == null
                            || normalized.equalsIgnoreCase(WomenProduct.normalizeCategory(p.getCategory()));
                })
                .collect(java.util.stream.Collectors.toList());

        model.addAttribute("seller", s);
        model.addAttribute("products", products);
        model.addAttribute("selectedCategory", WomenProduct.normalizeCategory(category));
        model.addAttribute("previewMode", true);
        return "women-products/seller-shop-preview";
    }

    // ══════════════════════════════════════
    // USER: Browse Products
    // ══════════════════════════════════════
    @GetMapping
    public String shopHome(Model model, HttpSession session,
                           @RequestParam(required = false) String category,
                           @RequestParam(required = false) String q,
                           @RequestParam(required = false) String price,
                           @RequestParam(required = false) String rating,
                           @RequestParam(required = false) String stock,
                           @RequestParam(required = false) String brand,
                           @RequestParam(required = false) String sort) {
        List<WomenProduct> listed = productRepo.findByActiveTrueAndDeletedFalseOrderByCreatedAtDesc()
                .stream()
                .filter(WomenProduct::isListedForShop)
                .collect(java.util.stream.Collectors.toList());

        Map<Long, Double> avgRatings = new HashMap<>();
        Map<Long, Long> reviewCounts = new HashMap<>();
        for (Object[] row : orderRepo.findAverageRatingsGroupedByProduct()) {
            if (row[0] == null) continue;
            Long pid = ((Number) row[0]).longValue();
            avgRatings.put(pid, row[1] == null ? 0d : ((Number) row[1]).doubleValue());
            reviewCounts.put(pid, row[2] == null ? 0L : ((Number) row[2]).longValue());
        }

        java.util.Set<String> brands = listed.stream()
                .map(WomenProduct::getBrand)
                .filter(b -> b != null && !b.isBlank())
                .map(String::trim)
                .collect(java.util.stream.Collectors.toCollection(java.util.TreeSet::new));

        String query = q == null ? "" : q.trim().toLowerCase();
        String selectedCategory = ProductCategories.normalize(category);
        if (selectedCategory == null && category != null && !category.isBlank()) {
            selectedCategory = category.trim();
        }

        List<WomenProduct> filtered = new ArrayList<>();
        for (WomenProduct p : listed) {
            if (!ProductCategories.matchesFilter(p.getCategory(), category)) continue;
            if (!query.isEmpty()) {
                String hay = ((p.getName() == null ? "" : p.getName()) + " "
                        + (p.getBrand() == null ? "" : p.getBrand()) + " "
                        + (p.getTags() == null ? "" : p.getTags())).toLowerCase();
                if (!hay.contains(query)) continue;
            }
            if (brand != null && !brand.isBlank()
                    && (p.getBrand() == null || !p.getBrand().trim().equalsIgnoreCase(brand.trim()))) {
                continue;
            }
            double pr = p.getPrice() == null ? 0 : p.getPrice();
            if (!matchesPriceBand(price, pr)) continue;
            int st = p.getStock() == null ? 0 : p.getStock();
            if ("in".equalsIgnoreCase(stock) && st <= 0) continue;
            if ("out".equalsIgnoreCase(stock) && st > 0) continue;
            double avg = avgRatings.getOrDefault(p.getId(), 0d);
            if (!matchesMinRating(rating, avg)) continue;
            filtered.add(p);
        }

        String sortKey = sort == null || sort.isBlank() ? "newest" : sort.trim().toLowerCase();
        filtered.sort((a, b) -> compareShopSort(a, b, sortKey, avgRatings));

        List<WomenProduct> featured = listed.stream()
                .filter(p -> Boolean.TRUE.equals(p.getFeatured()))
                .limit(8)
                .collect(java.util.stream.Collectors.toList());

        java.util.Set<Long> wishlistIds = java.util.Collections.emptySet();
        User u = (User) session.getAttribute("user");
        if (u != null) {
            wishlistIds = wishlistRepo.findByUser(u).stream()
                    .filter(w -> w.getProduct() != null)
                    .map(w -> w.getProduct().getId())
                    .collect(java.util.stream.Collectors.toSet());
        }

        model.addAttribute("products", filtered);
        model.addAttribute("featuredProducts", featured);
        model.addAttribute("categoryCodes", WomenProduct.CATEGORY_CODES);
        model.addAttribute("selectedCategory", selectedCategory);
        model.addAttribute("searchQuery", q == null ? "" : q.trim());
        model.addAttribute("selectedPrice", price == null ? "" : price);
        model.addAttribute("selectedRating", rating == null ? "" : rating);
        model.addAttribute("selectedStock", stock == null ? "" : stock);
        model.addAttribute("selectedBrand", brand == null ? "" : brand);
        model.addAttribute("selectedSort", sortKey);
        model.addAttribute("availableBrands", brands);
        model.addAttribute("avgRatings", avgRatings);
        model.addAttribute("reviewCounts", reviewCounts);
        model.addAttribute("wishlistIds", wishlistIds);
        return "women-products/shop";
    }

    private static boolean matchesPriceBand(String price, double pr) {
        if (price == null || price.isBlank() || "any".equalsIgnoreCase(price)) return true;
        return switch (price.trim().toLowerCase()) {
            case "under500" -> pr < 500;
            case "500-1000" -> pr >= 500 && pr <= 1000;
            case "1000-2000" -> pr > 1000 && pr <= 2000;
            case "2000plus" -> pr > 2000;
            default -> true;
        };
    }

    private static boolean matchesMinRating(String rating, double avg) {
        if (rating == null || rating.isBlank() || "any".equalsIgnoreCase(rating)) return true;
        try {
            double min = Double.parseDouble(rating.trim());
            return avg + 0.0001 >= min;
        } catch (NumberFormatException e) {
            return true;
        }
    }

    private static int compareShopSort(WomenProduct a, WomenProduct b, String sortKey, Map<Long, Double> avgRatings) {
        double pa = a.getPrice() == null ? 0 : a.getPrice();
        double pb = b.getPrice() == null ? 0 : b.getPrice();
        return switch (sortKey) {
            case "price_asc", "price" -> Double.compare(pa, pb);
            case "price_desc" -> Double.compare(pb, pa);
            case "rating" -> Double.compare(
                    avgRatings.getOrDefault(b.getId(), 0d),
                    avgRatings.getOrDefault(a.getId(), 0d));
            case "discount" -> Integer.compare(b.getDiscountPercent(), a.getDiscountPercent());
            default -> 0; // newest — repository already returns createdAt desc
        };
    }

    @GetMapping("/view/{id}")
    public String viewProduct(@PathVariable Long id, Model model, HttpSession session) {
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || !Boolean.TRUE.equals(p.getActive()) || p.getDeleted() || !p.isListedForShop()) {
            return "redirect:/women-products";
        }

        List<WomenProductOrder> reviews = orderRepo.findByProduct_IdOrderByOrderTimeDesc(id);
        List<WomenProductOrder> ratedReviews = reviews.stream()
                .filter(o -> o.getRating() != null)
                .collect(java.util.stream.Collectors.toList());

        double avgRating = ratedReviews.stream()
                .mapToInt(WomenProductOrder::getRating)
                .average()
                .orElse(0.0);

        List<WomenProduct> related = productRepo.findByActiveTrueAndDeletedFalseOrderByCreatedAtDesc().stream()
                .filter(WomenProduct::isListedForShop)
                .filter(o -> !o.getId().equals(id))
                .filter(o -> ProductCategories.matchesFilter(o.getCategory(), p.getCategory()))
                .limit(4)
                .collect(java.util.stream.Collectors.toList());

        model.addAttribute("product", p);
        model.addAttribute("productImageUrl", p.getPublicImagePath());
        model.addAttribute("additionalImageUrls", p.getPublicAdditionalImagePaths());
        model.addAttribute("ingredients", p.getIngredients());
        model.addAttribute("benefits", p.getBenefits());
        model.addAttribute("usageInstructions", p.getUsageInstructions());
        model.addAttribute("fullDescription", p.getFullDescription());
        model.addAttribute("reviews", ratedReviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("reviewCount", ratedReviews.size());
        model.addAttribute("relatedProducts", related);
        model.addAttribute("sellerApproved", p.getSeller() != null && p.getSeller().isApprovedForCatalog());

        User u = (User) session.getAttribute("user");
        if (u != null) {
            model.addAttribute("inWishlist", wishlistRepo.existsByUserAndProduct_Id(u, id));
            model.addAttribute("inCart", cartRepo.findByUserAndProduct_Id(u, id).isPresent());
        }
        return "women-products/product-view";
    }

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        List<WomenCartItem> items = cartRepo.findByUser(u);
        double total = items.stream().mapToDouble(i -> i.getProduct().getPrice() * i.getQuantity()).sum();
        model.addAttribute("cartItems", items);
        model.addAttribute("cartTotal", total);
        return "women-products/cart";
    }

    // ══════════════════════════════════════
    // USER: Wishlist
    // ══════════════════════════════════════
    @PostMapping("/wishlist/toggle")
    public String toggleWishlist(@RequestParam Long productId,
                                 @RequestParam(required = false) String returnTo,
                                 HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        if (wishlistRepo.existsByUserAndProduct_Id(u, productId)) {
            wishlistRepo.deleteByUserAndProduct_Id(u, productId);
            ra.addFlashAttribute("message", "Removed from wishlist.");
        } else {
            WomenProduct p = productRepo.findById(productId).orElse(null);
            if (p != null && !p.getDeleted()) {
                WomenWishlistItem w = new WomenWishlistItem();
                w.setUser(u);
                w.setProduct(p);
                wishlistRepo.save(w);
                ra.addFlashAttribute("message", "Added to wishlist!");
            }
        }
        if ("wishlist".equals(returnTo)) return "redirect:/women-products/wishlist";
        if ("shop".equals(returnTo)) return "redirect:/women-products";
        return "redirect:/women-products/view/" + productId;
    }

    @GetMapping("/wishlist")
    public String viewWishlist(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        model.addAttribute("wishlistItems", wishlistRepo.findByUser(u));
        return "women-products/wishlist";
    }

    @GetMapping("/api/product/{id}/stock")
    @ResponseBody
    public Map<String, Object> getProductStockApi(@PathVariable Long id) {
        Map<String, Object> res = new HashMap<>();
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || p.getDeleted()) {
            res.put("exists", false);
            res.put("stock", 0);
        } else {
            res.put("exists", true);
            res.put("id", p.getId());
            res.put("stock", p.getStock() != null ? p.getStock() : 0);
            res.put("active", p.getActive() != null ? p.getActive() : true);
        }
        return res;
    }

    // ══════════════════════════════════════
    // USER: Cart & Checkout
    // ══════════════════════════════════════
    @PostMapping("/cart/add")
    public String addToCart(@RequestParam Long productId,
                            @RequestParam(required = false, defaultValue = "1") Integer quantity,
                            HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        WomenProduct p = productRepo.findById(productId).orElse(null);
        if (p == null || !p.isListedForShop()) {
            ra.addFlashAttribute("error", "Product is unavailable.");
            return "redirect:/women-products";
        }
        int availableStock = p.getStock() != null ? p.getStock() : 0;
        if (availableStock <= 0) {
            ra.addFlashAttribute("error", "'" + p.getName() + "' is Out of Stock.");
            return "redirect:/women-products/view/" + productId;
        }

        int requestedQty = (quantity != null && quantity > 0) ? quantity : 1;
        if (requestedQty > availableStock) {
            requestedQty = availableStock;
        }

        Optional<WomenCartItem> existing = cartRepo.findByUserAndProduct_Id(u, productId);
        if (!existing.isPresent()) {
            WomenCartItem c = new WomenCartItem();
            c.setUser(u);
            c.setProduct(p);
            c.setQuantity(requestedQty);
            cartRepo.save(c);
            ra.addFlashAttribute("message", "Added to cart!");
        } else {
            WomenCartItem c = existing.get();
            int newTotalQty = c.getQuantity() + requestedQty;
            if (newTotalQty > availableStock) {
                newTotalQty = availableStock;
                ra.addFlashAttribute("message", "Quantity adjusted to max available stock (" + availableStock + ").");
            } else {
                ra.addFlashAttribute("message", "Cart updated!");
            }
            c.setQuantity(newTotalQty);
            cartRepo.save(c);
        }
        return "redirect:/women-products/cart";
    }

    @PostMapping("/buy-now")
    public String buyNow(@RequestParam Long productId,
                         @RequestParam(required = false, defaultValue = "1") Integer quantity,
                         HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        WomenProduct p = productRepo.findById(productId).orElse(null);
        if (p == null || !p.isListedForShop()) {
            ra.addFlashAttribute("error", "Product is unavailable.");
            return "redirect:/women-products";
        }
        int availableStock = p.getStock() != null ? p.getStock() : 0;
        if (availableStock <= 0) {
            ra.addFlashAttribute("error", "'" + p.getName() + "' is Out of Stock.");
            return "redirect:/women-products/view/" + productId;
        }
        int reqQty = (quantity != null && quantity > 0) ? quantity : 1;
        if (reqQty > availableStock) reqQty = availableStock;

        session.setAttribute(BUY_NOW_PRODUCT_ID, productId);
        session.setAttribute(BUY_NOW_QTY, reqQty);
        return "redirect:/women-products/checkout?buyNow=1";
    }

    @PostMapping("/cart/{id}/update")
    public String updateCartQty(@PathVariable Long id, @RequestParam int quantity, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        WomenCartItem c = cartRepo.findById(id).orElse(null);
        if (c != null && c.getUser().getId().equals(u.getId())) {
            int currentStock = (c.getProduct() != null && c.getProduct().getStock() != null) ? c.getProduct().getStock() : 0;
            if (quantity <= 0) {
                cartRepo.delete(c);
            } else {
                if (quantity > currentStock) quantity = currentStock;
                c.setQuantity(quantity);
                cartRepo.save(c);
            }
        }
        return "redirect:/women-products/cart";
    }

    @PostMapping("/cart/{id}/remove")
    public String removeCartItem(@PathVariable Long id, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        WomenCartItem c = cartRepo.findById(id).orElse(null);
        if (c != null && c.getUser().getId().equals(u.getId())) {
            cartRepo.delete(c);
        }
        return "redirect:/women-products/cart";
    }

    @GetMapping("/checkout")
    public String checkoutPage(@RequestParam(required = false) String buyNow,
                               Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        boolean buyNowMode = "1".equals(buyNow) && session.getAttribute(BUY_NOW_PRODUCT_ID) != null;
        if (!buyNowMode) {
            session.removeAttribute(BUY_NOW_PRODUCT_ID);
            session.removeAttribute(BUY_NOW_QTY);
        }

        List<WomenCartItem> items;
        if (buyNowMode) {
            Long pid = (Long) session.getAttribute(BUY_NOW_PRODUCT_ID);
            Integer qty = (Integer) session.getAttribute(BUY_NOW_QTY);
            WomenProduct p = productRepo.findById(pid).orElse(null);
            if (p == null || !p.isListedForShop()) {
                session.removeAttribute(BUY_NOW_PRODUCT_ID);
                session.removeAttribute(BUY_NOW_QTY);
                return "redirect:/women-products";
            }
            WomenCartItem temp = new WomenCartItem();
            temp.setProduct(p);
            temp.setQuantity(qty == null || qty < 1 ? 1 : qty);
            items = new ArrayList<>();
            items.add(temp);
        } else {
            items = cartRepo.findByUser(u);
            if (items.isEmpty()) return "redirect:/women-products/cart";
        }
        double total = items.stream()
                .filter(i -> i.getProduct() != null && i.getProduct().getPrice() != null)
                .mapToDouble(i -> i.getProduct().getPrice() * i.getQuantity()).sum();
        double savings = items.stream()
                .filter(i -> i.getProduct() != null && i.getProduct().getDiscountPercent() > 0)
                .mapToDouble(i -> (i.getProduct().getOriginalPrice() - i.getProduct().getPrice()) * i.getQuantity())
                .sum();
        model.addAttribute("cartItems", items);
        model.addAttribute("cartTotal", total);
        model.addAttribute("cartSavings", savings);
        model.addAttribute("deliveryFee", 0);
        model.addAttribute("buyNowMode", buyNowMode);
        model.addAttribute("user", u);
        model.addAttribute("paymentsAvailable", doctorPaymentService.paymentsAvailable());
        return "women-products/checkout";
    }

    @PostMapping("/checkout/place")
    @org.springframework.transaction.annotation.Transactional
    public synchronized String placeOrder(@RequestParam String paymentMethod,
                                           @RequestParam String shippingAddress,
                                           @RequestParam(required = false) String razorpayPaymentId,
                                           HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        String payNorm = normalizeWebPaymentMethod(paymentMethod);
        if (payNorm == null) {
            ra.addFlashAttribute("error", "Choose Cash on Delivery or Online Payment.");
            return checkoutRedirect(session);
        }
        String address = shippingAddress == null ? "" : shippingAddress.trim();
        if (address.length() < 8) {
            ra.addFlashAttribute("error", "Please enter a complete delivery address.");
            return checkoutRedirect(session);
        }

        boolean buyNowMode = session.getAttribute(BUY_NOW_PRODUCT_ID) != null;
        List<WomenCartItem> items = resolveCheckoutItems(session, u);
        if (items.isEmpty()) return "redirect:/women-products/cart";

        String stockError = validateCheckoutStock(items);
        if (stockError != null) {
            ra.addFlashAttribute("error", stockError);
            return buyNowMode ? checkoutRedirect(session) : "redirect:/women-products/cart";
        }

        List<Long> orderIds;
        try {
            orderIds = persistOrders(u, items, payNorm, address, razorpayPaymentId);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Could not place order.");
            return buyNowMode ? checkoutRedirect(session) : "redirect:/women-products/cart";
        }
        if (!buyNowMode) {
            cartRepo.deleteByUser(u);
        }
        session.removeAttribute(BUY_NOW_PRODUCT_ID);
        session.removeAttribute(BUY_NOW_QTY);
        session.setAttribute(JUST_PLACED_ORDER_IDS, orderIds);
        ra.addFlashAttribute("message", "Order placed successfully!");
        return "redirect:/women-products/order-confirmation";
    }

    @PostMapping("/checkout/place/ajax")
    @ResponseBody
    @org.springframework.transaction.annotation.Transactional
    public synchronized Map<String, Object> placeOrderAjax(@RequestParam String paymentMethod,
                                                           @RequestParam String shippingAddress,
                                                           @RequestParam(required = false) String razorpayPaymentId,
                                                           HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User u = (User) session.getAttribute("user");
        if (u == null) { response.put("status", "ERROR"); response.put("message", "User not logged in"); return response; }

        String payNorm = normalizeWebPaymentMethod(paymentMethod);
        if (payNorm == null) {
            response.put("status", "ERROR");
            response.put("message", "Choose Cash on Delivery or Online Payment.");
            return response;
        }
        String address = shippingAddress == null ? "" : shippingAddress.trim();
        if (address.length() < 8) {
            response.put("status", "ERROR");
            response.put("message", "Please enter a complete delivery address.");
            return response;
        }

        boolean buyNowMode = session.getAttribute(BUY_NOW_PRODUCT_ID) != null;
        List<WomenCartItem> items = resolveCheckoutItems(session, u);
        if (items.isEmpty()) { response.put("status", "ERROR"); response.put("message", "Cart is empty"); return response; }

        String stockError = validateCheckoutStock(items);
        if (stockError != null) {
            response.put("status", "ERROR");
            response.put("message", stockError);
            return response;
        }

        List<Long> orderIds;
        try {
            orderIds = persistOrders(u, items, payNorm, address, razorpayPaymentId);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            response.put("status", "ERROR");
            response.put("message", ex.getReason() != null ? ex.getReason() : "Could not place order.");
            return response;
        }
        if (!buyNowMode) {
            cartRepo.deleteByUser(u);
        }
        session.removeAttribute(BUY_NOW_PRODUCT_ID);
        session.removeAttribute(BUY_NOW_QTY);
        session.setAttribute(JUST_PLACED_ORDER_IDS, orderIds);

        response.put("status", "SUCCESS");
        response.put("orderIds", orderIds);
        response.put("redirect", "/women-products/order-confirmation");
        return response;
    }

    private String checkoutRedirect(HttpSession session) {
        if (session.getAttribute(BUY_NOW_PRODUCT_ID) != null) {
            return "redirect:/women-products/checkout?buyNow=1";
        }
        return "redirect:/women-products/checkout";
    }

    private static String normalizeWebPaymentMethod(String paymentMethod) {
        if (paymentMethod == null || paymentMethod.isBlank()) return null;
        String m = paymentMethod.trim().toUpperCase();
        if ("COD".equals(m)) return "COD";
        if (m.startsWith("ONLINE")) return "ONLINE";
        return null;
    }

    private List<WomenCartItem> resolveCheckoutItems(HttpSession session, User u) {
        Object pidObj = session.getAttribute(BUY_NOW_PRODUCT_ID);
        if (pidObj instanceof Long pid) {
            Integer qty = (Integer) session.getAttribute(BUY_NOW_QTY);
            WomenProduct p = productRepo.findById(pid).orElse(null);
            if (p == null) return new ArrayList<>();
            WomenCartItem temp = new WomenCartItem();
            temp.setProduct(p);
            temp.setQuantity(qty == null || qty < 1 ? 1 : qty);
            List<WomenCartItem> one = new ArrayList<>();
            one.add(temp);
            return one;
        }
        return cartRepo.findByUser(u);
    }

    private String validateCheckoutStock(List<WomenCartItem> items) {
        for (WomenCartItem ci : items) {
            if (ci.getProduct() == null) return "A product in your order is unavailable.";
            WomenProduct liveP = productRepo.findById(ci.getProduct().getId()).orElse(null);
            int currentStock = (liveP != null && liveP.getStock() != null) ? liveP.getStock() : 0;
            if (liveP == null || !liveP.isListedForShop() || currentStock <= 0) {
                return "Product '" + (liveP != null ? liveP.getName() : "Item") + "' is Out of Stock.";
            }
            if (ci.getQuantity() > currentStock) {
                return "Only " + currentStock + " unit(s) available for '" + liveP.getName() + "'. Please adjust your cart.";
            }
        }
        return null;
    }

    private List<Long> persistOrders(User u, List<WomenCartItem> items, String payNorm,
                                     String address, String razorpayPaymentId) {
        List<Long> orderIds = new ArrayList<>();
        String paymentStatus = "COD".equals(payNorm) ? "COD" : "PENDING";
        for (WomenCartItem ci : items) {
            WomenProduct p = productRepo.findById(ci.getProduct().getId()).orElse(null);
            if (p == null) continue;
            int finalQty = ci.getQuantity();

            WomenProductOrder order = new WomenProductOrder();
            order.setUser(u);
            order.setProduct(p);
            order.setSeller(p.getSeller());
            order.setQuantity(finalQty);
            order.setTotalPrice((p.getPrice() == null ? 0 : p.getPrice()) * finalQty);
            order.setPaymentMethod(payNorm);
            order.setPaymentStatus(paymentStatus);
            order.setShippingAddress(address);
            order.setStatus("PLACED");
            if (razorpayPaymentId != null && !razorpayPaymentId.isBlank()) {
                order.setRazorpayPaymentId(razorpayPaymentId.trim());
            }
            java.time.LocalDateTime placedAt = java.time.LocalDateTime.now();
            order.setOrderTime(placedAt);
            order.setExpectedDeliveryDate(deliveryService
                    .calculateExpectedDeliveryDate(placedAt, address, p, ci.getQuantity())
                    .atStartOfDay());
            orderRepo.save(order);
            orderIds.add(order.getId());
            orderLifecycle.decrementStock(p, finalQty);
        }
        return orderIds;
    }

    @PostMapping("/order/rate")
    @ResponseBody
    public Map<String, Object> submitOrderRating(@RequestParam Long orderId,
                                               @RequestParam Integer rating,
                                               @RequestParam String review,
                                               HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User u = (User) session.getAttribute("user");
        if (u == null) { response.put("status", "ERROR"); return response; }

        WomenProductOrder order = orderRepo.findById(orderId).orElse(null);
        if (order != null && order.getUser().getId().equals(u.getId())) {
            if (!"DELIVERED".equals(order.getStatus())) {
                response.put("status", "ERROR");
                response.put("message", "Only delivered orders can be rated.");
                return response;
            }
            if (rating == null || rating < 1 || rating > 5) {
                response.put("status", "ERROR");
                response.put("message", "Rating must be between 1 and 5.");
                return response;
            }
            String cleanedReview = review == null ? "" : review.trim();
            if (cleanedReview.length() > 2000) {
                response.put("status", "ERROR");
                response.put("message", "Review must be at most 2000 characters.");
                return response;
            }
            order.setRating(rating);
            order.setReview(cleanedReview.isEmpty() ? null : cleanedReview);
            orderRepo.save(order);

            // Update seller aggregate rating
            WomenProductSeller seller = order.getSeller();
            List<WomenProductOrder> allSellerOrders = orderRepo.findBySellerOrderByOrderTimeDesc(seller);
            double avg = allSellerOrders.stream()
                    .filter(o -> o.getRating() != null)
                    .mapToInt(o -> o.getRating())
                    .average()
                    .orElse(0.0);
            seller.setRating(avg);
            sellerRepo.save(seller);

            response.put("status", "SUCCESS");
        } else {
            response.put("status", "ERROR");
        }
        return response;
    }

    @GetMapping("/my-orders")
    public String myOrders(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        List<WomenProductOrder> orders = orderRepo.findByUserOrderByOrderTimeDesc(u);
        Map<String, String> expectedDeliveryLabels = new HashMap<>();
        java.time.format.DateTimeFormatter fmt =
                java.time.format.DateTimeFormatter.ofPattern("EEEE, d MMM yyyy", java.util.Locale.ENGLISH);
        for (WomenProductOrder o : orders) {
            if (o.getStatus() != null && "CANCELLED".equalsIgnoreCase(o.getStatus())) continue;
            java.time.LocalDate eta;
            if (o.getExpectedDeliveryDate() != null) {
                eta = o.getExpectedDeliveryDate().toLocalDate();
            } else {
                // Legacy orders: compute in-memory only (do not overwrite stored rows)
                eta = deliveryService.calculateExpectedDeliveryDate(
                        o.getOrderTime(),
                        o.getShippingAddress(),
                        o.getProduct(),
                        o.getQuantity());
            }
            expectedDeliveryLabels.put(String.valueOf(o.getId()), eta.format(fmt));
        }
        Map<String, Boolean> canCancel = new HashMap<>();
        Map<Long, java.util.List<java.util.Map<String, String>>> orderTracking = new HashMap<>();
        for (WomenProductOrder o : orders) {
            canCancel.put(String.valueOf(o.getId()), productsCareService.canCancel(o));
            orderTracking.put(o.getId(),
                    in.sp.main.Service.WomenProductOrderLifecycleService.trackingSteps(o.getStatus()));
        }
        model.addAttribute("orders", orders);
        model.addAttribute("expectedDeliveryLabels", expectedDeliveryLabels);
        model.addAttribute("canCancel", canCancel);
        model.addAttribute("orderTracking", orderTracking);
        model.addAttribute("cancelPolicy", in.sp.main.Service.WomenProductsCareService.CANCEL_POLICY);
        return "women-products/my-orders";
    }

    @GetMapping("/order-confirmation")
    public String orderConfirmation(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        @SuppressWarnings("unchecked")
        List<Long> ids = (List<Long>) session.getAttribute(JUST_PLACED_ORDER_IDS);
        if (ids == null || ids.isEmpty()) return "redirect:/women-products/my-orders";
        List<WomenProductOrder> placed = new ArrayList<>();
        for (Long id : ids) {
            WomenProductOrder o = orderRepo.findById(id).orElse(null);
            if (o != null && o.getUser() != null && o.getUser().getId().equals(u.getId())) {
                placed.add(o);
            }
        }
        if (placed.isEmpty()) return "redirect:/women-products/my-orders";
        double total = placed.stream().mapToDouble(o -> o.getTotalPrice() == null ? 0 : o.getTotalPrice()).sum();
        Map<String, String> expectedDeliveryLabels = new HashMap<>();
        java.time.format.DateTimeFormatter fmt =
                java.time.format.DateTimeFormatter.ofPattern("EEEE, d MMM yyyy", java.util.Locale.ENGLISH);
        for (WomenProductOrder o : placed) {
            if (o.getExpectedDeliveryDate() != null) {
                expectedDeliveryLabels.put(String.valueOf(o.getId()), o.getExpectedDeliveryDate().toLocalDate().format(fmt));
            }
        }
        model.addAttribute("orders", placed);
        model.addAttribute("orderTotal", total);
        model.addAttribute("expectedDeliveryLabels", expectedDeliveryLabels);
        return "women-products/order-confirmation";
    }

    @PostMapping("/orders/{id}/cancel")
    public String cancelOrder(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getUser() == null || !o.getUser().getId().equals(u.getId())) {
            ra.addFlashAttribute("error", "Order not found.");
            return "redirect:/women-products/my-orders";
        }
        try {
            productsCareService.cancel(o, "customer");
            ra.addFlashAttribute("message", "Order cancelled. Stock has been restored where applicable.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason() != null ? ex.getReason()
                    : in.sp.main.Service.WomenProductsCareService.CANCEL_POLICY);
        }
        return "redirect:/women-products/my-orders";
    }

    @GetMapping("/api/my-orders-status")
    @ResponseBody
    public List<Map<String, Object>> myOrdersStatusApi(HttpSession session) {
        List<Map<String, Object>> list = new ArrayList<>();
        User u = (User) session.getAttribute("user");
        if (u == null) return list;

        List<WomenProductOrder> orders = orderRepo.findByUserOrderByOrderTimeDesc(u);
        for (WomenProductOrder o : orders) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", o.getId());
            map.put("status", o.getStatus() != null ? o.getStatus() : "PLACED");
            list.add(map);
        }
        return list;
    }

    @PostMapping("/orders/{id}/return")
    public String submitReturnRequest(@PathVariable Long id,
                                      @RequestParam String type,
                                      @RequestParam String reason,
                                      @RequestParam(required = false) String comments,
                                      @RequestParam(required = false) String bankDetails,
                                      @RequestParam(required = false) String holderName,
                                      @RequestParam(required = false) String accountNumber,
                                      @RequestParam(required = false) String ifsc,
                                      @RequestParam(required = false) String branch,
                                      @RequestParam(value = "image", required = false) MultipartFile image,
                                      HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || !o.getUser().getId().equals(u.getId())) return "redirect:/women-products/my-orders";

        String cleanedType = type == null ? "" : type.trim().toUpperCase();
        if (!"REFUND".equals(cleanedType) && !"EXCHANGE".equals(cleanedType) && !"RETURN".equals(cleanedType)) {
            ra.addFlashAttribute("error", "Invalid request type.");
            return "redirect:/women-products/my-orders";
        }
        if (!"DELIVERED".equalsIgnoreCase(o.getStatus())) {
            ra.addFlashAttribute("error", "Refund/exchange is only available for delivered orders.");
            return "redirect:/women-products/my-orders";
        }
        if (returnRepo.findByOrder(o).isPresent()) {
            ra.addFlashAttribute("error", "A refund/exchange request already exists for this order.");
            return "redirect:/women-products/my-orders";
        }

        String cleanedReason = reason == null ? "" : reason.trim().toLowerCase();
        if ("REFUND".equals(cleanedType) || "RETURN".equals(cleanedType)) {
            if (!WomenReturnRequest.REFUND_REASONS.contains(cleanedReason)) {
                ra.addFlashAttribute("error", "Please select a valid refund reason.");
                return "redirect:/women-products/my-orders";
            }
            String refundErr = validateRefundBankFields(holderName, accountNumber, ifsc, branch);
            if (refundErr != null) {
                ra.addFlashAttribute("error", refundErr);
                return "redirect:/women-products/my-orders";
            }
        } else {
            if (!WomenReturnRequest.EXCHANGE_REASONS.contains(cleanedReason)) {
                ra.addFlashAttribute("error", "Please select a valid exchange reason.");
                return "redirect:/women-products/my-orders";
            }
            if (image == null || image.isEmpty()) {
                ra.addFlashAttribute("error", "Please upload a product image for the exchange request.");
                return "redirect:/women-products/my-orders";
            }
        }

        String cleanedComments = comments == null ? "" : comments.trim();
        if (cleanedComments.length() > WomenReturnRequest.COMMENTS_MAX) {
            ra.addFlashAttribute("error",
                    "Comments must be at most " + WomenReturnRequest.COMMENTS_MAX + " characters.");
            return "redirect:/women-products/my-orders";
        }

        try {
            WomenReturnRequest r = new WomenReturnRequest();
            r.setOrder(o);
            r.setSeller(o.getSeller());
            r.setType("RETURN".equals(cleanedType) ? "REFUND" : cleanedType);
            r.setReason(cleanedReason);
            r.setComments(cleanedComments.isEmpty() ? null : cleanedComments);

            if ("REFUND".equals(r.getType())) {
                String h = holderName.trim();
                String a = accountNumber.trim();
                String i = ifsc.trim().toUpperCase();
                String b = branch.trim();
                r.setBankDetails("Holder: " + h + ", A/C: " + a + ", IFSC: " + i + ", Branch: " + b);
            } else if (bankDetails != null && !bankDetails.isBlank()) {
                r.setBankDetails(bankDetails.trim());
            }

            r.setStatus("PENDING");
            if (image != null && !image.isEmpty()) {
                String contentType = image.getContentType();
                if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    ra.addFlashAttribute("error", "Please upload a valid image file (JPG/PNG).");
                    return "redirect:/women-products/my-orders";
                }
                if (image.getSize() > 5L * 1024 * 1024) {
                    ra.addFlashAttribute("error", "Image must be 5MB or smaller.");
                    return "redirect:/women-products/my-orders";
                }
                r.setImagePath(fileUploadService.saveFile(image));
            }
            returnRepo.save(r);
            ra.addFlashAttribute("message", r.getType() + " request submitted successfully!");
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to upload image. Please try again.");
        }
        return "redirect:/women-products/my-orders";
    }

    private static String validateRefundBankFields(String holderName, String accountNumber,
                                                   String ifsc, String branch) {
        String h = holderName == null ? "" : holderName.trim();
        if (h.length() < WomenReturnRequest.HOLDER_NAME_MIN
                || h.length() > WomenReturnRequest.HOLDER_NAME_MAX
                || !h.matches(WomenReturnRequest.HOLDER_NAME_PATTERN)) {
            return "Bank holder name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed).";
        }
        String a = accountNumber == null ? "" : accountNumber.trim();
        if (!a.matches(WomenReturnRequest.ACCOUNT_PATTERN)) {
            return "Account number must be 9–18 digits.";
        }
        String i = ifsc == null ? "" : ifsc.trim().toUpperCase();
        if (!i.matches(WomenReturnRequest.IFSC_PATTERN)) {
            return "Please enter a valid 11-character IFSC code (e.g. SBIN0001234).";
        }
        String b = branch == null ? "" : branch.trim();
        if (b.length() < WomenReturnRequest.BRANCH_MIN || b.length() > WomenReturnRequest.BRANCH_MAX) {
            return "Branch name must be between " + WomenReturnRequest.BRANCH_MIN
                    + " and " + WomenReturnRequest.BRANCH_MAX + " characters.";
        }
        return null;
    }
}
