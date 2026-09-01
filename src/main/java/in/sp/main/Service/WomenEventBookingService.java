package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.EventLifecycleStatus;
import in.sp.main.Entities.EventTicketType;
import in.sp.main.Entities.User;
import in.sp.main.Entities.WalletTransaction;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Repository.EventTicketTypeRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WalletTransactionRepository;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventRepository;

@Service
public class WomenEventBookingService {

    @Autowired private WomenEventRepository eventRepository;
    @Autowired private WomenEventRegistrationRepository registrationRepository;
    @Autowired private EventTicketTypeRepository ticketTypeRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private WalletTransactionRepository walletTransactionRepository;
    @Autowired private EventCoinPolicy coinPolicy;
    @Autowired private WomenEventAuditService auditService;
    @Autowired private WomenEventLifecycleService lifecycleService;
    @Autowired private PushNotificationService pushNotificationService;

    public Map<String, Object> quoteCoins(User user, double ticketAmount, int requestedCoins) {
        User fresh = user == null ? null : userRepository.findById(user.getId()).orElse(user);
        int available = fresh == null || fresh.getRewardPoints() == null ? 0 : fresh.getRewardPoints();
        int max = coinPolicy.maxRedeemableCoins(ticketAmount, available);
        int applied = Math.max(0, Math.min(requestedCoins, max));
        double coinsRupees = coinPolicy.rupeesForCoins(applied);
        double payable = coinPolicy.payable(ticketAmount, applied);
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("ticketAmount", ticketAmount);
        m.put("availableCoins", available);
        m.put("maxRedeemableCoins", max);
        m.put("coinsApplied", applied);
        m.put("coinsValue", coinsRupees);
        m.put("remainingAmount", payable);
        m.put("finalPayableAmount", payable);
        m.put("coinsEnabled", coinPolicy.isEnabled());
        m.put("rupeesPerCoin", coinPolicy.rupeesPerCoin());
        m.put("maxPercent", coinPolicy.maxPercent());
        return m;
    }

