package in.sp.main.Service;

import in.sp.main.Entities.ContactMessage;
import in.sp.main.Repository.ContactMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ContactMessageService {

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    public ContactMessage save(String name, String email, String subject, String message) {
        ContactMessage contact = new ContactMessage();
        contact.setName(name);
        contact.setEmail(email);
        contact.setSubject(subject);
        contact.setMessage(message);
        return contactMessageRepository.save(contact);
    }

    public List<ContactMessage> findAll() {
        return contactMessageRepository.findAllByOrderBySubmittedAtDesc();
    }

    public List<ContactMessage> findRecent(int limit) {
        if (limit <= 5) {
            return contactMessageRepository.findTop5ByOrderBySubmittedAtDesc();
        }
        return contactMessageRepository.findAllByOrderBySubmittedAtDesc();
    }

    public long countUnread() {
        return contactMessageRepository.countByReadByAdminFalse();
    }

    public Optional<ContactMessage> findById(Long id) {
        return contactMessageRepository.findById(id);
    }

    public void markAsRead(Long id) {
        contactMessageRepository.findById(id).ifPresent(msg -> {
            msg.setReadByAdmin(true);
            contactMessageRepository.save(msg);
        });
    }

    public void delete(Long id) {
        contactMessageRepository.deleteById(id);
    }
}
