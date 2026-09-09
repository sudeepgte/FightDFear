package in.sp.main.Controller;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

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

    private static final String STORAGE_PATH = "/videos/";
    private static final String ATTR_IS_RECORDING = "recording_active";
    private static final String ATTR_IS_STREAMING = "recording_streaming";
    private static final String ATTR_START_TIME = "recording_startTime";
    private static final String ATTR_STREAMING_PLATFORM = "streamingPlatform";

    // ✅ Live Streaming Platform Selection Page
    @RequestMapping(value = "/select", method = RequestMethod.GET)
    public String showPlatformSelection() {
        return "liveStreaming";  // Rendering liveStreaming.jsp
    }

    // ✅ Save Selected Platform in Session
    @RequestMapping(value = "/selectPlatform", method = RequestMethod.POST)
    @ResponseBody
    public void selectPlatform(@RequestParam String platform, HttpSession session) {
        session.setAttribute(ATTR_STREAMING_PLATFORM, platform);
    }

    // ✅ Show Recording Page with Selected Platform
    @RequestMapping(method = RequestMethod.GET)
    public String showRecordingPage(HttpSession session, Model model) {
        String streamingPlatform = Objects.toString(session.getAttribute(ATTR_STREAMING_PLATFORM), "None");
        boolean isRecording = Boolean.TRUE.equals(session.getAttribute(ATTR_IS_RECORDING));
        boolean isStreaming = Boolean.TRUE.equals(session.getAttribute(ATTR_IS_STREAMING));
        LocalDateTime startTime = (LocalDateTime) session.getAttribute(ATTR_START_TIME);

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
        String platform = Objects.toString(session.getAttribute(ATTR_STREAMING_PLATFORM), "None");
        boolean isRecording = Boolean.TRUE.equals(session.getAttribute(ATTR_IS_RECORDING));

        if (!isRecording) {
            LocalDateTime startTime = LocalDateTime.now();
            boolean isStreaming = !platform.equalsIgnoreCase("None");

            session.setAttribute(ATTR_IS_RECORDING, true);
            session.setAttribute(ATTR_START_TIME, startTime);
            session.setAttribute(ATTR_IS_STREAMING, isStreaming);

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
    public Map<String, String> stopRecording(HttpSession session) {
        Map<String, String> response = new HashMap<>();
        boolean isRecording = Boolean.TRUE.equals(session.getAttribute(ATTR_IS_RECORDING));

        if (isRecording) {
            LocalDateTime startTime = (LocalDateTime) session.getAttribute(ATTR_START_TIME);
            LocalDateTime endTime = LocalDateTime.now();

            session.setAttribute(ATTR_IS_RECORDING, false);
            session.setAttribute(ATTR_IS_STREAMING, false);
            session.removeAttribute(ATTR_START_TIME);

            long durationMinutes = startTime != null ? Duration.between(startTime, endTime).toMinutes() : 0;

            response.put("Recording", "Stopped");
            response.put("Duration", durationMinutes + " minutes");
            response.put("Storage Location", STORAGE_PATH);
        } else {
            response.put("Error", "No Active Recording");
        }
        return response;
    }

    // ✅ Get Recording Status
    @RequestMapping(value = "/status", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, String> getRecordingStatus(HttpSession session) {
        Map<String, String> status = new HashMap<>();
        boolean isRecording = Boolean.TRUE.equals(session.getAttribute(ATTR_IS_RECORDING));
        boolean isStreaming = Boolean.TRUE.equals(session.getAttribute(ATTR_IS_STREAMING));
        String streamingPlatform = Objects.toString(session.getAttribute(ATTR_STREAMING_PLATFORM), "None");
        LocalDateTime startTime = (LocalDateTime) session.getAttribute(ATTR_START_TIME);

        status.put("Recording Active", isRecording ? "Yes" : "No");
        status.put("Live Streaming", isStreaming ? "Yes on " + streamingPlatform : "No");
        if (isRecording && startTime != null) {
            status.put("Start Time", startTime.toString());
        }
        return status;
    }
}
