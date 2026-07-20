package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "online_classes")
public class OnlineClass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String martialArtType;
    private LocalDate date;
    private String startTime;
    private String endTime;
    private String meetingLink;
    private String recordingLink;
    private Integer maxStudents;
    private String description;

    @Enumerated(EnumType.STRING)
    private OnlineClassStatus status = OnlineClassStatus.UPCOMING;

    @ManyToOne
    @JoinColumn(name = "batch_id")
    private MartialArtsBatch batch;

    @ManyToOne
    @JoinColumn(name = "trainer_id")
    private User trainer;

    @ManyToOne
    @JoinColumn(name = "center_id")
    private MartialArtsCenter center;

    private String sessionType; // Group Session, Personal 1-to-1 Session
    private String notes;

    public OnlineClass() {}

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMartialArtType() { return martialArtType; }
    public void setMartialArtType(String martialArtType) { this.martialArtType = martialArtType; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }

    public String getRecordingLink() { return recordingLink; }
    public void setRecordingLink(String recordingLink) { this.recordingLink = recordingLink; }

    public Integer getMaxStudents() { return maxStudents; }
    public void setMaxStudents(Integer maxStudents) { this.maxStudents = maxStudents; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public OnlineClassStatus getStatus() { return status; }
    public void setStatus(OnlineClassStatus status) { this.status = status; }

    public MartialArtsBatch getBatch() { return batch; }
    public void setBatch(MartialArtsBatch batch) { this.batch = batch; }

    public User getTrainer() { return trainer; }
    public void setTrainer(User trainer) { this.trainer = trainer; }

    public MartialArtsCenter getCenter() { return center; }
    public void setCenter(MartialArtsCenter center) { this.center = center; }
}
