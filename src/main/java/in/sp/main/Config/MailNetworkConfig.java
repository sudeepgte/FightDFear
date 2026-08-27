package in.sp.main.Config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * On some Windows / ISP networks, {@code smtp.gmail.com} IPv4 is filtered while IPv6 works.
 * Java's default address order prefers IPv4, which surfaces as SMTP "Connect timed out"
 * even when Python (IPv6-first) can send mail successfully.
 * <p>
 * Prefer IPv6 for outbound sockets unless the operator already set an explicit JVM preference.
 */
@Component
@Order(0)
public class MailNetworkConfig implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(MailNetworkConfig.class);

    static {
        preferIpv6ForSmtpIfUnset();
    }

    public static void preferIpv6ForSmtpIfUnset() {
        if (System.getProperty("java.net.preferIPv4Stack") != null) {
            return;
        }
        if (System.getProperty("java.net.preferIPv6Addresses") != null) {
            return;
        }
        System.setProperty("java.net.preferIPv6Addresses", "true");
    }

    @Override
    public void run(ApplicationArguments args) {
        log.info("Mail network preference: preferIPv6Addresses={} preferIPv4Stack={}",
                System.getProperty("java.net.preferIPv6Addresses"),
                System.getProperty("java.net.preferIPv4Stack"));
    }
}
