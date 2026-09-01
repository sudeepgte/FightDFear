package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "creator_stories")
public class CreatorStory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String mediaPath;
    private String fileType; // IMAGE or VIDEO
    private String caption;
    private LocalDateTime uploadTime = LocalDateTime.now();
    private int viewCount = 0;
    private boolean isPrivate = false;
    private boolean isDraft = false;

    public CreatorStory() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getMediaPath() { return mediaPath; }
    public void setMediaPath(String mediaPath) { this.mediaPath = mediaPath; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = caption; }

    public LocalDateTime getUploadTime() { return uploadTime; }
    public void setUploadTime(LocalDateTime uploadTime) { this.uploadTime = uploadTime; }

    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }

    public boolean isPrivate() { return isPrivate; }
    public void setPrivate(boolean isPrivate) { this.isPrivate = isPrivate; }

    public boolean isDraft() { return isDraft; }
    public void setDraft(boolean isDraft) { this.isDraft = isDraft; }

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "story_viewers",
        joinColumns = @JoinColumn(name = "story_id"),
        inverseJoinColumns = @JoinColumn(name = "user_id"))
    private java.util.Set<User> viewers = new java.util.HashSet<>();

    public java.util.Set<User> getViewers() { return viewers; }
    public void setViewers(java.util.Set<User> viewers) { this.viewers = viewers; }
}
