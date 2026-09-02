package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.EventLifecycleStatus;
import in.sp.main.Entities.EventStatusHistory;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Repository.EventStatusHistoryRepository;
import in.sp.main.Repository.WomenEventRepository;

@Service
public class WomenEventLifecycleService {

    @Autowired private WomenEventRepository eventRepository;
    @Autowired private EventStatusHistoryRepository historyRepository;
    @Autowired private WomenEventAuditService auditService;

    @Transactional
    public WomenEvent transition(WomenEvent event, EventLifecycleStatus next,
                                 String actorRole, Long actorId, String actorEmail, String reason) {
        if (event == null || next == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Event and status are required");
        }
        EventLifecycleStatus current = event.getLifecycleStatus() != null
                ? event.getLifecycleStatus()
                : EventLifecycleStatus.fromLegacy(event.getStatus());
        if (current == next && next != EventLifecycleStatus.CHANGES_REQUESTED) {
            return event;
        }
        String from = current.name();
        event.setLifecycleStatus(next);
        event.setStatus(next.listingStatus());
        if (next == EventLifecycleStatus.PUBLISHED || next == EventLifecycleStatus.APPROVED) {
            if (event.getPublishedAt() == null && next == EventLifecycleStatus.PUBLISHED) {
                event.setPublishedAt(LocalDateTime.now());
            }
        }
        if (next == EventLifecycleStatus.CANCELLED) {
            event.setCancelledAt(LocalDateTime.now());
        }
        if (reason != null && !reason.isBlank()
                && (next == EventLifecycleStatus.CHANGES_REQUESTED || next == EventLifecycleStatus.REJECTED)) {
            event.setAdminReviewNote(reason);
        }
        WomenEvent saved = eventRepository.save(event);

        EventStatusHistory hist = new EventStatusHistory();
        hist.setEvent(saved);
        hist.setFromStatus(from);
        hist.setToStatus(next.name());
        hist.setActorRole(actorRole);
        hist.setActorId(actorId);
        hist.setReason(reason);
        historyRepository.save(hist);

        auditService.log(actorRole, actorId, actorEmail, "EVENT_" + next.name(),
                "EVENT", saved.getId(), reason, "{\"from\":\"" + from + "\",\"to\":\"" + next.name() + "\"}");
        return saved;
    }

    public void applyCreateStatus(WomenEvent event, boolean draft) {
        EventLifecycleStatus st = draft ? EventLifecycleStatus.DRAFT : EventLifecycleStatus.SUBMITTED;
        event.setLifecycleStatus(st);
        event.setStatus(st.listingStatus());
    }
}
