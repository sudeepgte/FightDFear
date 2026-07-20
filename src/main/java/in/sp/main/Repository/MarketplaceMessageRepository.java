package in.sp.main.Repository;

import in.sp.main.Entities.MarketplaceMessage;
import in.sp.main.Entities.ProviderBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MarketplaceMessageRepository extends JpaRepository<MarketplaceMessage, Long> {
    List<MarketplaceMessage> findByBookingOrderByTimestampAsc(ProviderBooking booking);
}
