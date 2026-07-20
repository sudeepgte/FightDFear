package in.sp.main.Repository;

import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
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
}
