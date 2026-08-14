package in.sp.main.Config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.storage")
public class StorageProperties {

    private String type = "local";
    private final S3 s3 = new S3();

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public S3 getS3() {
        return s3;
    }

    public static class S3 {
        private String bucket = "";
        private String region = "ap-south-1";
        private String accessKey = "";
        private String secretKey = "";
        private String publicBaseUrl = "";

        public String getBucket() {
            return bucket;
        }

        public void setBucket(String bucket) {
            this.bucket = bucket;
        }

        public String getRegion() {
            return region;
        }

        public void setRegion(String region) {
            this.region = region;
        }

        public String getAccessKey() {
            return accessKey;
        }

        public void setAccessKey(String accessKey) {
            this.accessKey = accessKey;
        }

        public String getSecretKey() {
            return secretKey;
        }

        public void setSecretKey(String secretKey) {
            this.secretKey = secretKey;
        }

        public String getPublicBaseUrl() {
            return publicBaseUrl;
        }

        public void setPublicBaseUrl(String publicBaseUrl) {
            this.publicBaseUrl = publicBaseUrl;
        }
    }
}
