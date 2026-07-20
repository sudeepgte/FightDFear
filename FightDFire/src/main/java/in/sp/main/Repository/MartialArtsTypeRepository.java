package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.MartialArtsType;


public interface MartialArtsTypeRepository extends JpaRepository<MartialArtsType, Long> {
    List<MartialArtsType> findByCentreId(Long centreId);
}