    @Transactional
    public WomenEventRegistration book(User user, Long eventId, Long ticketTypeId, int quantity, int requestedCoins) {
        if (user == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
        if (quantity < 1) quantity = 1;

        WomenEvent event = eventRepository.findByIdForUpdate(eventId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Event not found"));
        if (!WomenEventSupport.isPubliclyListed(event) || !WomenEventSupport.isBookableStatus(event)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This event is not available for registration.");
        }
        if (event.getOrganizer() != null && !EventHostProfileService.isApproved(event.getOrganizer())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Event not found");
        }
        LocalDateTime now = LocalDateTime.now();
        if (!WomenEventSupport.registrationWindowOpen(event, now)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Registration for this event has closed.");
        }
        if (registrationRepository.existsActiveByEventAndUser(event, user)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already registered");
        }

        EventTicketType ticket = null;
        double unitPrice;
        if (ticketTypeId != null) {
            ticket = ticketTypeRepository.findByIdForUpdate(ticketTypeId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ticket type not found"));
            if (ticket.getEvent() == null || !ticket.getEvent().getId().equals(event.getId())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ticket type does not belong to this event");
            }
            if (!ticket.isOnSale(now)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This ticket is not on sale.");
            }
            if (quantity > ticket.getMaxPerUser()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Maximum " + ticket.getMaxPerUser() + " tickets per user");
            }
            if (ticket.remaining() < quantity) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This event is sold out.");
            }
            unitPrice = ticket.getPrice();
        } else {
            Integer max = event.getMaxParticipants();
            if (max != null && max > 0) {
                long taken = registrationRepository.countActiveByEvent(event);
                if (taken + quantity > max) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This event is sold out.");
                }
            }
            unitPrice = event.getEntryFee() == null ? 0 : Math.max(0, event.getEntryFee());
        }

        double ticketAmount = unitPrice * quantity;
        User fresh = userRepository.findById(user.getId()).orElse(user);
        int available = fresh.getRewardPoints() == null ? 0 : fresh.getRewardPoints();
        int maxCoins = coinPolicy.maxRedeemableCoins(ticketAmount, available);
        int coins = Math.max(0, Math.min(requestedCoins, maxCoins));
        double payable = coinPolicy.payable(ticketAmount, coins);

        WomenEventRegistration existing = registrationRepository.findByEventAndUser(event, user).orElse(null);
        WomenEventRegistration reg;
        if (existing != null && "CANCELLED".equalsIgnoreCase(existing.getStatus())) {
            reg = existing;
            reg.setStatus("REGISTERED");
            reg.setCheckedIn(false);
            reg.setCheckedInAt(null);
            reg.setRefunded(false);
            reg.setRefundAmount(0.0);
            reg.setRegisteredAt(now);
        } else {
            reg = new WomenEventRegistration();
            reg.setEvent(event);
            reg.setUser(fresh);
            reg.setStatus("REGISTERED");
            reg.setRole("ATTENDEE");
        }
        reg.setTicketType(ticket);
        reg.setTicketTypeName(ticket == null ? (ticketAmount <= 0 ? "Free" : "General") : ticket.getName());
        reg.setQuantity(quantity);
        reg.setCoinsUsed(coins);
        reg.setPayableAmount(payable);
        reg.setPaid(payable <= 0);
        reg.setAmountPaid(payable <= 0 ? 0.0 : 0.0);

        if (ticket != null) {
            ticket.setSoldCount(ticket.getSoldCount() + quantity);
            ticketTypeRepository.save(ticket);
        }
        registrationRepository.save(reg);

        if (coins > 0) {
            debitCoins(fresh, coins, "Women Event booking #" + (reg.getId() == null ? "" : reg.getId()));
        }

        if (isSoldOut(event)) {
            lifecycleService.transition(event, EventLifecycleStatus.SOLD_OUT, "SYSTEM", null, null, "Capacity reached");
        }

        auditService.log("MEMBER", fresh.getId(), fresh.getEmail(), "BOOKING_CREATED",
                "BOOKING", reg.getId(), null,
                "{\"eventId\":" + event.getId() + ",\"coins\":" + coins + ",\"payable\":" + payable + "}");
        try {
            if (reg.getUser() != null) {
                pushNotificationService.notifyUser(
                        reg.getUser().getId(),
                        "Women Events",
                        "You're registered. " + EventsCareService.CANCEL_POLICY,
                        Map.of("type", "WOMEN_EVENT", "registrationId", String.valueOf(reg.getId())));
            }
        } catch (Exception ignored) {}
        return reg;
    }

    @Transactional
    public WomenEventRegistration checkIn(WomenEvent event, String code) {
        if (event == null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Event required");
        String raw = code == null ? "" : code.trim();
        if (raw.isBlank()) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ticket code is required");

        WomenEventRegistration reg = registrationRepository.findByTicketCode(raw.toUpperCase())
                .or(() -> registrationRepository.findByQrToken(raw))
                .or(() -> registrationRepository.findByTicketCode(raw))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid ticket"));

        if (reg.getEvent() == null || !reg.getEvent().getId().equals(event.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Wrong event");
        }
        if ("CANCELLED".equalsIgnoreCase(reg.getStatus())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cancelled booking");
        }
        if (Boolean.TRUE.equals(reg.getRefunded())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Refunded ticket");
        }
        if (reg.isCheckedIn() || "ATTENDED".equalsIgnoreCase(reg.getStatus())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Already checked-in ticket");
        }
        double fee = payableOf(reg);
        if (fee > 0 && !reg.isPaid()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Payment pending for this ticket");
        }
        LocalDateTime start = WomenEventSupport.eventStart(event);
        LocalDateTime end = WomenEventSupport.eventEnd(event);
        LocalDateTime now = LocalDateTime.now();
        if (end != null && now.isAfter(end.plusHours(6))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Expired ticket");
        }
        if (start != null && now.isBefore(start.minusHours(6))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ticket is not yet valid for check-in");
        }
        reg.setCheckedIn(true);
        reg.setStatus("ATTENDED");
        reg.setCheckedInAt(now);
        registrationRepository.save(reg);
        auditService.log("EVENT_HOST",
                event.getOrganizer() == null ? null : event.getOrganizer().getId(),
                event.getOrganizer() == null ? null : event.getOrganizer().getEmail(),
                "CHECK_IN", "BOOKING", reg.getId(), null, "{\"ticket\":\"" + reg.getTicketCode() + "\"}");
        return reg;
    }

    @Transactional
    public void restoreCoins(WomenEventRegistration r, String reason) {
        if (r == null || r.getCoinsUsed() == null || r.getCoinsUsed() <= 0) return;
        if (r.getUser() == null) return;
        User user = userRepository.findById(r.getUser().getId()).orElse(null);
        if (user == null) return;
        int coins = r.getCoinsUsed();
        int current = user.getRewardPoints() == null ? 0 : user.getRewardPoints();
        user.setRewardPoints(current + coins);
        userRepository.save(user);
        walletTransactionRepository.save(new WalletTransaction(
                user, (double) coins, "CREDIT",
                reason == null ? "Event booking coin restore" : reason,
                LocalDateTime.now()));
        r.setCoinsUsed(0);
        registrationRepository.save(r);
        auditService.log("SYSTEM", user.getId(), user.getEmail(), "COIN_RESTORE",
                "BOOKING", r.getId(), reason, "{\"coins\":" + coins + "}");
    }

    public double payableOf(WomenEventRegistration r) {
        if (r == null) return 0;
        if (r.getPayableAmount() != null && r.getPayableAmount() > 0) return r.getPayableAmount();
        if (r.isPaid()) return 0;
        double fee = r.getEvent() == null || r.getEvent().getEntryFee() == null ? 0 : r.getEvent().getEntryFee();
        return Math.max(0, fee);
    }

    public boolean isSoldOut(WomenEvent event) {
        var types = ticketTypeRepository.findByEventOrderByIdAsc(event);
        if (!types.isEmpty()) {
            return types.stream().noneMatch(t -> t.isActive() && t.remaining() > 0);
        }
        Integer max = event.getMaxParticipants();
        if (max == null || max <= 0) return false;
        return registrationRepository.countActiveByEvent(event) >= max;
    }

    private void debitCoins(User user, int coins, String description) {
        int current = user.getRewardPoints() == null ? 0 : user.getRewardPoints();
        if (current < coins) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Insufficient coins");
        }
        user.setRewardPoints(current - coins);
        userRepository.save(user);
        walletTransactionRepository.save(new WalletTransaction(
                user, (double) coins, "DEBIT", description, LocalDateTime.now()));
        auditService.log("MEMBER", user.getId(), user.getEmail(), "COIN_DEBIT",
                "WALLET", user.getId(), description, "{\"coins\":" + coins + "}");
    }
}
