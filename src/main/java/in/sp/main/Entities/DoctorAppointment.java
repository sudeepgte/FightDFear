package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "doctor_appointments")
public class DoctorAppointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Purpose: which user booked the appointment.
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Purpose: which doctor the appointment is with.
    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    private LocalDateTime appointmentTime;

    private String reason; // optional

    @Enumerated(EnumType.STRING)
    private DoctorAppointmentStatus status = DoctorAppointmentStatus.PENDING;

    @Enumerated(EnumType.STRING)
    private ConsultationType consultationType = ConsultationType.CLINIC;

    private String meetingRoomId;

    private String razorpayOrderId;
    private String razorpayPaymentId;
    private String razorpaySignature;
    private Double amountPaid;

    private String paymentStatus;
    private String refundId;
    private Double refundAmount;
    private LocalDateTime refundedAt;
    private String receiptNumber;
    private String meetingPassword;
    private LocalDateTime rescheduledFrom;
    private Double platformFee;
    private Double doctorEarning;
    private String cancelledBy;
    private String cancelReason;
    
    @jakarta.persistence.Column(columnDefinition = "TEXT")
    private String prescriptionText;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public LocalDateTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(LocalDateTime appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public DoctorAppointmentStatus getStatus() {
        return status;
    }

    public void setStatus(DoctorAppointmentStatus status) {
        this.status = status;
    }

    public String getRazorpayOrderId() { return razorpayOrderId; }
    public void setRazorpayOrderId(String razorpayOrderId) { this.razorpayOrderId = razorpayOrderId; }

    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }

    public String getRazorpaySignature() { return razorpaySignature; }
    public void setRazorpaySignature(String razorpaySignature) { this.razorpaySignature = razorpaySignature; }

    public Double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(Double amountPaid) { this.amountPaid = amountPaid; }

    public ConsultationType getConsultationType() { return consultationType; }
    public void setConsultationType(ConsultationType consultationType) { this.consultationType = consultationType; }

    public String getMeetingRoomId() { return meetingRoomId; }
    public void setMeetingRoomId(String meetingRoomId) { this.meetingRoomId = meetingRoomId; }

    public String getPrescriptionText() { return prescriptionText; }
    public void setPrescriptionText(String prescriptionText) { this.prescriptionText = prescriptionText; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public String getRefundId() { return refundId; }
    public void setRefundId(String refundId) { this.refundId = refundId; }
    public Double getRefundAmount() { return refundAmount; }
    public void setRefundAmount(Double refundAmount) { this.refundAmount = refundAmount; }
    public LocalDateTime getRefundedAt() { return refundedAt; }
    public void setRefundedAt(LocalDateTime refundedAt) { this.refundedAt = refundedAt; }
    public String getReceiptNumber() { return receiptNumber; }
    public void setReceiptNumber(String receiptNumber) { this.receiptNumber = receiptNumber; }
    public String getMeetingPassword() { return meetingPassword; }
    public void setMeetingPassword(String meetingPassword) { this.meetingPassword = meetingPassword; }
    public LocalDateTime getRescheduledFrom() { return rescheduledFrom; }
    public void setRescheduledFrom(LocalDateTime rescheduledFrom) { this.rescheduledFrom = rescheduledFrom; }
    public Double getPlatformFee() { return platformFee; }
    public void setPlatformFee(Double platformFee) { this.platformFee = platformFee; }
    public Double getDoctorEarning() { return doctorEarning; }
    public void setDoctorEarning(Double doctorEarning) { this.doctorEarning = doctorEarning; }
    public String getCancelledBy() { return cancelledBy; }
    public void setCancelledBy(String cancelledBy) { this.cancelledBy = cancelledBy; }
    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
}

