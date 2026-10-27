package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "contact_messages")
public class ContactMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String subject;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String message;

    private LocalDateTime submittedAt;

    @Column(name = "read_by_admin")
    private Boolean readByAdmin = false;

    @Column(name = "admin_reply", columnDefinition = "TEXT")
    private String adminReply;

    @Column(name = "replied_at")
    private LocalDateTime repliedAt;

    @Column(name = "reply_read_by_user")
    private Boolean replyReadByUser = false;

    public ContactMessage() {
        this.submittedAt = LocalDateTime.now();
        this.readByAdmin = false;
        this.replyReadByUser = false;
    }

    @PostLoad
    private void onLoad() {
        if (this.readByAdmin == null) {
            this.readByAdmin = false;
        }
        if (this.replyReadByUser == null) {
            this.replyReadByUser = false;
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public boolean isReadByAdmin() {
        return Boolean.TRUE.equals(readByAdmin);
    }

    public Boolean getReadByAdmin() {
        return isReadByAdmin();
    }

    public void setReadByAdmin(Boolean readByAdmin) {
        this.readByAdmin = (readByAdmin != null) ? readByAdmin : false;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public LocalDateTime getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(LocalDateTime repliedAt) {
        this.repliedAt = repliedAt;
    }

    public boolean isReplyReadByUser() {
        return Boolean.TRUE.equals(replyReadByUser);
    }

    public Boolean getReplyReadByUser() {
        return isReplyReadByUser();
    }

    public void setReplyReadByUser(Boolean replyReadByUser) {
        this.replyReadByUser = (replyReadByUser != null) ? replyReadByUser : false;
    }
}
