package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_blocks")
public class UserBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // blocker

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "blocked_user_id", nullable = false)
    private User blockedUser; // blocked

    private LocalDateTime blockedAt = LocalDateTime.now();

    public UserBlock() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public User getBlockedUser() { return blockedUser; }
    public void setBlockedUser(User blockedUser) { this.blockedUser = blockedUser; }

    public LocalDateTime getBlockedAt() { return blockedAt; }
    public void setBlockedAt(LocalDateTime blockedAt) { this.blockedAt = blockedAt; }
}
