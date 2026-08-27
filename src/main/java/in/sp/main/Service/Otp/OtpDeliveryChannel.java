package in.sp.main.Service.Otp;

import in.sp.main.Entities.OtpChannel;

public interface OtpDeliveryChannel {
    void send(String destination, String subject, String body);
    OtpChannel channel();
}
