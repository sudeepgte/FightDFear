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
import in.sp.main.Repository.WomenCartItemRepository;
import in.sp.main.Repository.WomenProductOrderRepository;

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
        }


        if (clearCart) {
            cartRepository.deleteByUser(user);
        }


        return orderIds;
    }
}
