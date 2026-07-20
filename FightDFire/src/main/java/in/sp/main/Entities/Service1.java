package in.sp.main.Entities;
 
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import in.sp.main.Entities.ServiceCategory;
 
@Entity
@Table(name = "services")
public class Service1 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    @Enumerated(EnumType.STRING)
    private ServiceCategory category;  // select only from predefined categories
 
  
 
	private String name; // Facial, Haircut, Massage
    private Double price;
    private Integer durationMinutes;
 
    // Product / ingredients info
    private String ingredients;
    private String allergenInfo;
 
    @ManyToOne
    @JoinColumn(name = "salon_id")
    private Salon salon;

 
    @ManyToOne
    @JoinColumn(name = "stylist_id")
    private Stylist stylist;
    private String photoUrl;
 
    @Enumerated(EnumType.STRING)
    private SkinType skinType; // only for skin treatments
 
	public SkinType getSkinType() {
		return skinType;
	}
 
	public void setSkinType(SkinType skinType) {
		this.skinType = skinType;
	}
 
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
	  public ServiceCategory getCategory() {
			return category;
		}
 
		public void setCategory(ServiceCategory category) {
			this.category = category;
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
	public String getPhotoUrl() {
        return photoUrl;
    }
 
    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }
 
    // getters & setters
}