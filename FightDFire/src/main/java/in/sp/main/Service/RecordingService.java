package in.sp.main.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import in.sp.main.Entities.RecordingEntity;
import in.sp.main.Repository.RecordingRepository;

@Service
public class RecordingService {

    @Autowired
    private RecordingRepository recordingRepository;

    public Map<String, String> startRecording(boolean autoTrigger, String platform) {
        Map<String, String> response = new HashMap<>();

        RecordingEntity latestRecording = recordingRepository.findTopByOrderByStartTimeDesc();
        if (latestRecording != null && latestRecording.isRecording()) {
            response.put("Recording", "Already in Progress");
            return response;
        }

        RecordingEntity recording = new RecordingEntity();
        recording.setRecording(true);
        recording.setStartTime(LocalDateTime.now());
        recording.setStreamingPlatform(platform);
        recording.setStreaming(!platform.equalsIgnoreCase("None"));
        recording.setStoragePath("/videos/");

        recordingRepository.save(recording);

        response.put("Trigger", autoTrigger ? "Automatic (SOS Detected)" : "Manual");
        response.put("Recording", "Started");
        response.put("Timestamp", recording.getStartTime().toString());
        response.put("Live Streaming", platform.equalsIgnoreCase("None") ? "No" : "Yes on " + platform);

        return response;
    }

    public Map<String, String> stopRecording() {
        Map<String, String> response = new HashMap<>();

        RecordingEntity recording = recordingRepository.findTopByOrderByStartTimeDesc();
        if (recording == null || !recording.isRecording()) {
            response.put("Error", "No Active Recording");
            return response;
        }

        recording.setRecording(false);
        recording.setEndTime(LocalDateTime.now());
        recordingRepository.save(recording);

        response.put("Recording", "Stopped");
        response.put("Duration", String.valueOf(Duration.between(recording.getStartTime(), recording.getEndTime()).toMinutes()) + " minutes");
        response.put("Storage Location", recording.getStoragePath());

        return response;
    }

    public Map<String, String> getRecordingStatus() {
        Map<String, String> status = new HashMap<>();

        RecordingEntity recording = recordingRepository.findTopByOrderByStartTimeDesc();
        if (recording == null) {
            status.put("Recording Active", "No");
            return status;
        }

        status.put("Recording Active", recording.isRecording() ? "Yes" : "No");
        status.put("Live Streaming", recording.isStreaming() ? "Yes on " + recording.getStreamingPlatform() : "No");
        if (recording.isRecording()) {
            status.put("Start Time", recording.getStartTime().toString());
        }

        return status;
    }
}
