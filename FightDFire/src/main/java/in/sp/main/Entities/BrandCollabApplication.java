package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "brand_collab_applications")
public class BrandCollabApplication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "collaboration_id", nullable = false)
    private BrandCollaboration collaboration;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "creator_id", nullable = false)
    private User creator;

    @Column(columnDefinition = "TEXT")
    private String pitch;

    private String status = "PENDING"; // PENDING, APPROVED, REJECTED
    private LocalDateTime createdAt = LocalDateTime.now();

    public BrandCollabApplication() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public BrandCollaboration getCollaboration() { return collaboration; }
    public void setCollaboration(BrandCollaboration collaboration) { this.collaboration = collaboration; }

    public User getCreator() { return creator; }
    public void setCreator(User creator) { this.creator = creator; }

    public String getPitch() { return pitch; }
    public void setPitch(String pitch) { this.pitch = pitch; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
