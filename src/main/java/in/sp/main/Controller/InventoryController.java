package in.sp.main.Controller;

import in.sp.main.Entities.InventoryItem;
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.InventoryItemRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/salon/inventory")
public class InventoryController {

    @Autowired
    private InventoryItemRepository inventoryItemRepository;

    @GetMapping
    public String viewInventoryDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<InventoryItem> items = inventoryItemRepository.findBySalonIdOrderByIdDesc(loggedSalon.getId());

        int totalItems = items.size();
        int lowStockCount = 0;
        int outOfStockCount = 0;
        double totalValue = 0;

        for (InventoryItem item : items) {
            String status = item.getStockStatus();
            if (status.equals("LOW_STOCK")) lowStockCount++;
            if (status.equals("OUT_OF_STOCK")) outOfStockCount++;
            totalValue += (item.getQuantityInStock() * item.getUnitCost());
        }

        model.addAttribute("items", items);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("outOfStockCount", outOfStockCount);
        model.addAttribute("totalValue", totalValue);

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-inventory";
    }

    @PostMapping("/addItem")
    public String addItem(@RequestParam("itemName") String itemName,
                          @RequestParam("sku") String sku,
                          @RequestParam("category") String category,
                          @RequestParam("usageType") String usageType,
                          @RequestParam("quantityInStock") int quantityInStock,
                          @RequestParam("lowStockThreshold") int lowStockThreshold,
                          @RequestParam("unitCost") double unitCost,
                          @RequestParam("retailPrice") double retailPrice,
                          @RequestParam("supplierName") String supplierName,
                          HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        InventoryItem item = new InventoryItem();
        item.setSalon(loggedSalon);
        item.setItemName(itemName);
        item.setSku(sku);
        item.setCategory(category);
        item.setUsageType(usageType);
        item.setQuantityInStock(quantityInStock);
        item.setLowStockThreshold(lowStockThreshold);
        item.setUnitCost(unitCost);
        item.setRetailPrice(retailPrice);
        item.setSupplierName(supplierName);

        inventoryItemRepository.save(item);
        session.setAttribute("successMsg", "Item added to inventory successfully.");

        return "redirect:/salon/inventory";
    }

    @PostMapping("/updateStock")
    public String updateStock(@RequestParam("itemId") Long itemId,
                              @RequestParam("stockAdjustment") int stockAdjustment,
                              HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<InventoryItem> itemOpt = inventoryItemRepository.findById(itemId);
        if (itemOpt.isPresent() && itemOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            InventoryItem item = itemOpt.get();
            int newQty = item.getQuantityInStock() + stockAdjustment;
            item.setQuantityInStock(newQty < 0 ? 0 : newQty);
            inventoryItemRepository.save(item);
            session.setAttribute("successMsg", "Stock updated successfully for " + item.getItemName());
        }

        return "redirect:/salon/inventory";
    }

    @PostMapping("/deleteItem")
    public String deleteItem(@RequestParam("itemId") Long itemId, HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        Optional<InventoryItem> itemOpt = inventoryItemRepository.findById(itemId);
        if (itemOpt.isPresent() && itemOpt.get().getSalon().getId().equals(loggedSalon.getId())) {
            inventoryItemRepository.delete(itemOpt.get());
            session.setAttribute("successMsg", "Item deleted from inventory.");
        }

        return "redirect:/salon/inventory";
    }
}
