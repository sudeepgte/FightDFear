package in.sp.main.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.BuddyAvailability;
import in.sp.main.Entities.BuddyRequest;
import in.sp.main.Entities.BuddyRequestStatus;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.BuddyAvailabilityRepository;
import in.sp.main.Repository.BuddyRequestRepository;
import in.sp.main.Repository.UserRepository;

@Service
public class BuddyService {

    @Autowired
    private BuddyAvailabilityRepository availabilityRepo;

    @Autowired
    private BuddyRequestRepository requestRepo;

    @Autowired
    private UserRepository userRepo;

    public BuddyAvailability startAvailability(User user, double lat, double lng, String destinationText, int windowMinutes) {
        // Purpose: enforce verified-only participation (admin approved).
        if (user.getVerificationStatus() != VerificationStatus.VERIFIED) {
            throw new IllegalStateException("USER_NOT_VERIFIED");
        }

        // Purpose: stop previous active availability to avoid duplicates.
        BuddyAvailability existing = availabilityRepo.findTop1ByUserAndActiveOrderByCreatedAtDesc(user, true);
        if (existing != null) {
            existing.setActive(false);
            availabilityRepo.save(existing);
        }

        BuddyAvailability a = new BuddyAvailability();
        a.setUser(user);
        a.setStartLatRounded(round3(lat));
        a.setStartLngRounded(round3(lng));
        a.setDestinationText(normalizeDestination(destinationText));
        a.setCreatedAt(new Date());
        a.setExpiresAt(new Date(System.currentTimeMillis() + Math.max(10, Math.min(120, windowMinutes)) * 60_000L));
        a.setActive(true);
        return availabilityRepo.save(a);
    }

    public void stopAvailability(User user) {
        BuddyAvailability existing = availabilityRepo.findTop1ByUserAndActiveOrderByCreatedAtDesc(user, true);
        if (existing != null) {
            existing.setActive(false);
            availabilityRepo.save(existing);
        }
    }

    public BuddyAvailability getActiveAvailability(User user) {
        return availabilityRepo.findTop1ByUserAndActiveOrderByCreatedAtDesc(user, true);
    }

    public List<Map<String, Object>> findMatches(User currentUser, double lat, double lng, String destinationText, double radiusKm) {
        // Purpose: only show verified users in match results.
        if (currentUser.getVerificationStatus() != VerificationStatus.VERIFIED) {
            throw new IllegalStateException("USER_NOT_VERIFIED");
        }

        String normDest = normalizeDestination(destinationText);
        double rMeters = Math.max(0.5, Math.min(10.0, radiusKm)) * 1000.0;

        Date now = new Date();
        List<BuddyAvailability> active = availabilityRepo.findByActiveTrueAndExpiresAtAfter(now);

        List<Map<String, Object>> out = new ArrayList<>();
        for (BuddyAvailability a : active) {
            if (a.getUser() == null || a.getUser().getId() == null) continue;
            if (a.getUser().getId().equals(currentUser.getId())) continue;
            if (a.getUser().getVerificationStatus() != VerificationStatus.VERIFIED) continue;

            // Purpose: compute approximate distance using rounded availability coordinates (privacy).
            double distMeters = haversineMeters(
                    lat, lng,
                    a.getStartLatRounded(), a.getStartLngRounded());
            if (distMeters > rMeters) continue;

            // Purpose: check destination similarity. We no longer filter out matches going to other nearby destinations.
            double destScore = destinationSimilarity(normDest, a.getDestinationText());

            Map<String, Object> m = new HashMap<>();
            m.put("availabilityId", a.getId());
            m.put("userId", a.getUser().getId());
            m.put("name", safeFirstName(a.getUser().getFullName()));
            m.put("age", a.getUser().getAge());
            m.put("distanceKmApprox", round1(distMeters / 1000.0));
            m.put("destinationArea", a.getDestinationText());
            m.put("score", score(distMeters, destScore, a.getCreatedAt()));
            out.add(m);
        }

        out.sort((x, y) -> Double.compare((double) y.get("score"), (double) x.get("score")));
        return out;
    }

