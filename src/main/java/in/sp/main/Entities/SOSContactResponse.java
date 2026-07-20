package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "sos_contact_responses")
public class SOSContactResponse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "sos_request_id", nullable = false)
    private SOSRequest sosRequest;

    private String contactName;
    private String contactPhone;
    private String contactEmail;
    private String relation;

    private String uniqueToken; // For SMS/webhook verification

    @Enumerated(EnumType.STRING)
    private ResponseStatus responseStatus = ResponseStatus.PENDING;

    private LocalDateTime notifiedAt;
    private LocalDateTime respondedAt;

    private String notificationMethod; // SMS, EMAIL, CALL, WHATSAPP
    private boolean isNotificationSent = false;
    private boolean isSMSDelivered = false;
    private boolean isEmailDelivered = false;

    private String responseMessage; // Optional message from contact

    public enum ResponseStatus {
        PENDING, ACCEPTED, REJECTED, NO_RESPONSE, ON_THE_WAY
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public SOSRequest getSosRequest() {
        return sosRequest;
    }

    public void setSosRequest(SOSRequest sosRequest) {
        this.sosRequest = sosRequest;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getRelation() {
        return relation;
    }

    public void setRelation(String relation) {
        this.relation = relation;
    }

    public String getUniqueToken() {
        return uniqueToken;
    }

    public void setUniqueToken(String uniqueToken) {
        this.uniqueToken = uniqueToken;
    }

    public ResponseStatus getResponseStatus() {
        return responseStatus;
    }

    public void setResponseStatus(ResponseStatus responseStatus) {
        this.responseStatus = responseStatus;
    }

    public LocalDateTime getNotifiedAt() {
        return notifiedAt;
    }

    public void setNotifiedAt(LocalDateTime notifiedAt) {
        this.notifiedAt = notifiedAt;
    }

    public LocalDateTime getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(LocalDateTime respondedAt) {
        this.respondedAt = respondedAt;
    }

    public String getNotificationMethod() {
        return notificationMethod;
    }

    public void setNotificationMethod(String notificationMethod) {
        this.notificationMethod = notificationMethod;
    }

    public boolean isNotificationSent() {
        return isNotificationSent;
    }

    public void setNotificationSent(boolean isNotificationSent) {
        this.isNotificationSent = isNotificationSent;
    }

    public boolean isSMSDelivered() {
        return isSMSDelivered;
    }

    public void setSMSDelivered(boolean isSMSDelivered) {
        this.isSMSDelivered = isSMSDelivered;
    }

    public boolean isEmailDelivered() {
        return isEmailDelivered;
    }

    public void setEmailDelivered(boolean isEmailDelivered) {
        this.isEmailDelivered = isEmailDelivered;
    }

    public String getResponseMessage() {
        return responseMessage;
    }

    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }
}
