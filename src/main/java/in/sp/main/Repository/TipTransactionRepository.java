package in.sp.main.Repository;

import in.sp.main.Entities.TipTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TipTransactionRepository extends JpaRepository<TipTransaction, Long> {
    List<TipTransaction> findBySender_Id(Long senderId);
    List<TipTransaction> findByReceiver_Id(Long receiverId);
}
