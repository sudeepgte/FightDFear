package in.sp.main.Repository;

import in.sp.main.Entities.WomenProduct;
import in.sp.main.Entities.WomenProductSeller;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WomenProductRepository extends JpaRepository<WomenProduct, Long> {
    List<WomenProduct> findBySeller(WomenProductSeller seller);
    List<WomenProduct> findBySellerOrderByCreatedAtDesc(WomenProductSeller seller);
    List<WomenProduct> findByActiveTrueOrderByCreatedAtDesc();
    List<WomenProduct> findByCategoryAndActiveTrueOrderByCreatedAtDesc(String category);

    List<WomenProduct> findBySellerAndDeletedFalseOrderByCreatedAtDesc(WomenProductSeller seller);
    List<WomenProduct> findByActiveTrueAndDeletedFalseOrderByCreatedAtDesc();
    List<WomenProduct> findByCategoryAndActiveTrueAndDeletedFalseOrderByCreatedAtDesc(String category);

    long countByActiveTrueAndDeletedFalse();

    @org.springframework.data.jpa.repository.Lock(jakarta.persistence.LockModeType.PESSIMISTIC_WRITE)
    @org.springframework.data.jpa.repository.Query("SELECT p FROM WomenProduct p WHERE p.id = :id")
    java.util.Optional<WomenProduct> findByIdForUpdate(@org.springframework.data.repository.query.Param("id") Long id);
}
