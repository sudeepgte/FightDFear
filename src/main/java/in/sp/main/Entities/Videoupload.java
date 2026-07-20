package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "user_videos")
public class Videoupload {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String description;
    private String videoPath;
    private LocalDateTime uploadTime;
    private int likeCount = 0;
    private int shareCount = 0;
    
    @Transient
    private int score;
    @Transient
    private boolean eligibleForReward;

    public boolean isEligibleForReward() {
        return eligibleForReward;
    }
    public void setEligibleForReward(boolean eligibleForReward) {
        this.eligibleForReward = eligibleForReward;
    }

    public int getScore() {
		return score;
	}
	public void setScore(int score) {
		this.score = score;
	}


	@Transient
    private boolean likedByCurrentUser;

    private int viewCount;

    public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public boolean isLikedByCurrentUser() {
        return likedByCurrentUser;
    }
    public void setLikedByCurrentUser(boolean liked) {
        this.likedByCurrentUser = liked;
    }

    
    private String fileType;    // VIDEO or IMAGE
    private boolean isReel = false; // New field to distinguish reels from standard videos
    private String category;
    private String thumbnailPath;
    private boolean isPrivate = false;
    private boolean isDraft = false;
    private String location;
    private String hashtags;
    private boolean isPaidContent = false;
    private Double price = 0.0;
    private boolean isSubscriberOnly = false;
    private String affiliateLink;
    private String status = "APPROVED"; // APPROVED, PENDING_MODERATION, BLOCKED
    private boolean isBlocked = false;

    public boolean isBlocked() {
        return isBlocked;
    }
    public void setBlocked(boolean isBlocked) {
        this.isBlocked = isBlocked;
    }

    public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getThumbnailPath() {
		return thumbnailPath;
	}
	public void setThumbnailPath(String thumbnailPath) {
		this.thumbnailPath = thumbnailPath;
	}
	public boolean isPrivate() {
		return isPrivate;
	}
	public void setPrivate(boolean isPrivate) {
		this.isPrivate = isPrivate;
	}
	public boolean isReel() {
		return isReel;
	}
	public void setReel(boolean isReel) {
		this.isReel = isReel;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	@ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "uploader_id", nullable = false)
    private User user;


    public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	@OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<VideoComment> comments;

    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<VideoLike> likes;

    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<VideoReport> reports;

    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<VideoView> views;
	
    public List<VideoComment> getComments() {
		return comments;
	}
	public void setComments(List<VideoComment> comments) {
		this.comments = comments;
	}

    public List<VideoLike> getLikes() {
        return likes;
    }
    public void setLikes(List<VideoLike> likes) {
        this.likes = likes;
    }

    public List<VideoReport> getReports() {
        return reports;
    }
    public void setReports(List<VideoReport> reports) {
        this.reports = reports;
    }

    public List<VideoView> getViews() {
        return views;
    }
    public void setViews(List<VideoView> views) {
        this.views = views;
    }
	// Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getVideoPath() { return videoPath; }
    public void setVideoPath(String videoPath) { this.videoPath = videoPath; }

    public LocalDateTime getUploadTime() { return uploadTime; }
    public void setUploadTime(LocalDateTime uploadTime) { this.uploadTime = uploadTime; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public int getShareCount() { return shareCount; }
    public void setShareCount(int shareCount) { this.shareCount = shareCount; }

    public boolean isDraft() { return isDraft; }
    public void setDraft(boolean draft) { isDraft = draft; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getHashtags() { return hashtags; }
    public void setHashtags(String hashtags) { this.hashtags = hashtags; }
    public boolean isPaidContent() { return isPaidContent; }
    public void setPaidContent(boolean paidContent) { isPaidContent = paidContent; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public boolean isSubscriberOnly() { return isSubscriberOnly; }
    public void setSubscriberOnly(boolean subscriberOnly) { isSubscriberOnly = subscriberOnly; }
    public String getAffiliateLink() { return affiliateLink; }
    public void setAffiliateLink(String affiliateLink) { this.affiliateLink = affiliateLink; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    }