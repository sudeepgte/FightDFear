package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
public class TrainingSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "batch_id")
    private MartialArtsBatch batch;

    private LocalDate date;
    private String startTime;
    private String endTime;
    private String trainer;
    private String duration;
    private String notes;

    public TrainingSession() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public MartialArtsBatch getBatch() { return batch; }
    public void setBatch(MartialArtsBatch batch) { this.batch = batch; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getTrainer() { return trainer; }
    public void setTrainer(String trainer) { this.trainer = trainer; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
