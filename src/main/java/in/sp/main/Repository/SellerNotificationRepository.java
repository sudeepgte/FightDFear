package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.SellerNotification;
import in.sp.main.Entities.WomenProductSeller;

@Repository
public interface SellerNotificationRepository extends JpaRepository<SellerNotification, Long> {

    List<SellerNotification> findBySeller_IdOrderByCreatedAtDesc(Long sellerId);

    List<SellerNotification> findBySellerOrderByCreatedAtDesc(WomenProductSeller seller);

    long countBySeller_IdAndReadFlagFalse(Long sellerId);

    long countBySellerAndReadFlagFalse(WomenProductSeller seller);

    @Modifying
    @Query("UPDATE SellerNotification n SET n.readFlag = true WHERE n.seller.id = :sellerId AND n.readFlag = false")
    int markAllAsRead(@Param("sellerId") Long sellerId);
}
