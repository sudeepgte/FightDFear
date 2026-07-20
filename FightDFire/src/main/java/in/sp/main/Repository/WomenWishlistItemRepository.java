package in.sp.main.Repository;

import in.sp.main.Entities.WomenWishlistItem;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

public interface WomenWishlistItemRepository extends JpaRepository<WomenWishlistItem, Long> {
    List<WomenWishlistItem> findByUser(User user);
    boolean existsByUserAndProduct_Id(User user, Long productId);
    @Transactional
    void deleteByUserAndProduct_Id(User user, Long productId);
    @Transactional
    void deleteByProduct_Id(Long productId);
}