    public BuddyRequest sendRequest(User fromUser, Long availabilityId) {
        // Purpose: verified-only participation.
        if (fromUser.getVerificationStatus() != VerificationStatus.VERIFIED) {
            throw new IllegalStateException("USER_NOT_VERIFIED");
        }

        BuddyRequest last = requestRepo.findTop1ByFromUserOrderByCreatedAtDesc(fromUser);
        if (last != null && last.getCreatedAt() != null) {
            long ageMs = System.currentTimeMillis() - last.getCreatedAt().getTime();
            if (ageMs >= 0 && ageMs < 30_000) {
                throw new IllegalStateException("RATE_LIMIT");
            }
        }

        BuddyAvailability a = availabilityRepo.findById(availabilityId).orElse(null);
        if (a == null || !a.isActive() || a.getExpiresAt() == null || a.getExpiresAt().before(new Date())) {
            throw new IllegalStateException("AVAILABILITY_NOT_ACTIVE");
        }
        if (a.getUser() == null) {
            throw new IllegalStateException("USER_NOT_FOUND");
        }
        if (a.getUser().getId().equals(fromUser.getId())) {
            throw new IllegalStateException("CANNOT_REQUEST_SELF");
        }
        if (a.getUser().getVerificationStatus() != VerificationStatus.VERIFIED) {
            throw new IllegalStateException("TARGET_NOT_VERIFIED");
        }

        BuddyRequest existing = requestRepo.findTop1ByFromUserAndToUserAndStatusOrderByCreatedAtDesc(
                fromUser, a.getUser(), BuddyRequestStatus.PENDING);
        if (existing != null) {
            return existing;
        }

        BuddyRequest r = new BuddyRequest();
        r.setFromUser(fromUser);
        r.setToUser(a.getUser());
        r.setAvailability(a);
        r.setStatus(BuddyRequestStatus.PENDING);
        r.setCreatedAt(new Date());
        return requestRepo.save(r);
    }

    public List<BuddyRequest> incomingPending(User toUser) {
        return dedupeIncoming(requestRepo.findByToUserAndStatusOrderByCreatedAtDesc(toUser, BuddyRequestStatus.PENDING));
    }

    public List<BuddyRequest> outgoingPending(User fromUser) {
        return dedupeOutgoing(requestRepo.findByFromUserAndStatusOrderByCreatedAtDesc(fromUser, BuddyRequestStatus.PENDING));
    }

    public Map<String, Object> pendingRequestsPayload(User user) {
        Map<String, Object> out = new HashMap<>();
        out.put("incoming", toIncomingMaps(incomingPending(user)));
        out.put("outgoing", toOutgoingMaps(outgoingPending(user)));
        return out;
    }

    private List<Map<String, Object>> toIncomingMaps(List<BuddyRequest> list) {
        List<Map<String, Object>> rows = new ArrayList<>();
        for (BuddyRequest r : list) {
            if (r.getFromUser() == null) continue;
            Map<String, Object> m = new HashMap<>();
            m.put("id", r.getId());
            m.put("fromUserId", r.getFromUser().getId());
            m.put("fromName", r.getFromUser().getFullName());
            m.put("fromAge", r.getFromUser().getAge());
            rows.add(m);
        }
        return rows;
    }

    private List<Map<String, Object>> toOutgoingMaps(List<BuddyRequest> list) {
        List<Map<String, Object>> rows = new ArrayList<>();
        for (BuddyRequest r : list) {
            if (r.getToUser() == null) continue;
            Map<String, Object> m = new HashMap<>();
            m.put("id", r.getId());
            m.put("toUserId", r.getToUser().getId());
            m.put("toName", r.getToUser().getFullName());
            m.put("toAge", r.getToUser().getAge());
            rows.add(m);
        }
        return rows;
    }

    private static List<BuddyRequest> dedupeIncoming(List<BuddyRequest> list) {
        Map<Long, BuddyRequest> bySender = new LinkedHashMap<>();
        for (BuddyRequest r : list) {
            if (r.getFromUser() == null || r.getFromUser().getId() == null) continue;
            bySender.putIfAbsent(r.getFromUser().getId(), r);
        }
        return new ArrayList<>(bySender.values());
    }

