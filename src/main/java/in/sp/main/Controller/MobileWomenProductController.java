package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenCartItem;
import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenWishlistItem;
import in.sp.main.Util.ProductCategories;
import in.sp.main.Util.WomenProductValidation;
import in.sp.main.Repository.WomenCartItemRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Repository.WomenProductRepository;
import in.sp.main.Repository.WomenWishlistItemRepository;
import in.sp.main.Service.ProductDeliveryTrackingService;
import in.sp.main.Service.WomenProductDeliveryService;
import in.sp.main.Service.WomenProductOrderLifecycleService;
import in.sp.main.Service.WomenProductsCareService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Mobile JSON APIs for Women Products buyer flow.
 */
@RestController
@RequestMapping("/api/women-products")
public class MobileWomenProductController {

    @Autowired
    private WomenProductRepository productRepo;

    @Autowired
    private WomenCartItemRepository cartRepo;

    @Autowired
    private WomenWishlistItemRepository wishlistRepo;

    @Autowired
    private WomenProductOrderRepository orderRepo;

    @Autowired
    private ProductDeliveryTrackingService trackingService;
    @Autowired
    private WomenProductsCareService productsCareService;
    @Autowired
    private WomenProductOrderLifecycleService orderLifecycle;
    @Autowired
    private WomenProductDeliveryService deliveryService;

    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        return ResponseEntity.ok(ok(Map.of("categories", ProductCategories.asCatalog())));
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> listProducts(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Boolean inStock,
            @RequestParam(required = false) String sort,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String cityQ = city == null ? "" : city.trim().toLowerCase();
        List<WomenProduct> products = productRepo.findByActiveTrueAndDeletedFalseOrderByCreatedAtDesc();
        List<Map<String, Object>> items = new ArrayList<>();
        for (WomenProduct p : products) {
            if (!ProductCategories.matchesFilter(p.getCategory(), category)) continue;
            if (p.getSeller() == null || !p.getSeller().isApprovedForCatalog()) {
                continue;
            }
            String sellerCity = p.getSeller().getCity() == null ? "" : p.getSeller().getCity().toLowerCase();
            if (!cityQ.isBlank() && !sellerCity.contains(cityQ)) continue;
            double price = p.getPrice() == null ? 0 : p.getPrice();
            if (maxPrice != null && (price == 0 || price > maxPrice)) continue;
            int stock = p.getStock() == null ? 0 : p.getStock();
            if (Boolean.TRUE.equals(inStock) && stock <= 0) continue;
            Map<String, Object> dto = productDto(p);
            dto.put("inWishlist", wishlistRepo.existsByUserAndProduct_Id(user, p.getId()));
            Optional<WomenCartItem> c = cartRepo.findByUserAndProduct_Id(user, p.getId());
            dto.put("inCart", c.isPresent());
            dto.put("cartQty", c.map(WomenCartItem::getQuantity).orElse(0));
            items.add(dto);
        }
        String sortKey = sort == null ? "newest" : sort.trim().toLowerCase();
        items.sort((a, b) -> {
            if ("price".equals(sortKey) || "fee".equals(sortKey)) {
                double pa = a.get("price") instanceof Number n ? n.doubleValue() : 0;
                double pb = b.get("price") instanceof Number n ? n.doubleValue() : 0;
                return Double.compare(pa, pb);
            }
            if ("rating".equals(sortKey)) {
                double ra = a.get("avgRating") instanceof Number n ? n.doubleValue() : 0;
                double rb = b.get("avgRating") instanceof Number n ? n.doubleValue() : 0;
                return Double.compare(rb, ra);
            }
            return 0;
        });

        return ResponseEntity.ok(ok(Map.of(
                "products", items,
                "count", items.size(),
                "cancelPolicy", WomenProductsCareService.CANCEL_POLICY
        )));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> productDetail(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        WomenProduct p = productRepo.findById(id).orElse(null);
        if (p == null || !p.isListedForShop()) {
            return badRequest("Product not found.");
        }

        List<WomenProductOrder> reviews = orderRepo.findByProduct_IdOrderByOrderTimeDesc(id).stream()
                .filter(o -> o.getRating() != null)
                .toList();

        double avgRating = reviews.stream().mapToInt(WomenProductOrder::getRating).average().orElse(0.0);
        List<Map<String, Object>> reviewDtos = new ArrayList<>();
        for (WomenProductOrder r : reviews) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("orderId", r.getId());
            m.put("rating", r.getRating());
            m.put("review", r.getReview());
            m.put("userName", r.getUser() != null ? r.getUser().getFullName() : "User");
            m.put("orderTime", r.getOrderTime() != null ? r.getOrderTime().toString() : null);
            reviewDtos.add(m);
        }

        Map<String, Object> dto = productDto(p);
        dto.put("inWishlist", wishlistRepo.existsByUserAndProduct_Id(user, id));
        dto.put("inCart", cartRepo.findByUserAndProduct_Id(user, id).isPresent());
        dto.put("reviews", reviewDtos);
        dto.put("avgRating", avgRating);
        dto.put("reviewCount", reviewDtos.size());
        return ResponseEntity.ok(ok(Map.of("product", dto)));
    }

