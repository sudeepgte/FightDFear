package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

@Entity
@Table(name = "doctor_profile_drafts")
public class DoctorProfileDraft {

    @Id
    @Column(name = "doctor_id")
    private Long doctorId;

    @Column(name = "draft_json", nullable = false, columnDefinition = "LONGTEXT")
    private String draftJson;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private DoctorDraftStatus status = DoctorDraftStatus.DRAFT;

    @Column(columnDefinition = "TEXT")
    private String adminNotes;

    private LocalDateTime submittedAt;

    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public Long getDoctorId() { return doctorId; }
    public void setDoctorId(Long doctorId) { this.doctorId = doctorId; }

    public String getDraftJson() { return draftJson; }
    public void setDraftJson(String draftJson) { this.draftJson = draftJson; }

    public DoctorDraftStatus getStatus() { return status; }
    public void setStatus(DoctorDraftStatus status) { this.status = status; }

    public String getAdminNotes() { return adminNotes; }
    public void setAdminNotes(String adminNotes) { this.adminNotes = adminNotes; }

    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(LocalDateTime submittedAt) { this.submittedAt = submittedAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
