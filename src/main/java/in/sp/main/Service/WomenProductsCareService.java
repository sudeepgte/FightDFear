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
        return orderRepository.save(o);
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
        if (o == null || Boolean.TRUE.equals(o.getSellerPayoutCredited())) return;
        WomenProductSeller s = o.getSeller();
        if (s == null) return;
        double amount = o.getTotalPrice() == null ? 0 : o.getTotalPrice();
        if (amount <= 0) return;
        s.setPayoutBalance(s.getPayoutBalance() + amount);
        sellerRepository.save(s);
        o.setSellerPayoutCredited(true);
        orderRepository.save(o);
    }

    @Transactional
    public void creditDelivery(WomenProductOrder o) {
        if (o == null || Boolean.TRUE.equals(o.getDeliveryPayoutCredited())) return;
        DeliveryPartner p = o.getDeliveryPartner();
        if (p == null) return;
        double total = o.getTotalPrice() == null ? 0 : o.getTotalPrice();
        double fee = Math.max(30, Math.round(total * 0.10));
        p.setPayoutBalance(p.getPayoutBalance() + fee);
        deliveryRepository.save(p);
        o.setDeliveryPayoutCredited(true);
        orderRepository.save(o);
        if (o.getUser() != null) {
            pushNotificationService.notifyUser(
                    o.getUser().getId(),
                    "Order delivered",
                    "Your Women Products order has been delivered.",
                    Map.of("type", "WOMEN_PRODUCT_DELIVERED", "orderId", String.valueOf(o.getId())));
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
