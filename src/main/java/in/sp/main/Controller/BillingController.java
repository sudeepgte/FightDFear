package in.sp.main.Controller;

import in.sp.main.Entities.Invoice;
import in.sp.main.Entities.InvoiceItem;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Service1;
import in.sp.main.Repository.InvoiceRepository;
import in.sp.main.Repository.ServiceRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/salon/billing")
public class BillingController {

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @GetMapping
    public String viewBillingDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<Invoice> invoices = invoiceRepository.findBySalonIdOrderByInvoiceDateDesc(loggedSalon.getId());
        List<Service1> salonServices = serviceRepository.findBySalonId(loggedSalon.getId());

        double todayRevenue = 0;
        int totalInvoices = invoices.size();
        
        for (Invoice inv : invoices) {
            if ("PAID".equals(inv.getPaymentStatus())) {
                todayRevenue += inv.getFinalTotal();
            }
        }

        model.addAttribute("invoices", invoices);
        model.addAttribute("salonServices", salonServices);
        model.addAttribute("todayRevenue", todayRevenue);
        model.addAttribute("totalInvoices", totalInvoices);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-billing";
    }

    @PostMapping("/create")
    public String createInvoice(@RequestParam("clientName") String clientName,
                                @RequestParam("clientPhone") String clientPhone,
                                @RequestParam("paymentMethod") String paymentMethod,
                                @RequestParam("serviceIds") List<Long> serviceIds,
                                @RequestParam(value = "discountAmount", defaultValue = "0") Double discountAmount,
                                @RequestParam(value = "taxAmount", defaultValue = "0") Double taxAmount,
                                HttpSession session) {
        
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Invoice invoice = new Invoice();
        invoice.setSalon(loggedSalon);
        invoice.setClientName(clientName);
        invoice.setClientPhone(clientPhone);
        invoice.setPaymentMethod(paymentMethod);
        invoice.setPaymentStatus("PAID");
        invoice.setDiscountAmount(discountAmount);
        invoice.setTaxAmount(taxAmount);
        
        // Generate random invoice number
        String invNum = "INV-" + System.currentTimeMillis() % 100000;
        invoice.setInvoiceNumber(invNum);

        List<InvoiceItem> items = new ArrayList<>();
        double subTotal = 0.0;

        for (Long sid : serviceIds) {
            serviceRepository.findById(sid).ifPresent(svc -> {
                InvoiceItem item = new InvoiceItem();
                item.setInvoice(invoice);
                item.setItemName(svc.getName());
                item.setQuantity(1);
                item.setUnitPrice(svc.getPrice());
                item.setTotalPrice(svc.getPrice());
                items.add(item);
            });
        }
        
        for(InvoiceItem i : items) {
            subTotal += i.getTotalPrice();
        }

        invoice.setItems(items);
        invoice.setSubTotal(subTotal);
        invoice.setFinalTotal((subTotal - discountAmount) + taxAmount);

        invoiceRepository.save(invoice);
        session.setAttribute("successMsg", "Invoice " + invNum + " created successfully!");

        return "redirect:/salon/billing";
    }
}
