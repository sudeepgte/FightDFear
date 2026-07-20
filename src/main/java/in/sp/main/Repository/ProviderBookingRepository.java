package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.User;

public interface ProviderBookingRepository extends JpaRepository<ProviderBooking, Long> {
    List<ProviderBooking> findByUserOrderByRequestedTimeDesc(User user);
    List<ProviderBooking> findByProviderOrderByRequestedTimeDesc(ServiceProvider provider);
}

