package in.sp.main;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class FightthefireApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(FightthefireApplication.class);
    }

    public static void main(String[] args) {
        // Must run before any SMTP sockets open (see MailNetworkConfig).
        in.sp.main.Config.MailNetworkConfig.preferIpv6ForSmtpIfUnset();
        SpringApplication.run(FightthefireApplication.class, args);
        System.out.println("Women safety");
    }
}


