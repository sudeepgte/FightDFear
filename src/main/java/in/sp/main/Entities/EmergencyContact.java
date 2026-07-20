package in.sp.main.Entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class EmergencyContact {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String phone;
    private String relation;
    private String email;
    
    // Default police and ambulance numbers
    private String policeNumber = "100";  // Default Police number
    private String ambulanceNumber = "108";  // Default Ambulance number

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    // No-argument constructor (required by Hibernate)
    public EmergencyContact() {
    }

	// Constructor with all parameters
    public EmergencyContact(String name, String phone, String relation, String email) {
        this.name = name;
        this.phone = phone;
        this.relation = relation;
        this.email = email;
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

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getRelation() {
		return relation;
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

    public String getPoliceNumber() {
		return policeNumber;
	}

	public void setPoliceNumber(String policeNumber) {
		this.policeNumber = policeNumber;
	}

	public String getAmbulanceNumber() {
		return ambulanceNumber;
	}

	public void setAmbulanceNumber(String ambulanceNumber) {
		this.ambulanceNumber = ambulanceNumber;
	}
    
}
