package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
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
                                 @RequestParam String businessName,
                                 @RequestParam(required = false) String description,
                                 @RequestParam String address,
                                 @RequestParam("profilePhoto") MultipartFile profilePhoto,
                                 @RequestParam("identityDoc") MultipartFile identityDoc,
                                 Model model) {
        if (sellerRepo.findByEmail(email.trim().toLowerCase()).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "women-products/seller-register";
        }

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "women-products/seller-register";
        }
        try {
            WomenProductSeller s = new WomenProductSeller();
            s.setFullName(fullName);
            s.setEmail(email.trim().toLowerCase());
            s.setPhone(phone);
            s.setPassword(passwordService.encode(password));
            s.setBusinessName(businessName);
            s.setDescription(description);
            s.setAddress(address);
            if (!profilePhoto.isEmpty()) s.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            if (!identityDoc.isEmpty()) s.setIdentityDocPath(fileUploadService.saveFile(identityDoc));
            s.setVerificationStatus(VerificationStatus.PENDING);
            sellerRepo.save(s);
            return "redirect:/women-products/seller/login?registered=true";
        } catch (IOException e) {
            model.addAttribute("error", "Failed to upload files.");
            return "women-products/seller-register";
        }
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
        Optional<WomenProductSeller> sOpt = sellerRepo.findByEmail(email.trim().toLowerCase());
        if (sOpt.isEmpty()) { model.addAttribute("error", "Seller not found."); return "women-products/seller-login"; }
        WomenProductSeller s = sOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, s.getPassword(), hashed -> {
            s.setPassword(hashed);
            sellerRepo.save(s);
        });
        if (!ok) { model.addAttribute("error", "Invalid password."); return "women-products/seller-login"; }
        if (s.getVerificationStatus() == VerificationStatus.PENDING) {
            model.addAttribute("error", "Your account is pending verification by Admin. Please check back later.");
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

    // ══════════════════════════════════════
    // SELLER: Dashboard
    // ══════════════════════════════════════
    @GetMapping("/seller/dashboard")
    public String sellerDashboard(@RequestParam(defaultValue = "overview") String section,
                                  HttpSession session, Model model) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        s = sellerRepo.findById(s.getId()).orElse(s);

        List<WomenProduct> products = productRepo.findBySellerAndDeletedFalseOrderByCreatedAtDesc(s);
        List<WomenProductOrder> orders = orderRepo.findBySellerOrderByOrderTimeDesc(s);

        double totalEarnings = orders.stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .mapToDouble(o -> o.getTotalPrice() != null ? o.getTotalPrice() : 0)
                .sum();

        List<WomenReturnRequest> returns = returnRepo.findBySellerOrderByRequestTimeDesc(s);

        model.addAttribute("seller", s);
        model.addAttribute("products", products);
        model.addAttribute("orders", orders);
        model.addAttribute("returns", returns);
        model.addAttribute("section", section);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("totalOrders", orders.size());
        model.addAttribute("totalProducts", products.size());
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
                existing.setFullName(fullName != null ? fullName.trim() : "");
                existing.setBusinessName(businessName != null ? businessName.trim() : "");
                existing.setPhone(phone != null ? phone.trim() : "");
                existing.setAddress(address != null ? address.trim() : "");
                existing.setCategory(category != null ? category.trim() : "");
                existing.setServiceArea(serviceArea != null ? serviceArea.trim() : "");
                existing.setDescription(description != null ? description.trim() : "");
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
                             @RequestParam String description,
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
                             @RequestParam(value = "images", required = false) MultipartFile[] images,
                             HttpSession session, RedirectAttributes ra) {
        WomenProductSeller s = (WomenProductSeller) session.getAttribute("loggedSeller");
        if (s == null) return "redirect:/women-products/seller/login";
        if (brand == null || brand.trim().isEmpty()) {
            ra.addFlashAttribute("error", "Brand name is required.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        if (price == null || price <= 0) {
            ra.addFlashAttribute("error", "Selling price must be positive.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        if (originalPrice != null && originalPrice <= 0) {
            ra.addFlashAttribute("error", "MRP must be positive.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        if (images == null || images.length == 0 || images[0].isEmpty()) {
            ra.addFlashAttribute("error", "Product image is required.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }

        try {
            WomenProduct p = new WomenProduct();
            p.setName(name);
            p.setBrand(brand);
            p.setDescription(description);
            p.setFullDescription(fullDescription);
            p.setPrice(price);
            Double finalMrp = originalPrice != null ? originalPrice : price;
            p.setOriginalPrice(finalMrp);

            String finalOfferBadge = offerBadge;
            if ((finalOfferBadge == null || finalOfferBadge.trim().isEmpty() || finalOfferBadge.trim().endsWith("% OFF")) && finalMrp > price) {
                long discount = Math.round(((finalMrp - price) / finalMrp) * 100);
                if (discount > 0) finalOfferBadge = discount + "% OFF";
            }
            p.setOfferBadge(finalOfferBadge);
            p.setStock(stock);
            p.setLowStockAlertLevel(lowStockAlertLevel);
            p.setSku(sku);
            p.setCategory(category);
            p.setWeightSize(weightSize);
            p.setManufacturer(manufacturer);
            p.setIngredients(ingredients);
            p.setBenefits(benefits);
            p.setUsageInstructions(usageInstructions);
            p.setTags(tags);
            p.setActive(active);
            p.setFeatured(featured);
            p.setTrackInventory(trackInventory);
            p.setSeller(s);
            
            if (images != null && images.length > 0) {
                if (!images[0].isEmpty()) {
                    p.setImagePath(fileUploadService.saveFile(images[0]));
                }
                if (images.length > 1) {
                    StringBuilder additionalPaths = new StringBuilder();
                    for (int i = 1; i < images.length; i++) {
                        if (!images[i].isEmpty()) {
                            if (additionalPaths.length() > 0) additionalPaths.append(",");
                            additionalPaths.append(fileUploadService.saveFile(images[i]));
                        }
                    }
                    if (additionalPaths.length() > 0) {
                        p.setAdditionalImagePaths(additionalPaths.toString());
                    }
                }
            }

            productRepo.save(p);
            ra.addFlashAttribute("message", "Product added successfully!");
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to upload image.");
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
                              @RequestParam(value = "images", required = false) MultipartFile[] images,
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

        if (name == null || name.trim().isEmpty()) {
            ra.addFlashAttribute("error", "Product name is required.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        if (brand == null || brand.trim().isEmpty()) {
            ra.addFlashAttribute("error", "Brand name is required.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        if (price == null || price <= 0) {
            ra.addFlashAttribute("error", "Selling price must be positive.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }
        if (originalPrice != null && originalPrice <= 0) {
            ra.addFlashAttribute("error", "MRP must be positive.");
            return "redirect:/women-products/seller/dashboard?section=products";
        }

        p.setName(name.trim());
        p.setBrand(brand.trim());
        p.setDescription(description != null ? description.trim() : "");
        p.setFullDescription(fullDescription != null ? fullDescription.trim() : "");
        p.setPrice(price);
        Double finalMrp = originalPrice != null ? originalPrice : price;
        p.setOriginalPrice(finalMrp);
        
        String finalOfferBadge = offerBadge;
        if ((finalOfferBadge == null || finalOfferBadge.trim().isEmpty() || finalOfferBadge.trim().endsWith("% OFF")) && finalMrp > price) {
            long discount = Math.round(((finalMrp - price) / finalMrp) * 100);
            if (discount > 0) finalOfferBadge = discount + "% OFF";
        }
        p.setOfferBadge(finalOfferBadge);
        p.setStock(stock != null ? stock : 0);
        p.setLowStockAlertLevel(lowStockAlertLevel != null ? lowStockAlertLevel : 5);
        p.setSku(sku);
        p.setCategory(category != null ? category.trim() : p.getCategory());
        p.setWeightSize(weightSize);
        p.setManufacturer(manufacturer);
        p.setIngredients(ingredients);
        p.setBenefits(benefits);
        p.setUsageInstructions(usageInstructions);
        p.setTags(tags);
        p.setActive(active != null ? active : true);
        p.setFeatured(featured != null ? featured : false);
        p.setTrackInventory(trackInventory != null ? trackInventory : true);
        
        try {
            if (images != null && images.length > 0) {
                if (!images[0].isEmpty()) {
                    p.setImagePath(fileUploadService.saveFile(images[0]));
                }
                if (images.length > 1) {
                    StringBuilder additionalPaths = new StringBuilder();
                    for (int i = 1; i < images.length; i++) {
                        if (!images[i].isEmpty()) {
                            if (additionalPaths.length() > 0) additionalPaths.append(",");
                            additionalPaths.append(fileUploadService.saveFile(images[i]));
                        }
                    }
                    if (additionalPaths.length() > 0) {
                        p.setAdditionalImagePaths(additionalPaths.toString());
                    }
                }
            }
        } catch (IOException e) { /* keep old image */ }
        productRepo.save(p);
        ra.addFlashAttribute("message", "Product updated successfully!");
        return "redirect:/women-products/seller/dashboard?section=products";
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
        if (o != null && o.getSeller().getId().equals(s.getId())) {
            String normStatus = status != null ? status.trim().toUpperCase() : "PLACED";
            if ("IN_TRANSIT".equals(normStatus)) normStatus = "SHIPPED";
            o.setStatus(normStatus);
            orderRepo.save(o);
            ra.addFlashAttribute("message", "Order status updated.");
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
        if (o != null && o.getSeller().getId().equals(s.getId())) {
            String normStatus = status != null ? status.trim().toUpperCase() : "PLACED";
            if ("IN_TRANSIT".equals(normStatus)) normStatus = "SHIPPED";
            o.setStatus(normStatus);
            orderRepo.save(o);
            resp.put("status", "SUCCESS");
            resp.put("newStatus", normStatus);
            resp.put("orderId", o.getId());
        } else {
            resp.put("status", "ERROR");
            resp.put("message", "Order not found");
        }
        return resp;
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
    // USER: Browse Products
    // ══════════════════════════════════════
    @GetMapping
    public String shopHome(Model model, @RequestParam(required = false) String category) {
        if (category != null && !category.isEmpty()) {
            model.addAttribute("products", productRepo.findByCategoryAndActiveTrueAndDeletedFalseOrderByCreatedAtDesc(category));
        } else {
            model.addAttribute("products", productRepo.findByActiveTrueAndDeletedFalseOrderByCreatedAtDesc());
        }
        model.addAttribute("selectedCategory", category);
        return "women-products/shop";
    }

    @GetMapping("/view/{id}")
    public String viewProduct(@PathVariable Long id, Model model, HttpSession session) {
        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || !p.getActive() || p.getDeleted()) return "redirect:/women-products";
        
        List<WomenProductOrder> reviews = orderRepo.findByProduct_IdOrderByOrderTimeDesc(id);
        List<WomenProductOrder> ratedReviews = reviews.stream()
                .filter(o -> o.getRating() != null)
                .collect(java.util.stream.Collectors.toList());
        
        double avgRating = ratedReviews.stream()
                .mapToInt(o -> o.getRating())
                .average()
                .orElse(0.0);
        
        model.addAttribute("product", p);
        model.addAttribute("reviews", ratedReviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("reviewCount", ratedReviews.size());

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
    public String toggleWishlist(@RequestParam Long productId, HttpSession session, RedirectAttributes ra) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        if (wishlistRepo.existsByUserAndProduct_Id(u, productId)) {
            wishlistRepo.deleteByUserAndProduct_Id(u, productId);
            ra.addFlashAttribute("message", "Removed from wishlist.");
        } else {
            WomenProduct p = productRepo.findById(productId).orElse(null);
            if (p != null) {
                WomenWishlistItem w = new WomenWishlistItem();
                w.setUser(u);
                w.setProduct(p);
                wishlistRepo.save(w);
                ra.addFlashAttribute("message", "Added to wishlist!");
            }
        }
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
        if (p == null || !p.getActive() || p.getDeleted()) {
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
        if (p == null || !p.getActive() || p.getDeleted()) {
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

        cartRepo.deleteByUser(u);
        WomenCartItem c = new WomenCartItem();
        c.setUser(u);
        c.setProduct(p);
        c.setQuantity(reqQty);
        cartRepo.save(c);
        return "redirect:/women-products/checkout";
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
    public String checkoutPage(Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        List<WomenCartItem> items = cartRepo.findByUser(u);
        if (items.isEmpty()) return "redirect:/women-products/cart";
        double total = items.stream().mapToDouble(i -> i.getProduct().getPrice() * i.getQuantity()).sum();
        model.addAttribute("cartItems", items);
        model.addAttribute("cartTotal", total);
        model.addAttribute("user", u);
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
        List<WomenCartItem> items = cartRepo.findByUser(u);
        if (items.isEmpty()) return "redirect:/women-products/cart";

        // Strict Stock Pre-validation before order placement
        for (WomenCartItem ci : items) {
            WomenProduct liveP = productRepo.findById(ci.getProduct().getId()).orElse(null);
            int currentStock = (liveP != null && liveP.getStock() != null) ? liveP.getStock() : 0;
            if (liveP == null || !liveP.getActive() || liveP.getDeleted() || currentStock <= 0) {
                ra.addFlashAttribute("error", "Product '" + (liveP != null ? liveP.getName() : "Item") + "' is Out of Stock.");
                return "redirect:/women-products/cart";
            }
            if (ci.getQuantity() > currentStock) {
                ra.addFlashAttribute("error", "Only " + currentStock + " unit(s) available for '" + liveP.getName() + "'. Please adjust your cart.");
                return "redirect:/women-products/cart";
            }
        }

        for (WomenCartItem ci : items) {
            WomenProduct p = productRepo.findById(ci.getProduct().getId()).orElse(null);
            int finalQty = ci.getQuantity();

            WomenProductOrder order = new WomenProductOrder();
            order.setUser(u);
            order.setProduct(p);
            order.setSeller(p.getSeller());
            order.setQuantity(finalQty);
            order.setTotalPrice(p.getPrice() * finalQty);
            order.setPaymentMethod(paymentMethod);
            order.setShippingAddress(shippingAddress);
            order.setStatus("PLACED");
            if (razorpayPaymentId != null) order.setRazorpayPaymentId(razorpayPaymentId);
            orderRepo.save(order);

            // Deduct stock safely
            int remainingStock = p.getStock() - finalQty;
            if (remainingStock < 0) remainingStock = 0;
            p.setStock(remainingStock);
            productRepo.save(p);
        }

        // Clear cart
        cartRepo.deleteByUser(u);

        ra.addFlashAttribute("message", "Order placed successfully!");
        return "redirect:/women-products/my-orders";
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
        
        List<WomenCartItem> items = cartRepo.findByUser(u);
        if (items.isEmpty()) { response.put("status", "ERROR"); response.put("message", "Cart is empty"); return response; }

        // Strict Stock Pre-validation before order placement
        for (WomenCartItem ci : items) {
            WomenProduct liveP = productRepo.findById(ci.getProduct().getId()).orElse(null);
            int currentStock = (liveP != null && liveP.getStock() != null) ? liveP.getStock() : 0;
            if (liveP == null || !liveP.getActive() || liveP.getDeleted() || currentStock <= 0) {
                response.put("status", "ERROR");
                response.put("message", "Product '" + (liveP != null ? liveP.getName() : "Item") + "' is Out of Stock.");
                return response;
            }
            if (ci.getQuantity() > currentStock) {
                response.put("status", "ERROR");
                response.put("message", "Only " + currentStock + " unit(s) available for '" + liveP.getName() + "'. Please adjust your cart.");
                return response;
            }
        }

        List<Long> orderIds = new ArrayList<>();
        for (WomenCartItem ci : items) {
            WomenProduct p = productRepo.findById(ci.getProduct().getId()).orElse(null);
            int finalQty = ci.getQuantity();

            WomenProductOrder order = new WomenProductOrder();
            order.setUser(u);
            order.setProduct(p);
            order.setSeller(p.getSeller());
            order.setQuantity(finalQty);
            order.setTotalPrice(p.getPrice() * finalQty);
            order.setPaymentMethod(paymentMethod);
            order.setShippingAddress(shippingAddress);
            order.setStatus("PLACED");
            if (razorpayPaymentId != null) order.setRazorpayPaymentId(razorpayPaymentId);
            orderRepo.save(order);
            orderIds.add(order.getId());

            int remainingStock = p.getStock() - finalQty;
            if (remainingStock < 0) remainingStock = 0;
            p.setStock(remainingStock);
            productRepo.save(p);
        }
        cartRepo.deleteByUser(u);
        
        response.put("status", "SUCCESS");
        response.put("orderIds", orderIds);
        return response;
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
            order.setRating(rating);
            order.setReview(review);
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
        model.addAttribute("orders", orderRepo.findByUserOrderByOrderTimeDesc(u));
        return "women-products/my-orders";
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

        try {
            WomenReturnRequest r = returnRepo.findByOrder(o).orElse(new WomenReturnRequest());
            r.setOrder(o);
            r.setSeller(o.getSeller());
            r.setType(type);
            r.setReason(reason);
            r.setComments(comments);
            
            if (bankDetails == null && holderName != null) {
                bankDetails = "Holder: " + holderName + ", A/C: " + accountNumber + ", IFSC: " + ifsc + ", Branch: " + branch;
            }
            r.setBankDetails(bankDetails);
            r.setStatus("PENDING");
            if (image != null && !image.isEmpty()) {
                r.setImagePath(fileUploadService.saveFile(image));
            }
            returnRepo.save(r);
            ra.addFlashAttribute("message", type + " request submitted successfully!");
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to upload image.");
        }
        return "redirect:/women-products/my-orders";
    }
}
