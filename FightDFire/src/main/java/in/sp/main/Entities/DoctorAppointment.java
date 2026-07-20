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
}

