package in.sp.main.Repository;

import java.util.List;
import in.sp.main.Entities.Group;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.GroupMember;

@Repository
public interface GroupMemberRepository extends JpaRepository<GroupMember, Long> {
	
	 @Query("SELECT gm.group FROM GroupMember gm WHERE gm.user.id = :userId")
	    List<Group> findGroupsByUserId(@Param("userId") Long userId);

	 boolean existsByGroupIdAndUserId(Long groupId, Long userId);
	 void deleteByGroupIdAndUserId(Long groupId, Long userId);

}
