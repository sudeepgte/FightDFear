package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.ChatMessage;
import in.sp.main.Entities.User;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    List<ChatMessage> findBySenderAndReceiverOrReceiverAndSenderOrderByTimestampAsc(
        User sender, User receiver, User receiver2, User sender2
    );

    @Query("""
    SELECT m FROM ChatMessage m 
    WHERE (m.sender.id = :user1Id AND m.receiver.id = :user2Id)
       OR (m.sender.id = :user2Id AND m.receiver.id = :user1Id)
    ORDER BY m.timestamp ASC
    """)
    List<ChatMessage> findChatHistory(
        @Param("user1Id") Long user1Id,
        @Param("user2Id") Long user2Id
    );

    // ✅ FIXED
    @Modifying
    @Query("""
    UPDATE ChatMessage c 
    SET c.readStatus = true 
    WHERE c.sender.id = :senderId 
      AND c.receiver.id = :receiverId 
      AND c.readStatus = false
    """)
    void markMessagesAsRead(
        @Param("senderId") Long senderId,
        @Param("receiverId") Long receiverId
    );

	List<ChatMessage> findByGroupIdOrderByCreatedAtAsc(Long groupId);
}
