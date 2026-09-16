package in.sp.main.Controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import in.sp.main.Service.storage.StorageService;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UploadsController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(UploadsController.class);

    private static final Set<String> BLOCKED_SERVE_EXTENSIONS = Set.of(
            "jsp", "jspx", "jspa", "html", "htm", "xhtml", "php", "asp", "aspx",
            "exe", "bat", "cmd", "sh", "bash", "ps1", "jar", "war", "class",
            "dll", "svg", "svgz", "svg+xml", "js", "vbs");

    @Autowired
    private StorageService storageService;

    @Autowired
    private ServletContext servletContext;

    @GetMapping("/uploads/{*fileName}")
    public void getUploadedFile(@PathVariable("fileName") String fileName, HttpServletResponse response) throws IOException {
        if (fileName == null || fileName.isBlank()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String normalizedName = fileName.trim().replace('\\', '/');
        while (normalizedName.startsWith("/")) {
            normalizedName = normalizedName.substring(1);
        }
        if (normalizedName.isEmpty() || normalizedName.contains("..") || normalizedName.contains("\0")) {
            log.warn("[SECURITY-AUDIT] event=PATH_TRAVERSAL_BLOCKED path={}",
                    in.sp.main.Util.LogSanitizer.sanitize(fileName));
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String lowerName = normalizedName.toLowerCase(Locale.ROOT);
        String ext = lowerName.contains(".") ? lowerName.substring(lowerName.lastIndexOf('.') + 1) : "";
        if (BLOCKED_SERVE_EXTENSIONS.contains(ext)) {
            log.warn("[SECURITY-AUDIT] event=BLOCKED_EXTENSION_REQUEST extension={} path={}",
                    in.sp.main.Util.LogSanitizer.sanitize(ext), in.sp.main.Util.LogSanitizer.sanitize(fileName));
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.setHeader("X-Content-Type-Options", "nosniff");

        try {
            Resource resource = storageService.readResource(normalizedName);
            if (resource.exists()) {
                serveResource(normalizedName, resource, response);
                return;
            }
        } catch (FileNotFoundException ignored) {
            // Fall through to legacy local/temp lookup
        } catch (SecurityException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Check permanent upload dir
        String permanentUploadDir = System.getProperty("user.dir") + File.separator + "uploads";
        Path permanentRoot = Paths.get(permanentUploadDir).toAbsolutePath().normalize();
        Path filePath = permanentRoot.resolve(normalizedName).normalize();
        
        if (!filePath.startsWith(permanentRoot)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        File file = filePath.toFile();

        // Check temp upload dir
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
            writeNotFoundPage(normalizedName, response);
            return;
        }

        String mimeType = Files.probeContentType(filePath);
        if (mimeType == null) {
            if (lowerName.endsWith(".png")) mimeType = "image/png";
            else if (lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")) mimeType = "image/jpeg";
            else if (lowerName.endsWith(".gif")) mimeType = "image/gif";
            else if (lowerName.endsWith(".webp")) mimeType = "image/webp";
            else if (lowerName.endsWith(".mp4")) mimeType = "video/mp4";
            else if (lowerName.endsWith(".pdf")) mimeType = "application/pdf";
            else mimeType = "application/octet-stream";
        }

        // Never serve HTML/SVG/executable MIME from uploads
        if (mimeType.contains("html") || mimeType.contains("javascript") || mimeType.contains("svg")) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        response.setHeader("Cache-Control", "public, max-age=86400");
        String safeName = file.getName().replaceAll("[^a-zA-Z0-9._-]", "_");
        response.setHeader("Content-Disposition", "inline; filename=\"" + safeName + "\"");
        Files.copy(filePath, response.getOutputStream());
        response.getOutputStream().flush();
    }

    private void serveResource(String fileName, Resource resource, HttpServletResponse response) throws IOException {
        String lower = fileName.toLowerCase(Locale.ROOT);
        String mimeType = Files.probeContentType(Paths.get(fileName));
        if (mimeType == null && resource.getFilename() != null) {
            mimeType = Files.probeContentType(Paths.get(resource.getFilename()));
        }
        if (mimeType == null) {
            if (lower.endsWith(".png")) mimeType = "image/png";
            else if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) mimeType = "image/jpeg";
            else if (lower.endsWith(".gif")) mimeType = "image/gif";
            else if (lower.endsWith(".webp")) mimeType = "image/webp";
            else if (lower.endsWith(".mp4")) mimeType = "video/mp4";
            else if (lower.endsWith(".pdf")) mimeType = "application/pdf";
            else mimeType = "application/octet-stream";
        }

        if (mimeType.contains("html") || mimeType.contains("javascript") || mimeType.contains("svg")) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        String safeName = Paths.get(fileName).getFileName().toString().replaceAll("[^a-zA-Z0-9._-]", "_");
        response.setHeader("Content-Disposition", "inline; filename=\"" + safeName + "\"");
        StreamUtils.copy(resource.getInputStream(), response.getOutputStream());
        response.getOutputStream().flush();
    }

    private void writeNotFoundPage(String fileName, HttpServletResponse response) throws IOException {
        String fileType = "File";
        String lowerName = fileName.toLowerCase(Locale.ROOT);
        if (lowerName.endsWith(".mp4") || lowerName.endsWith(".mov") || lowerName.endsWith(".avi")
                || lowerName.endsWith(".mkv")) {
            fileType = "Video";
        } else if (lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg") || lowerName.endsWith(".png")
                || lowerName.endsWith(".gif") || lowerName.endsWith(".webp")) {
            fileType = "Image";
        }

        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>File Not Found</title></head><body style='display:flex;justify-content:center;align-items:center;height:100vh;background:#f6f0f4;font-family:sans-serif;margin:0;'><div style='text-align:center;padding:2.5rem;background:white;border-radius:12px;box-shadow:0 4px 12px rgba(125,42,90,0.15);max-width:400px;'><h2 style='color:#7d2a5a;margin-top:0;font-size:1.5rem;'>" + fileType + " Not Found</h2><p style='color:#4b5563;font-size:0.95rem;line-height:1.5;'>This " + fileType.toLowerCase(Locale.ROOT) + " was not found or is no longer available.</p><button onclick='window.close()' style='margin-top:1.5rem;background:#7d2a5a;color:white;border:none;padding:10px 20px;border-radius:6px;cursor:pointer;font-weight:600;font-size:0.9rem;'>Close Window</button></div></body></html>");
    }
}
