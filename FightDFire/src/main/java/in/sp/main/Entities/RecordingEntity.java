package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "recordings")
public class RecordingEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private boolean isRecording;
    private boolean isStreaming;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String storagePath;
    private String streamingPlatform;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public boolean isRecording() { return isRecording; }
    public void setRecording(boolean isRecording) { this.isRecording = isRecording; }

    public boolean isStreaming() { return isStreaming; }
    public void setStreaming(boolean isStreaming) { this.isStreaming = isStreaming; }

    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public String getStoragePath() { return storagePath; }
    public void setStoragePath(String storagePath) { this.storagePath = storagePath; }

    public String getStreamingPlatform() { return streamingPlatform; }
    public void setStreamingPlatform(String streamingPlatform) { this.streamingPlatform = streamingPlatform; }
}
