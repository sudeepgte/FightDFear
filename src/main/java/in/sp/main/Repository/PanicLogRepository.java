package in.sp.main.Repository;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.PanicLog;

public interface PanicLogRepository extends JpaRepository<PanicLog, Long> {
    List<PanicLog> findByUserId(Long userId);
}
