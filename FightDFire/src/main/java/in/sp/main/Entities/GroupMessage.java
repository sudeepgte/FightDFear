package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
public class GroupMessage {
    @Id @GeneratedValue
    private Long id;

    @ManyToOne
    private Group group;

    @ManyToOne
    private User sender;

    private String message;

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Group getGroup() {
		return group;
	}

	public void setGroup(Group group) {
		this.group = group;
	}

	public User getSender() {
		return sender;
	}

	public void setSender(User sender) {
		this.sender = sender;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public LocalDateTime getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(LocalDateTime timestamp) {
		this.timestamp = timestamp;
	}

	private LocalDateTime timestamp;
}
