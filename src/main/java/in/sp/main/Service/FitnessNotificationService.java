package in.sp.main.Service;

import java.time.LocalDate;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.FitnessAttendance;
import in.sp.main.Entities.FitnessBooking;
import in.sp.main.Entities.FitnessClass;
import in.sp.main.Entities.FitnessPackage;
import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.User;

@Service
public class FitnessNotificationService {

    private static final Logger log = LoggerFactory.getLogger(FitnessNotificationService.class);

    @Autowired
    private EmailAsyncService emailAsyncService;

    @Autowired
    private PushNotificationService pushNotificationService;

    /**
     * 1. PERSONAL TRAINING SESSION BOOKING CREATED
     */
    public void notifyPersonalBookingCreated(FitnessBooking booking) {
        if (booking == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = booking.getTrainer();

        // Push notification
        if (user != null && user.getId() != null) {
            try {
                pushNotificationService.notifyUser(
                        user.getId(),
                        "Fitness Session Requested",
                        "Your session request with Coach " + (trainer != null ? trainer.getFullName() : "Trainer") + " has been submitted.",
                        Map.of("type", "FITNESS", "bookingId", String.valueOf(booking.getId())));
            } catch (Exception ex) {
                log.warn("Push to user {} failed: {}", user.getId(), ex.getMessage());
            }
        }

        // Email to User
        if (user != null && hasEmail(user.getEmail())) {
            String subject = "Session Booking Request Submitted - " + (trainer != null ? trainer.getFullName() : "Coach") + " | Fight D Fear Fitness";
            String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                    + "Your personal fitness session booking request has been submitted successfully.\n\n"
                    + "Session Overview:\n"
                    + "--------------------------------------------------\n"
                    + "• Coach: " + (trainer != null ? trainer.getFullName() : "Assigned Coach") + "\n"
                    + "• Specialization: " + defaultStr(booking.getCategory(), "Personal Training") + "\n"
                    + "• Date: " + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "TBD") + "\n"
                    + "• Time Slot: " + defaultStr(booking.getBookingTime(), "TBD") + "\n"
                    + "• Session Format: " + defaultStr(booking.getSessionType(), "Online / In-Person") + "\n"
                    + "• Package Duration: " + defaultStr(booking.getDuration(), "SINGLE") + " (" + (booking.getTotalSessions() != null ? booking.getTotalSessions() : 1) + " session(s))\n"
                    + "• Amount: ₹" + (booking.getPaymentAmount() != null ? booking.getPaymentAmount() : 0.0) + "\n"
                    + "• Booking Status: " + defaultStr(booking.getStatus(), "PENDING") + " (Payment: " + defaultStr(booking.getPaymentStatus(), "PENDING") + ")\n"
                    + "--------------------------------------------------\n\n"
                    + "Coach Contact Information:\n"
                    + "• Email: " + (trainer != null && trainer.getEmail() != null ? trainer.getEmail() : "support@fightdfear.com") + "\n"
                    + "• Phone: " + (trainer != null && trainer.getPhone() != null ? trainer.getPhone() : "N/A") + "\n\n"
                    + "Cancellation Policy:\n"
                    + "Free cancellation is permitted up to 2 hours before the scheduled session start.\n\n"
                    + "You will receive another update as soon as your coach reviews and confirms your session.\n\n"
                    + "Stay empowered,\n"
                    + "Fight D Fear Fitness & Wellness Team";
            emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
        }

        // Email to Trainer
        if (trainer != null && hasEmail(trainer.getEmail())) {
            String subject = "New Booking Request from " + (user != null ? user.getFullName() : "Client") + " | Fight D Fear Studio";
            String body = "Dear Coach " + defaultStr(trainer.getFullName(), "Coach") + ",\n\n"
                    + "You have received a new personal session booking request!\n\n"
                    + "Client Details:\n"
                    + "--------------------------------------------------\n"
                    + "• Client Name: " + (user != null ? user.getFullName() : "Member") + "\n"
                    + "• Contact Email: " + (user != null && user.getEmail() != null ? user.getEmail() : "N/A") + "\n"
                    + "• Contact Phone: " + (user != null && user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A") + "\n\n"
                    + "Requested Session Information:\n"
                    + "--------------------------------------------------\n"
                    + "• Specialization: " + defaultStr(booking.getCategory(), "General Fitness") + "\n"
                    + "• Requested Date: " + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "TBD") + "\n"
                    + "• Requested Slot: " + defaultStr(booking.getBookingTime(), "TBD") + "\n"
                    + "• Format: " + defaultStr(booking.getSessionType(), "Online / In-Person") + "\n"
                    + "• Package: " + defaultStr(booking.getDuration(), "SINGLE") + " (" + (booking.getTotalSessions() != null ? booking.getTotalSessions() : 1) + " session(s))\n"
                    + "• Total Fee: ₹" + (booking.getPaymentAmount() != null ? booking.getPaymentAmount() : 0.0) + "\n"
                    + "--------------------------------------------------\n\n"
                    + "Please log in to your Trainer Portal to Accept, Reschedule, or manage this session request.\n\n"
                    + "Fight D Fear Studio Network";
            emailAsyncService.sendEmailAsync(trainer.getEmail(), subject, body);
        }
    }

