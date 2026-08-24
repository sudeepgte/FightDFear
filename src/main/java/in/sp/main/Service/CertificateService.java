package in.sp.main.Service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

@Service
public class CertificateService {

    private static final Logger log = LoggerFactory.getLogger(CertificateService.class);

    @Value("${app.storage.certificate-dir:}")
    private String customCertificateDir;

    private Path resolveCertificatesDirectory() {
        Path dir;
        if (customCertificateDir != null && !customCertificateDir.trim().isEmpty()) {
            dir = Paths.get(customCertificateDir.trim());
        } else {
            String userHome = System.getProperty("user.home", ".");
            dir = Paths.get(userHome, ".fightdfear", "certificates");
        }
        try {
            if (!Files.exists(dir)) {
                Files.createDirectories(dir);
            }
        } catch (IOException e) {
            log.error("Failed to create certificate directory: " + dir, e);
            // Fallback to temp directory
            dir = Paths.get(System.getProperty("java.io.tmpdir", "."), "fightdfear-certificates");
            try {
                if (!Files.exists(dir)) {
                    Files.createDirectories(dir);
                }
            } catch (IOException ignored) {}
        }
        return dir;
    }

    public String generateCertificate(String userName, String courseName) {
        return generateBeltCertificate(userName, courseName, null, null, null);
    }

    public String generateBeltCertificate(String userName, String discipline, String beltName, String centreName, String trainerName) {
        try {
            Path certDir = resolveCertificatesDirectory();
            String cleanUser = (userName != null ? userName : "Student").replaceAll("[^a-zA-Z0-9_-]", "_");
            String cleanTitle = (discipline != null ? discipline : "Martial_Arts").replaceAll("[^a-zA-Z0-9_-]", "_");
            String certId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String fileName = "Cert_" + cleanUser + "_" + cleanTitle + "_" + certId + ".pdf";
            Path filePath = certDir.resolve(fileName);

            Document document = new Document(PageSize.A4.rotate(), 36, 36, 36, 36);
            PdfWriter.getInstance(document, new FileOutputStream(filePath.toFile()));

            document.open();

            // Colors
            BaseColor navy = new BaseColor(15, 23, 42);
            BaseColor gold = new BaseColor(180, 83, 9);
            BaseColor gray = new BaseColor(100, 116, 139);

            // Fonts
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, navy);
            Font subHeaderFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, gold);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 13, Font.NORMAL, navy);
            Font nameFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, navy);
            Font beltFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, gold);
            Font smallFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, gray);

            // Content
            Paragraph orgHeader = new Paragraph("FIGHT D FEAR · MARTIAL ARTS ACADEMY", subHeaderFont);
            orgHeader.setAlignment(Element.ALIGN_CENTER);
            orgHeader.setSpacingAfter(10);
            document.add(orgHeader);

            Paragraph title = new Paragraph(beltName != null ? "CERTIFICATE OF BELT PROMOTION" : "CERTIFICATE OF COMPLETION", headerFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(15);
            document.add(title);

            LineSeparator line = new LineSeparator(1, 80, gold, Element.ALIGN_CENTER, -2);
            document.add(line);

            Paragraph certText = new Paragraph();
            certText.setAlignment(Element.ALIGN_CENTER);
            certText.setSpacingBefore(20);
            certText.setSpacingAfter(10);
            certText.add(new Chunk("This is to proudly certify that\n\n", normalFont));
            certText.add(new Chunk(userName != null ? userName : "Student", nameFont));
            document.add(certText);

            Paragraph detailText = new Paragraph();
            detailText.setAlignment(Element.ALIGN_CENTER);
            detailText.setSpacingAfter(25);

            if (beltName != null && !beltName.isBlank()) {
                detailText.add(new Chunk("\nhas successfully passed the formal examination and is hereby awarded the rank of\n\n", normalFont));
                detailText.add(new Chunk(beltName + " in " + (discipline != null ? discipline : "Martial Arts") + "\n\n", beltFont));
            } else {
                detailText.add(new Chunk("\nhas successfully completed the training requirements for\n\n", normalFont));
                detailText.add(new Chunk((discipline != null ? discipline : "Martial Arts Training") + "\n\n", beltFont));
            }

            if (centreName != null && !centreName.isBlank()) {
                detailText.add(new Chunk("Certified at " + centreName + "\n", normalFont));
            }
            document.add(detailText);

            Paragraph footer = new Paragraph();
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.add(new Chunk("Certificate ID: FDF-" + certId + "  ·  Date Issued: " + LocalDate.now() + "\n", smallFont));
            if (trainerName != null && !trainerName.isBlank()) {
                footer.add(new Chunk("Authorized Examiner / Master Instructor: " + trainerName, smallFont));
            }
            document.add(footer);

            document.close();
            log.info("Certificate generated successfully: {}", filePath.toAbsolutePath());
            return filePath.toAbsolutePath().toString();
        } catch (Exception e) {
            log.error("Certificate generation error", e);
            return null;
        }
    }
}

