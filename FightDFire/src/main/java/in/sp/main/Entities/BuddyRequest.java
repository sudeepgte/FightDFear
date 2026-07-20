package in.sp.main.Entities;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "buddy_requests")
public class BuddyRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Purpose: who is asking for a buddy.
    @ManyToOne
    @JoinColumn(name = "from_user_id")
    private User fromUser;

    // Purpose: who receives the buddy request.
    @ManyToOne
    @JoinColumn(name = "to_user_id")
    private User toUser;

    // Purpose: which availability listing this request refers to.
    @ManyToOne
    @JoinColumn(name = "availability_id")
    private BuddyAvailability availability;

    // Purpose: allow accept/reject flow and auditing.
    @Enumerated(EnumType.STRING)
    private BuddyRequestStatus status = BuddyRequestStatus.PENDING;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt = new Date();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getFromUser() {
        return fromUser;
    }

    public void setFromUser(User fromUser) {
        this.fromUser = fromUser;
    }

    public User getToUser() {
        return toUser;
    }

    public void setToUser(User toUser) {
        this.toUser = toUser;
    }

    public BuddyAvailability getAvailability() {
        return availability;
    }

    public void setAvailability(BuddyAvailability availability) {
        this.availability = availability;
    }

    public BuddyRequestStatus getStatus() {
        return status;
    }

    public void setStatus(BuddyRequestStatus status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}

