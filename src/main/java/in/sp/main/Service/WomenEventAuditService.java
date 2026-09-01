package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.EventAuditLog;
import in.sp.main.Repository.EventAuditLogRepository;

@Service
public class WomenEventAuditService {

    @Autowired
    private EventAuditLogRepository auditLogRepository;

    public void log(String actorRole, Long actorId, String actorEmail,
                    String action, String entityType, Long entityId,
                    String reason, String metadata) {
        EventAuditLog row = new EventAuditLog();
        row.setActorRole(actorRole == null ? "SYSTEM" : actorRole);
        row.setActorId(actorId);
        row.setActorEmail(actorEmail);
        row.setAction(action);
        row.setEntityType(entityType);
        row.setEntityId(entityId);
        row.setReason(reason);
        row.setMetadata(metadata);
        auditLogRepository.save(row);
    }
}
