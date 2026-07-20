package in.sp.main.Repository;

import in.sp.main.Entities.WomenEventPhoto;
import in.sp.main.Entities.WomenEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface WomenEventPhotoRepository extends JpaRepository<WomenEventPhoto, Long> {

    List<WomenEventPhoto> findByEventOrderByUploadedAtDesc(WomenEvent event);
}
