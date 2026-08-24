package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.DeliveryPartnerRepository;
import in.sp.main.Repository.WomenProductOrderRepository;
import in.sp.main.Repository.WomenProductRepository;

/**
 * Women Products order lifecycle, inventory deduction, and delivery assignment.
 * Extends existing statuses; does not replace stored values on historical orders.
 */
@Service
public class WomenProductOrderLifecycleService {

    public static final String PLACED = "PLACED";
    public static final String CONFIRMED = "CONFIRMED";
    public static final String PROCESSING = "PROCESSING";
    public static final String PACKED = "PACKED";
    public static final String READY_FOR_PICKUP = "READY_FOR_PICKUP";
    public static final String ASSIGNED = "ASSIGNED";
    public static final String PICKED_UP = "PICKED_UP";
    public static final String IN_TRANSIT = "IN_TRANSIT";
    public static final String SHIPPED = "SHIPPED";
    public static final String OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY";
    public static final String DELIVERED = "DELIVERED";
    public static final String CANCELLED = "CANCELLED";

    private static final Set<String> PRE_ASSIGN_CANCEL = Set.of(
            PLACED, CONFIRMED, PROCESSING, PACKED, READY_FOR_PICKUP);

    @Autowired
    private WomenProductOrderRepository orderRepository;
    @Autowired
    private WomenProductRepository productRepository;
    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;
    @Autowired
    private WomenProductsCareService productsCareService;
    @Autowired
    private ProductDeliveryTrackingService trackingService;

    /**
     * Normalizes aliases without collapsing distinct delivery stages.
     * PENDING → PLACED. Legacy SHIPPED stays SHIPPED (in-transit era).
     */
    public static String canonical(String status) {
        if (status == null || status.isBlank()) return PLACED;
        String s = status.trim().toUpperCase(Locale.ROOT);
        if ("PENDING".equals(s) || "ORDER_PLACED".equals(s)) return PLACED;
        if ("PICKEDUP".equals(s)) return PICKED_UP;
        return s;
    }

    public static int rank(String status) {
        return switch (canonical(status)) {
            case PLACED -> 0;
            case CONFIRMED -> 1;
            case PROCESSING -> 2;
            case PACKED -> 3;
            case READY_FOR_PICKUP -> 4;
            case ASSIGNED -> 5;
            case PICKED_UP, SHIPPED -> 6;
            case IN_TRANSIT -> 7;
            case OUT_FOR_DELIVERY -> 8;
            case DELIVERED -> 9;
            case CANCELLED -> -1;
            default -> 0;
        };
    }

    public static boolean isTerminal(String status) {
        String c = canonical(status);
        return DELIVERED.equals(c) || CANCELLED.equals(c);
    }

    public static boolean canCancel(WomenProductOrder o) {
        if (o == null) return false;
        if (o.getDeliveryPartner() != null) return false;
        String c = canonical(o.getStatus());
        return PRE_ASSIGN_CANCEL.contains(c);
    }

    public static boolean isLiveDelivery(String status) {
        String c = canonical(status);
        return ASSIGNED.equals(c) || PICKED_UP.equals(c) || SHIPPED.equals(c)
                || IN_TRANSIT.equals(c) || OUT_FOR_DELIVERY.equals(c);
    }

    public static List<String> sellerNextStatuses(String current) {
        return switch (canonical(current)) {
            case PLACED -> List.of(CONFIRMED, CANCELLED);
            case CONFIRMED -> List.of(PROCESSING, READY_FOR_PICKUP, CANCELLED);
            case PROCESSING -> List.of(PACKED, READY_FOR_PICKUP, CANCELLED);
            case PACKED -> List.of(READY_FOR_PICKUP, CANCELLED);
            case READY_FOR_PICKUP -> List.of(CANCELLED);
            default -> List.of();
        };
    }

    public static List<String> deliveryNextStatuses(String current) {
        return switch (canonical(current)) {
            case ASSIGNED -> List.of(PICKED_UP, OUT_FOR_DELIVERY);
            case PICKED_UP -> List.of(IN_TRANSIT);
            case SHIPPED, IN_TRANSIT -> List.of(OUT_FOR_DELIVERY);
            case OUT_FOR_DELIVERY -> List.of(DELIVERED);
            default -> List.of();
        };
    }

    public static boolean sellerMaySet(String current, String requested) {
        String next = mapSellerRequest(requested);
        return sellerNextStatuses(current).contains(next);
    }

    public static boolean deliveryMaySet(String current, String requested) {
        String next = mapDeliveryRequest(requested);
        return deliveryNextStatuses(current).contains(next);
    }

