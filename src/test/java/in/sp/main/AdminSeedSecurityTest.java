package in.sp.main;

import in.sp.main.Config.DevAdminSeeder;
import in.sp.main.Entities.Admin;
import in.sp.main.Repository.AdminRepository;
import in.sp.main.Service.AdminService;
import in.sp.main.Service.PasswordService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:admin_seed_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=test",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused"
})
public class AdminSeedSecurityTest {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private AdminService adminService;

    @Autowired
    private PasswordService passwordService;

    @BeforeEach
    void setUp() {
        adminRepository.deleteAll();
    }

    @Test
    void defaultHardcodedAdminSeed_MustNotExist() {
        // Assert that the former hardcoded credentials (admin@gmail.com / admin123) are not in DB
        assertTrue(adminRepository.findByEmail("admin@gmail.com").isEmpty(),
                "Hardcoded default admin seed must not exist in the database");
    }

    @Test
    void devAdminSeeder_RefusesToSeedWhenEnvironmentVariablesMissing() {
        // Seeder without dev.admin.email / dev.admin.password
        DevAdminSeeder seeder = new DevAdminSeeder(adminRepository, passwordService, "", "");
        seeder.run();

        assertTrue(adminRepository.findAll().isEmpty(),
                "DevAdminSeeder must not create any admin when credentials env variables are absent");
    }

    @Test
    void adminRoleDefaultAndSuperAdminChecks() {
        Admin regular = new Admin();
        regular.setEmail("staff@test.com");
        regular.setName("Staff Member");
        regular.setPassword("hash");
        assertEquals("ADMIN", regular.getRole(), "Default role should be ADMIN");
        assertFalse(regular.isSuperAdmin());
        assertFalse(adminService.isSuperAdmin(regular));

        Admin superAdmin = new Admin("Owner", "owner@test.com", "hash", "SUPER_ADMIN");
        assertTrue(superAdmin.isSuperAdmin());
        assertTrue(adminService.isSuperAdmin(superAdmin));
    }

    @Test
    void testProductionProfile_DoesNotLoadDevSeederOrSeedAdmin() {
        new ApplicationContextRunner()
                .withUserConfiguration(DevAdminSeeder.class)
                .withPropertyValues("spring.profiles.active=prod")
                .run(context -> {
                    assertFalse(context.containsBean("devAdminSeeder"),
                            "DevAdminSeeder must NOT be loaded under prod profile");
                });

        assertEquals(0, adminRepository.count(), "Initial and final admin count must be 0");
        assertTrue(adminRepository.findByEmail("admin@gmail.com").isEmpty(),
                "admin@gmail.com must not exist");
        assertNull(adminService.loginAdmin("admin@gmail.com", "Admin@123"),
                "Known default admin must not authenticate");
        assertNull(adminService.loginAdmin("admin@gmail.com", "admin123"),
                "Known default admin must not authenticate");
    }
}
