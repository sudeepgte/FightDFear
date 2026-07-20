package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "`services`")
public class StylistService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name; // e.g., Facial, Haircut, Massage
    private Double price;
    private Integer durationMinutes; // duration in minutes

    // Optional info for clients
    private String ingredients;
    private String allergenInfo;

    // Relation to Salon (optional if needed)
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;

    // Relation to Stylist
    @ManyToOne
    @JoinColumn(name = "stylist_id")
    private Stylist stylist;

    // Constructors
    public StylistService() {}

    public StylistService(String name, Double price, Integer durationMinutes, String ingredients, String allergenInfo, Stylist stylist, Salon salon) {
        this.name = name;
        this.price = price;
        this.durationMinutes = durationMinutes;
        this.ingredients = ingredients;
        this.allergenInfo = allergenInfo;
        this.stylist = stylist;
        this.salon = salon;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public String getAllergenInfo() {
        return allergenInfo;
    }

    public void setAllergenInfo(String allergenInfo) {
        this.allergenInfo = allergenInfo;
    }

    public Salon getSalon() {
        return salon;
    }

    public void setSalon(Salon salon) {
        this.salon = salon;
    }

    public Stylist getStylist() {
        return stylist;
    }

    public void setStylist(Stylist stylist) {
        this.stylist = stylist;
    }
}
