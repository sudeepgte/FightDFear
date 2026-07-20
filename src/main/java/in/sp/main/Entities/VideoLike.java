package in.sp.main.Entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.validation.constraints.Pattern;

@Entity
@Table(
    name = "video_likes",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "video_id"})
)
public class VideoLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Videoupload getVideo() {
		return video;
	}

	public void setVideo(Videoupload video) {
		this.video = video;
	}

	@ManyToOne
    private Videoupload video;

    // getters & setters
}
