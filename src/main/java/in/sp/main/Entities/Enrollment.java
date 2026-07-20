package in.sp.main.Entities;

import jakarta.persistence.*;
import java.util.Set;
import java.util.TreeSet;
import java.time.LocalDate;

@Entity
public class Enrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private MartialArtsCenter center;

    @ManyToOne
    private MartialArtsType martialArtsType;

    @ElementCollection(targetClass = DayAvailable.class)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "enrollment_preferred_days")
    @OrderBy
    private Set<DayAvailable> preferredDays = new TreeSet<>();

    @Enumerated(EnumType.STRING)
    private TrainingStatus status;

    @ManyToOne
    private Slot selectedSlot;

    @ManyToOne
    private MartialArtsBatch batch;

    private String certificateDetails;

    private String razorpayOrderId;
    private String razorpayPaymentId;
    private String razorpaySignature;
    private Double amountPaid;
    private Integer progressPercentage = 0;

    // --- New Fields for Comprehensive Enrollment ---
    
    // 1. Personal Details
    private String fullName;
    private LocalDate dob;
    private Integer age;
    private String gender;
    private String phoneNumber;
    private String email;
    @Column(columnDefinition = "TEXT")
    private String residentialAddress;

    // 2. Emergency Contact
    private String emergencyContactName;

    // 3. Training Preference
    private String skillLevel; // Beginner, Intermediate, Advanced
    private String trainingGoal;
    @Column(columnDefinition = "TEXT")
    private String motivation; // Why do you want to learn martial arts?

    // 4. Health Information
    @Column(columnDefinition = "TEXT")
    private String medicalConditions;
    @Column(columnDefinition = "TEXT")
    private String allergies;
    @Column(columnDefinition = "TEXT")
    private String fitnessNotes;

    // 5. Enrollment Details
    private LocalDate proposedStartDate;
    private String trainerPreference;
    
    // 6. Consent
    private boolean consentAccuracy;
    private boolean consentRules;
    private String paymentStatus;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public MartialArtsCenter getCenter() { return center; }
    public void setCenter(MartialArtsCenter center) { this.center = center; }
    public MartialArtsType getMartialArtsType() { return martialArtsType; }
    public void setMartialArtsType(MartialArtsType martialArtsType) { this.martialArtsType = martialArtsType; }
    public Set<DayAvailable> getPreferredDays() { return preferredDays; }
    public void setPreferredDays(Set<DayAvailable> preferredDays) { this.preferredDays = preferredDays; }
    public TrainingStatus getStatus() { return status; }
    public void setStatus(TrainingStatus status) { this.status = status; }
    public Slot getSelectedSlot() { return selectedSlot; }
    public void setSelectedSlot(Slot selectedSlot) { this.selectedSlot = selectedSlot; }
    public MartialArtsBatch getBatch() { return batch; }
    public void setBatch(MartialArtsBatch batch) { this.batch = batch; }
    public String getCertificateDetails() { return certificateDetails; }
    public void setCertificateDetails(String certificateDetails) { this.certificateDetails = certificateDetails; }

    public String getRazorpayOrderId() { return razorpayOrderId; }
    public void setRazorpayOrderId(String razorpayOrderId) { this.razorpayOrderId = razorpayOrderId; }

    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }

    public String getRazorpaySignature() { return razorpaySignature; }
    public void setRazorpaySignature(String razorpaySignature) { this.razorpaySignature = razorpaySignature; }

    public Double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(Double amountPaid) { this.amountPaid = amountPaid; }

    public Integer getProgressPercentage() { return progressPercentage; }
    public void setProgressPercentage(Integer progressPercentage) { this.progressPercentage = progressPercentage; }

    // Getters and Setters for New Fields
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getResidentialAddress() { return residentialAddress; }
    public void setResidentialAddress(String residentialAddress) { this.residentialAddress = residentialAddress; }
    public String getEmergencyContactName() { return emergencyContactName; }
    public void setEmergencyContactName(String emergencyContactName) { this.emergencyContactName = emergencyContactName; }

    public String getSkillLevel() { return skillLevel; }
    public void setSkillLevel(String skillLevel) { this.skillLevel = skillLevel; }
    public String getTrainingGoal() { return trainingGoal; }
    public void setTrainingGoal(String trainingGoal) { this.trainingGoal = trainingGoal; }
    public String getMotivation() { return motivation; }
    public void setMotivation(String motivation) { this.motivation = motivation; }
    public String getMedicalConditions() { return medicalConditions; }
    public void setMedicalConditions(String medicalConditions) { this.medicalConditions = medicalConditions; }
    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }
    public String getFitnessNotes() { return fitnessNotes; }
    public void setFitnessNotes(String fitnessNotes) { this.fitnessNotes = fitnessNotes; }
    public LocalDate getProposedStartDate() { return proposedStartDate; }
    public void setProposedStartDate(LocalDate proposedStartDate) { this.proposedStartDate = proposedStartDate; }
    public String getTrainerPreference() { return trainerPreference; }
    public void setTrainerPreference(String trainerPreference) { this.trainerPreference = trainerPreference; }
    public boolean isConsentAccuracy() { return consentAccuracy; }
    public void setConsentAccuracy(boolean consentAccuracy) { this.consentAccuracy = consentAccuracy; }
    public boolean isConsentRules() { return consentRules; }
    public void setConsentRules(boolean consentRules) { this.consentRules = consentRules; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}