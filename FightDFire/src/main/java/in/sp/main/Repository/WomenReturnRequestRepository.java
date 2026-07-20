package in.sp.main.Repository;

import in.sp.main.Entities.WomenProductOrder;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Entities.WomenReturnRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WomenReturnRequestRepository extends JpaRepository<WomenReturnRequest, Long> {
    List<WomenReturnRequest> findBySellerOrderByRequestTimeDesc(WomenProductSeller seller);
    Optional<WomenReturnRequest> findByOrder(WomenProductOrder order);
}
