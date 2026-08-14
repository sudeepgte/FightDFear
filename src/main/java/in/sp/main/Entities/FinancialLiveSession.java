package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "financial_live_sessions")
public class FinancialLiveSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "educator_id")
    private FinancialEducator educator;

    private String title;
    private String speaker;
    @Column(name = "session_date")
    private String date;
    @Column(name = "session_time")
    private String time;
    @Column(length = 1000)
    private String meetingUrl;
    private Integer seats;
    private Double fee = 0.0;
    private String category;
    @Column(columnDefinition = "TEXT")
    private String description;
    private boolean published = true;
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public FinancialEducator getEducator() { return educator; }
    public void setEducator(FinancialEducator educator) { this.educator = educator; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSpeaker() { return speaker; }
    public void setSpeaker(String speaker) { this.speaker = speaker; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
    public String getMeetingUrl() { return meetingUrl; }
    public void setMeetingUrl(String meetingUrl) { this.meetingUrl = meetingUrl; }
    public Integer getSeats() { return seats; }
    public void setSeats(Integer seats) { this.seats = seats; }
    public Double getFee() { return fee == null ? 0d : fee; }
    public void setFee(Double fee) { this.fee = fee; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isPublished() { return published; }
    public void setPublished(boolean published) { this.published = published; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
