package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenCartItem;
import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.WomenCartItemRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import java.util.Map;

@Service
public class WomenProductOrderService {

    @Autowired
    private WomenProductOrderRepository orderRepository;

    @Autowired
    private WomenCartItemRepository cartRepository;

    @Autowired
    private AtomicStockService atomicStockService;

    @Autowired
    private WomenProductDeliveryService deliveryService;

    @Autowired
    private ProductDeliveryTrackingService trackingService;

    @Autowired
    private SellerNotificationService sellerNotificationService;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private EmailService emailService;

    @Transactional
    public List<Long> placeOrders(User user, List<WomenCartItem> items, String paymentMethod,
                                String address, String razorpayPaymentId, boolean clearCart) {
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User login required.");
        }
        if (items == null || items.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cart is empty.");
        }

        List<Long> orderIds = new ArrayList<>();
        String paymentStatus = "COD".equalsIgnoreCase(paymentMethod) ? "COD" : "PENDING";

        for (WomenCartItem ci : items) {
            if (ci.getProduct() == null || ci.getProduct().getId() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid product in cart.");
            }
            int finalQty = ci.getQuantity() == null || ci.getQuantity() < 1 ? 1 : ci.getQuantity();

            // Pessimistically locks row, validates stock, and decrements atomically
            WomenProduct lockedProduct = atomicStockService.decrementStock(ci.getProduct().getId(), finalQty);


            WomenProductOrder order = new WomenProductOrder();
            order.setUser(user);
            order.setProduct(lockedProduct);
            order.setSeller(lockedProduct.getSeller());
            order.setQuantity(finalQty);
            order.setTotalPrice((lockedProduct.getPrice() == null ? 0.0 : lockedProduct.getPrice()) * finalQty);
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus(paymentStatus);
            order.setShippingAddress(address);
            order.setStatus("PLACED");
            if (razorpayPaymentId != null && !razorpayPaymentId.isBlank()) {
                order.setRazorpayPaymentId(razorpayPaymentId.trim());
            }
            java.time.LocalDateTime placedAt = java.time.LocalDateTime.now();
            order.setOrderTime(placedAt);
            order.setExpectedDeliveryDate(deliveryService
                    .calculateExpectedDeliveryDate(placedAt, address, lockedProduct, finalQty)
                    .atStartOfDay());

            orderRepository.save(order);
            if (trackingService != null) {
                try {
                    trackingService.ensureGeocoded(order);
                } catch (Exception ignored) {
                }
            }
            orderIds.add(order.getId());

            // Notify Seller
            WomenProductSeller seller = lockedProduct.getSeller();
            String clientName = user.getFullName() != null && !user.getFullName().isBlank() ? user.getFullName() : "Customer";
            String productName = lockedProduct.getName() != null ? lockedProduct.getName() : "Product";
            double orderTotal = order.getTotalPrice() != null ? order.getTotalPrice() : 0.0;
            if (seller != null && sellerNotificationService != null) {
                sellerNotificationService.notifySeller(
                        seller,
                        "ORDER_PLACED",
                        "New Order: " + productName,
                        "Customer " + clientName + " placed order #" + order.getId() + " for " + productName + " (Qty: " + finalQty + ", ₹" + String.format("%.2f", orderTotal) + ").",
                        order.getId(),
                        true
                );
            }

            // Notify User
            if (pushNotificationService != null) {
                pushNotificationService.notifyUser(
                        user.getId(),
                        "Order Placed Successfully!",
                        "Your order #" + order.getId() + " for " + productName + " (₹" + String.format("%.2f", orderTotal) + ") has been received.",
                        Map.of("type", "PRODUCT_ORDER_PLACED", "orderId", String.valueOf(order.getId()))
                );
            }
            if (emailService != null && user.getEmail() != null && !user.getEmail().isBlank()) {
                try {
                    emailService.sendEmail(
                            user.getEmail(),
                            "Order Confirmation: #" + order.getId(),
                            "Hello " + clientName + ",\n\nThank you for your order!\n\nOrder #" + order.getId()
                                    + " for " + productName + " (Qty: " + finalQty + ", Total: ₹" + String.format("%.2f", orderTotal)
                                    + ") has been received and is being processed by the seller.\n\nDelivery Address:\n" + address
                                    + "\n\nThank you,\nFight D Fear"
                    );
                } catch (Exception ignored) {}
            }
        }


        if (clearCart) {
            cartRepository.deleteByUser(user);
        }


        return orderIds;
    }
}
