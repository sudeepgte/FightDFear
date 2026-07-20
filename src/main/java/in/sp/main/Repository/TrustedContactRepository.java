package in.sp.main.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import in.sp.main.Entities.TrustedContact;

public interface TrustedContactRepository extends JpaRepository<TrustedContact, Long> {
    List<TrustedContact> findByUserId(Long userId); // Find contacts by user ID
}
