package in.sp.main.dto;

import java.util.List;
import java.util.Map;

public class PaymentResponseDTO {
    private double totalPaid;
    private double pendingAmount;
    private String nextDueDate;
    private List<Map<String, Object>> transactions;

    public PaymentResponseDTO() {}

    public PaymentResponseDTO(double totalPaid, double pendingAmount, String nextDueDate, List<Map<String, Object>> transactions) {
        this.totalPaid = totalPaid;
        this.pendingAmount = pendingAmount;
        this.nextDueDate = nextDueDate;
        this.transactions = transactions;
    }

    public double getTotalPaid() { return totalPaid; }
    public void setTotalPaid(double totalPaid) { this.totalPaid = totalPaid; }

    public double getPendingAmount() { return pendingAmount; }
    public void setPendingAmount(double pendingAmount) { this.pendingAmount = pendingAmount; }

    public String getNextDueDate() { return nextDueDate; }
    public void setNextDueDate(String nextDueDate) { this.nextDueDate = nextDueDate; }

    public List<Map<String, Object>> getTransactions() { return transactions; }
    public void setTransactions(List<Map<String, Object>> transactions) { this.transactions = transactions; }
}
