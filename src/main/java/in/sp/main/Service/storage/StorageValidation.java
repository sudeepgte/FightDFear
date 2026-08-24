package in.sp.main.Service.storage;

import java.util.Locale;
import java.util.Set;

import org.springframework.web.multipart.MultipartFile;

public final class StorageValidation {

    private static final long MAX_IMAGE_BYTES = 5L * 1024 * 1024;
    private static final long MAX_VIDEO_BYTES = 2048L * 1024 * 1024;
    private static final long MAX_DOCUMENT_BYTES = 50L * 1024 * 1024;
    private static final long MAX_GENERAL_BYTES = 2048L * 1024 * 1024;

    private static final Set<String> DANGEROUS_EXTENSIONS = Set.of(
            "exe", "bat", "cmd", "com", "scr", "pif", "vbs", "js", "jsp",
            "html", "htm", "php", "asp", "aspx", "sh", "bash", "ps1",
            "jar", "war", "class", "dll", "msi", "reg", "inf", "svg+xml");

    private StorageValidation() {
    }

    public static void validate(MultipartFile file, StorageCategory category) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        String extension = extractExtension(file.getOriginalFilename());
        if (extension != null && DANGEROUS_EXTENSIONS.contains(extension.toLowerCase(Locale.ROOT))) {
            throw new IllegalArgumentException("File type not allowed: ." + extension);
        }

        long maxBytes = maxBytesFor(category);
        if (file.getSize() > maxBytes) {
            throw new IllegalArgumentException(
                    "File exceeds maximum size of " + (maxBytes / (1024 * 1024)) + " MB for " + category.name());
        }

        validateMimeType(file, category);
    }

    public static void validateStoredKey(String storedKey) {
        if (storedKey == null || storedKey.isBlank()) {
            throw new IllegalArgumentException("Stored key is empty");
        }
        if (storedKey.contains("..") || storedKey.contains("/") || storedKey.contains("\\")) {
            throw new SecurityException("Invalid stored key");
        }
    }

    public static String sanitizeOriginalName(String originalName) {
        if (originalName == null || originalName.isBlank()) {
            return "file";
        }
        return originalName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
    }

    public static String extractExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return null;
        }
        return filename.substring(filename.lastIndexOf('.') + 1);
    }

    private static long maxBytesFor(StorageCategory category) {
        return switch (category) {
            case IMAGE -> MAX_IMAGE_BYTES;
            case VIDEO -> MAX_VIDEO_BYTES;
            case DOCUMENT -> MAX_DOCUMENT_BYTES;
            case GENERAL -> MAX_GENERAL_BYTES;
        };
    }

    private static void validateMimeType(MultipartFile file, StorageCategory category) {
        String contentType = file.getContentType();
        if (contentType == null) {
            return;
        }

        switch (category) {
            case IMAGE -> {
                if (!contentType.startsWith("image/")) {
                    throw new IllegalArgumentException("Expected an image file");
                }
            }
            case VIDEO -> {
                if (!contentType.startsWith("video/")) {
                    throw new IllegalArgumentException("Expected a video file");
                }
            }
            default -> {
                if (contentType.startsWith("text/html") || contentType.contains("javascript")) {
                    throw new IllegalArgumentException("File type not allowed");
                }
            }
        }
    }
}
