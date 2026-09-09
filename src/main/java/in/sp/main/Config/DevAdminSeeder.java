package in.sp.main.Config;

import in.sp.main.Entities.Admin;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Service.PasswordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * Optional development/test administrator seeder.
 * Strictly restricted to 'dev' and 'test' profiles.
 * Never executes in 'prod' or unprofiled environments.
 * Only provisions an account if DEV_ADMIN_EMAIL and DEV_ADMIN_PASSWORD are provided via environment.
 */
@Component
@Profile({"dev", "test"})
public class DevAdminSeeder implements CommandLineRunner {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private PasswordService passwordService;

    @Value("${dev.admin.email:}")
    private String devAdminEmail;

    @Value("${dev.admin.password:}")
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
                System.out.println("Controlled Dev Super Admin seeded for email: " + devAdminEmail.trim().toLowerCase());
            }
        }
    }
}
