package in.sp.main.Entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class TrustedContact {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String phone;
    private String email;
    private String relation;
    private boolean isPrimary = false;
    private boolean canReceiveSMS = true;
    private boolean canReceiveEmail = true;
    private boolean canReceiveCall = true;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

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

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getRelation() {
		return relation;
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}

	public boolean isPrimary() {
		return isPrimary;
	}

	public void setPrimary(boolean isPrimary) {
		this.isPrimary = isPrimary;
	}

	public boolean isCanReceiveSMS() {
		return canReceiveSMS;
	}

	public void setCanReceiveSMS(boolean canReceiveSMS) {
		this.canReceiveSMS = canReceiveSMS;
	}

	public boolean isCanReceiveEmail() {
		return canReceiveEmail;
	}

	public void setCanReceiveEmail(boolean canReceiveEmail) {
		this.canReceiveEmail = canReceiveEmail;
	}

	public boolean isCanReceiveCall() {
		return canReceiveCall;
	}

	public void setCanReceiveCall(boolean canReceiveCall) {
		this.canReceiveCall = canReceiveCall;
	}
    
}