    @GetMapping("/cart")
    public ResponseEntity<Map<String, Object>> cart(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<WomenCartItem> items = cartRepo.findByUser(user);
        List<Map<String, Object>> out = new ArrayList<>();
        double total = 0;
        for (WomenCartItem i : items) {
            WomenProduct p = i.getProduct();
            if (p == null) continue;
            double subtotal = (p.getPrice() == null ? 0 : p.getPrice()) * i.getQuantity();
            total += subtotal;
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", i.getId());
            row.put("quantity", i.getQuantity());
            row.put("subtotal", subtotal);
            row.put("product", productDto(p));
            out.add(row);
        }
        return ResponseEntity.ok(ok(Map.of(
                "items", out,
                "count", out.size(),
                "total", total
        )));
    }

    @PostMapping("/cart/add")
    @Transactional
    public ResponseEntity<Map<String, Object>> addToCart(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Long productId = asLong(body.get("productId"));
        int quantity = asInt(body.get("quantity"), 1);
        if (productId == null || quantity <= 0) return badRequest("productId and positive quantity are required.");

        WomenProduct p = productRepo.findById(productId).orElse(null);
        if (p == null || !Boolean.TRUE.equals(p.getActive()) || p.getDeleted()) return badRequest("Product not found.");
        if (p.getStock() != null && p.getStock() <= 0) return badRequest("Product is out of stock.");

        WomenCartItem item = cartRepo.findByUserAndProduct_Id(user, productId).orElse(null);
        if (item == null) {
            item = new WomenCartItem();
            item.setUser(user);
            item.setProduct(p);
            item.setQuantity(0);
        }
        int stock = p.getStock() == null ? 0 : p.getStock();
        int newQty = item.getQuantity() + quantity;
        if (newQty > stock) {
            return badRequest("Only " + stock + " unit(s) available for '" + p.getName() + "'.");
        }
        item.setQuantity(newQty);
        cartRepo.save(item);
        return ResponseEntity.ok(ok(Map.of("message", "Added to cart.")));
    }

    @PostMapping("/cart/{id}/update")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateCart(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenCartItem item = cartRepo.findById(id).orElse(null);
        if (item == null || item.getUser() == null || !item.getUser().getId().equals(user.getId())) {
            return badRequest("Cart item not found.");
        }
        int quantity = asInt(body.get("quantity"), item.getQuantity());
        if (quantity <= 0) {
            cartRepo.deleteById(id);
            return ResponseEntity.ok(ok(Map.of("message", "Removed from cart.")));
        }
        WomenProduct p = item.getProduct();
        int stock = (p != null && p.getStock() != null) ? p.getStock() : 0;
        if (quantity > stock) {
            return badRequest("Only " + stock + " unit(s) available"
                    + (p != null ? " for '" + p.getName() + "'" : "") + ".");
        }
        item.setQuantity(quantity);
        cartRepo.save(item);
        return ResponseEntity.ok(ok(Map.of("message", "Cart updated.")));
    }

