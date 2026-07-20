package in.sp.main.Entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
public class Slot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String timeRange;

    @ManyToOne
    @JoinColumn(name = "martial_arts_type_id")
    @JsonIgnore // avoid infinite recursion
    private MartialArtsType martialArtsType;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTimeRange() { return timeRange; }
    public void setTimeRange(String timeRange) { this.timeRange = timeRange; }

    public MartialArtsType getMartialArtsType() { return martialArtsType; }
    public void setMartialArtsType(MartialArtsType martialArtsType) { this.martialArtsType = martialArtsType; }
}
