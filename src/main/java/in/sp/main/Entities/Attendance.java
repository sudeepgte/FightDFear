package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
public class Attendance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "trainer_id")
    private User trainer;

    @ManyToOne
    @JoinColumn(name = "centre_id")
    private MartialArtsCenter center;

    @ManyToOne
    @JoinColumn(name = "batch_id")
    private MartialArtsBatch batch;

    @ManyToOne
    @JoinColumn(name = "session_id")
    private TrainingSession session;

    private java.time.LocalDate attendanceDate;
    private java.time.LocalTime joinTime;
    private java.time.LocalTime leaveTime;
    private String mode; // ONLINE or OFFLINE

    @ManyToOne
    @JoinColumn(name = "online_class_id")
    private OnlineClass onlineClass;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Enumerated(EnumType.STRING)
    private AttendanceStatus status;

    private String notes;
    private java.time.LocalDateTime createdAt = java.time.LocalDateTime.now();

    public Attendance() {}

    public java.time.LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.time.LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getTrainer() { return trainer; }
    public void setTrainer(User trainer) { this.trainer = trainer; }

    public MartialArtsCenter getCenter() { return center; }
    public void setCenter(MartialArtsCenter center) { this.center = center; }

    public MartialArtsBatch getBatch() { return batch; }
    public void setBatch(MartialArtsBatch batch) { this.batch = batch; }

    public TrainingSession getSession() { return session; }
    public void setSession(TrainingSession session) { this.session = session; }

    public java.time.LocalDate getAttendanceDate() { return attendanceDate; }
    public void setAttendanceDate(java.time.LocalDate attendanceDate) { this.attendanceDate = attendanceDate; }

    public java.time.LocalTime getJoinTime() { return joinTime; }
    public void setJoinTime(java.time.LocalTime joinTime) { this.joinTime = joinTime; }

    public java.time.LocalTime getLeaveTime() { return leaveTime; }
    public void setLeaveTime(java.time.LocalTime leaveTime) { this.leaveTime = leaveTime; }

    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }

    public OnlineClass getOnlineClass() { return onlineClass; }
    public void setOnlineClass(OnlineClass onlineClass) { this.onlineClass = onlineClass; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public AttendanceStatus getStatus() { return status; }
    public void setStatus(AttendanceStatus status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
