package in.sp.main.Entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "crime_data")
public class CrimeData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private double latitude;
    private double longitude;
    private int crimeCount;
    private int nightTimeCrime;
    private int policeStations;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
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
	public int getCrimeCount() {
		return crimeCount;
	}
	public void setCrimeCount(int crimeCount) {
		this.crimeCount = crimeCount;
	}
	public int getNightTimeCrime() {
		return nightTimeCrime;
	}
	public void setNightTimeCrime(int nightTimeCrime) {
		this.nightTimeCrime = nightTimeCrime;
	}
	public int getPoliceStations() {
		return policeStations;
	}
	public void setPoliceStations(int policeStations) {
		this.policeStations = policeStations;
	}

  
}

