package in.sp.main.Repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.Booking;
import in.sp.main.Entities.BookingStatus;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByUserId(Long userId);
    List<Booking> findBySalonId(Long salonId);
    List<Booking> findByStylistId(Long stylistId);
    List<Booking> findByBookingTimeBetween(LocalDateTime start, LocalDateTime end);
    List<Booking> findByIsInstantTrue(); // For "Available Now"
	List<Booking> findByStylistIdAndStatus(Long id, String string);
	boolean existsByUserIdAndStylistIdAndStatus(Long id, Long stylistId, BookingStatus completed);
	List<Booking> findByStylistIdAndStatus(Long stylistId, BookingStatus confirmed);
}
