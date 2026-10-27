package in.sp.main.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class EmailAsyncService {

    private static final Logger log = LoggerFactory.getLogger(EmailAsyncService.class);

    @Autowired
    private EmailService emailService;

    @Async
    public void sendEmailAsync(String to, String subject, String text) {
        try {
            emailService.sendEmail(to, subject, text);
        } catch (Exception e) {
            log.warn("Async email send to {} failed: {}", to, e.getMessage());
        }
    }
}

