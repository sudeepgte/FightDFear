package in.sp.main.Repository;

import in.sp.main.Entities.WomenCartItem;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface WomenCartItemRepository extends JpaRepository<WomenCartItem, Long> {
    List<WomenCartItem> findByUser(User user);
    Optional<WomenCartItem> findByUserAndProduct_Id(User user, Long productId);
    @Transactional
    void deleteByUser(User user);
    @Transactional
    void deleteByProduct_Id(Long productId);
    long countByUser(User user);
}
