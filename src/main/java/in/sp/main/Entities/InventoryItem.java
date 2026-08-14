package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "salon_inventory_items")
public class InventoryItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "salon_id", nullable = false)
    private Salon salon;

    private String itemName;
    private String sku;
    private String category;
    
    // "Professional" or "Retail"
    private String usageType;

    private int quantityInStock = 0;
    private int lowStockThreshold = 5;

    private double unitCost = 0.0;
    private double retailPrice = 0.0;
    
    private String supplierName;

    // Getters and Setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Salon getSalon() { return salon; }
    public void setSalon(Salon salon) { this.salon = salon; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getUsageType() { return usageType; }
    public void setUsageType(String usageType) { this.usageType = usageType; }

    public int getQuantityInStock() { return quantityInStock; }
    public void setQuantityInStock(int quantityInStock) { this.quantityInStock = quantityInStock; }

    public int getLowStockThreshold() { return lowStockThreshold; }
    public void setLowStockThreshold(int lowStockThreshold) { this.lowStockThreshold = lowStockThreshold; }

    public double getUnitCost() { return unitCost; }
    public void setUnitCost(double unitCost) { this.unitCost = unitCost; }

    public double getRetailPrice() { return retailPrice; }
    public void setRetailPrice(double retailPrice) { this.retailPrice = retailPrice; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    
    // Helper Method
    public String getStockStatus() {
        if (quantityInStock <= 0) return "OUT_OF_STOCK";
        if (quantityInStock <= lowStockThreshold) return "LOW_STOCK";
        return "IN_STOCK";
    }
}
