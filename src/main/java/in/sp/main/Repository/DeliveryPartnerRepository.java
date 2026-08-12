package in.sp.main.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;

public interface DeliveryPartnerRepository extends JpaRepository<DeliveryPartner, Long> {
    Optional<DeliveryPartner> findByEmail(String email);
    List<DeliveryPartner> findByVerificationStatus(VerificationStatus status);
    List<DeliveryPartner> findByPartnerProfileStatusIn(Collection<PartnerProfileStatus> statuses);
    List<DeliveryPartner> findByPartnerProfileStatusIsNull();
}
