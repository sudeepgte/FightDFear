package in.sp.main.Controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UploadsController {

    @Autowired
    private ServletContext servletContext;

    @GetMapping("/uploads/{fileName:.+}")
    public void getUploadedFile(@PathVariable String fileName, HttpServletResponse response) throws IOException {
        String permanentUploadDir = System.getProperty("user.dir") + File.separator + "uploads";
        Path filePath = Paths.get(permanentUploadDir).resolve(fileName).normalize();
        File file = filePath.toFile();

        // Check fallback temporary directory
        if (!file.exists()) {
            String tempUploadDir = servletContext.getRealPath("/uploads/");
            if (tempUploadDir != null) {
                filePath = Paths.get(tempUploadDir).resolve(fileName).normalize();
                file = filePath.toFile();
            }
        }

        if (!file.exists()) {
            String fileType = "File";
            String lowerName = fileName.toLowerCase();
            if (lowerName.endsWith(".mp4") || lowerName.endsWith(".mov") || lowerName.endsWith(".avi") || lowerName.endsWith(".mkv")) {
                fileType = "Video";
            } else if (lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg") || lowerName.endsWith(".png") || lowerName.endsWith(".gif")) {
                fileType = "Image";
            }

            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("text/html");
            response.getWriter().write("<html><body style='display:flex;justify-content:center;align-items:center;height:100vh;background:#f6f0f4;font-family:sans-serif;margin:0;'><div style='text-align:center;padding:2.5rem;background:white;border-radius:12px;box-shadow:0 4px 12px rgba(125,42,90,0.15);max-width:400px;'><h2 style='color:#7d2a5a;margin-top:0;font-size:1.5rem;'>" + fileType + " Not Found</h2><p style='color:#4b5563;font-size:0.95rem;line-height:1.5;'>This " + fileType.toLowerCase() + " was uploaded before the recent system update. It was saved in a temporary folder that has since been cleared by the server.</p><button onclick='window.close()' style='margin-top:1.5rem;background:#7d2a5a;color:white;border:none;padding:10px 20px;border-radius:6px;cursor:pointer;font-weight:600;font-size:0.9rem;'>Close Window</button></div></body></html>");
            return;
        }

        String mimeType = Files.probeContentType(filePath);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        Files.copy(filePath, response.getOutputStream());
        response.getOutputStream().flush();
    }
}
