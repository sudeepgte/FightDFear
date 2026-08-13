package in.sp.main.Entities;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "centre_favorites")
@IdClass(CentreFavorite.Key.class)
public class CentreFavorite {

    @Id
    private Long userId;
    @Id
    private Long centreId;
    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getCentreId() { return centreId; }
    public void setCentreId(Long centreId) { this.centreId = centreId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public static class Key implements Serializable {
        private Long userId;
        private Long centreId;

        public Key() {}

        public Key(Long userId, Long centreId) {
            this.userId = userId;
            this.centreId = centreId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key key)) return false;
            return Objects.equals(userId, key.userId) && Objects.equals(centreId, key.centreId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(userId, centreId);
        }
    }
}
