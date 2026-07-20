package in.sp.main.Entities;

import java.sql.Time;

import lombok.Data;
@Data
public class EnrollmentRequest {
    private Long userId;
    private Long centerId;

    private Long martialArtTypeId;

    // Constructors
    public EnrollmentRequest() {}

    public EnrollmentRequest(Long userId, Long centerId,Long martialArtTypeId) {
        this.userId = userId;
        this.centerId = centerId;

        this.martialArtTypeId=martialArtTypeId;
    }

    // Getters and Setters
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCenterId() {
        return centerId;
    }

    public void setCenterId(Long centerId) {
        this.centerId = centerId;
    }

	
	public Long getMartialArtTypeId() {
		return martialArtTypeId;
	}

	public void setMartialArtTypeId(Long martialArtTypeId) {
		this.martialArtTypeId = martialArtTypeId;
	}

    
}

