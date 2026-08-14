package in.sp.main.Service.storage;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@ConditionalOnExpression("!'${app.storage.type:local}'.equals('s3') or '${app.storage.s3.bucket:}'.isEmpty()")
public class LocalStorageService implements StorageService {

    private final Path uploadRoot;

    public LocalStorageService() {
        this.uploadRoot = Paths.get(System.getProperty("user.dir"), "uploads")
                .normalize()
                .toAbsolutePath();
    }

    @Override
    public String store(MultipartFile file, StorageCategory category) throws IOException {
        StorageValidation.validate(file, category);

        Files.createDirectories(uploadRoot);

        String sanitizedName = StorageValidation.sanitizeOriginalName(file.getOriginalFilename());
        String storedKey = UUID.randomUUID() + "_" + sanitizedName;
        StorageValidation.validateStoredKey(storedKey);

        Path target = resolvePath(storedKey);
        file.transferTo(target.toFile());
        return storedKey;
    }

    @Override
    public String resolvePublicUrl(String storedKey) {
        StorageValidation.validateStoredKey(storedKey);
        return "/uploads/" + storedKey;
    }

    @Override
    public void delete(String storedKey) throws IOException {
        Path target = resolvePath(storedKey);
        Files.deleteIfExists(target);
    }

    @Override
    public Resource readResource(String storedKey) throws IOException {
        Path target = resolvePath(storedKey);
        File file = target.toFile();
        if (!file.exists()) {
            throw new java.io.FileNotFoundException("File not found: " + storedKey);
        }
        return new FileSystemResource(file);
    }

    Path getUploadRoot() {
        return uploadRoot;
    }

    private Path resolvePath(String storedKey) {
        StorageValidation.validateStoredKey(storedKey);
        Path resolved = uploadRoot.resolve(storedKey).normalize();
        if (!resolved.startsWith(uploadRoot)) {
            throw new SecurityException("Path traversal attempt blocked");
        }
        return resolved;
    }
}
