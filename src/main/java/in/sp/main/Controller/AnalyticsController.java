package in.sp.main.Controller;

import in.sp.main.Entities.Booking;
import in.sp.main.Entities.Expense;
import in.sp.main.Entities.InventoryItem;
import in.sp.main.Entities.Invoice;
import in.sp.main.Entities.InvoiceItem;
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.BookingRepository;
import in.sp.main.Repository.ExpenseRepository;
import in.sp.main.Repository.InventoryItemRepository;
import in.sp.main.Repository.InvoiceRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/salon/analytics")
public class AnalyticsController {

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private InventoryItemRepository inventoryItemRepository;

    @GetMapping
    public String viewAnalyticsDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Long salonId = loggedSalon.getId();

        // 1. Calculate Gross Revenue from Invoices
        List<Invoice> invoices = invoiceRepository.findBySalonIdOrderByInvoiceDateDesc(salonId);
        double grossRevenue = 0.0;
        int totalInvoices = 0;
        
        Map<String, Integer> popularServices = new HashMap<>();
        
        for (Invoice inv : invoices) {
            if ("PAID".equals(inv.getPaymentStatus())) {
                grossRevenue += inv.getFinalTotal();
                totalInvoices++;
                
                // Track popular services
                if (inv.getItems() != null) {
                    for (InvoiceItem item : inv.getItems()) {
                        popularServices.put(item.getItemName(), popularServices.getOrDefault(item.getItemName(), 0) + item.getQuantity());
                    }
                }
            }
        }

        // Top 5 Popular Services
        List<Map.Entry<String, Integer>> topServices = popularServices.entrySet().stream()
                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                .limit(5)
                .collect(Collectors.toList());

        // 2. Calculate Total Expenses
        List<Expense> expenses = expenseRepository.findBySalonIdOrderByExpenseDateDesc(salonId);
        double totalExpenses = 0.0;
        for (Expense exp : expenses) {
            totalExpenses += exp.getAmount();
        }

        // 3. Calculate Net Profit
        double netProfit = grossRevenue - totalExpenses;

        // 4. Calculate Total App Bookings (Online)
        List<Booking> bookings = bookingRepository.findBySalonId(salonId);
        long completedBookings = bookings.stream().filter(b -> b.getStatus() != null && "Completed".equalsIgnoreCase(b.getStatus().name())).count();
        long pendingBookings = bookings.stream().filter(b -> b.getStatus() != null && "Pending".equalsIgnoreCase(b.getStatus().name())).count();

        // 5. Calculate Total Inventory Value
        List<InventoryItem> inventory = inventoryItemRepository.findBySalonIdOrderByIdDesc(salonId);
        double totalInventoryValue = 0.0;
        for (InventoryItem item : inventory) {
            totalInventoryValue += (item.getQuantityInStock() * item.getUnitCost());
        }

        model.addAttribute("grossRevenue", grossRevenue);
        model.addAttribute("totalExpenses", totalExpenses);
        model.addAttribute("netProfit", netProfit);
        model.addAttribute("totalInvoices", totalInvoices);
        model.addAttribute("completedBookings", completedBookings);
        model.addAttribute("pendingBookings", pendingBookings);
        model.addAttribute("totalInventoryValue", totalInventoryValue);
        model.addAttribute("topServices", topServices);

        return "salon/salon-analytics";
    }
}
