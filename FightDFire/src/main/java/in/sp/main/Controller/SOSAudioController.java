package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.SOSRequest;
import in.sp.main.Service.SosService;
import in.sp.main.Repository.SOSRequestRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/sos/audio")
public class SOSAudioController {

    @Autowired
    private SOSRequestRepository sosRequestRepository;

    private final String UPLOAD_DIR = "src/main/resources/static/uploads/sos_recordings/";

    @PostMapping("/upload")
    public ResponseEntity<Map<String, Object>> uploadAudio(
            @RequestParam("sosId") Long sosId,
            @RequestParam("audio") MultipartFile audioFile,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        SOSRequest sosRequest = sosRequestRepository.findById(sosId).orElse(null);
        if (sosRequest == null) {
            response.put("success", false);
            response.put("message", "SOS request not found");
            return ResponseEntity.status(404).body(response);
        }

        try {
            // Ensure directory exists
            File directory = new File(UPLOAD_DIR);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            // Generate unique filename
            String fileName = "sos_" + sosId + "_" + UUID.randomUUID().toString() + ".webm";
            Path path = Paths.get(UPLOAD_DIR + fileName);
            Files.write(path, audioFile.getBytes());

            // Save path in database (relative path for web access)
            sosRequest.setAudioRecordingPath("/uploads/sos_recordings/" + fileName);
            sosRequestRepository.save(sosRequest);

            response.put("success", true);
            response.put("audioPath", sosRequest.getAudioRecordingPath());
            return ResponseEntity.ok(response);

        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Failed to save audio file: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}