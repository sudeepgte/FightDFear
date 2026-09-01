package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalTime;

@Entity
@Table(name = "event_agenda_items")
public class EventAgendaItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "event_id", nullable = false)
    private WomenEvent event;

    @Column(nullable = false)
    private String title;
    @Column(length = 2000)
    private String description;
    private LocalTime startTime;
    private LocalTime endTime;
    private String speakerName;
    private Integer sortOrder = 0;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public WomenEvent getEvent() { return event; }
    public void setEvent(WomenEvent event) { this.event = event; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }
    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }
    public String getSpeakerName() { return speakerName; }
    public void setSpeakerName(String speakerName) { this.speakerName = speakerName; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
}