    @PostMapping("/cart/{id}/remove")
    @Transactional
    public ResponseEntity<Map<String, Object>> removeCart(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenCartItem item = cartRepo.findById(id).orElse(null);
        if (item != null && item.getUser() != null && item.getUser().getId().equals(user.getId())) {
            cartRepo.deleteById(id);
        }
        return ResponseEntity.ok(ok(Map.of("message", "Removed from cart.")));
    }

    @GetMapping("/wishlist")
    public ResponseEntity<Map<String, Object>> wishlist(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<WomenWishlistItem> list = wishlistRepo.findByUser(user);
        List<Map<String, Object>> out = new ArrayList<>();
        for (WomenWishlistItem w : list) {
            if (w.getProduct() == null) continue;
            out.add(productDto(w.getProduct()));
        }
        return ResponseEntity.ok(ok(Map.of("items", out, "count", out.size())));
    }

    @PostMapping("/wishlist/toggle")
    @Transactional
    public ResponseEntity<Map<String, Object>> wishlistToggle(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Long productId = asLong(body.get("productId"));
        if (productId == null) return badRequest("productId is required.");
        if (wishlistRepo.existsByUserAndProduct_Id(user, productId)) {
            wishlistRepo.deleteByUserAndProduct_Id(user, productId);
            return ResponseEntity.ok(ok(Map.of("inWishlist", false)));
        }
        WomenProduct p = productRepo.findById(productId).orElse(null);
        if (p == null || p.getDeleted()) return badRequest("Product not found.");
        WomenWishlistItem w = new WomenWishlistItem();
        w.setUser(user);
        w.setProduct(p);
        wishlistRepo.save(w);
        return ResponseEntity.ok(ok(Map.of("inWishlist", true)));
    }

