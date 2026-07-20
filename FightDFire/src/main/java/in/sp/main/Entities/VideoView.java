package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "video_views",
       uniqueConstraints = @UniqueConstraint(columnNames = {"video_id", "user_id"}))
public class VideoView {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Videoupload video;

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Videoupload getVideo() {
		return video;
	}

	public void setVideo(Videoupload video) {
		this.video = video;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public LocalDateTime getViewedAt() {
		return viewedAt;
	}

	public void setViewedAt(LocalDateTime viewedAt) {
		this.viewedAt = viewedAt;
	}

	@ManyToOne
    private User user;

    private LocalDateTime viewedAt;
}
