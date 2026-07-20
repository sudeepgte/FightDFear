package in.sp.main.Service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDate;

import org.springframework.stereotype.Service;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

@Service
public class CertificateService {
    
    private static final String CERTIFICATE_PATH = "C:/certificates/"; // Change path as needed

    public String generateCertificate(String userName, String courseName) {
        try {
            // Ensure directory exists
            File certDir = new File(CERTIFICATE_PATH);
            if (!certDir.exists()) {
                certDir.mkdirs();
            }

            // Define certificate file name
            String fileName = userName.replace(" ", "_") + "_" + courseName + "_Certificate.pdf";
            String filePath = CERTIFICATE_PATH + fileName;

            // Create document
            Document document = new Document();
            PdfWriter.getInstance(document, new FileOutputStream(filePath));

            // Open document
            document.open();

            // Define fonts
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 14);
            Font userFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Font dateFont = new Font(Font.FontFamily.HELVETICA, 12);

            // Add certificate content
            document.add(new Paragraph("CERTIFICATE OF COMPLETION", titleFont));
            document.add(new Paragraph("This is to certify that", normalFont));
            document.add(new Paragraph(userName, userFont));
            document.add(new Paragraph("has successfully completed the " + courseName + " training.", normalFont));
            document.add(new Paragraph("Date: " + LocalDate.now(), dateFont));

            // Close document
            document.close();

            return filePath; // Return path of generated certificate
        } catch (DocumentException | IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
