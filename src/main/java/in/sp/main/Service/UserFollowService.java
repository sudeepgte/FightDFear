package in.sp.main.Service;

import java.util.stream.Collectors;
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.User;
import in.sp.main.Entities.UserFollow;
import in.sp.main.Repository.UserFollowRepository;
import in.sp.main.Repository.UserRepository;
import jakarta.transaction.Transactional;


@Service
public class UserFollowService {

    @Autowired
    private UserFollowRepository followRepo;

    @Autowired
    private UserRepository userRepo;

    @Autowired(required = false)
    private in.sp.main.Repository.CreatorNotificationRepository creatorNotificationRepository;

    @Autowired(required = false)
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;
    
    private static final Logger log = LoggerFactory.getLogger(UserFollowService.class);

    public void followUser(Long followerId, Long followedId) {
        log.info("followUser called: followerId={} followedId={}", followerId, followedId);
        User follower = userRepo.findById(followerId).orElseThrow();
        User followed = userRepo.findById(followedId).orElseThrow();

        UserFollow existing = followRepo.findByFollower_IdAndFollowed_Id(followerId, followedId);
        
        if (existing == null) {
            log.info("Creating new follow request from {} to {}", followerId, followedId);
            UserFollow uf = new UserFollow();
            uf.setFollower(follower);
            uf.setFollowed(followed);
            
            // Check if the other user is already following this user and is accepted
            boolean isAlreadyFollowedByTarget = followRepo.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(followedId, followerId);
            
            if (isAlreadyFollowedByTarget) {
                log.info("Target user {} already follows {}, auto-accepting follow back", followedId, followerId);
                uf.setAccepted(true);
            } else {
                uf.setAccepted(false);
            }
            
            followRepo.save(uf);
            log.info("Follow relationship saved: id={}, accepted={}", uf.getId(), uf.isAccepted());

            if (creatorNotificationRepository != null) {
                try {
                    in.sp.main.Entities.CreatorNotification notif = new in.sp.main.Entities.CreatorNotification();
                    notif.setUser(followed);
                    notif.setSender(follower);
                    notif.setType("FOLLOW");
                    notif.setMessage(follower.getFullName() + (uf.isAccepted() ? " started following you." : " requested to follow you."));
                    creatorNotificationRepository.save(notif);

                    if (messagingTemplate != null) {
                        Map<String, Object> evt = new HashMap<>();
                        evt.put("type", "FOLLOW_NOTIFICATION");
                        evt.put("message", notif.getMessage());
                        evt.put("senderName", follower.getFullName());
                        messagingTemplate.convertAndSend("/topic/follow/" + followed.getId(), evt);
                    }
                } catch (Exception e) {
                    log.warn("Could not save or broadcast follow notification: {}", e.getMessage());
                }
            }
        } else if (!existing.isAccepted()) {
            // If request exists but not accepted, and now we are "following back" (or just trying to follow again)
            // check if we should auto-accept it now
            boolean isAlreadyFollowedByTarget = followRepo.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(followedId, followerId);
            if (isAlreadyFollowedByTarget) {
                log.info("Existing pending request from {} to {} found, auto-accepting as target now follows back", followerId, followedId);
                existing.setAccepted(true);
                followRepo.save(existing);
            }
        } else {
            log.info("Follow relationship already exists and is accepted between {} and {}", followerId, followedId);
        }
    }

    public boolean isFollowing(Long followerId, Long followingId) {
        return followRepo.existsByFollower_IdAndFollowed_Id(followerId, followingId);
    }

    public boolean isAcceptedFollower(Long followerId, Long followedId) {
        return followRepo.existsByFollower_IdAndFollowed_IdAndAcceptedTrue(followerId, followedId);
    }


    public boolean isFollowing(User follower, User followed) {
        return followRepo.existsByFollowerAndFollowed(follower, followed);
    }

    public boolean isMutualFollow(User a, User b) {
        return isFollowing(a, b) && isFollowing(b, a);
    }

 // ONLY accepted followers
    public List<User> getFollowers(Long userId) {
        return followRepo.findByFollowed_IdAndAcceptedTrue(userId)
                .stream()
                .map(UserFollow::getFollower)
                .collect(Collectors.toList());
    }

    // ONLY accepted following
    public List<User> getFollowing(Long userId) {
        return followRepo.findByFollower_IdAndAcceptedTrue(userId)
                .stream()
                .map(UserFollow::getFollowed)
                .collect(Collectors.toList());
    }

    // Pending requests
    public List<User> getPendingRequests(Long userId) {
        return followRepo.findByFollowed_IdAndAcceptedFalse(userId)
                .stream()
                .map(UserFollow::getFollower)
                .collect(Collectors.toList());
    }

    public boolean isPendingRequest(Long followerId, Long followedId) {
        return followRepo.existsByFollower_IdAndFollowed_IdAndAcceptedFalse(
                followerId, followedId);
    }

    // ✅ Accept follow request
    public void acceptRequest(Long currentUserId, Long followerId) {
        UserFollow request = followRepo.findByFollower_IdAndFollowed_Id(followerId, currentUserId);
        if (request != null) {
            request.setAccepted(true);
            followRepo.save(request);
            log.info("Follow request from {} to {} accepted", followerId, currentUserId);
            
            // Also check if currentUserId is following followerId (pending)
            // If so, auto-accept that as well to make them mutual friends immediately
            UserFollow inverseRequest = followRepo.findByFollower_IdAndFollowed_Id(currentUserId, followerId);
            if (inverseRequest != null && !inverseRequest.isAccepted()) {
                inverseRequest.setAccepted(true);
                followRepo.save(inverseRequest);
                log.info("Inverse follow request from {} to {} auto-accepted upon acceptance", currentUserId, followerId);
            }
        }
    }
    

    @Transactional
    public void unfollowUser(Long followerId, Long followedId) {
        log.info("unfollowUser called with followerId={} followedId={}", followerId, followedId);
        followRepo.deleteByFollower_IdAndFollowed_Id(followerId, followedId);
        log.info("deleteByFollower_IdAndFollowed_Id executed for followerId={} followedId={}", followerId, followedId);
    }
    
    // ❌ Decline follow request
    public void declineRequest(Long currentUserId, Long followerId) {
        UserFollow request = followRepo.findByFollower_IdAndFollowed_Id(followerId, currentUserId);
        if (request != null) {
            followRepo.delete(request);
        }
    }
    public int getPendingRequestCount(Long userId) {
        return followRepo.countByFollowed_IdAndAcceptedFalse(userId);
    }
    public List<User> getFriends(Long userId) {
        List<User> followers = getFollowers(userId);
        List<User> following = getFollowing(userId);

        log.info("getFriends for {}: followers={}, following={}", userId, followers.size(), following.size());

        List<User> friends = new ArrayList<>();
        for (User u : followers) {
            if (following.contains(u)) {
                friends.add(u);
            }
        }
        log.info("getFriends for {}: mutual friends={}", userId, friends.size());
        return friends;
    }

}