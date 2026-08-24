package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DoctorFavorite;

public interface DoctorFavoriteRepository extends JpaRepository<DoctorFavorite, DoctorFavorite.Key> {
    List<DoctorFavorite> findByUserIdOrderByCreatedAtDesc(Long userId);
    boolean existsByUserIdAndDoctorId(Long userId, Long doctorId);
    void deleteByUserIdAndDoctorId(Long userId, Long doctorId);
}
