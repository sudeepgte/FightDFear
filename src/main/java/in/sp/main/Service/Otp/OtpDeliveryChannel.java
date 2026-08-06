package in.sp.main.Service.Otp;

import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;

/**
 * Pluggable OTP delivery channel (email today, SMS later).
 */
public interface OtpDeliveryChannel {

    OtpChannel channel();

    void send(String destination, String subject, String messageBody);
}
