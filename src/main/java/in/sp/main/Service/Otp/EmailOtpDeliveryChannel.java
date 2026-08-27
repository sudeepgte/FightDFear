package in.sp.main.Service.Otp;

import in.sp.main.Entities.OtpChannel;
import in.sp.main.Service.EmailService;
import org.springframework.stereotype.Component;

@Component
public class EmailOtpDeliveryChannel implements OtpDeliveryChannel {

    private final EmailService emailService;

    public EmailOtpDeliveryChannel(EmailService emailService) {
        this.emailService = emailService;
    }

    @Override
    public OtpChannel channel() {
        return OtpChannel.EMAIL;
    }

    @Override
    public void send(String destination, String subject, String body) {
        emailService.sendEmail(destination, subject, body);
    }
}
