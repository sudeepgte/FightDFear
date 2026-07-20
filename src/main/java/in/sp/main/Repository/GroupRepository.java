package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.Group;
import in.sp.main.Entities.User;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {
    List<Group> findByMembers_Id(Long userId);

	List<Group> findByCreatedBy(User currentUser);
}
