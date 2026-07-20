package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
	@Table(name = "live_location")
@Data
	public class LiveLocation {

	    @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;

	    @Column(nullable = false)
	    private Long userId;

	    @Column(nullable = false)
	    private double latitude;

	    @Column(nullable = false)
	    private double longitude;

	    @Column(nullable = false)
	    private LocalDateTime trackingStartTime = LocalDateTime.now();

	    private LocalDateTime trackingEndTime;

	    private boolean isActive = true;
	    
	    private LocalDateTime timestamp;
	    
	   

		public Long getId() {
			return id;
		}

		public void setId(Long id) {
			this.id = id;
		}

		public Long getUserId() {
			return userId;
		}

		public void setUserId(Long userId) {
			this.userId = userId;
		}

		public double getLatitude() {
			return latitude;
		}

		public void setLatitude(double latitude) {
			this.latitude = latitude;
		}

		public double getLongitude() {
			return longitude;
		}

		public void setLongitude(double longitude) {
			this.longitude = longitude;
		}

		public LocalDateTime getTrackingStartTime() {
			return trackingStartTime;
		}

		public void setTrackingStartTime(LocalDateTime trackingStartTime) {
			this.trackingStartTime = trackingStartTime;
		}

		public LocalDateTime getTrackingEndTime() {
			return trackingEndTime;
		}

		public void setTrackingEndTime(LocalDateTime trackingEndTime) {
			this.trackingEndTime = trackingEndTime;
		}

		public boolean isActive() {
			return isActive;
		}

		public void setActive(boolean isActive) {
			this.isActive = isActive;
		}

		public LocalDateTime getTimestamp() {
			return timestamp;
		}

		public void setTimestamp(LocalDateTime timestamp) {
			this.timestamp = timestamp;
		}

		
	    
	}

	

