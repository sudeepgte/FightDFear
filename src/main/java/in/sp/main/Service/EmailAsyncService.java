package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class EmailAsyncService {

    @Autowired
    private EmailService emailService;

    @Async
    public void sendEmailAsync(String to, String subject, String text) {
        emailService.sendEmail(to, subject, text);
    }
}
