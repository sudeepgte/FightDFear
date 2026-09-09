package in.sp.main;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.io.File;
import java.nio.file.Files;
import java.time.LocalDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:file_dl_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused"
})
class SensitiveFileDownloadSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorAppointmentRepository appointmentRepository;

    private User userA;
    private User userB;
    private Admin admin;
    private Enrollment enrollmentA;
    private DoctorAppointment appointmentA;
    private File tempCertFile;

    @BeforeEach
    void setup() throws Exception {
        appointmentRepository.deleteAll();
        enrollmentRepository.deleteAll();
        doctorRepository.deleteAll();
        userRepository.deleteAll();
        adminRepository.deleteAll();

        // Create Users
        User u1 = new User();
        u1.setFullName("Alice User");
        u1.setEmail("alice@test.com");
        u1.setPassword("Pass@1234");
        userA = userRepository.save(u1);

        User u2 = new User();
        u2.setFullName("Bob User");
        u2.setEmail("bob@test.com");
        u2.setPassword("Pass@1234");
        userB = userRepository.save(u2);

        Admin adm = new Admin("Super Admin", "admin@test.com", "Admin@1234");
        admin = adminRepository.save(adm);

        // Create temporary certificate file
        tempCertFile = File.createTempFile("test_cert_", ".pdf");
        Files.write(tempCertFile.toPath(), "%PDF-1.4 certificate data".getBytes());
        tempCertFile.deleteOnExit();

        // Create Enrollment for userA
        Enrollment enr = new Enrollment();
        enr.setUser(userA);
        enr.setFullName("Alice User");
        enr.setStatus(TrainingStatus.COMPLETED);
        enr.setPaymentStatus("PAID");
        enr.setCertificateDetails(tempCertFile.getAbsolutePath());
        enrollmentA = enrollmentRepository.save(enr);

        // Create Doctor and Appointment with prescription for userA
        Doctor doc = new Doctor();
        doc.setFullName("Dr. Smith");
        doc.setEmail("doctor@test.com");
        doc.setPassword("Doc@1234");
        doc.setVerificationStatus(VerificationStatus.VERIFIED);
        doc.setDoctorProfileStatus(DoctorProfileStatus.APPROVED);
        doc = doctorRepository.save(doc);

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(userA);
        appt.setDoctor(doc);
        appt.setAppointmentTime(LocalDateTime.now().plusDays(1));
        appt.setStatus(DoctorAppointmentStatus.COMPLETED);
        appt.setPrescriptionText("Take Paracetamol 500mg twice daily for 3 days.");
        appointmentA = appointmentRepository.save(appt);
    }

    @Test
    void unauthenticatedCannotDownloadCertificate() throws Exception {
        mockMvc.perform(get("/enrollment/downloadCertificate/" + enrollmentA.getId()))
                .andExpect(status().is3xxRedirection())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl("/login"));
    }

    @Test
    void ownerCanDownloadCertificate() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/enrollment/downloadCertificate/" + enrollmentA.getId()).session(session))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Disposition", org.hamcrest.Matchers.containsString("attachment")));
    }

    @Test
    void crossUserCannotDownloadCertificate() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userB);

        mockMvc.perform(get("/enrollment/downloadCertificate/" + enrollmentA.getId()).session(session))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminCanDownloadCertificate() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("admin", admin);

        mockMvc.perform(get("/enrollment/downloadCertificate/" + enrollmentA.getId()).session(session))
                .andExpect(status().isOk());
    }

    @Test
    void unauthenticatedCannotDownloadPrescription() throws Exception {
        mockMvc.perform(get("/doctors/appointments/" + appointmentA.getId() + "/prescription/download"))
                .andExpect(status().is3xxRedirection())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl("/login"));
    }

    @Test
    void ownerCanDownloadPrescription() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/doctors/appointments/" + appointmentA.getId() + "/prescription/download").session(session))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Disposition", org.hamcrest.Matchers.containsString("attachment")));
    }

    @Test
    void crossUserCannotDownloadPrescription() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userB);

        mockMvc.perform(get("/doctors/appointments/" + appointmentA.getId() + "/prescription/download").session(session))
                .andExpect(status().isForbidden());
    }

    @Test
    void prescriptionNotFoundWhenMissing() throws Exception {
        appointmentA.setPrescriptionText(null);
        appointmentRepository.save(appointmentA);

        MockHttpSession session = new MockHttpSession();
        session.setAttribute("user", userA);

        mockMvc.perform(get("/doctors/appointments/" + appointmentA.getId() + "/prescription/download").session(session))
                .andExpect(status().isNotFound());
    }

    @Test
    void uploadsEndpointBlocksDangerousFilesAndTraversals() throws Exception {
        mockMvc.perform(get("/uploads/evil.jsp"))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/uploads/..%2fsecret.txt"))
                .andExpect(status().isBadRequest());
    }
}
