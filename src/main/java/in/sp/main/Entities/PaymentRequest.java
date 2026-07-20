package in.sp.main.Entities;

public class PaymentRequest {
    private Long userId;
    private Long centerId;
    private double amount;
    private String paymentMethod;  // Example: "Credit Card", "UPI", "Net Banking"

    // Constructors
    public PaymentRequest() {}

    public PaymentRequest(Long userId, Long centerId, double amount, String paymentMethod) {
        this.userId = userId;
        this.centerId = centerId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
    }

    // Getters and Setters
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCenterId() {
        return centerId;
    }

    public void setCenterId(Long centerId) {
        this.centerId = centerId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}
