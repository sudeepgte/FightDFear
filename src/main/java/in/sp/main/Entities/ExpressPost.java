package in.sp.main.Entities;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "express_posts")
public class ExpressPost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String content;
    private String mediaUrl; // optional image/video
    private LocalDateTime createdAt = LocalDateTime.now();

    // Purpose: allow users to browse Safety Stories/Tips separately from general posts.
    @Enumerated(EnumType.STRING)
    private ExpressPostType postType = ExpressPostType.GENERAL;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL)
    private List<ExpressComment> comments;

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL)
    private List<ExpressLike> likes;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getMediaUrl() {
		return mediaUrl;
	}

	public void setMediaUrl(String mediaUrl) {
		this.mediaUrl = mediaUrl;
	}

    public ExpressPostType getPostType() {
        return postType;
    }

    public void setPostType(ExpressPostType postType) {
        this.postType = postType;
    }

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<ExpressComment> getComments() {
		return comments;
	}

	public void setComments(List<ExpressComment> comments) {
		this.comments = comments;
	}

	public List<ExpressLike> getLikes() {
		return likes;
	}

	public void setLikes(List<ExpressLike> likes) {
		this.likes = likes;
	}
    
    
    
}
