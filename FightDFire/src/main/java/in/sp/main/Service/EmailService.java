package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender emailSender;

    public void sendEmail(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("kvsudeep014@gmail.com"); 
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            emailSender.send(message);
            System.out.println("Email sent successfully to: " + to);
        } catch (Exception e) {

            System.err.println("CRITICAL: Email sending failed to " + to + ". Error: " + e.getMessage());

            System.err.println("Failed to send email to " + to + ": " + e.getMessage());

        }
    }
}



