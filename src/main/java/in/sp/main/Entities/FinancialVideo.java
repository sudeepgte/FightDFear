package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "financial_videos")
public class FinancialVideo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "educator_id")
    private FinancialEducator educator;

    private String title;
    private String category;
    private String customCategory;
    @Column(columnDefinition = "TEXT")
    private String description;
    @Column(length = 1000)
    private String videoUrl;
    private String duration;
    private String level;
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
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getCustomCategory() { return customCategory; }
    public void setCustomCategory(String customCategory) { this.customCategory = customCategory; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public boolean isPublished() { return published; }
    public void setPublished(boolean published) { this.published = published; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
