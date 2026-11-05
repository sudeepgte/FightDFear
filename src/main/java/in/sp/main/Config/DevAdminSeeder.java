package in.sp.main.Config;

import in.sp.main.Entities.Admin;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Service.PasswordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Default administrator seeder.
 * Provisions initial Super Admin account when no administrators exist in the database.
 */
@Component
public class DevAdminSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DevAdminSeeder.class);

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private PasswordService passwordService;

    @Value("${dev.admin.email:admin@gmail.com}")
    private String devAdminEmail;

    @Value("${dev.admin.password:Admin@123}")
    private String devAdminPassword;

    public DevAdminSeeder() {}

    public DevAdminSeeder(AdminRepository adminRepository, PasswordService passwordService, String devAdminEmail, String devAdminPassword) {
        this.adminRepository = adminRepository;
        this.passwordService = passwordService;
        this.devAdminEmail = devAdminEmail;
        this.devAdminPassword = devAdminPassword;
    }

    @Override
    public void run(String... args) {
        if (devAdminEmail != null && !devAdminEmail.isBlank()
                && devAdminPassword != null && !devAdminPassword.isBlank()) {
            if (adminRepository.count() == 0) {
                Admin admin = new Admin("Super Admin", devAdminEmail.trim().toLowerCase(), passwordService.encode(devAdminPassword.trim()), "SUPER_ADMIN");
                adminRepository.save(admin);
                log.info("Default Super Admin seeded for email: {}", devAdminEmail.trim().toLowerCase());
            }
        }
    }
}
