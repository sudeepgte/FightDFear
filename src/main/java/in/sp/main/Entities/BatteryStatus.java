package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
public class BatteryStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private int batteryLevel;
    private boolean alertSent;
    private String lastKnownLocation;
    private boolean nonEssentialAppsDisabled;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public int getBatteryLevel() { return batteryLevel; }
    public void setBatteryLevel(int batteryLevel) { this.batteryLevel = batteryLevel; }

    public boolean isAlertSent() { return alertSent; }
    public void setAlertSent(boolean alertSent) { this.alertSent = alertSent; }

    public String getLastKnownLocation() { return lastKnownLocation; }
    public void setLastKnownLocation(String lastKnownLocation) { this.lastKnownLocation = lastKnownLocation; }

    public boolean isNonEssentialAppsDisabled() { return nonEssentialAppsDisabled; }
    public void setNonEssentialAppsDisabled(boolean nonEssentialAppsDisabled) { this.nonEssentialAppsDisabled = nonEssentialAppsDisabled; }
}
