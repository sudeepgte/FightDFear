package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.SOSRequest;
import in.sp.main.Service.FileUploadService;
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

    @Autowired
    private FileUploadService fileUploadService;

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
        if (sosRequest.getUser() == null || !sosRequest.getUser().getId().equals(user.getId())) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }

        try {
            String savedUrl = fileUploadService.saveFile(audioFile);
            sosRequest.setAudioRecordingPath(savedUrl);
            sosRequestRepository.save(sosRequest);

            response.put("success", true);
            response.put("audioPath", savedUrl);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to save audio file: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}