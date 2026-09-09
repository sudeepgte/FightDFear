package in.sp.main;

import in.sp.main.Service.storage.StorageCategory;
import in.sp.main.Service.storage.StorageValidation;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:upload_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
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
class UploadSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void testValidJpegUploadPasses() {
        byte[] jpegHeader = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, (byte) 0xE0, 0x00, 0x10, 0x4A, 0x46};
        MockMultipartFile file = new MockMultipartFile("file", "photo.jpg", "image/jpeg", jpegHeader);
        assertDoesNotThrow(() -> StorageValidation.validate(file, StorageCategory.IMAGE));
    }

    @Test
    void testValidPngUploadPasses() {
        byte[] pngHeader = new byte[]{(byte) 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00};
        MockMultipartFile file = new MockMultipartFile("file", "avatar.png", "image/png", pngHeader);
        assertDoesNotThrow(() -> StorageValidation.validate(file, StorageCategory.IMAGE));
    }

    @Test
    void testValidPdfUploadPasses() {
        byte[] pdfHeader = "%PDF-1.5 test content".getBytes(StandardCharsets.UTF_8);
        MockMultipartFile file = new MockMultipartFile("file", "resume.pdf", "application/pdf", pdfHeader);
        assertDoesNotThrow(() -> StorageValidation.validate(file, StorageCategory.DOCUMENT));
    }

    @Test
    void testValidMp4UploadPasses() {
        byte[] mp4Header = new byte[]{0x00, 0x00, 0x00, 0x18, 'f', 't', 'y', 'p', 'm', 'p', '4', '2'};
        MockMultipartFile file = new MockMultipartFile("file", "clip.mp4", "video/mp4", mp4Header);
        assertDoesNotThrow(() -> StorageValidation.validate(file, StorageCategory.VIDEO));
    }

    @Test
    void testSpoofedMimeTypeFailsMagicBytes() {
        // PHP shell with .jpg extension
        byte[] phpShell = "<?php echo 'malicious code'; ?>".getBytes(StandardCharsets.UTF_8);
        MockMultipartFile file = new MockMultipartFile("file", "innocent.jpg", "image/jpeg", phpShell);
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                StorageValidation.validate(file, StorageCategory.IMAGE));
        assertTrue(ex.getMessage().contains("File signature does not match JPEG image"));
    }

    @Test
    void testDangerousExtensionsRejected() {
        String[] dangerous = new String[]{"shell.jsp", "payload.svg", "index.html", "run.exe", "script.bat", "worm.sh", "code.php"};
        for (String name : dangerous) {
            byte[] content = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF};
            MockMultipartFile file = new MockMultipartFile("file", name, "image/jpeg", content);
            assertThrows(IllegalArgumentException.class, () ->
                    StorageValidation.validate(file, StorageCategory.IMAGE), "Should reject " + name);
        }
    }

    @Test
    void testDoubleExtensionRejected() {
        byte[] jpegHeader = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00};
        MockMultipartFile file1 = new MockMultipartFile("file", "backdoor.php.jpg", "image/jpeg", jpegHeader);
        MockMultipartFile file2 = new MockMultipartFile("file", "shell.jsp.png", "image/png", jpegHeader);

        assertThrows(IllegalArgumentException.class, () -> StorageValidation.validate(file1, StorageCategory.IMAGE));
        assertThrows(IllegalArgumentException.class, () -> StorageValidation.validate(file2, StorageCategory.IMAGE));
    }

    @Test
    void testPathTraversalInFilenameRejected() {
        byte[] jpegHeader = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00};
        MockMultipartFile file = new MockMultipartFile("file", "../../etc/passwd.jpg", "image/jpeg", jpegHeader);
        assertThrows(SecurityException.class, () -> StorageValidation.validate(file, StorageCategory.IMAGE));
    }

    @Test
    void testUploadsControllerBlocksDangerousFileTypes() throws Exception {
        mockMvc.perform(get("/uploads/evil.jsp"))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/uploads/test.html"))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/uploads/malware.exe"))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/uploads/vector.svg"))
                .andExpect(status().isForbidden());
    }

    @Test
    void testUploadsControllerBlocksPathTraversal() throws Exception {
        mockMvc.perform(get("/uploads/..%2fsecret.txt"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void testUploadsControllerSetsNosniffHeader() throws Exception {
        mockMvc.perform(get("/uploads/nonexistent-file.jpg"))
                .andExpect(header().string("X-Content-Type-Options", "nosniff"));
    }
}