    /** Seller SHIPPED historically meant packed for pickup. */
    public static String mapSellerRequest(String requested) {
        String s = canonical(requested);
        if (SHIPPED.equals(s) || "IN_TRANSIT".equals(s)) return READY_FOR_PICKUP;
        return s;
    }

    public static String mapDeliveryRequest(String requested) {
        return canonical(requested);
    }

    public static boolean canAssign(WomenProductOrder o) {
        if (o == null || isTerminal(o.getStatus())) return false;
        if (o.getDeliveryPartner() != null) return false;
        return READY_FOR_PICKUP.equals(canonical(o.getStatus()));
    }

    public static boolean isEligibleDeliveryPartner(DeliveryPartner p) {
        if (p == null || p.isSuspended()) return false;
        if (p.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED) return true;
        return p.getPartnerProfileStatus() == null
                && p.getVerificationStatus() == VerificationStatus.VERIFIED;
    }

    public static String displayLabel(String status) {
        return switch (canonical(status)) {
            case PLACED -> "Order Placed";
            case CONFIRMED -> "Confirmed";
            case PROCESSING -> "Processing";
            case PACKED -> "Packed";
            case READY_FOR_PICKUP -> "Ready for Pickup";
            case ASSIGNED -> "Assigned";
            case PICKED_UP -> "Picked Up";
            case SHIPPED -> "Shipped";
            case IN_TRANSIT -> "In Transit";
            case OUT_FOR_DELIVERY -> "Out for Delivery";
            case DELIVERED -> "Delivered";
            case CANCELLED -> "Cancelled";
            default -> canonical(status);
        };
    }

    public static List<Map<String, String>> trackingSteps(String status) {
        String c = canonical(status);
        if (CANCELLED.equals(c)) return List.of();
        int r = rank(c);
        int[] activeAt = {0, 1, 2, 3, 4, 8, 9};
        String[] labels = {
                "Order Placed", "Confirmed", "Processing", "Packed", "Shipped", "Out for Delivery", "Delivered"};
        String[] keys = {PLACED, CONFIRMED, PROCESSING, PACKED, READY_FOR_PICKUP, OUT_FOR_DELIVERY, DELIVERED};
        List<Map<String, String>> out = new ArrayList<>();
        for (int i = 0; i < keys.length; i++) {
            Map<String, String> row = new LinkedHashMap<>();
            row.put("key", keys[i]);
            row.put("label", labels[i]);
            int start = activeAt[i];
            int end = i + 1 < activeAt.length ? activeAt[i + 1] : 10;
            if (i == keys.length - 1) {
                row.put("state", r >= 9 ? "completed" : "");
            } else if (r >= end) {
                row.put("state", "completed");
            } else if (r >= start) {
                row.put("state", "active");
            } else {
                row.put("state", "");
            }
            out.add(row);
        }
        return out;
    }

