package in.sp.main.Service;

import in.sp.main.Entities.Booking1;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GlowBookingNotificationService {

    private static final Logger log = LoggerFactory.getLogger(GlowBookingNotificationService.class);

    @Autowired
    private EmailService emailService;

    private String getServiceName(Booking1 b) {
        if (b == null) return "Beauty Service";
        if (b.getService() != null && b.getService().getName() != null) return b.getService().getName();
        if (b.getTreatment() != null && b.getTreatment().getServiceName() != null) return b.getTreatment().getServiceName();
        if (b.getOffer() != null && b.getOffer().getTitle() != null) return b.getOffer().getTitle();
        if (b.getSalonPackage() != null && b.getSalonPackage().getPackageName() != null) return b.getSalonPackage().getPackageName();
        if (b.getSalonMembership() != null && b.getSalonMembership().getMembershipName() != null) return b.getSalonMembership().getMembershipName();
        return "Beauty & Wellness Service";
    }

    public void notifyBookingCreated(Booking1 booking) {
        if (booking == null) return;
        User user = booking.getUser();
        Salon salon = booking.getSalon();
        String serviceName = getServiceName(booking);
        String clientName = user != null && user.getFullName() != null && !user.getFullName().isBlank() ? user.getFullName() : "Customer";
        String salonName = salon != null && salon.getName() != null && !salon.getName().isBlank() ? salon.getName() : "Glow Space";

        // 1. Email to Customer
        if (emailService != null && user != null && user.getEmail() != null && !user.getEmail().isBlank()) {
            try {
                emailService.sendEmail(
                        user.getEmail(),
                        "Glow Space Booking Request Received - #" + booking.getId(),
                        "Hello " + clientName + ",\n\nYour appointment request at '" + salonName + "' for '" + serviceName + "' has been received!\n\nBooking Details:\n- Booking ID: #" + booking.getId() + "\n- Date: " + booking.getBookingDate() + "\n- Time: " + booking.getPreferredTime() + "\n- Price: ₹" + booking.getPrice() + "\n- Status: " + booking.getStatus() + "\n\nWe will notify you once confirmed by the salon.\n\nThank you,\nFight D Fear"
                );
            } catch (Exception ex) {
                log.warn("Failed to send booking creation email to user: {}", ex.getMessage());
            }
        }

        // 2. Email to Salon / Owner
        if (emailService != null && salon != null && salon.getEmail() != null && !salon.getEmail().isBlank()) {
            try {
                emailService.sendEmail(
                        salon.getEmail(),
                        "New Booking Alert: #" + booking.getId() + " - " + serviceName,
                        "Hello " + salonName + ",\n\nYou have received a new appointment booking from " + clientName + "!\n\nBooking Details:\n- Booking ID: #" + booking.getId() + "\n- Client Name: " + clientName + "\n- Service: " + serviceName + "\n- Date: " + booking.getBookingDate() + "\n- Time: " + booking.getPreferredTime() + "\n- Price: ₹" + booking.getPrice() + "\n\nPlease check your dashboard to manage this appointment.\n\nThank you,\nFight D Fear"
                );
            } catch (Exception ex) {
                log.warn("Failed to send booking creation email to salon: {}", ex.getMessage());
            }
        }
    }

    public void notifyBookingStatusUpdated(Booking1 booking, String status) {
        if (booking == null || status == null) return;
        User user = booking.getUser();
        Salon salon = booking.getSalon();
        String serviceName = getServiceName(booking);
        String clientName = user != null && user.getFullName() != null && !user.getFullName().isBlank() ? user.getFullName() : "Customer";
        String salonName = salon != null && salon.getName() != null && !salon.getName().isBlank() ? salon.getName() : "Glow Space";
        String displayStatus = status.trim().toUpperCase();

        // 1. Email to Customer
        if (emailService != null && user != null && user.getEmail() != null && !user.getEmail().isBlank()) {
            try {
                emailService.sendEmail(
                        user.getEmail(),
                        "Glow Space Booking Update: #" + booking.getId() + " is " + displayStatus,
                        "Hello " + clientName + ",\n\nYour booking #" + booking.getId() + " at '" + salonName + "' for '" + serviceName + "' status has been updated to: " + displayStatus + ".\n\nBooking Details:\n- Date: " + booking.getBookingDate() + "\n- Time: " + booking.getPreferredTime() + "\n- Salon: " + salonName + "\n\nThank you,\nFight D Fear"
                );
            } catch (Exception ex) {
                log.warn("Failed to send status email to user: {}", ex.getMessage());
            }
        }

        // 2. Email to Salon
        if (emailService != null && salon != null && salon.getEmail() != null && !salon.getEmail().isBlank()) {
            try {
                emailService.sendEmail(
                        salon.getEmail(),
                        "Booking #" + booking.getId() + " Status Update: " + displayStatus,
                        "Hello " + salonName + ",\n\nBooking #" + booking.getId() + " for '" + serviceName + "' (Client: " + clientName + ") status changed to: " + displayStatus + ".\n\nThank you,\nFight D Fear"
                );
            } catch (Exception ex) {
                log.warn("Failed to send status email to salon: {}", ex.getMessage());
            }
        }
    }
}
