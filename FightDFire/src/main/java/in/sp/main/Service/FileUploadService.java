package in.sp.main.Service;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;

@Service
public class FileUploadService {

    private final ServletContext servletContext;

    public FileUploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }
 
    public String saveFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        // Use a permanent directory relative to the application's working directory
        // This prevents uploaded files from being deleted when the server restarts
        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads";  
        File uploadFolder = new File(uploadDir);

       
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        String originalName = file.getOriginalFilename();
        if (originalName != null) {
            // Remove non-ASCII and special characters to prevent DB insertion errors (e.g. emojis)
            originalName = originalName.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
        } else {
            originalName = "file";
        }
        
        String fileName = UUID.randomUUID().toString() + "_" + originalName;
        String filePath = uploadDir + File.separator + fileName;

      
        file.transferTo(new File(filePath));

   
        return "/uploads/" + fileName;
    }
}
