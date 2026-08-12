package in.sp.main.Config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

@Configuration
@EnableConfigurationProperties(StorageProperties.class)
public class StorageConfig {

    @Bean(destroyMethod = "close")
    @ConditionalOnExpression("'${app.storage.type:local}'.equals('s3') and !'${app.storage.s3.bucket:}'.isEmpty()")
    public S3Client s3Client(StorageProperties properties) {
        StorageProperties.S3 s3 = properties.getS3();
        var builder = S3Client.builder().region(Region.of(s3.getRegion()));

        if (s3.getAccessKey() != null && !s3.getAccessKey().isBlank()
                && s3.getSecretKey() != null && !s3.getSecretKey().isBlank()) {
            builder.credentialsProvider(StaticCredentialsProvider.create(
                    AwsBasicCredentials.create(s3.getAccessKey(), s3.getSecretKey())));
        } else {
            builder.credentialsProvider(DefaultCredentialsProvider.create());
        }

        return builder.build();
    }
}
