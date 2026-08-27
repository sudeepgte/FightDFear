package in.sp.main.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.Videoupload;

@Repository
public interface VideoUploadRepository extends JpaRepository<Videoupload, Long> {
	List<Videoupload> findByUser_Id(Long userId);

	List<Videoupload> findByUserId(Long userId);

	List<Videoupload> findByUser_IdAndIsReel(Long userId, boolean isReel);

	List<Videoupload> findByIsReel(boolean isReel);

	@Query("""
			SELECT v FROM Videoupload v
			JOIN FETCH v.user u
			WHERE v.isReel = true
			  AND v.isBlocked = false
			  AND (v.status IS NULL OR UPPER(v.status) <> 'BLOCKED')
			ORDER BY v.uploadTime DESC
			""")
	List<Videoupload> findFeedReels();

	Page<Videoupload> findByIsBlockedFalseAndIsDraftFalseAndStatusOrderByUploadTimeDesc(
			String status, Pageable pageable);

	Page<Videoupload> findByIsBlockedFalseAndIsDraftFalseAndStatusOrderByViewCountDesc(
			String status, Pageable pageable);

	List<Videoupload> findTop8ByIsBlockedFalseAndIsDraftFalseAndStatusOrderByUploadTimeDesc(String status);

	void deleteByUserId(Long userId);
}