    public void decrementStock(WomenProduct product, int qty) {
        if (product == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "A product in your order is unavailable.");
        }
        if (qty < 1) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid quantity.");
        }
        int stock = product.getStock() == null ? 0 : product.getStock();
        if (stock <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Product '" + product.getName() + "' is out of stock.");
        }
        if (qty > stock) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Only " + stock + " unit(s) available for '" + product.getName() + "'.");
        }
        product.setStock(stock - qty);
        productRepository.save(product);
    }

    public void applyStockUpdate(WomenProduct product, int stock) {
        if (product == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Product not found.");
        }
        if (stock < 0 || stock > WomenProduct.STOCK_MAX) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Stock quantity must be between 0 and " + WomenProduct.STOCK_MAX + ".");
        }
        product.setStock(stock);
        productRepository.save(product);
    }

    @Transactional
    public WomenProductOrder applySellerStatus(WomenProductOrder order, WomenProductSeller seller, String requested) {
        requireSellerOwns(order, seller);
        String next = mapSellerRequest(requested);
        if (CANCELLED.equals(next)) {
            if (!canCancel(order)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, WomenProductsCareService.CANCEL_POLICY);
            }
            return productsCareService.cancel(order, "seller");
        }
        if (!sellerMaySet(order.getStatus(), next)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Invalid order status transition from " + displayLabel(order.getStatus())
                            + " to " + displayLabel(next) + ".");
        }
        if (CONFIRMED.equals(next)) {
            order.setTrackingNote("Seller confirmed the order");
        } else if (PROCESSING.equals(next)) {
            order.setTrackingNote("Seller is processing the order");
        } else if (PACKED.equals(next)) {
            order.setTrackingNote("Order packed");
        } else if (READY_FOR_PICKUP.equals(next)) {
            order.setTrackingNote("Packed and ready for delivery pickup");
        }
        order.setStatus(next);
        orderRepository.save(order);
        if (READY_FOR_PICKUP.equals(next)) {
            trackingService.ensureGeocoded(order);
        }
        return order;
    }

    @Transactional
    public WomenProductOrder assignDeliveryPartner(WomenProductOrder order, WomenProductSeller seller,
                                                   Long partnerId) {
        requireSellerOwns(order, seller);
        if (!canAssign(order)) {
            if (order.getDeliveryPartner() != null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order is already assigned.");
            }
            if (isTerminal(order.getStatus())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        CANCELLED.equals(canonical(order.getStatus()))
                                ? "Cancelled orders cannot be assigned."
                                : "Order already delivered.");
            }
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Only orders marked ready for pickup can be assigned to a delivery partner.");
        }
        if (partnerId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Select a delivery partner.");
        }
        DeliveryPartner partner = deliveryPartnerRepository.findById(partnerId).orElse(null);
        if (!isEligibleDeliveryPartner(partner)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Delivery partner is not available.");
        }
        return attachPartner(order, partner);
    }

    @Transactional
    public WomenProductOrder acceptByPartner(WomenProductOrder order, DeliveryPartner partner) {
        if (order == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order not found");
        }
        if (order.getDeliveryPartner() != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This order is already assigned.");
        }
        if (!READY_FOR_PICKUP.equals(canonical(order.getStatus()))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Only packed orders ready for pickup can be accepted.");
        }
        if (!isEligibleDeliveryPartner(partner)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Your profile must be approved before you can accept deliveries.");
        }
        return attachPartner(order, partner);
    }

    @Transactional
    public WomenProductOrder applyDeliveryStatus(WomenProductOrder order, DeliveryPartner partner, String requested) {
        requirePartnerOwns(order, partner);
        String next = mapDeliveryRequest(requested);
        if (!deliveryMaySet(order.getStatus(), next)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Invalid status change from " + displayLabel(order.getStatus())
                            + " to " + displayLabel(next) + ".");
        }
        order.setStatus(next);
        if (PICKED_UP.equals(next) || OUT_FOR_DELIVERY.equals(next)) {
            if (order.getPickedUpAt() == null) {
                order.setPickedUpAt(LocalDateTime.now());
            }
            order.setTrackingNote(PICKED_UP.equals(next) ? "Picked up" : "Out for delivery");
        }
        if (IN_TRANSIT.equals(next)) {
            order.setTrackingNote("In transit");
        }
        if (DELIVERED.equals(next)) {
            order.setDeliveredAt(LocalDateTime.now());
            order.setTrackingNote("Delivered");
            orderRepository.save(order);
            if ("COD".equalsIgnoreCase(order.getPaymentMethod()) || "COD".equalsIgnoreCase(order.getPaymentStatus())) {
                productsCareService.creditSeller(order);
            }
            productsCareService.creditDelivery(order);
        }
        orderRepository.save(order);
        trackingService.ensureGeocoded(order);
        trackingService.refreshRouteIfNeeded(order, true);
        return order;
    }

    public List<DeliveryPartner> listAssignablePartners() {
        List<DeliveryPartner> out = new ArrayList<>();
        for (DeliveryPartner p : deliveryPartnerRepository.findByPartnerProfileStatusIn(
                List.of(PartnerProfileStatus.APPROVED))) {
            if (isEligibleDeliveryPartner(p)) out.add(p);
        }
        for (DeliveryPartner p : deliveryPartnerRepository.findByPartnerProfileStatusIsNull()) {
            if (isEligibleDeliveryPartner(p)) out.add(p);
        }
        return out;
    }

    private WomenProductOrder attachPartner(WomenProductOrder order, DeliveryPartner partner) {
        order.setDeliveryPartner(partner);
        order.setStatus(ASSIGNED);
        order.setAssignedAt(LocalDateTime.now());
        order.setTrackingNote("Delivery partner assigned");
        orderRepository.save(order);
        trackingService.ensureGeocoded(order);
        return order;
    }

    private static void requireSellerOwns(WomenProductOrder order, WomenProductSeller seller) {
        if (order == null || seller == null || order.getSeller() == null
                || !order.getSeller().getId().equals(seller.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order not found");
        }
    }

    private static void requirePartnerOwns(WomenProductOrder order, DeliveryPartner partner) {
        if (order == null || partner == null || order.getDeliveryPartner() == null
                || !order.getDeliveryPartner().getId().equals(partner.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order not found");
        }
    }
}
