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

    @Autowired(required = false)
    private org.springframework.mail.javamail.JavaMailSender mailSender;

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

    public List<ContactMessage> findByEmail(String email) {
        if (email == null || email.isBlank()) return java.util.Collections.emptyList();
        return contactMessageRepository.findByEmailIgnoreCaseOrderBySubmittedAtDesc(email.trim());
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

    public Optional<ContactMessage> reply(Long id, String replyText) {
        return contactMessageRepository.findById(id).map(msg -> {
            msg.setAdminReply(replyText);
            msg.setRepliedAt(java.time.LocalDateTime.now());
            msg.setReadByAdmin(true);
            msg.setReplyReadByUser(false);
            ContactMessage saved = contactMessageRepository.save(msg);

            if (mailSender != null && saved.getEmail() != null && !saved.getEmail().isBlank()) {
                try {
                    org.springframework.mail.SimpleMailMessage mail = new org.springframework.mail.SimpleMailMessage();
                    mail.setTo(saved.getEmail());
                    mail.setSubject("Fight D Fear Response: " + saved.getSubject());
                    mail.setText("Hello " + saved.getName() + ",\n\n"
                            + "Our administration team has responded to your inquiry:\n\n\""
                            + replyText + "\"\n\n"
                            + "You can also view this response on Fight D Fear at /index/contact\n\n"
                            + "Best regards,\nFight D Fear Support Team");
                    mailSender.send(mail);
                } catch (Exception ignored) {
                    // Best effort email
                }
            }
            return saved;
        });
    }

    public void markReplyReadByUser(Long id, String email) {
        contactMessageRepository.findById(id).ifPresent(msg -> {
            if (email != null && email.equalsIgnoreCase(msg.getEmail())) {
                msg.setReplyReadByUser(true);
                contactMessageRepository.save(msg);
            }
        });
    }

    public void delete(Long id) {
        contactMessageRepository.deleteById(id);
    }
}
