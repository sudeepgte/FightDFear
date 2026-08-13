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

    /**
     * Serve files from the permanent uploads directory.
     * Uses {*fileName} so extensions like .jpg/.png are not stripped by path matching.
     */
    @GetMapping("/uploads/{*fileName}")
    public void getUploadedFile(@PathVariable("fileName") String fileName, HttpServletResponse response) throws IOException {
        if (fileName == null || fileName.isBlank()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        // {*var} may include a leading slash
        String normalizedName = fileName.trim().replace('\\', '/');
        while (normalizedName.startsWith("/")) {
            normalizedName = normalizedName.substring(1);
        }
        if (normalizedName.isEmpty() || normalizedName.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Path uploadsRoot = Paths.get(System.getProperty("user.dir"), "uploads").toAbsolutePath().normalize();
        Path filePath = uploadsRoot.resolve(normalizedName).normalize();
        if (!filePath.startsWith(uploadsRoot)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        File file = filePath.toFile();

        if (!file.exists() || !file.isFile()) {
            String tempUploadDir = servletContext.getRealPath("/uploads/");
            if (tempUploadDir != null) {
                Path tempRoot = Paths.get(tempUploadDir).toAbsolutePath().normalize();
                Path tempPath = tempRoot.resolve(normalizedName).normalize();
                if (tempPath.startsWith(tempRoot) && Files.isRegularFile(tempPath)) {
                    filePath = tempPath;
                    file = tempPath.toFile();
                }
            }
        }

        if (!file.exists() || !file.isFile()) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("text/html");
            response.getWriter().write("<html><body style='display:flex;justify-content:center;align-items:center;height:100vh;background:#f6f0f4;font-family:sans-serif;margin:0;'>"
                    + "<div style='text-align:center;padding:2.5rem;background:white;border-radius:12px;box-shadow:0 4px 12px rgba(125,42,90,0.15);max-width:400px;'>"
                    + "<h2 style='color:#7d2a5a;margin-top:0;font-size:1.5rem;'>Image Not Found</h2>"
                    + "<p style='color:#4b5563;font-size:0.95rem;line-height:1.5;'>The requested file could not be found on the server.</p>"
                    + "</div></body></html>");
            return;
        }

        String mimeType = Files.probeContentType(filePath);
        if (mimeType == null) {
            String lower = normalizedName.toLowerCase();
            if (lower.endsWith(".png")) mimeType = "image/png";
            else if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) mimeType = "image/jpeg";
            else if (lower.endsWith(".gif")) mimeType = "image/gif";
            else if (lower.endsWith(".webp")) mimeType = "image/webp";
            else mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        response.setHeader("Cache-Control", "public, max-age=86400");
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
        Files.copy(filePath, response.getOutputStream());
        response.getOutputStream().flush();
    }
}
