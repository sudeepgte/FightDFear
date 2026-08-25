package in.sp.main.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.*;

@Repository
public interface Booking1Repository extends JpaRepository<Booking1, Long> {

    List<Booking1> findByUser(User user);

    /** Prefer ID-based lookup - session User entities are detached. */
    List<Booking1> findByUser_IdOrderByIdDesc(Long userId);

    List<Booking1> findBySalon(Salon salon);

    /** Prefer ID-based lookup - session Salon entities are detached. */
    List<Booking1> findBySalon_IdOrderByIdDesc(Long salonId);

    // Find bookings for a salon on a specific date
    List<Booking1> findBySalonAndBookingDate(Salon salon, LocalDate date);

    // Count bookings for a salon on a specific date
    long countBySalonAndBookingDate(Salon salon, LocalDate date);

    // Count bookings for a salon with a specific status on a specific date
    @Query("SELECT COUNT(b) FROM Booking1 b WHERE b.salon = :salon AND b.bookingDate = :date AND LOWER(b.status) = LOWER(:status)")
    long countBySalonAndBookingDateAndStatusIgnoreCase(@Param("salon") Salon salon, @Param("date") LocalDate date, @Param("status") String status);

    long countBySalonAndStatusAndBookingDate(Salon salon, String status, LocalDate date);
    long countBySalonAndStatusAndBookingDateBetween(Salon salon, String status, LocalDate start, LocalDate end);
    long countBySalonAndBookingDateBetween(Salon salon, LocalDate start, LocalDate end);

    @Query("SELECT SUM(b.price) FROM Booking1 b WHERE b.salon = :salon AND b.status = 'COMPLETED' AND b.bookingDate = :date")
    Double sumRevenueBySalonAndDate(@Param("salon") Salon salon, @Param("date") LocalDate date);

    @Query("SELECT SUM(b.price) FROM Booking1 b WHERE b.salon = :salon AND b.status = 'COMPLETED' AND b.bookingDate BETWEEN :start AND :end")
    Double sumRevenueBySalonAndDateBetween(@Param("salon") Salon salon, @Param("start") LocalDate start, @Param("end") LocalDate end);

    // Find upcoming bookings for a salon
    @Query("SELECT b FROM Booking1 b WHERE b.salon = :salon AND b.bookingDate >= :today ORDER BY b.bookingDate ASC, b.preferredTime ASC")
    List<Booking1> findUpcomingBookingsBySalon(@Param("salon") Salon salon, @Param("today") LocalDate today);

    // Find recent bookings for a salon ordered by date desc
    @Query("SELECT b FROM Booking1 b WHERE b.salon = :salon ORDER BY b.bookingDate DESC, b.preferredTime DESC")
    List<Booking1> findBySalonOrderByBookingDateDesc(@Param("salon") Salon salon);

    // Count total bookings for a salon
    long countBySalon(Salon salon);

    // Find bookings for a salon between dates
    @Query("SELECT b FROM Booking1 b WHERE b.salon = :salon AND b.bookingDate BETWEEN :start AND :end ORDER BY b.bookingDate DESC, b.preferredTime DESC")
    List<Booking1> findBySalonAndBookingDateBetween(@Param("salon") Salon salon, @Param("start") LocalDate start, @Param("end") LocalDate end);

    List<Booking1> findByStatusIgnoreCase(String status);

    List<Booking1> findByBookingDateBetweenAndStatusInIgnoreCase(
            LocalDate from, LocalDate to, Collection<String> statuses);

    boolean existsByUser_IdAndSalon_IdAndStatusIgnoreCase(Long userId, Long salonId, String status);
}
