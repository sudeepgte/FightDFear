package in.sp.main.Repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import in.sp.main.Entities.sosActivation;

@Repository
public interface SosActivationRepository extends JpaRepository<sosActivation, Long> {
}
