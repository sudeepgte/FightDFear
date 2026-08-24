package in.sp.main.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import in.sp.main.Entities.PaymentFulfillment;
import in.sp.main.Entities.PaymentPendingOrder;
import in.sp.main.Entities.User;
import in.sp.main.Repository.PaymentFulfillmentRepository;
import in.sp.main.Repository.PaymentPendingOrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@Service
public class PaymentPendingOrderService {

    private static final long PENDING_TTL_MINUTES = 30;

    @Autowired
    private PaymentPendingOrderRepository pendingOrderRepository;

    @Autowired
    private PaymentFulfillmentRepository fulfillmentRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Transactional
    public void savePendingOrder(
            String orderId,
            User user,
            int amountPaise,
            String type,
            Long targetId,
            String consultationType,
            String appointmentTime,
            String reason) {
        expireStalePendingOrders();
        PaymentPendingOrder row = pendingOrderRepository.findByRazorpayOrderId(orderId).orElse(new PaymentPendingOrder());
        row.setRazorpayOrderId(orderId);
        row.setUserId(user.getId());
        row.setAmountPaise(amountPaise);
        row.setPaymentType(type);
        row.setTargetId(targetId);
        row.setConsultationType(consultationType);
        row.setAppointmentTime(appointmentTime);
        row.setReason(reason);
        row.setStatus("PENDING");
        row.setCreatedAt(LocalDateTime.now());
        row.setExpiresAt(LocalDateTime.now().plusMinutes(PENDING_TTL_MINUTES));
        pendingOrderRepository.save(row);
    }

    @Transactional(readOnly = true)
    public Optional<PaymentPendingOrder> findPendingForUser(String orderId, Long userId) {
        return pendingOrderRepository.findByRazorpayOrderId(orderId)
                .filter(p -> "PENDING".equalsIgnoreCase(p.getStatus()))
                .filter(p -> p.getExpiresAt() == null || p.getExpiresAt().isAfter(LocalDateTime.now()))
                .filter(p -> userId.equals(p.getUserId()));
    }

    @Transactional(readOnly = true)
    public Optional<PaymentPendingOrder> findByOrderId(String orderId) {
        return pendingOrderRepository.findByRazorpayOrderId(orderId);
    }

    @Transactional
    public void markFulfilled(PaymentPendingOrder pending, String paymentId) {
        pending.setStatus("FULFILLED");
        pending.setRazorpayPaymentId(paymentId);
        pending.setFulfilledAt(LocalDateTime.now());
        pendingOrderRepository.save(pending);
    }

    @Transactional(readOnly = true)
    public Optional<Map<String, Object>> findCachedFulfillmentResponse(String paymentId, String orderId) {
        Optional<PaymentFulfillment> byPayment = paymentId == null || paymentId.isBlank()
                ? Optional.empty()
                : fulfillmentRepository.findByRazorpayPaymentId(paymentId);
        Optional<PaymentFulfillment> byOrder = orderId == null || orderId.isBlank()
                ? Optional.empty()
                : fulfillmentRepository.findByRazorpayOrderId(orderId);
        PaymentFulfillment hit = byPayment.or(() -> byOrder).orElse(null);
        if (hit == null || hit.getResponseJson() == null || hit.getResponseJson().isBlank()) {
            return Optional.empty();
        }
        try {
            return Optional.of(objectMapper.readValue(hit.getResponseJson(), new TypeReference<>() {}));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Transactional
    public void recordFulfillment(
            String paymentId,
            String orderId,
            Long userId,
            String paymentType,
            Long targetId,
            int amountPaise,
            Map<String, Object> response) {
        if (fulfillmentRepository.findByRazorpayPaymentId(paymentId).isPresent()
                || fulfillmentRepository.findByRazorpayOrderId(orderId).isPresent()) {
            return;
        }
        PaymentFulfillment f = new PaymentFulfillment();
        f.setRazorpayPaymentId(paymentId);
        f.setRazorpayOrderId(orderId);
        f.setUserId(userId);
        f.setPaymentType(paymentType == null ? "UNKNOWN" : paymentType);
        f.setTargetId(targetId);
        f.setAmountPaise(amountPaise);
        try {
            f.setResponseJson(objectMapper.writeValueAsString(response));
        } catch (Exception e) {
            f.setResponseJson("{\"status\":\"success\"}");
        }
        fulfillmentRepository.save(f);
    }

    @Transactional
    public void expireStalePendingOrders() {
        pendingOrderRepository.expireOlderThan(LocalDateTime.now());
    }
}
