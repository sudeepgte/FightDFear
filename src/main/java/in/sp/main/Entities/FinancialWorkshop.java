package in.sp.main.Entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "financial_workshops")
public class FinancialWorkshop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "educator_id")
    private FinancialEducator educator;

    private String title;
    private String venue;
    @Column(name = "workshop_date")
    private String date;
    @Column(name = "workshop_time")
    private String time;
    private String city;
    private Integer seats;
    private Double fee = 0.0;
    private String category;
    @Column(name = "custom_category")
    private String customCategory;
    @Column(columnDefinition = "TEXT")
    private String description;
    private boolean published = true;
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public FinancialEducator getEducator() { return educator; }
    public void setEducator(FinancialEducator educator) { this.educator = educator; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public Integer getSeats() { return seats; }
    public void setSeats(Integer seats) { this.seats = seats; }
    public Double getFee() { return fee == null ? 0d : fee; }
    public void setFee(Double fee) { this.fee = fee; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getCustomCategory() { return customCategory; }
    public void setCustomCategory(String customCategory) { this.customCategory = customCategory; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isPublished() { return published; }
    public void setPublished(boolean published) { this.published = published; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
