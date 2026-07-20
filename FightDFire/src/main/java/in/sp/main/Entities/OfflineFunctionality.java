package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
public class OfflineFunctionality {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private boolean fakeCallAvailable;
    private boolean sosAlertViaSMS;
    private String emergencyMessage;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public boolean isFakeCallAvailable() { return fakeCallAvailable; }
    public void setFakeCallAvailable(boolean fakeCallAvailable) { this.fakeCallAvailable = fakeCallAvailable; }

    public boolean isSosAlertViaSMS() { return sosAlertViaSMS; }
    public void setSosAlertViaSMS(boolean sosAlertViaSMS) { this.sosAlertViaSMS = sosAlertViaSMS; }

    public String getEmergencyMessage() { return emergencyMessage; }
    public void setEmergencyMessage(String emergencyMessage) { this.emergencyMessage = emergencyMessage; }
}
