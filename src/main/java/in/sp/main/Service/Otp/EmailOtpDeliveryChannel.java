package in.sp.main.Service.Otp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import in.sp.main.Entities.OtpChannel;
import in.sp.main.Service.EmailService;

@Component
public class EmailOtpDeliveryChannel implements OtpDeliveryChannel {

    @Autowired
    private EmailService emailService;

    @Value("${otp.email.from-name:Fight D Fear}")
    private String fromName;

    @Override
    public OtpChannel channel() {
        return OtpChannel.EMAIL;
    }

    @Override
    public void send(String destination, String subject, String messageBody) {
        emailService.sendEmail(destination, subject, messageBody);
    }
}
