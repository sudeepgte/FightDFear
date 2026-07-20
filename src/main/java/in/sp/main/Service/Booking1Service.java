package in.sp.main.Service;
 
import in.sp.main.Entities.OfferBooking;
import in.sp.main.Repository.OfferBookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 
import java.util.List;
 
@Service
public class Booking1Service {
 
    @Autowired
    private OfferBookingRepository offerBookingRepository;
 
    // Save offer booking
    public void saveBooking(OfferBooking booking) {
        offerBookingRepository.save(booking);
    }
 
    // Get all bookings
    public List<OfferBooking> getAllBookings() {
        return offerBookingRepository.findAll();
    }
 
    // Get bookings by salon ID
    public List<OfferBooking> getBookingsBySalonId(Long salonId) {
        return offerBookingRepository.findBySalonId(salonId);
    }
 
    // Get bookings by user name
    public List<OfferBooking> getBookingsByUser(String customerName) {
        return offerBookingRepository.findByCustomerName(customerName);
    }
}