    /**
     * 2. GROUP FITNESS CLASS ENROLLMENT
     */
    public void notifyClassEnrolled(FitnessBooking booking, FitnessClass fc) {
        if (booking == null || fc == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = fc.getTrainer();

        // Email to User
        if (user != null && hasEmail(user.getEmail())) {
            String subject = "Class Enrollment Confirmed: " + fc.getClassName() + " | Fight D Fear";
            String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                    + "Congratulations! Your spot in the group fitness session \"" + fc.getClassName() + "\" is confirmed.\n\n"
                    + "Class Details:\n"
                    + "--------------------------------------------------\n"
                    + "• Class: " + fc.getClassName() + " (" + defaultStr(fc.getCategory(), "Fitness") + ")\n"
                    + "• Coach: " + (trainer != null ? trainer.getFullName() : "Certified Coach") + "\n"
                    + "• Date: " + (fc.getClassDate() != null ? fc.getClassDate().toString() : "TBD") + "\n"
                    + "• Time: " + (fc.getClassTime() != null ? fc.getClassTime().toString() : "TBD") + "\n"
                    + "• Duration: " + (fc.getDurationMinutes() != null ? fc.getDurationMinutes() : 60) + " Minutes\n"
                    + "• Format: " + defaultStr(fc.getSessionType(), "ONLINE") + "\n"
                    + "• Location / Access Link: " + defaultStr(fc.getMeetingLinkOrLocation(), "Shared in class dashboard") + "\n"
                    + "• Fee: " + (fc.getPrice() != null && fc.getPrice() > 0 ? "₹" + fc.getPrice() : "FREE") + "\n"
                    + "--------------------------------------------------\n\n"
                    + "Please join 5 minutes prior to the start time with your workout gear ready.\n\n"
                    + "Fight D Fear Fitness & Wellness";
            emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
        }

        // Email to Trainer
        if (trainer != null && hasEmail(trainer.getEmail())) {
            int seatsLeft = (fc.getMaxCapacity() != null ? fc.getMaxCapacity() : 20)
                    - (fc.getCurrentEnrollment() != null ? fc.getCurrentEnrollment() : 0);
            String subject = "New Enrollment: " + fc.getClassName() + " - " + (user != null ? user.getFullName() : "Member");
            String body = "Dear Coach " + defaultStr(trainer.getFullName(), "Coach") + ",\n\n"
                    + "A member has just enrolled in your group class \"" + fc.getClassName() + "\".\n\n"
                    + "Member Info: " + (user != null ? user.getFullName() : "Member")
                    + " (" + (user != null && user.getEmail() != null ? user.getEmail() : "N/A") + ")\n"
                    + "Scheduled Date & Time: " + fc.getClassDate() + " at " + fc.getClassTime() + "\n"
                    + "Current Enrollment: " + fc.getCurrentEnrollment() + " / " + fc.getMaxCapacity() + " (" + Math.max(0, seatsLeft) + " spots left)\n\n"
                    + "Fight D Fear Studio Network";
            emailAsyncService.sendEmailAsync(trainer.getEmail(), subject, body);
        }
    }

    /**
     * 3. VALUE PASS / MEMBERSHIP PACKAGE SUBSCRIPTION
     */
    public void notifyPackageSubscribed(FitnessBooking booking, FitnessPackage pkg) {
        if (booking == null || pkg == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = pkg.getTrainer();

        // Email to User
        if (user != null && hasEmail(user.getEmail())) {
            String subject = "Membership Pass Subscribed: " + pkg.getPackageName() + " | Fight D Fear";
            String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                    + "You have successfully subscribed to the \"" + pkg.getPackageName() + "\" membership pass!\n\n"
                    + "Pass Benefits & Coverage:\n"
                    + "--------------------------------------------------\n"
                    + "• Pass Name: " + pkg.getPackageName() + "\n"
                    + "• Coach: " + (trainer != null ? trainer.getFullName() : "Dedicated Coach") + "\n"
                    + "• Category: " + defaultStr(pkg.getCategory(), "All Categories") + "\n"
                    + "• Total Workout Sessions: " + (pkg.getSessionCount() == 0 ? "Unlimited" : pkg.getSessionCount()) + "\n"
                    + "• Validity: " + pkg.getDurationDays() + " Days (Active until: " + (booking.getValidUntil() != null ? booking.getValidUntil().toString() : "N/A") + ")\n"
                    + "• Format: " + defaultStr(pkg.getSessionType(), "Online / In-Person") + "\n"
                    + "• Amount: ₹" + (pkg.getPrice() != null ? pkg.getPrice() : 0.0) + "\n"
                    + "--------------------------------------------------\n\n"
                    + "You can book sessions with Coach " + (trainer != null ? trainer.getFullName() : "your coach") + " at your convenience using this active pass.\n\n"
                    + "Fight D Fear Fitness";
            emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
        }

        // Email to Trainer
        if (trainer != null && hasEmail(trainer.getEmail())) {
            String subject = "New Pass Subscriber: " + pkg.getPackageName() + " - " + (user != null ? user.getFullName() : "Member");
            String body = "Dear Coach " + defaultStr(trainer.getFullName(), "Coach") + ",\n\n"
                    + "A client has subscribed to your pass \"" + pkg.getPackageName() + "\".\n\n"
                    + "• Client: " + (user != null ? user.getFullName() : "Member") + " (" + (user != null && user.getEmail() != null ? user.getEmail() : "") + ")\n"
                    + "• Pass: " + pkg.getPackageName() + " (" + (pkg.getSessionCount() == 0 ? "Unlimited" : pkg.getSessionCount() + " sessions") + ", " + pkg.getDurationDays() + " days)\n"
                    + "• Earnings Credited: ₹" + (pkg.getPrice() != null ? pkg.getPrice() : 0.0) + "\n\n"
                    + "Fight D Fear Studio Network";
            emailAsyncService.sendEmailAsync(trainer.getEmail(), subject, body);
        }
    }

    /**
     * 4. BOOKING STATUS UPDATE (APPROVED, REJECTED, COMPLETED)
     */
    public void notifyBookingStatusUpdated(FitnessBooking booking, String previousStatus) {
        if (booking == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = booking.getTrainer();
        String status = booking.getStatus() != null ? booking.getStatus().toUpperCase() : "";

        if ("APPROVED".equals(status)) {
            // Email to User
            if (user != null && hasEmail(user.getEmail())) {
                String subject = "Session Confirmed by Coach " + (trainer != null ? trainer.getFullName() : "Trainer") + " | Fight D Fear";
                String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                        + "Great news! Coach " + (trainer != null ? trainer.getFullName() : "your coach") + " has confirmed your fitness session.\n\n"
                        + "Confirmed Session Details:\n"
                        + "--------------------------------------------------\n"
                        + "• Date: " + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "TBD") + "\n"
                        + "• Time: " + defaultStr(booking.getBookingTime(), "TBD") + "\n"
                        + "• Format: " + defaultStr(booking.getSessionType(), "Online / In-Person") + "\n"
                        + "• Specialization: " + defaultStr(booking.getCategory(), "Fitness Training") + "\n"
                        + "--------------------------------------------------\n\n"
                        + "Coach Contact: " + (trainer != null ? trainer.getPhone() : "Available in app") + "\n\n"
                        + "Fight D Fear Fitness";
                emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
            }
        } else if ("REJECTED".equals(status)) {
            // Email to User
            if (user != null && hasEmail(user.getEmail())) {
                String subject = "Session Request Update - " + (trainer != null ? trainer.getFullName() : "Coach") + " | Fight D Fear";
                String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                        + "Coach " + (trainer != null ? trainer.getFullName() : "your coach") + " was unable to accept your session request for "
                        + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "the requested date") + " at " + defaultStr(booking.getBookingTime(), "") + ".\n\n"
                        + ("REFUNDED".equalsIgnoreCase(booking.getPaymentStatus())
                            ? "The session fee of ₹" + booking.getPaymentAmount() + " has been refunded back to your wallet balance.\n\n" : "")
                        + "You can browse other available coaches or choose a different time slot anytime.\n\n"
                        + "Fight D Fear Fitness";
                emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
            }
        } else if ("COMPLETED".equals(status)) {
            // Email to User
            if (user != null && hasEmail(user.getEmail())) {
                String subject = "Workout Completed! Rate Coach " + (trainer != null ? trainer.getFullName() : "Trainer") + " | Fight D Fear";
                String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                        + "Congratulations on completing your session with Coach " + (trainer != null ? trainer.getFullName() : "your coach") + "!\n\n"
                        + "Please take a moment to leave a review and rate your experience in the Fight D Fear app to help other members.\n\n"
                        + "Keep up the fantastic work,\n"
                        + "Fight D Fear Fitness";
                emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
            }
        }
    }

    /**
     * 5. BOOKING RESCHEDULED BY TRAINER
     */
    public void notifyBookingRescheduled(FitnessBooking booking, String oldDate, String oldTime) {
        if (booking == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = booking.getTrainer();

        // Email to User
        if (user != null && hasEmail(user.getEmail())) {
            String subject = "Session Rescheduled by Coach " + (trainer != null ? trainer.getFullName() : "Coach") + " | Fight D Fear";
            String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                    + "Your fitness training session has been rescheduled by Coach " + (trainer != null ? trainer.getFullName() : "your coach") + ".\n\n"
                    + "Updated Schedule:\n"
                    + "--------------------------------------------------\n"
                    + "• New Session Date: " + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "TBD") + "\n"
                    + "• New Session Time: " + defaultStr(booking.getBookingTime(), "TBD") + "\n"
                    + "• Previous Schedule: " + defaultStr(oldDate, "Previous Date") + " at " + defaultStr(oldTime, "Previous Time") + "\n"
                    + "• Session Format: " + defaultStr(booking.getSessionType(), "Online / In-Person") + "\n"
                    + "--------------------------------------------------\n\n"
                    + "If this new timing does not work for you, please contact Coach " + (trainer != null ? trainer.getFullName() : "your coach")
                    + " at " + (trainer != null && trainer.getPhone() != null ? trainer.getPhone() : "via the app") + " or manage your booking in the dashboard.\n\n"
                    + "Fight D Fear Fitness";
            emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
        }

        // Email to Trainer
        if (trainer != null && hasEmail(trainer.getEmail())) {
            String subject = "Reschedule Confirmation: " + (user != null ? user.getFullName() : "Session");
            String body = "Dear Coach " + defaultStr(trainer.getFullName(), "Coach") + ",\n\n"
                    + "You have rescheduled the session with " + (user != null ? user.getFullName() : "your client") + ".\n\n"
                    + "New Schedule: " + booking.getBookingDate() + " at " + booking.getBookingTime() + "\n"
                    + "Client notification email has been dispatched.\n\n"
                    + "Fight D Fear Studio Network";
            emailAsyncService.sendEmailAsync(trainer.getEmail(), subject, body);
        }
    }

    /**
     * 6. BOOKING CANCELLED
     */
    public void notifyBookingCancelled(FitnessBooking booking, boolean cancelledByTrainer) {
        if (booking == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = booking.getTrainer();

        // Email to User
        if (user != null && hasEmail(user.getEmail())) {
            String subject = "Session Cancellation Confirmed | Fight D Fear Fitness";
            String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                    + "Your fitness session scheduled for " + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "TBD")
                    + " at " + defaultStr(booking.getBookingTime(), "") + " has been cancelled" + (cancelledByTrainer ? " by your coach." : ".") + "\n\n"
                    + ("REFUNDED".equalsIgnoreCase(booking.getPaymentStatus())
                        ? "The refund amount of ₹" + booking.getPaymentAmount() + " has been processed to your wallet.\n\n" : "")
                    + "Feel free to book a new session whenever you are ready.\n\n"
                    + "Fight D Fear Fitness";
            emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
        }

        // Email to Trainer
        if (trainer != null && hasEmail(trainer.getEmail())) {
            String subject = "Session Cancelled: " + (user != null ? user.getFullName() : "Member") + " | Fight D Fear Studio";
            String body = "Dear Coach " + defaultStr(trainer.getFullName(), "Coach") + ",\n\n"
                    + "The session with " + (user != null ? user.getFullName() : "Member")
                    + " scheduled for " + (booking.getBookingDate() != null ? booking.getBookingDate().toString() : "TBD")
                    + " at " + defaultStr(booking.getBookingTime(), "") + " has been cancelled.\n\n"
                    + "This time slot is now open for new bookings.\n\n"
                    + "Fight D Fear Studio Network";
            emailAsyncService.sendEmailAsync(trainer.getEmail(), subject, body);
        }
    }

    /**
     * 7. ATTENDANCE & CHECK-IN RECORDED
     */
    public void notifyAttendanceRecorded(FitnessBooking booking, FitnessAttendance attendance) {
        if (booking == null || attendance == null) return;
        User user = booking.getUser();
        FitnessTrainer trainer = booking.getTrainer();

        if (user != null && hasEmail(user.getEmail())) {
            String subject = "Workout Attendance Recorded | Fight D Fear Fitness";
            String body = "Dear " + defaultStr(user.getFullName(), "Member") + ",\n\n"
                    + "Your attendance for the fitness session on " + (attendance.getSessionDate() != null ? attendance.getSessionDate().toString() : "today")
                    + " has been logged by Coach " + (trainer != null ? trainer.getFullName() : "your coach") + ".\n\n"
                    + "Attendance Summary:\n"
                    + "--------------------------------------------------\n"
                    + "• Status: " + defaultStr(attendance.getStatus(), "PRESENT") + "\n"
                    + "• Session Time: " + defaultStr(attendance.getSessionTime(), "Recorded") + "\n"
                    + "• Remaining Pass Sessions: " + (booking.getRemainingSessions() != null ? booking.getRemainingSessions() : "N/A") + "\n"
                    + (attendance.getNotes() != null && !attendance.getNotes().isBlank() ? "• Coach Notes: " + attendance.getNotes() + "\n" : "")
                    + "--------------------------------------------------\n\n"
                    + "Keep striving towards your fitness goals!\n\n"
                    + "Fight D Fear Fitness";
            emailAsyncService.sendEmailAsync(user.getEmail(), subject, body);
        }
    }

    private static boolean hasEmail(String email) {
        return email != null && !email.trim().isEmpty() && email.contains("@");
    }

    private static String defaultStr(String val, String def) {
        return val == null || val.trim().isEmpty() ? def : val.trim();
    }
}
