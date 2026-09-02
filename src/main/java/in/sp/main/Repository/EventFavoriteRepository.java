package in.sp.main.Repository;

import in.sp.main.Entities.EventFavorite;
import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface EventFavoriteRepository extends JpaRepository<EventFavorite, Long> {
    Optional<EventFavorite> findByEventAndUser(WomenEvent event, User user);
    boolean existsByEventAndUser(WomenEvent event, User user);
    List<EventFavorite> findByUserOrderByCreatedAtDesc(User user);
    void deleteByEventAndUser(WomenEvent event, User user);
}
