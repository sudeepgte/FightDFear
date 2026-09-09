package in.sp.main.Entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "admin")
public class Admin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String email;
    /** Stored as BCrypt — do not put plaintext @Pattern here (breaks login upgrade). */
    private String password;
    private String profilePhoto;

    @jakarta.persistence.Column(nullable = false, length = 32)
    private String role = "ADMIN";

    public Admin() {}

    public Admin(String name, String email, String password) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = "ADMIN";
    }

    public Admin(String name, String email, String password, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = (role != null && !role.isBlank()) ? role : "ADMIN";
    }

	public String getProfilePhoto() {
		return profilePhoto;
	}

	public void setProfilePhoto(String profilePhoto) {
		this.profilePhoto = profilePhoto;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public boolean isSuperAdmin() {
		return "SUPER_ADMIN".equalsIgnoreCase(this.role) 
			|| "Super Admin".equalsIgnoreCase(this.name);
	}
}
