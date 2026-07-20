package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/recording")
public class RecordingController {

    private boolean isRecording = false;
    private boolean isStreaming = false;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String storagePath = "/videos/";
    private String streamingPlatform = "None";

    // ✅ Live Streaming Platform Selection Page
    @RequestMapping(value = "/select", method = RequestMethod.GET)
    public String showPlatformSelection() {
        return "liveStreaming";  // Rendering liveStreaming.jsp
    }

    // ✅ Save Selected Platform in Session
    @RequestMapping(value = "/selectPlatform", method = RequestMethod.POST)
    @ResponseBody
    public void selectPlatform(@RequestParam String platform, HttpSession session) {
        session.setAttribute("streamingPlatform", platform);
    }

    // ✅ Show Recording Page with Selected Platform
    @RequestMapping(method = RequestMethod.GET)
    public String showRecordingPage(HttpSession session, Model model) {
        streamingPlatform = (String) session.getAttribute("streamingPlatform");
        model.addAttribute("isRecording", isRecording);
        model.addAttribute("isStreaming", isStreaming);
        model.addAttribute("streamingPlatform", streamingPlatform);
        model.addAttribute("startTime", startTime);
        return "recording";  // Rendering recording.jsp
    }

    // ✅ Start Recording API
    @RequestMapping(value = "/start", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> startRecording(@RequestParam boolean autoTrigger, HttpSession session) {
        Map<String, String> response = new HashMap<>();
        String platform = (String) session.getAttribute("streamingPlatform");

        if (!isRecording) {
            isRecording = true;
            startTime = LocalDateTime.now();
            isStreaming = !platform.equalsIgnoreCase("None");

            response.put("Trigger", autoTrigger ? "Automatic (SOS Detected)" : "Manual");
            response.put("Recording", "Started");
            response.put("Timestamp", startTime.toString());
            response.put("Live Streaming", isStreaming ? "Yes on " + platform : "No");
        } else {
            response.put("Recording", "Already in Progress");
        }
        return response;
    }

    // ✅ Stop Recording API
    @RequestMapping(value = "/stop", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> stopRecording() {
        Map<String, String> response = new HashMap<>();
        if (isRecording) {
            isRecording = false;
            isStreaming = false;
            endTime = LocalDateTime.now();

            response.put("Recording", "Stopped");
            response.put("Duration", java.time.Duration.between(startTime, endTime).toMinutes() + " minutes");
            response.put("Storage Location", storagePath);
        } else {
            response.put("Error", "No Active Recording");
        }
        return response;
    }

    // ✅ Get Recording Status
    @RequestMapping(value = "/status", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, String> getRecordingStatus() {
        Map<String, String> status = new HashMap<>();
        status.put("Recording Active", isRecording ? "Yes" : "No");
        status.put("Live Streaming", isStreaming ? "Yes on " + streamingPlatform : "No");
        if (isRecording) {
            status.put("Start Time", startTime.toString());
        }
        return status;
    }
}
