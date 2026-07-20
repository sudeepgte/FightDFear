package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "video_comments")
public class VideoComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String text;

    private LocalDateTime commentedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "video_id")
    private Videoupload video;

    // New: Self-referencing parent comment
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private VideoComment parent;

    // New: List of replies
    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
    private List<VideoComment> replies;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public LocalDateTime getCommentedAt() { return commentedAt; }
    public void setCommentedAt(LocalDateTime commentedAt) { this.commentedAt = commentedAt; }

    public Videoupload getVideo() { return video; }
    public void setVideo(Videoupload video) { this.video = video; }

    public VideoComment getParent() { return parent; }
    public void setParent(VideoComment parent) { this.parent = parent; }

    public List<VideoComment> getReplies() { return replies; }
    public void setReplies(List<VideoComment> replies) { this.replies = replies; }
}