    @PostMapping("/checkout/place")
    @Transactional
    public ResponseEntity<Map<String, Object>> placeOrder(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String shippingAddress = str(body.get("shippingAddress"));
        String paymentMethod = str(body.get("paymentMethod")).toUpperCase();
        String addressErr = WomenProductValidation.validateShippingAddress(shippingAddress);
        if (addressErr != null) {
            return badRequest(addressErr);
        }
        if (!"COD".equals(paymentMethod) && !"ONLINE".equals(paymentMethod)) {
            return badRequest("Use COD or ONLINE.");
        }

        List<WomenCartItem> items = cartRepo.findByUser(user);
        if (items.isEmpty()) return badRequest("Cart is empty.");

        for (WomenCartItem ci : items) {
            WomenProduct p = productRepo.findById(ci.getProduct().getId()).orElse(null);
            if (p == null || p.getDeleted() || !Boolean.TRUE.equals(p.getActive())
                    || p.getSeller() == null || !p.getSeller().isApprovedForCatalog()) {
                return badRequest("A product in your cart is unavailable.");
            }
            int stock = p.getStock() == null ? 0 : p.getStock();
            int qty = ci.getQuantity() == null ? 0 : ci.getQuantity();
            if (qty < 1) return badRequest("Invalid quantity.");
            if (stock <= 0) return badRequest("Product '" + p.getName() + "' is out of stock.");
            if (qty > stock) return badRequest("Only " + stock + " unit(s) available for '" + p.getName() + "'.");
        }

        List<Long> orderIds = new ArrayList<>();
        double total = 0;
        try {
            for (WomenCartItem ci : items) {
                WomenProduct p = productRepo.findById(ci.getProduct().getId()).orElse(null);
                int qty = ci.getQuantity();
                WomenProductOrder o = new WomenProductOrder();
                o.setUser(user);
                o.setProduct(p);
                o.setSeller(p.getSeller());
                o.setQuantity(qty);
                double line = (p.getPrice() == null ? 0 : p.getPrice()) * qty;
                o.setTotalPrice(line);
                o.setPaymentMethod(paymentMethod);
                o.setPaymentStatus("COD".equals(paymentMethod) ? "COD" : "PENDING");
                o.setShippingAddress(shippingAddress);
                o.setStatus("PLACED");
                java.time.LocalDateTime placedAt = java.time.LocalDateTime.now();
                o.setOrderTime(placedAt);
                o.setExpectedDeliveryDate(deliveryService
                        .calculateExpectedDeliveryDate(placedAt, shippingAddress, p, qty)
                        .atStartOfDay());
                orderRepo.save(o);
                trackingService.ensureGeocoded(o);
                orderIds.add(o.getId());
                total += line;
                orderLifecycle.decrementStock(p, qty);
            }
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
        cartRepo.deleteByUser(user);

        if (orderIds.isEmpty()) return badRequest("Could not place order. Items are unavailable.");
        return ResponseEntity.ok(ok(Map.of(
                "message", "ONLINE".equals(paymentMethod)
                        ? "Order placed. Pay from My Orders."
                        : "Order placed successfully.",
                "orderIds", orderIds,
                "amount", total,
                "paymentMethod", paymentMethod,
                "paymentRequired", "ONLINE".equals(paymentMethod),
                "cancelPolicy", WomenProductsCareService.CANCEL_POLICY
        )));
    }

    @GetMapping("/my-orders")
    public ResponseEntity<Map<String, Object>> myOrders(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<WomenProductOrder> orders = orderRepo.findByUserOrderByOrderTimeDesc(user);
        List<Map<String, Object>> out = new ArrayList<>();
        for (WomenProductOrder o : orders) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", o.getId());
            row.put("quantity", o.getQuantity());
            row.put("totalPrice", o.getTotalPrice());
            row.put("paymentMethod", o.getPaymentMethod());
            row.put("status", WomenProductOrderLifecycleService.canonical(o.getStatus()));
            row.put("statusLabel", WomenProductOrderLifecycleService.displayLabel(o.getStatus()));
            row.put("trackingSteps", WomenProductOrderLifecycleService.trackingSteps(o.getStatus()));
            row.put("shippingAddress", o.getShippingAddress());
            row.put("orderTime", o.getOrderTime() == null ? null : o.getOrderTime().toString());
            row.put("rating", o.getRating());
            row.put("review", o.getReview());
            row.put("trackingNote", o.getTrackingNote());
            row.put("assignedAt", o.getAssignedAt() == null ? null : o.getAssignedAt().toString());
            row.put("pickedUpAt", o.getPickedUpAt() == null ? null : o.getPickedUpAt().toString());
            row.put("deliveredAt", o.getDeliveredAt() == null ? null : o.getDeliveredAt().toString());
            row.put("paymentStatus", o.getPaymentStatus());
            row.put("canCancel", productsCareService.canCancel(o));
            row.put("needsPayment", "ONLINE".equalsIgnoreCase(o.getPaymentMethod())
                    && !"PAID".equalsIgnoreCase(o.getPaymentStatus())
                    && !"CANCELLED".equalsIgnoreCase(normStatus(o.getStatus())));
            row.put("canReview", "DELIVERED".equalsIgnoreCase(normStatus(o.getStatus())) && o.getRating() == null);
            row.put("cancelPolicy", WomenProductsCareService.CANCEL_POLICY);
            row.put("canLiveTrack", ProductDeliveryTrackingService.isLive(o.getStatus()));
            row.put("etaMinutes", o.getEtaMinutes());
            row.put("remainingKm", o.getRemainingKm());
            row.put("product", o.getProduct() == null ? null : productDto(o.getProduct()));
            if (o.getDeliveryPartner() != null) {
                row.put("deliveryName", o.getDeliveryPartner().getFullName());
                row.put("deliveryPhone", o.getDeliveryPartner().getPhone());
                row.put("deliveryVehicle", o.getDeliveryPartner().getVehicleType());
            }
            out.add(row);
        }
        return ResponseEntity.ok(ok(Map.of("orders", out, "count", out.size())));
    }

