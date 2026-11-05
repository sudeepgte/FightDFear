package in.sp.main.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailAuthenticationException;
import org.springframework.mail.MailSendException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender emailSender;

    @Value("${spring.mail.username:}")
    private String mailFrom;

    @Value("${spring.mail.password:}")
    private String mailPassword;

    @jakarta.annotation.PostConstruct
    void logMailConfig() {
        if (emailSender instanceof JavaMailSenderImpl impl) {
            if (mailFrom != null && !mailFrom.isBlank()) {
                impl.setUsername(mailFrom.trim());
            }
            if (mailPassword != null && !mailPassword.isBlank()) {
                impl.setPassword(mailPassword.trim());
            }
        }
        log.info("Mail SMTP user={} passwordSet={}",
                (mailFrom == null || mailFrom.isBlank()) ? "(empty)" : mailFrom.trim(),
                mailPassword != null && !mailPassword.isBlank());
    }

    public boolean isConfigured() {
        return mailFrom != null && !mailFrom.isBlank()
                && mailPassword != null && !mailPassword.isBlank();
    }

    public void sendEmail(String to, String subject, String text) {
        if (to == null || to.isBlank()) {
            throw new IllegalStateException("Recipient email is required");
        }
        if (mailFrom == null || mailFrom.isBlank()) {
            log.warn("Mail send skipped: MAIL_USERNAME / spring.mail.username is not set");
            throw new IllegalStateException(
                    "Email service is not configured. Set MAIL_USERNAME and MAIL_PASSWORD.");
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(mailFrom.trim());
            message.setTo(to.trim());
            message.setSubject(subject);
            message.setText(text);
            emailSender.send(message);
            log.info("Email sent successfully to {}", to.trim());
        } catch (MailAuthenticationException e) {
            log.error("SMTP authentication failed while sending to {}: {}", to, rootMessage(e));
            throw new IllegalStateException(
                    "Email authentication failed. Check MAIL_USERNAME / MAIL_PASSWORD (Gmail app password).", e);
        } catch (MailSendException e) {
            log.error("SMTP send failed while sending to {}: {}", to, rootMessage(e));
            throw new IllegalStateException("Could not deliver email: " + rootMessage(e), e);
        } catch (Exception e) {
            log.error("Unexpected mail failure while sending to {}: {}", to, rootMessage(e), e);
            throw new IllegalStateException("Could not send email to " + to + ": " + rootMessage(e), e);
        }
    }

    private static String rootMessage(Throwable e) {
        Throwable cur = e;
        String msg = e.getMessage();
        while (cur.getCause() != null && cur.getCause() != cur) {
            cur = cur.getCause();
            if (cur.getMessage() != null && !cur.getMessage().isBlank()) {
                msg = cur.getMessage();
            }
        }
        return msg == null ? e.getClass().getSimpleName() : msg;
    }
}
