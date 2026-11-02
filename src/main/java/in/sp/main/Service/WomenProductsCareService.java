package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.DeliveryPartnerRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Repository.WomenProductRepository;
import in.sp.main.Repository.WomenProductSellerRepository;

@Service
public class WomenProductsCareService {

    public static final String CANCEL_POLICY =
            "Free cancellation until the order is packed and assigned to a delivery partner.";

    @Autowired
    private WomenProductSellerRepository sellerRepository;
    @Autowired
    private DeliveryPartnerRepository deliveryRepository;
    @Autowired
    private WomenProductOrderRepository orderRepository;
    @Autowired
    private WomenProductRepository productRepository;
    @Autowired
    private PushNotificationService pushNotificationService;
    @Autowired
    private EmailService emailService;
    @Autowired
    private SellerNotificationService sellerNotificationService;

    public static String normStatus(String status) {
        return WomenProductOrderLifecycleService.canonical(status);
    }

    public boolean canCancel(WomenProductOrder o) {
        return WomenProductOrderLifecycleService.canCancel(o);
    }

    @Transactional
    public WomenProductOrder cancel(WomenProductOrder o, String by) {
        if (o == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order not found");
        if (!canCancel(o)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, CANCEL_POLICY);
        }
        restoreStock(o);
        o.setStatus("CANCELLED");
        o.setTrackingNote("Cancelled by " + (by == null ? "user" : by));
        WomenProductOrder saved = orderRepository.save(o);

        // Cancellation notifications
        try {
            WomenProductSeller seller = saved.getSeller();
            in.sp.main.Entities.User user = saved.getUser();
            String productName = saved.getProduct() != null && saved.getProduct().getName() != null
                    ? saved.getProduct().getName() : "Product";
            boolean isUserCancel = "user".equalsIgnoreCase(by);

            if (seller != null && sellerNotificationService != null) {
                sellerNotificationService.notifySeller(
                        seller,
                        "ORDER_CANCELLED",
                        "Order #" + saved.getId() + " Cancelled",
                        (isUserCancel ? "Customer cancelled" : "Cancelled") + " order #" + saved.getId() + " for " + productName + ".",
                        saved.getId(),
                        isUserCancel
                );
            }

            if (user != null && pushNotificationService != null) {
                pushNotificationService.notifyUser(
                        user.getId(),
                        "Order Cancelled",
                        "Your order #" + saved.getId() + " for " + productName + " was cancelled.",
                        Map.of("type", "PRODUCT_ORDER_CANCELLED", "orderId", String.valueOf(saved.getId()))
                );
                if (emailService != null && user.getEmail() != null && !user.getEmail().isBlank()) {
                    try {
                        String clientName = user.getFullName() != null ? user.getFullName() : "Customer";
                        emailService.sendEmail(
                                user.getEmail(),
                                "Order Cancelled: #" + saved.getId(),
                                "Hello " + clientName + ",\n\nYour order #" + saved.getId() + " for " + productName
                                        + " has been cancelled.\n\nIf you have any questions, feel free to reach out to our support.\n\nThank you,\nFight D Fear"
                        );
                    } catch (Exception ignored) {}
                }
            }
        } catch (Exception ignored) {}

        return saved;
    }

    public void restoreStock(WomenProductOrder order) {
        WomenProduct p = order.getProduct();
        if (p == null) return;
        int qty = order.getQuantity() == null ? 0 : order.getQuantity();
        int stock = p.getStock() == null ? 0 : p.getStock();
        p.setStock(stock + Math.max(qty, 0));
        productRepository.save(p);
    }

    @Transactional
    public void creditSeller(WomenProductOrder o) {
        if (o == null || o.getId() == null || Boolean.TRUE.equals(o.getSellerPayoutCredited())) return;
        WomenProductOrder order = orderRepository.findByIdForUpdate(o.getId()).orElse(o);
        if (Boolean.TRUE.equals(order.getSellerPayoutCredited())) return;
        WomenProductSeller s = order.getSeller();
        if (s == null || s.getId() == null) return;
        double amount = order.getTotalPrice() == null ? 0 : order.getTotalPrice();
        if (amount <= 0) return;
        WomenProductSeller lockedSeller = sellerRepository.findByIdForUpdate(s.getId()).orElse(s);
        lockedSeller.setPayoutBalance(lockedSeller.getPayoutBalance() + amount);
        sellerRepository.save(lockedSeller);
        order.setSellerPayoutCredited(true);
        orderRepository.save(order);
    }

    @Transactional
    public void creditDelivery(WomenProductOrder o) {
        if (o == null || o.getId() == null || Boolean.TRUE.equals(o.getDeliveryPayoutCredited())) return;
        WomenProductOrder order = orderRepository.findByIdForUpdate(o.getId()).orElse(o);
        if (Boolean.TRUE.equals(order.getDeliveryPayoutCredited())) return;
        DeliveryPartner p = order.getDeliveryPartner();
        if (p == null || p.getId() == null) return;
        double total = order.getTotalPrice() == null ? 0 : order.getTotalPrice();
        double fee = Math.max(30, Math.round(total * 0.10));
        DeliveryPartner lockedPartner = deliveryRepository.findByIdForUpdate(p.getId()).orElse(p);
        lockedPartner.setPayoutBalance(lockedPartner.getPayoutBalance() + fee);
        deliveryRepository.save(lockedPartner);
        order.setDeliveryPayoutCredited(true);
        orderRepository.save(order);
        if (order.getUser() != null) {
            pushNotificationService.notifyUser(
                    order.getUser().getId(),
                    "Order delivered",
                    "Your Women Products order has been delivered.",
                    Map.of("type", "WOMEN_PRODUCT_DELIVERED", "orderId", String.valueOf(order.getId())));
        }
    }

    @Transactional
    public Map<String, Object> requestSellerPayout(WomenProductSeller s) {
        if (s == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Seller profile required");
        if (PartnerLifecycleSupport.blank(s.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = s.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        s.setPayoutRequestedAt(LocalDateTime.now());
        sellerRepository.save(s);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + s.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", s.getUpiId());
        return m;
    }

    @Transactional
    public Map<String, Object> requestDeliveryPayout(DeliveryPartner p) {
        if (p == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Delivery profile required");
        if (PartnerLifecycleSupport.blank(p.getUpiId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Add a UPI ID before requesting payout.");
        }
        double bal = p.getPayoutBalance();
        if (bal < 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Minimum payout is ₹100.");
        }
        p.setPayoutRequestedAt(LocalDateTime.now());
        deliveryRepository.save(p);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("message", "Payout of ₹" + Math.round(bal) + " requested to " + p.getUpiId());
        m.put("payoutBalance", bal);
        m.put("upiId", p.getUpiId());
        return m;
    }
}
