package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.UserDeviceToken;

public interface UserDeviceTokenRepository extends JpaRepository<UserDeviceToken, Long> {
    List<UserDeviceToken> findByUserId(Long userId);
    Optional<UserDeviceToken> findByUserIdAndFcmToken(Long userId, String fcmToken);
}
