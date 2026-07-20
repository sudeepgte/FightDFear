package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
public class VideoReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Reported video
    @ManyToOne
    @JoinColumn(name = "video_id", nullable = false)
    private Videoupload video;

    // Reporter (USES YOUR USER ENTITY)
    @ManyToOne
    @JoinColumn(name = "reported_by", nullable = false)
    private User reportedBy;

    @Column(length = 1000, nullable = false)
    private String reason;

    private LocalDateTime reportedAt = LocalDateTime.now();

    /* Getters & Setters */
    public Long getId() {
        return id;
    }

    public Videoupload getVideo() {
        return video;
    }

    public void setVideo(Videoupload video) {
        this.video = video;
    }

    public User getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(User reportedBy) {
        this.reportedBy = reportedBy;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public LocalDateTime getReportedAt() {
        return reportedAt;
    }
}
