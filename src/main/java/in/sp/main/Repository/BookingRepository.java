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
    List<Booking> findBySalonIdAndBookingTimeBetween(Long salonId, LocalDateTime start, LocalDateTime end);
    List<Booking> findBySalonIdAndStatus(Long salonId, BookingStatus status);
    
    List<Booking> findBySalonIdAndUserId(Long salonId, Long userId);
    List<Booking> findBySalonIdAndUserIdOrderByBookingTimeDesc(Long salonId, Long userId);

    @org.springframework.data.jpa.repository.Query("SELECT b.salonService.name, COUNT(b) as bookingCount FROM Booking b WHERE b.salon.id = :salonId AND b.salonService IS NOT NULL GROUP BY b.salonService.name ORDER BY bookingCount DESC")
    List<Object[]> findTopServicesBySalonId(@org.springframework.data.repository.query.Param("salonId") Long salonId);

    long countBySalonIdAndBookingTimeBetween(Long salonId, LocalDateTime start, LocalDateTime end);
    long countBySalonIdAndStatusAndBookingTimeBetween(Long salonId, BookingStatus status, LocalDateTime start, LocalDateTime end);
    long countBySalonId(Long salonId);

    @org.springframework.data.jpa.repository.Query("SELECT SUM(b.pricePaid) FROM Booking b WHERE b.salon.id = :salonId AND b.status = 'COMPLETED' AND b.bookingTime BETWEEN :start AND :end")
    Double sumRevenueBySalonIdAndDate(@org.springframework.data.repository.query.Param("salonId") Long salonId, @org.springframework.data.repository.query.Param("start") LocalDateTime start, @org.springframework.data.repository.query.Param("end") LocalDateTime end);

    @org.springframework.data.jpa.repository.Query("SELECT AVG(b.rating), COUNT(b) FROM Booking b WHERE b.salon.id = :salonId AND b.rating IS NOT NULL")
    List<Object[]> getAverageRatingAndCount(@org.springframework.data.repository.query.Param("salonId") Long salonId);
}