    @GetMapping("/orders/{id}/track")
    public ResponseEntity<Map<String, Object>> trackOrder(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getUser() == null || !o.getUser().getId().equals(user.getId())) {
            return badRequest("Order not found.");
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.putAll(trackingService.trackPayload(o));
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/orders/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelOrder(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getUser() == null || !o.getUser().getId().equals(user.getId())) {
            return badRequest("Order not found.");
        }
        try {
            productsCareService.cancel(o, "customer");
            return ResponseEntity.ok(ok(Map.of("message", "Order cancelled", "status", "CANCELLED",
                    "cancelPolicy", WomenProductsCareService.CANCEL_POLICY)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping("/orders/{id}/rate")
    @Transactional
    public ResponseEntity<Map<String, Object>> rateOrder(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenProductOrder o = orderRepo.findById(id).orElse(null);
        if (o == null || o.getUser() == null || !o.getUser().getId().equals(user.getId())) {
            return badRequest("Order not found.");
        }
        if (!"DELIVERED".equalsIgnoreCase(o.getStatus())) {
            return badRequest("Only delivered orders can be rated.");
        }
        int rating = asInt(body.get("rating"), 0);
        if (rating < 1 || rating > 5) return badRequest("rating must be between 1 and 5.");
        String cleanedReview = str(body.get("review"));
        String reviewErr = WomenProductValidation.validateReviewText(cleanedReview);
        if (reviewErr != null) return badRequest(reviewErr);
        o.setRating(rating);
        o.setReview(cleanedReview.isEmpty() ? null : cleanedReview);
        orderRepo.save(o);
        return ResponseEntity.ok(ok(Map.of("message", "Thanks for your review.")));
    }

    private static Map<String, Object> productDto(WomenProduct p) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", p.getId());
        dto.put("name", p.getName());
        dto.put("brand", p.getBrand());
        dto.put("description", p.getDescription());
        dto.put("fullDescription", p.getFullDescription());
        dto.put("price", p.getPrice());
        dto.put("originalPrice", p.getOriginalPrice());
        dto.put("offerBadge", p.getOfferBadge());
        dto.put("stock", p.getStock());
        dto.put("category", p.getCategory());
        dto.put("weightSize", p.getWeightSize());
        dto.put("manufacturer", p.getManufacturer());
        dto.put("ingredients", p.getIngredients());
        dto.put("benefits", p.getBenefits());
        dto.put("usageInstructions", p.getUsageInstructions());
        dto.put("tags", p.getTags());
        dto.put("imagePath", p.getPublicImagePath());
        dto.put("additionalImagePaths", p.getAdditionalImagePaths());
        dto.put("featured", p.getFeatured());
        dto.put("sellerName", p.getSeller() != null ? p.getSeller().getBusinessName() : null);
        dto.put("sellerCity", p.getSeller() != null ? p.getSeller().getCity() : null);
        dto.put("inStock", p.getStock() != null && p.getStock() > 0);
        return dto;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "error", "Login required"
        ));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", error
        ));
    }

    private User requireUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private static Long asLong(Object v) {
        if (v == null) return null;
        if (v instanceof Number n) return n.longValue();
        try { return Long.parseLong(v.toString().trim()); } catch (Exception e) { return null; }
    }

    private static int asInt(Object v, int fallback) {
        if (v == null) return fallback;
        if (v instanceof Number n) return n.intValue();
        try { return Integer.parseInt(v.toString().trim()); } catch (Exception e) { return fallback; }
    }

    private static String str(Object v) {
        return v == null ? "" : v.toString().trim();
    }

    private static String normStatus(String status) {
        return in.sp.main.Service.WomenProductOrderLifecycleService.canonical(status);
    }
}
