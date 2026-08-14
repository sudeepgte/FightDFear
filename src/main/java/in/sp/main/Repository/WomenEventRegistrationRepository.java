package in.sp.main.Repository;

import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface WomenEventRegistrationRepository extends JpaRepository<WomenEventRegistration, Long> {

    List<WomenEventRegistration> findByEvent(WomenEvent event);

    List<WomenEventRegistration> findByUserOrderByRegisteredAtDesc(User user);

    Optional<WomenEventRegistration> findByEventAndUser(WomenEvent event, User user);

    boolean existsByEventAndUser(WomenEvent event, User user);

    long countByEvent(WomenEvent event);

    Optional<WomenEventRegistration> findByTicketCode(String ticketCode);

    List<WomenEventRegistration> findByEventAndRole(WomenEvent event, String role);

    boolean existsByEventAndUserAndRole(WomenEvent event, User user, String role);

    long countByEventAndRole(WomenEvent event, String role);

    @Query("SELECT COUNT(r) FROM WomenEventRegistration r WHERE r.event = :event AND (r.status IS NULL OR UPPER(r.status) <> 'CANCELLED')")
    long countActiveByEvent(@Param("event") WomenEvent event);

    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM WomenEventRegistration r "
            + "WHERE r.event = :event AND r.user = :user AND (r.status IS NULL OR UPPER(r.status) <> 'CANCELLED')")
    boolean existsActiveByEventAndUser(@Param("event") WomenEvent event, @Param("user") User user);

    @Query("SELECT r FROM WomenEventRegistration r WHERE r.event = :event AND r.user = :user "
            + "AND (r.status IS NULL OR UPPER(r.status) <> 'CANCELLED')")
    Optional<WomenEventRegistration> findActiveByEventAndUser(@Param("event") WomenEvent event, @Param("user") User user);
}
