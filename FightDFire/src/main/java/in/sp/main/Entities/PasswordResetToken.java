package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "password_reset_tokens")
public class PasswordResetToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String token;
    
    private String email; // Used to identify the user
    private LocalDateTime expiryDate;

    @Enumerated(EnumType.STRING)
    private UserType userType; // USER, ADMIN, VOLUNTEER, CENTRE

    public PasswordResetToken() {}

    public PasswordResetToken(String email, String token, UserType userType, int expirationMinutes) {
        this.email = email;
        this.token = token;
        this.userType = userType;
        this.expiryDate = LocalDateTime.now().plusMinutes(expirationMinutes);
    }

    public boolean isExpired() {
        return expiryDate.isBefore(LocalDateTime.now());
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public LocalDateTime getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(LocalDateTime expiryDate) {
		this.expiryDate = expiryDate;
	}

	public UserType getUserType() {
		return userType;
	}

	public void setUserType(UserType userType) {
		this.userType = userType;
	}

  
}


