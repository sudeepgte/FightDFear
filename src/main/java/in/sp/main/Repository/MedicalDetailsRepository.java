package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.MedicalDetails;
import in.sp.main.Entities.User;

public interface MedicalDetailsRepository extends JpaRepository<MedicalDetails, Long> {

    // Find MedicalDetails by associated User
    List<MedicalDetails> findByUser(User user);  // This queries by the User object
}