    private static List<BuddyRequest> dedupeOutgoing(List<BuddyRequest> list) {
        Map<Long, BuddyRequest> byTarget = new LinkedHashMap<>();
        for (BuddyRequest r : list) {
            if (r.getToUser() == null || r.getToUser().getId() == null) continue;
            byTarget.putIfAbsent(r.getToUser().getId(), r);
        }
        return new ArrayList<>(byTarget.values());
    }

    public BuddyRequest accept(User toUser, Long requestId) {
        BuddyRequest r = requestRepo.findById(requestId).orElse(null);
        if (r == null) throw new IllegalStateException("NOT_FOUND");
        if (r.getToUser() == null || !r.getToUser().getId().equals(toUser.getId())) {
            throw new IllegalStateException("FORBIDDEN");
        }
        if (r.getStatus() != BuddyRequestStatus.PENDING) {
            throw new IllegalStateException("NOT_PENDING");
        }
        r.setStatus(BuddyRequestStatus.ACCEPTED);
        return requestRepo.save(r);
    }

    public BuddyRequest reject(User toUser, Long requestId) {
        BuddyRequest r = requestRepo.findById(requestId).orElse(null);
        if (r == null) throw new IllegalStateException("NOT_FOUND");
        if (r.getToUser() == null || !r.getToUser().getId().equals(toUser.getId())) {
            throw new IllegalStateException("FORBIDDEN");
        }
        if (r.getStatus() != BuddyRequestStatus.PENDING) {
            throw new IllegalStateException("NOT_PENDING");
        }
        r.setStatus(BuddyRequestStatus.REJECTED);
        return requestRepo.save(r);
    }

    public User getUserById(Long id) {
        return userRepo.findById(id).orElse(null);
    }

    private static double round3(double x) {
        // Purpose: keep only ~3 decimal places (~110m) for privacy-safe matching.
        return Math.round(x * 1000.0) / 1000.0;
    }

    private static double round1(double x) {
        return Math.round(x * 10.0) / 10.0;
    }

    private static String normalizeDestination(String s) {
        // Purpose: simple normalization for matching (lowercase, trim).
        if (s == null) return "";
        return s.trim().toLowerCase(Locale.ROOT);
    }

    private static String safeFirstName(String fullName) {
        // Purpose: avoid revealing too much identity in match list.
        if (fullName == null) return "User";
        String t = fullName.trim();
        if (t.isEmpty()) return "User";
        int idx = t.indexOf(' ');
        return (idx > 0) ? t.substring(0, idx) : t;
    }

    private static double destinationSimilarity(String a, String b) {
        // Purpose: v1 destination similarity by token overlap.
        if (a == null) a = "";
        if (b == null) b = "";
        a = a.trim();
        b = b.trim();
        if (a.isEmpty() || b.isEmpty()) return 0.0;

        String[] ta = a.split("\\s+");
        String[] tb = b.split("\\s+");

        int common = 0;
        int total = 0;

        for (String x : ta) {
            if (x.length() < 2) continue;
            total++;
            for (String y : tb) {
                if (y.length() < 2) continue;
                if (x.equals(y)) {
                    common++;
                    break;
                }
            }
        }

        if (total == 0) return 0.0;
        return Math.min(1.0, (double) common / (double) total);
    }

    private static double score(double distMeters, double destScore, Date createdAt) {
        // Purpose: rank closer, more similar destinations higher; newer has slight boost.
        double distComponent = 1.0 / (1.0 + (distMeters / 1000.0)); // 1..0
        double recencyBoost = 0.0;
        if (createdAt != null) {
            long ageMin = Math.max(0, (System.currentTimeMillis() - createdAt.getTime()) / 60_000L);
            recencyBoost = 1.0 / (1.0 + ageMin / 30.0);
        }
        return (destScore * 0.55) + (distComponent * 0.35) + (recencyBoost * 0.10);
    }

    private static double haversineMeters(double lat1, double lng1, double lat2, double lng2) {
        // Purpose: approximate distance without external APIs.
        final double R = 6371000.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}

