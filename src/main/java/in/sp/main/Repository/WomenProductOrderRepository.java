package in.sp.main.Repository;

import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WomenProductOrderRepository extends JpaRepository<WomenProductOrder, Long> {
    List<WomenProductOrder> findByUserOrderByOrderTimeDesc(User user);
    List<WomenProductOrder> findBySellerOrderByOrderTimeDesc(WomenProductSeller seller);
    List<WomenProductOrder> findByProduct_IdOrderByOrderTimeDesc(Long productId);
    List<WomenProductOrder> findAllByOrderByOrderTimeDesc();
}
