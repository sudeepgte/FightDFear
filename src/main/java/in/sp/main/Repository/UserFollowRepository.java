package in.sp.main.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.User;
import in.sp.main.Entities.UserFollow;

@Repository
public interface UserFollowRepository extends JpaRepository<UserFollow, Long> {

    boolean existsByFollowerAndFollowed(User follower, User followed);

    List<UserFollow> findByFollower(User follower);

    List<UserFollow> findByFollowed(User followed);

    @Query("SELECT uf FROM UserFollow uf WHERE uf.follower = :a AND uf.followed = :b")
    Optional<UserFollow> findRelation(@Param("a") User a, @Param("b") User b);
    
    // derived delete by path: follower.id and followed.id
    void deleteByFollower_IdAndFollowed_Id(Long followerId, Long followedId);
    
    List<UserFollow> findByFollowed_IdAndAcceptedTrue(Long followedId);

    List<UserFollow> findByFollower_IdAndAcceptedTrue(Long followerId);

	UserFollow findByFollower_IdAndFollowed_Id(Long followerId, Long currentUserId);

	 boolean existsByFollower_IdAndFollowed_Id(Long followerId, Long followedId);

	boolean existsByFollower_IdAndFollowed_IdAndAcceptedTrue(Long followerId, Long followedId);

	 List<UserFollow> findByFollowed_IdAndAcceptedFalse(Long followedId);

	int countByFollowed_IdAndAcceptedFalse(Long userId);

	boolean existsByFollower_IdAndFollowed_IdAndAcceptedFalse(Long followerId, Long followedId);

	
}