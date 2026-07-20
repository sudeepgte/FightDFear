package in.sp.main.Entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class MartialArtsType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private Double cost;

    @ManyToOne
    @JoinColumn(name = "center_id")
    @JsonIgnore // avoid infinite recursion
    private MartialArtsCenter centre;

    @OneToMany(mappedBy = "martialArtsType", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Slot> slots = new ArrayList<>();

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Double getCost() { return cost; }
    public void setCost(Double cost) { this.cost = cost; }

    public MartialArtsCenter getCentre() { return centre; }
    public void setCentre(MartialArtsCenter centre) { this.centre = centre; }

    public List<Slot> getSlots() { return slots; }
    public void setSlots(List<Slot> slots) { this.slots = slots; }
}
