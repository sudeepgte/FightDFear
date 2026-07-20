package in.sp.main.Entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "`groups`")
public class Group {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    
    private String groupPhoto;
    
    
    public String getGroupPhoto() {
		return groupPhoto;
	}

	public void setGroupPhoto(String groupPhoto) {
		this.groupPhoto = groupPhoto;
	}

	// 👤 Group creator
    @ManyToOne
    @JoinColumn(
        name = "created_by",
        foreignKey = @ForeignKey(ConstraintMode.NO_CONSTRAINT)
    )
    private User createdBy;
    
    // 👥 Group members
  
    @OneToMany(mappedBy = "group", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<GroupMember> members;



    public List<GroupMember> getMembers() {
		return members;
	}

	public void setMembers(List<GroupMember> members) {
		if (this.members == null) {
			this.members = new java.util.ArrayList<>();
		}
		this.members.clear();
		if (members != null) {
			this.members.addAll(members);
		}
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	private LocalDateTime createdAt = LocalDateTime.now();

    // 🔧 Getters & Setters
    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public User getCreatedBy() {
        return createdBy;
    }

   

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

  
}
