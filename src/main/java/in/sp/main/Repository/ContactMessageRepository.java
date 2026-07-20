package in.sp.main.Repository;

import in.sp.main.Entities.ContactMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContactMessageRepository extends JpaRepository<ContactMessage, Long> {

    List<ContactMessage> findAllByOrderBySubmittedAtDesc();

    List<ContactMessage> findTop5ByOrderBySubmittedAtDesc();

    long countByReadByAdminFalse();
}
