package in.sp.main.Repository;

import in.sp.main.Entities.EventAuditLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventAuditLogRepository extends JpaRepository<EventAuditLog, Long> {
    List<EventAuditLog> findByEntityTypeAndEntityIdOrderByCreatedAtDesc(String entityType, Long entityId);
    List<EventAuditLog> findTop100ByOrderByCreatedAtDesc();
}
