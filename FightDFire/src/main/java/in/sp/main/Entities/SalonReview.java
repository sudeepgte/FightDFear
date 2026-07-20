package in.sp.main.Entities;
 
import jakarta.persistence.*;

import java.time.LocalDateTime;
 
@Entity

@Table(name = "salon_reviews")

public class SalonReview {

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private long id;
 
   

	@ManyToOne

    @JoinColumn(name = "salon_id", nullable = false)

    private Salon salon;
 
    private String userName;

    private int rating;
 
    @Column(length = 1000)

    private String comment;
 
    private LocalDateTime createdAt = LocalDateTime.now();

    private String reply;               // reply message

    private LocalDateTime repliedAt;    // time of reply
 
 
    public String getReply() {

		return reply;

	}

	public void setReply(String reply) {

		this.reply = reply;

	}

	public LocalDateTime getRepliedAt() {

		return repliedAt;

	}

	public void setRepliedAt(LocalDateTime repliedAt) {

		this.repliedAt = repliedAt;

	}

	// Getters and Setters

    public long getId() {

		return id;

	}

	public void setId(long id) {

		this.id = id;

	}

    public Salon getSalon() { return salon; }

    public void setSalon(Salon salon) { this.salon = salon; }
 
    public String getUserName() { return userName; }

    public void setUserName(String userName) { this.userName = userName; }
 
    public int getRating() { return rating; }

    public void setRating(int rating) { this.rating = rating; }
 
    public String getComment() { return comment; }

    public void setComment(String comment) { this.comment = comment; }
 
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

}

 