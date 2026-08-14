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
@Table(name = "doctor_favorites")
@IdClass(DoctorFavorite.Key.class)
public class DoctorFavorite {

    @Id
    private Long userId;
    @Id
    private Long doctorId;
    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getDoctorId() { return doctorId; }
    public void setDoctorId(Long doctorId) { this.doctorId = doctorId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public static class Key implements Serializable {
        private Long userId;
        private Long doctorId;

        public Key() {}

        public Key(Long userId, Long doctorId) {
            this.userId = userId;
            this.doctorId = doctorId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key key)) return false;
            return Objects.equals(userId, key.userId) && Objects.equals(doctorId, key.doctorId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(userId, doctorId);
        }
    }
}
