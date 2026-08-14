package in.sp.main.Service.storage;

import java.io.IOException;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface StorageService {

    String store(MultipartFile file, StorageCategory category) throws IOException;

    String resolvePublicUrl(String storedKey);

    void delete(String storedKey) throws IOException;

    Resource readResource(String storedKey) throws IOException;
}
