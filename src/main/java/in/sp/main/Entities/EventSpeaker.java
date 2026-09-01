package in.sp.main.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "event_speakers")
public class EventSpeaker {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "event_id", nullable = false)
    private WomenEvent event;

    @Column(nullable = false)
    private String name;
    private String photoPath;
    private String designation;
    private String organization;
    @Column(length = 2000)
    private String bio;
    private String topic;
    private Integer sortOrder = 0;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public WomenEvent getEvent() { return event; }
    public void setEvent(WomenEvent event) { this.event = event; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhotoPath() { return photoPath; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    public String getOrganization() { return organization; }
    public void setOrganization(String organization) { this.organization = organization; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
}
