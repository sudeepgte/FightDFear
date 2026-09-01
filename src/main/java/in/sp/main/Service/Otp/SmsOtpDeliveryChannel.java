package in.sp.main.Service.Otp;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.OtpChannel;
import in.sp.main.Service.SMSService;

@Component
public class SmsOtpDeliveryChannel implements OtpDeliveryChannel {

    private final SMSService smsService;

    public SmsOtpDeliveryChannel(SMSService smsService) {
        this.smsService = smsService;
    }

    @Override
    public OtpChannel channel() {
        return OtpChannel.SMS;
    }

    @Override
    public void send(String destination, String subject, String body) {
        if (!smsService.sendSMS(destination, body)) {
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Could not send verification SMS. Please try again in a moment.");
        }
    }
}
