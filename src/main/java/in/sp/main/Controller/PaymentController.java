package in.sp.main.Controller;

import in.sp.main.Entities.Expense;
import in.sp.main.Entities.Invoice;
import in.sp.main.Entities.Payout;
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.ExpenseRepository;
import in.sp.main.Repository.InvoiceRepository;
import in.sp.main.Repository.PayoutRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/salon/payments")
public class PaymentController {

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private PayoutRepository payoutRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @GetMapping
    public String viewPaymentsDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<Expense> expenses = expenseRepository.findBySalonIdOrderByExpenseDateDesc(loggedSalon.getId());
        List<Payout> payouts = payoutRepository.findBySalonIdOrderByPayoutDateDesc(loggedSalon.getId());
        List<Invoice> invoices = invoiceRepository.findBySalonIdOrderByInvoiceDateDesc(loggedSalon.getId());

        double totalRevenue = 0;
        for (Invoice inv : invoices) {
            if ("PAID".equals(inv.getPaymentStatus())) {
                totalRevenue += inv.getFinalTotal();
            }
        }

        double totalExpenses = 0;
        for (Expense exp : expenses) {
            totalExpenses += exp.getAmount();
        }
        
        double pendingPayouts = 0;
        for (Payout p : payouts) {
            if ("PENDING".equals(p.getStatus())) {
                pendingPayouts += p.getAmount();
            }
        }

        double netProfit = totalRevenue - totalExpenses;

        model.addAttribute("expenses", expenses);
        model.addAttribute("payouts", payouts);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("totalExpenses", totalExpenses);
        model.addAttribute("netProfit", netProfit);
        model.addAttribute("pendingPayouts", pendingPayouts);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-payments";
    }

    @PostMapping("/addExpense")
    public String addExpense(@RequestParam("category") String category,
                             @RequestParam("description") String description,
                             @RequestParam("amount") Double amount,
                             @RequestParam("expenseDate") String expenseDateStr,
                             HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Expense expense = new Expense();
        expense.setSalon(loggedSalon);
        expense.setCategory(category);
        expense.setDescription(description);
        expense.setAmount(amount);
        expense.setExpenseDate(LocalDate.parse(expenseDateStr));

        expenseRepository.save(expense);
        session.setAttribute("successMsg", "Expense added successfully.");

        return "redirect:/salon/payments";
    }

    @PostMapping("/requestPayout")
    public String requestPayout(@RequestParam("amount") Double amount,
                                HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Payout payout = new Payout();
        payout.setSalon(loggedSalon);
        payout.setAmount(amount);
        payout.setStatus("PENDING");
        payout.setPayoutDate(LocalDate.now());
        payout.setTransactionReference("REQ-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

        payoutRepository.save(payout);
        session.setAttribute("successMsg", "Payout request submitted to platform.");

        return "redirect:/salon/payments";
    }
}
