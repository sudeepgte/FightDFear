package in.sp.main.Service;

import java.io.File;
import java.io.IOException;
import java.util.Locale;
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

    /**
     * Ensures the upload is a real PNG or JPEG image (magic bytes), not only by extension/MIME.
     * @return null if valid, otherwise a user-facing error message
     */
    public String validatePngOrJpegImage(MultipartFile file, long maxBytes) {
        if (file == null || file.isEmpty()) {
            return null;
        }
        if (file.getSize() > maxBytes) {
            long maxMb = Math.max(1, maxBytes / (1024 * 1024));
            return "Profile photo must be at most " + maxMb + " MB.";
        }

        String contentType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);
        boolean declaredOk = contentType.equals("image/jpeg")
                || contentType.equals("image/jpg")
                || contentType.equals("image/png");
        if (!declaredOk && !contentType.isEmpty() && !contentType.equals("application/octet-stream")) {
            return "Profile photo must be a JPG/JPEG or PNG image.";
        }

        byte[] data;
        try {
            data = file.getBytes();
        } catch (IOException e) {
            return "Could not read the uploaded profile photo.";
        }
        if (data.length < 3) {
            return "Profile photo file is invalid or corrupted.";
        }

        boolean jpeg = isJpegHeader(data);
        boolean png = data.length >= 8 && isPngHeader(data);
        if (!jpeg && !png) {
            return "Profile photo must be a JPG/JPEG or PNG image (PDF and other formats are not allowed).";
        }

        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        if (!name.isEmpty()) {
            boolean extOk = name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png");
            if (!extOk) {
                return "Profile photo filename must end with .jpg, .jpeg, or .png.";
            }
        }
        return null;
    }

    private static boolean isJpegHeader(byte[] h) {
        return (h[0] & 0xFF) == 0xFF && (h[1] & 0xFF) == 0xD8 && (h[2] & 0xFF) == 0xFF;
    }

    private static boolean isPngHeader(byte[] h) {
        return (h[0] & 0xFF) == 0x89 && h[1] == 0x50 && h[2] == 0x4E && h[3] == 0x47
                && h[4] == 0x0D && h[5] == 0x0A && h[6] == 0x1A && h[7] == 0x0A;
    }
}
