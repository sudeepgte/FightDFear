package in.sp.main.Service;

import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Service.storage.StorageCategory;
import in.sp.main.Service.storage.StorageService;

@Service
public class FileUploadService {

    private final StorageService storageService;

    public FileUploadService(StorageService storageService) {
        this.storageService = storageService;
    }

    public String saveFile(MultipartFile file) throws IOException {
        StorageCategory category = StorageCategory.inferFrom(file);
        String storedKey = storageService.store(file, category);
        return storageService.resolvePublicUrl(storedKey);
    }
}
