package in.sp.main.Service.storage;

import org.springframework.web.multipart.MultipartFile;

public enum StorageCategory {
    IMAGE,
    VIDEO,
    DOCUMENT,
    GENERAL;

    public static StorageCategory inferFrom(MultipartFile file) {
        String contentType = file.getContentType();
        if (contentType != null) {
            if (contentType.startsWith("image/")) {
                return IMAGE;
            }
            if (contentType.startsWith("video/")) {
                return VIDEO;
            }
            if (contentType.equals("application/pdf")
                    || contentType.startsWith("application/vnd.")
                    || contentType.startsWith("application/msword")
                    || contentType.equals("application/octet-stream")) {
                return DOCUMENT;
            }
        }

        String name = file.getOriginalFilename();
        if (name != null) {
            String lower = name.toLowerCase();
            if (lower.matches(".*\\.(jpg|jpeg|png|gif|webp|bmp|svg|heic|heif)$")) {
                return IMAGE;
            }
            if (lower.matches(".*\\.(mp4|mov|avi|mkv|webm|mpeg|mpg|3gp)$")) {
                return VIDEO;
            }
            if (lower.matches(".*\\.(pdf|doc|docx|xls|xlsx|ppt|pptx|txt|csv)$")) {
                return DOCUMENT;
            }
        }

        return GENERAL;
    }
}
