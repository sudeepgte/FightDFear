package in.sp.main.Service.storage;

import java.io.IOException;
import java.util.UUID;

import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Config.StorageProperties;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.core.sync.ResponseTransformer;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadObjectRequest;
import software.amazon.awssdk.services.s3.model.NoSuchKeyException;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Service
@ConditionalOnExpression("'${app.storage.type:local}'.equals('s3') and !'${app.storage.s3.bucket:}'.isEmpty()")
public class S3StorageService implements StorageService {

    private final S3Client s3Client;
    private final StorageProperties properties;

    public S3StorageService(S3Client s3Client, StorageProperties properties) {
        this.s3Client = s3Client;
        this.properties = properties;
    }

    @Override
    public String store(MultipartFile file, StorageCategory category) throws IOException {
        StorageValidation.validate(file, category);

        String sanitizedName = StorageValidation.sanitizeOriginalName(file.getOriginalFilename());
        String storedKey = UUID.randomUUID() + "_" + sanitizedName;
        StorageValidation.validateStoredKey(storedKey);

        PutObjectRequest.Builder requestBuilder = PutObjectRequest.builder()
                .bucket(properties.getS3().getBucket())
                .key(storedKey);

        if (file.getContentType() != null && !file.getContentType().isBlank()) {
            requestBuilder.contentType(file.getContentType());
        }

        s3Client.putObject(requestBuilder.build(), RequestBody.fromInputStream(file.getInputStream(), file.getSize()));
        return storedKey;
    }

    @Override
    public String resolvePublicUrl(String storedKey) {
        StorageValidation.validateStoredKey(storedKey);

        String publicBaseUrl = properties.getS3().getPublicBaseUrl();
        if (publicBaseUrl != null && !publicBaseUrl.isBlank()) {
            return publicBaseUrl.endsWith("/")
                    ? publicBaseUrl + storedKey
                    : publicBaseUrl + "/" + storedKey;
        }

        String region = properties.getS3().getRegion();
        return "https://" + properties.getS3().getBucket() + ".s3." + region + ".amazonaws.com/" + storedKey;
    }

    @Override
    public void delete(String storedKey) throws IOException {
        StorageValidation.validateStoredKey(storedKey);
        s3Client.deleteObject(DeleteObjectRequest.builder()
                .bucket(properties.getS3().getBucket())
                .key(storedKey)
                .build());
    }

    @Override
    public Resource readResource(String storedKey) throws IOException {
        StorageValidation.validateStoredKey(storedKey);

        try {
            s3Client.headObject(HeadObjectRequest.builder()
                    .bucket(properties.getS3().getBucket())
                    .key(storedKey)
                    .build());
        } catch (NoSuchKeyException e) {
            throw new java.io.FileNotFoundException("Object not found: " + storedKey);
        }

        var response = s3Client.getObject(
                GetObjectRequest.builder()
                        .bucket(properties.getS3().getBucket())
                        .key(storedKey)
                        .build(),
                ResponseTransformer.toInputStream());

        return new InputStreamResource(response);
    }
}
