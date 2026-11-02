package in.sp.main.Service;

import in.sp.main.Entities.BroadcastMessage;
import in.sp.main.Entities.CreatorNotification;
import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ProviderBookingStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.BroadcastMessageRepository;
import in.sp.main.Repository.CreatorNotificationRepository;
import in.sp.main.Repository.OfferRepository;
import in.sp.main.Repository.ProviderBookingRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WomenEventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class UserNotificationService {

    @Autowired private BroadcastMessageRepository broadcastRepo;
    @Autowired private WomenEventRepository eventRepo;
    @Autowired private OfferRepository offerRepo;
    @Autowired private CreatorNotificationRepository creatorNotificationRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private ProviderBookingRepository bookingRepo;
    @Autowired private in.sp.main.Repository.ContactMessageRepository contactMessageRepo;

    @Autowired private DoctorAppointmentRepository doctorAppointmentRepo;
    @Autowired private Booking1Repository glowBookingRepo;
    @Autowired private WomenEventRegistrationRepository eventRegRepo;
    @Autowired private EnrollmentRepository martialArtsRepo;
    @Autowired private FitnessBookingRepository fitnessRepo;
    @Autowired private FinancialEnrollmentRepository financialRepo;
    @Autowired private WorkerBookingRepository workerBookingRepo;
    @Autowired private WomenProductOrderRepository productOrderRepo;

    @Transactional(readOnly = true)
    public Map<String, Object> buildForUser(User user) {
        List<Map<String, Object>> items = new ArrayList<>();
        List<BroadcastMessage> broadcasts = broadcastRepo.findAllByOrderBySentAtDesc();
        LocalDateTime lastRead = user != null ? user.getLastReadBroadcastTime() : null;

        for (BroadcastMessage b : broadcasts) {
            if (items.size() >= 20) break;
            boolean unread = lastRead == null
                    || (b.getSentAt() != null && b.getSentAt().isAfter(lastRead));
            items.add(notificationItem(
                    "broadcast-" + b.getId(),
                    "BROADCAST",
                    b.getType() == null ? "INFO" : b.getType(),
                    b.getTitle() != null ? b.getTitle() : "Announcement",
                    b.getMessage(),
                    b.getSentAt(),
                    inferLink(b.getTitle(), b.getMessage(), b.getType()),
                    unread));
        }

        eventRepo.findByStatusOrderByCreatedAtDesc("APPROVED").stream().limit(3).forEach(e -> {
            String where = e.getCity() != null ? e.getCity()
                    : (e.getVenue() != null ? e.getVenue() : "Open now");
            String msg = where + (e.getEventDate() == null ? "" : " · " + e.getEventDate());
            items.add(notificationItem(
                    "event-" + e.getId(),
                    "EVENT",
                    "INFO",
                    "New event: " + nullToEmpty(e.getName()),
                    msg,
                    e.getCreatedAt(),
                    "/women-events",
                    lastRead == null));
        });

        offerRepo.findByActiveTrue().stream()
                .filter(o -> o.getSalon() != null && o.getSalon().isApproved())
                .limit(3)
                .forEach(o -> {
                    String salon = o.getSalon() == null ? "Glow Space" : o.getSalon().getName();
                    String discount = o.getDiscountPercent() > 0
                            ? ((int) o.getDiscountPercent()) + "% OFF · "
                            : "";
                    items.add(notificationItem(
                            "offer-" + o.getId(),
                            "OFFER",
                            "INFO",
                            o.getTitle() == null ? "Glow offer" : o.getTitle(),
                            discount + salon,
                            null,
                            "/user/offers",
                            lastRead == null));
                });

        if (user != null) {
            items.add(0, notificationItem(
                    "system-sos",
                    "SYSTEM",
                    "TIP",
                    "Stay prepared",
                    "Keep trusted contacts updated so SOS can reach help fast.",
                    null,
                    "/trusted-contacts",
                    false));

            try {
                List<CreatorNotification> creatorNotifs =
                        creatorNotificationRepo.findByUser_IdOrderByCreatedAtDesc(user.getId());
                for (CreatorNotification n : creatorNotifs) {
                    if (items.size() >= 40) break;
                    items.add(notificationItem(
                            "creator-" + n.getId(),
                            "CREATOR",
                            n.getType() != null ? n.getType() : "INFO",
                            "Creator Hub",
                            n.getMessage(),
                            n.getCreatedAt(),
                            "/creator/notifications",
                            !n.isRead()));
                }
            } catch (Exception ignored) {
                // Creator notifications optional
            }

            if (user.getEmail() != null && !user.getEmail().isBlank()) {
                try {
                    List<in.sp.main.Entities.ContactMessage> contactReplies =
                            contactMessageRepo.findByEmailIgnoreCaseAndAdminReplyIsNotNullOrderByRepliedAtDesc(user.getEmail().trim());
                    for (in.sp.main.Entities.ContactMessage cm : contactReplies) {
                        if (items.size() >= 50) break;
                        boolean unread = !cm.isReplyReadByUser();
                        items.add(0, notificationItem(
                                "contact-reply-" + cm.getId(),
                                "SUPPORT",
                                "INFO",
                                "Admin Response: " + (cm.getSubject() != null ? cm.getSubject() : "Your inquiry"),
                                cm.getAdminReply(),
                                cm.getRepliedAt(),
                                "/index/contact",
                                unread));
                    }
                } catch (Exception ignored) {
                    // Contact message replies optional
                }
            }

            try {
                List<ProviderBooking> bookings = bookingRepo.findByUserOrderByRequestedTimeDesc(user);
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM, hh:mm a");
                for (ProviderBooking b : bookings) {
                    if (items.size() >= 60) break;
                    String lawyerName = b.getProvider() != null && b.getProvider().getFullName() != null
                            ? b.getProvider().getFullName() : "Lawyer";
                    String timeStr = b.getRequestedTime() != null ? b.getRequestedTime().format(dtf) : "Upcoming";
                    ProviderBookingStatus st = b.getStatus() != null ? b.getStatus() : ProviderBookingStatus.PENDING;
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case CONFIRMED:
                            title = "Appointment Confirmed: Adv. " + lawyerName;
                            msg = "Your legal consultation on " + timeStr + " is confirmed. Tap to view.";
                            type = "SUCCESS";
                            break;
                        case CANCELLED:
                            title = "Appointment Cancelled: Adv. " + lawyerName;
                            msg = "Your legal consultation on " + timeStr + " was cancelled.";
                            type = "WARNING";
                            break;
                        case COMPLETED:
                            title = "Consultation Completed: Adv. " + lawyerName;
                            msg = "Consultation on " + timeStr + " completed. Tap to review.";
                            type = "INFO";
                            break;
                        default:
                            title = "Consultation Requested: Adv. " + lawyerName;
                            msg = "Requested for " + timeStr + ". Waiting for lawyer confirmation.";
                            type = "INFO";
                            break;
                    }
                    boolean unread = lastRead == null
                            || (b.getRequestedTime() != null && b.getRequestedTime().isAfter(lastRead));
                    items.add(0, notificationItem(
                            "booking-" + b.getId() + "-" + st.name().toLowerCase(),
                            "LAWYER",
                            type,
                            title,
                            msg,
                            b.getRequestedTime(),
                            "/marketplace/catalog",
                            unread));
                }
            } catch (Exception ignored) {
                // Booking notifications optional
            }

            // Doctor Appointments
            try {
                List<DoctorAppointment> docAppts = doctorAppointmentRepo.findByUserOrderByAppointmentTimeDesc(user);
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM, hh:mm a");
                for (DoctorAppointment a : docAppts) {
                    if (items.size() >= 100) break;
                    String docName = a.getDoctor() != null && a.getDoctor().getFullName() != null
                            ? a.getDoctor().getFullName() : "Doctor";
                    String timeStr = a.getAppointmentTime() != null ? a.getAppointmentTime().format(dtf) : "Upcoming";
                    DoctorAppointmentStatus st = a.getStatus() != null ? a.getStatus() : DoctorAppointmentStatus.PENDING;
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case CONFIRMED:
                            title = "Appointment Confirmed: Dr. " + docName;
                            msg = "Your consultation on " + timeStr + " is confirmed.";
                            type = "SUCCESS";
                            break;
                        case CANCELLED:
                            title = "Appointment Cancelled: Dr. " + docName;
                            msg = "Your consultation on " + timeStr + " was cancelled.";
                            type = "WARNING";
                            break;
                        case COMPLETED:
                            title = "Consultation Completed: Dr. " + docName;
                            msg = "Your consultation on " + timeStr + " is completed.";
                            type = "INFO";
                            break;
                        default:
                            title = "Appointment Scheduled: Dr. " + docName;
                            msg = "Scheduled for " + timeStr + ".";
                            type = "INFO";
                            break;
                    }
                    boolean unread = lastRead == null
                            || (a.getAppointmentTime() != null && a.getAppointmentTime().isAfter(lastRead));
                    items.add(0, notificationItem(
                            "doc-appt-" + a.getId() + "-" + st.name().toLowerCase(),
                            "DOCTOR",
                            type,
                            title,
                            msg,
                            a.getAppointmentTime(),
                            "/doctors",
                            unread));
                }
            } catch (Exception ignored) {}

            // Glow Space / Salon Bookings
            try {
                List<Booking1> glowBookings = glowBookingRepo.findByUser_IdOrderByIdDesc(user.getId());
                for (Booking1 b : glowBookings) {
                    if (items.size() >= 130) break;
                    String salonName = b.getSalon() != null && b.getSalon().getName() != null
                            ? b.getSalon().getName() : "Glow Space";
                    String itemName = b.getService() != null && b.getService().getName() != null
                            ? b.getService().getName()
                            : (b.getTreatment() != null && b.getTreatment().getServiceName() != null
                            ? b.getTreatment().getServiceName()
                            : (b.getOffer() != null && b.getOffer().getTitle() != null
                            ? b.getOffer().getTitle() : "service"));
                    String st = b.getStatus() != null ? b.getStatus().toUpperCase() : "PENDING";
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case "CONFIRMED":
                        case "PAID":
                            title = "Booking Confirmed: " + salonName;
                            msg = "Your Glow Space booking for " + itemName + " is confirmed.";
                            type = "SUCCESS";
                            break;
                        case "CANCELLED":
                        case "REJECTED":
                            title = "Booking Cancelled: " + salonName;
                            msg = "Your Glow Space booking was " + st.toLowerCase() + ".";
                            type = "WARNING";
                            break;
                        case "COMPLETED":
                            title = "Service Completed: " + salonName;
                            msg = "Your Glow Space service is completed.";
                            type = "INFO";
                            break;
                        default:
                            title = "Booking Requested: " + salonName;
                            msg = "Booking requested for " + itemName + ".";
                            type = "INFO";
                            break;
                    }
                    items.add(0, notificationItem(
                            "glow-booking-" + b.getId() + "-" + st.toLowerCase(),
                            "GLOW_SPACE",
                            type,
                            title,
                            msg,
                            b.getBookingDate() == null ? null : b.getBookingDate().atStartOfDay(),
                            "/user/user-salon-list",
                            lastRead == null));
                }
            } catch (Exception ignored) {}

            // Event Registrations
            try {
                List<WomenEventRegistration> eventRegs = eventRegRepo.findByUserOrderByRegisteredAtDesc(user);
                for (WomenEventRegistration r : eventRegs) {
                    if (items.size() >= 160) break;
                    String eventName = r.getEvent() != null && r.getEvent().getName() != null
                            ? r.getEvent().getName() : "Women Event";
                    String st = r.getStatus() != null ? r.getStatus().toUpperCase() : "REGISTERED";
                    String title;
                    String msg;
                    String type;
                    if ("CANCELLED".equals(st)) {
                        title = "Event Registration Cancelled: " + eventName;
                        msg = "Your ticket for " + eventName + " was cancelled.";
                        type = "WARNING";
                    } else if (r.isPaid() || "CONFIRMED".equals(st)) {
                        title = "Event Ticket Confirmed: " + eventName;
                        msg = "Your ticket for " + eventName + " is confirmed.";
                        type = "SUCCESS";
                    } else {
                        title = "Registered for Event: " + eventName;
                        msg = "Registration details for " + eventName + ".";
                        type = "INFO";
                    }
                    items.add(0, notificationItem(
                            "event-reg-" + r.getId() + "-" + st.toLowerCase(),
                            "EVENT",
                            type,
                            title,
                            msg,
                            r.getRegisteredAt(),
                            "/women-events",
                            lastRead == null || (r.getRegisteredAt() != null && r.getRegisteredAt().isAfter(lastRead))));
                }
            } catch (Exception ignored) {}

            // Martial Arts Enrollments
            try {
                List<Enrollment> maEnrollments = martialArtsRepo.findByUserId(user.getId());
                for (Enrollment e : maEnrollments) {
                    if (items.size() >= 180) break;
                    String centerName = e.getCenter() != null && e.getCenter().getName() != null
                            ? e.getCenter().getName() : "Martial Arts Centre";
                    String st = e.getStatus() != null ? e.getStatus().name() : "PENDING";
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case "APPROVED":
                        case "IN_PROGRESS":
                            title = "Enrollment Approved: " + centerName;
                            msg = "Your training enrollment at " + centerName + " is approved.";
                            type = "SUCCESS";
                            break;
                        case "REJECTED":
                        case "CANCELLED":
                            title = "Enrollment Status: " + centerName;
                            msg = "Your enrollment at " + centerName + " is " + st.toLowerCase() + ".";
                            type = "WARNING";
                            break;
                        default:
                            title = "Enrollment Requested: " + centerName;
                            msg = "Application submitted to " + centerName + ".";
                            type = "INFO";
                            break;
                    }
                    items.add(0, notificationItem(
                            "ma-enroll-" + e.getId() + "-" + st.toLowerCase(),
                            "MARTIAL_ARTS",
                            type,
                            title,
                            msg,
                            e.getEnrolledAt(),
                            "/centres/allacceptedcentres",
                            lastRead == null || (e.getEnrolledAt() != null && e.getEnrolledAt().isAfter(lastRead))));
                }
            } catch (Exception ignored) {}

            // Fitness Coaching Bookings
            try {
                List<FitnessBooking> fitnessBookings = fitnessRepo.findByUser_Id(user.getId());
                for (FitnessBooking fb : fitnessBookings) {
                    if (items.size() >= 200) break;
                    String trainerName = fb.getTrainer() != null && fb.getTrainer().getFullName() != null
                            ? fb.getTrainer().getFullName() : "Fitness Trainer";
                    String st = fb.getStatus() != null ? fb.getStatus().toUpperCase() : "PENDING";
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case "APPROVED":
                        case "ACCEPTED":
                        case "PAID":
                            title = "Fitness Session Confirmed: " + trainerName;
                            msg = "Your session with " + trainerName + " is confirmed.";
                            type = "SUCCESS";
                            break;
                        case "CANCELLED":
                        case "REJECTED":
                            title = "Fitness Session Cancelled: " + trainerName;
                            msg = "Your session with " + trainerName + " was " + st.toLowerCase() + ".";
                            type = "WARNING";
                            break;
                        default:
                            title = "Fitness Session Requested: " + trainerName;
                            msg = "Session request submitted to " + trainerName + ".";
                            type = "INFO";
                            break;
                    }
                    items.add(0, notificationItem(
                            "fitness-booking-" + fb.getId() + "-" + st.toLowerCase(),
                            "FITNESS",
                            type,
                            title,
                            msg,
                            fb.getBookingDate() == null ? null : fb.getBookingDate().atStartOfDay(),
                            "/fitness",
                            lastRead == null));
                }
            } catch (Exception ignored) {}

            // Financial Literacy Enrollments
            try {
                List<FinancialEnrollment> finEnrollments = financialRepo.findByUser_IdOrderByCreatedAtDesc(user.getId());
                for (FinancialEnrollment fe : finEnrollments) {
                    if (items.size() >= 220) break;
                    String sessionTitle = fe.getWorkshop() != null && fe.getWorkshop().getTitle() != null
                            ? fe.getWorkshop().getTitle()
                            : (fe.getLiveSession() != null && fe.getLiveSession().getTitle() != null
                            ? fe.getLiveSession().getTitle() : "Financial Workshop");
                    String st = fe.getStatus() != null ? fe.getStatus().toUpperCase() : "ENROLLED";
                    items.add(0, notificationItem(
                            "fin-enroll-" + fe.getId() + "-" + st.toLowerCase(),
                            "FINANCIAL",
                            "ENROLLED".equals(st) || "PAID".equals(st) ? "SUCCESS" : "INFO",
                            "Workshop Enrolled: " + sessionTitle,
                            "Your registration for " + sessionTitle + " is active.",
                            fe.getCreatedAt(),
                            "/financial-literacy",
                            lastRead == null || (fe.getCreatedAt() != null && fe.getCreatedAt().isAfter(lastRead))));
                }
            } catch (Exception ignored) {}

            // Marketplace Worker Bookings
            try {
                List<WorkerBooking> workerBookings = workerBookingRepo.findByClient_Id(user.getId());
                for (WorkerBooking wb : workerBookings) {
                    if (items.size() >= 240) break;
                    String workerName = wb.getJobApplication() != null && wb.getJobApplication().getUser() != null
                            && wb.getJobApplication().getUser().getFullName() != null
                            ? wb.getJobApplication().getUser().getFullName() : "Marketplace Worker";
                    String st = wb.getStatus() != null ? wb.getStatus().toUpperCase() : "PENDING";
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case "ACCEPTED":
                        case "PAID":
                            title = "Worker Booking Accepted: " + workerName;
                            msg = "Your booking with " + workerName + " is accepted.";
                            type = "SUCCESS";
                            break;
                        case "COMPLETED":
                            title = "Worker Service Completed: " + workerName;
                            msg = "Service with " + workerName + " has been completed.";
                            type = "INFO";
                            break;
                        case "CANCELLED":
                        case "REJECTED":
                            title = "Worker Booking Cancelled: " + workerName;
                            msg = "Booking with " + workerName + " was " + st.toLowerCase() + ".";
                            type = "WARNING";
                            break;
                        default:
                            title = "Worker Booking Sent: " + workerName;
                            msg = "Booking request sent to " + workerName + ".";
                            type = "INFO";
                            break;
                    }
                    items.add(0, notificationItem(
                            "worker-booking-" + wb.getId() + "-" + st.toLowerCase(),
                            "MARKETPLACE",
                            type,
                            title,
                            msg,
                            wb.getBookingDate(),
                            "/marketplace",
                            lastRead == null || (wb.getBookingDate() != null && wb.getBookingDate().isAfter(lastRead))));
                }
            } catch (Exception ignored) {}

            // Women Product Orders
            try {
                List<WomenProductOrder> productOrders = productOrderRepo.findByUserOrderByOrderTimeDesc(user);
                for (WomenProductOrder po : productOrders) {
                    if (items.size() >= 260) break;
                    String productName = po.getProduct() != null && po.getProduct().getName() != null
                            ? po.getProduct().getName() : "Product Order";
                    String st = po.getStatus() != null ? po.getStatus().toUpperCase() : "PLACED";
                    String title;
                    String msg;
                    String type;
                    switch (st) {
                        case "DELIVERED":
                            title = "Order Delivered: " + productName;
                            msg = "Order #" + po.getId() + " has been delivered successfully.";
                            type = "SUCCESS";
                            break;
                        case "SHIPPED":
                        case "OUT_FOR_DELIVERY":
                            title = "Order Out for Delivery: " + productName;
                            msg = "Order #" + po.getId() + " is " + st.toLowerCase().replace('_', ' ') + ".";
                            type = "INFO";
                            break;
                        case "CANCELLED":
                            title = "Order Cancelled: Order #" + po.getId();
                            msg = "Your order for " + productName + " was cancelled.";
                            type = "WARNING";
                            break;
                        default:
                            title = "Order Placed: Order #" + po.getId();
                            msg = "Order for " + productName + " is " + st.toLowerCase() + ".";
                            type = "INFO";
                            break;
                    }
                    items.add(0, notificationItem(
                            "product-order-" + po.getId() + "-" + st.toLowerCase(),
                            "E_COMMERCE",
                            type,
                            title,
                            msg,
                            po.getOrderTime(),
                            "/women-products/my-orders",
                            lastRead == null || (po.getOrderTime() != null && po.getOrderTime().isAfter(lastRead))));
                }
            } catch (Exception ignored) {}
        }

        int unreadCount = 0;
        for (Map<String, Object> item : items) {
            if (Boolean.TRUE.equals(item.get("unread"))) {
                unreadCount++;
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("unreadCount", unreadCount);
        result.put("notifications", items);
        result.put("count", items.size());
        return result;
    }

    @Transactional
    public void markAllRead(User user) {
        if (user == null) return;
        User fresh = userRepo.findById(user.getId()).orElse(user);
        fresh.setLastReadBroadcastTime(LocalDateTime.now());
        userRepo.save(fresh);

        try {
            List<CreatorNotification> creatorNotifs =
                    creatorNotificationRepo.findByUser_IdOrderByCreatedAtDesc(fresh.getId());
            boolean changed = false;
            for (CreatorNotification n : creatorNotifs) {
                if (!n.isRead()) {
                    n.setRead(true);
                    changed = true;
                }
            }
            if (changed) {
                creatorNotificationRepo.saveAll(creatorNotifs);
            }
        } catch (Exception ignored) {
            // Non-fatal
        }

        if (fresh.getEmail() != null && !fresh.getEmail().isBlank()) {
            try {
                List<in.sp.main.Entities.ContactMessage> contactReplies =
                        contactMessageRepo.findByEmailIgnoreCaseAndAdminReplyIsNotNullOrderByRepliedAtDesc(fresh.getEmail().trim());
                boolean changed = false;
                for (in.sp.main.Entities.ContactMessage cm : contactReplies) {
                    if (!cm.isReplyReadByUser()) {
                        cm.setReplyReadByUser(true);
                        changed = true;
                    }
                }
                if (changed) {
                    contactMessageRepo.saveAll(contactReplies);
                }
            } catch (Exception ignored) {
                // Non-fatal
            }
        }
    }

    private Map<String, Object> notificationItem(String id, String source, String type,
                                                  String title, String message,
                                                  LocalDateTime createdAt, String link,
                                                  boolean unread) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", id);
        m.put("source", source);
        m.put("type", type);
        m.put("title", title);
        m.put("message", message);
        m.put("createdAt", createdAt == null ? null : createdAt.toString());
        m.put("link", link);
        m.put("unread", unread);
        return m;
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private String inferLink(String title, String message, String type) {
        String blob = ((title == null ? "" : title) + " " + (message == null ? "" : message)
                + " " + (type == null ? "" : type)).toLowerCase(Locale.ROOT);
        if (blob.contains("sos") || blob.contains("emergency") || blob.contains("alert")) {
            return "/";
        }
        if (blob.contains("event") || blob.contains("workshop") || blob.contains("webinar")) {
            return "/women-events";
        }
        if (blob.contains("glow") || blob.contains("salon") || blob.contains("spa") || blob.contains("offer")) {
            return "/user/offers";
        }
        if (blob.contains("martial") || blob.contains("defence") || blob.contains("defense")
                || blob.contains("training")) {
            return "/centres/allacceptedcentres";
        }
        if (blob.contains("doctor") || blob.contains("health") || blob.contains("clinic")) {
            return "/doctors";
        }
        if (blob.contains("market") || blob.contains("provider") || blob.contains("service")) {
            return "/marketplace";
        }
        if (blob.contains("community") || blob.contains("creator") || blob.contains("video")) {
            return "/video/reels";
        }
        return null;
    }
}
