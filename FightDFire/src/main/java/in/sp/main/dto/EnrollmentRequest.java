package in.sp.main.dto;

import java.time.LocalDate;
import java.util.List;

public class EnrollmentRequest {
    private Long centerId;
    private Long batchId;
    
    // Personal Details
    private String fullName;
    private LocalDate dob;
    private Integer age;
    private String gender;
    private String phoneNumber;
    private String email;
    private String address;

    // Emergency Contact
    private String emergencyName;

    // Training Preference
    private String style;
    private String skillLevel;
    private List<String> preferredDays;
    private String goal;
    private String motivation;

    // Health Info
    private String medicalConditions;
    private String allergies;
    private String fitnessNotes;

    // Enrollment Details
    private LocalDate startDate;
    private String trainerPreference;
    private Double monthlyFee;

    // Consent
    private boolean consentAccuracy;
    private boolean consentRules;

    // Getters and Setters
    public Long getCenterId() { return centerId; }
    public void setCenterId(Long centerId) { this.centerId = centerId; }

    public Long getBatchId() { return batchId; }
    public void setBatchId(Long batchId) { this.batchId = batchId; }

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

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmergencyName() { return emergencyName; }
    public void setEmergencyName(String emergencyName) { this.emergencyName = emergencyName; }

    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }

    public String getSkillLevel() { return skillLevel; }
    public void setSkillLevel(String skillLevel) { this.skillLevel = skillLevel; }

    public List<String> getPreferredDays() { return preferredDays; }
    public void setPreferredDays(List<String> preferredDays) { this.preferredDays = preferredDays; }

    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }

    public String getMotivation() { return motivation; }
    public void setMotivation(String motivation) { this.motivation = motivation; }

    public String getMedicalConditions() { return medicalConditions; }
    public void setMedicalConditions(String medicalConditions) { this.medicalConditions = medicalConditions; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public String getFitnessNotes() { return fitnessNotes; }
    public void setFitnessNotes(String fitnessNotes) { this.fitnessNotes = fitnessNotes; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getTrainerPreference() { return trainerPreference; }
    public void setTrainerPreference(String trainerPreference) { this.trainerPreference = trainerPreference; }

    public Double getMonthlyFee() { return monthlyFee; }
    public void setMonthlyFee(Double monthlyFee) { this.monthlyFee = monthlyFee; }

    public boolean isConsentAccuracy() { return consentAccuracy; }
    public void setConsentAccuracy(boolean consentAccuracy) { this.consentAccuracy = consentAccuracy; }

    public boolean isConsentRules() { return consentRules; }
    public void setConsentRules(boolean consentRules) { this.consentRules = consentRules; }
}
