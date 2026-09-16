package in.sp.main.Service.storage;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.Set;

import org.springframework.web.multipart.MultipartFile;

public final class StorageValidation {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(StorageValidation.class);

    private static final long MAX_IMAGE_BYTES = 10L * 1024 * 1024; // 10 MB
    private static final long MAX_VIDEO_BYTES = 2048L * 1024 * 1024; // 2 GB
    private static final long MAX_DOCUMENT_BYTES = 50L * 1024 * 1024; // 50 MB
    private static final long MAX_GENERAL_BYTES = 2048L * 1024 * 1024;

    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = Set.of(
            "jpg", "jpeg", "png", "webp", "gif");

    private static final Set<String> ALLOWED_DOCUMENT_EXTENSIONS = Set.of(
            "pdf", "doc", "docx", "xls", "xlsx", "txt", "csv");

    private static final Set<String> ALLOWED_VIDEO_EXTENSIONS = Set.of(
            "mp4", "webm", "mov", "mkv", "avi", "3gp");

    private static final Set<String> ALLOWED_GENERAL_EXTENSIONS = Set.of(
            "jpg", "jpeg", "png", "webp", "gif",
            "pdf", "doc", "docx", "xls", "xlsx", "txt", "csv",
            "mp4", "webm", "mov", "mkv", "avi", "3gp",
            "mp3", "wav", "m4a", "aac", "ogg", "amr");

    private static final Set<String> DANGEROUS_EXTENSIONS = Set.of(
            "exe", "bat", "cmd", "com", "scr", "pif", "vbs", "js", "jsp",
            "jspx", "jspa", "html", "htm", "xhtml", "php", "php3", "php4", "php5",
            "phtml", "asp", "aspx", "sh", "bash", "ps1", "jar", "war", "class",
            "dll", "msi", "reg", "inf", "svg", "svgz", "svg+xml", "swf", "cgi",
            "pl", "htaccess", "shtml", "py", "rb", "jsonp");

    private StorageValidation() {
    }

    public static void validate(MultipartFile file, StorageCategory category) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.isBlank()) {
            throw new IllegalArgumentException("Filename is missing");
        }

        // Check for path traversal or null byte in filename
        if (originalFilename.contains("..") || originalFilename.contains("/") || originalFilename.contains("\\") || originalFilename.contains("\0")) {
            log.warn("[SECURITY-AUDIT] event=UPLOAD_BLOCKED category={} reason=PATH_TRAVERSAL filename={}",
                    category, in.sp.main.Util.LogSanitizer.sanitizeFilename(originalFilename));
            throw new SecurityException("Invalid characters or path traversal attempt in filename");
        }

        String extension = extractExtension(originalFilename);
        if (extension == null || extension.isBlank()) {
            throw new IllegalArgumentException("File extension is missing");
        }
        extension = extension.toLowerCase(Locale.ROOT);

        // Check against dangerous extensions
        if (DANGEROUS_EXTENSIONS.contains(extension)) {
            log.warn("[SECURITY-AUDIT] event=UPLOAD_BLOCKED category={} reason=DANGEROUS_EXTENSION extension={} filename={}",
                    category, extension, in.sp.main.Util.LogSanitizer.sanitizeFilename(originalFilename));
            throw new IllegalArgumentException("File type not allowed: ." + extension);
        }

        // Check for double extension containing dangerous extensions (e.g., evil.jsp.jpg, exploit.php.png)
        validateNoHiddenDangerousExtension(originalFilename);

        // Check against allowed extensions for category
        Set<String> allowedSet = allowedExtensionsFor(category);
        if (!allowedSet.contains(extension)) {
            log.warn("[SECURITY-AUDIT] event=UPLOAD_BLOCKED category={} reason=DISALLOWED_EXTENSION extension={} filename={}",
                    category, extension, in.sp.main.Util.LogSanitizer.sanitizeFilename(originalFilename));
            throw new IllegalArgumentException("Extension ." + extension + " is not permitted for category " + category.name());
        }

        // Size check
        long maxBytes = maxBytesFor(category);
        if (file.getSize() > maxBytes) {
            log.warn("[SECURITY-AUDIT] event=UPLOAD_BLOCKED category={} reason=SIZE_EXCEEDED sizeBytes={} maxBytes={} filename={}",
                    category, file.getSize(), maxBytes, in.sp.main.Util.LogSanitizer.sanitizeFilename(originalFilename));
            throw new IllegalArgumentException(
                    "File exceeds maximum size of " + (maxBytes / (1024 * 1024)) + " MB for " + category.name());
        }

        // MIME type validation
        validateMimeType(file, category, extension);

        // Magic bytes / file header signature check
        validateFileSignature(file, extension, category);
    }

    public static void validateStoredKey(String storedKey) {
        if (storedKey == null || storedKey.isBlank()) {
            throw new IllegalArgumentException("Stored key is empty");
        }
        if (storedKey.contains("..") || storedKey.contains("/") || storedKey.contains("\\") || storedKey.contains("\0")) {
            throw new SecurityException("Invalid stored key");
        }
    }

    public static String sanitizeOriginalName(String originalName) {
        if (originalName == null || originalName.isBlank()) {
            return "file";
        }
        String clean = originalName.replace('\\', '/');
        if (clean.contains("/")) {
            clean = clean.substring(clean.lastIndexOf('/') + 1);
        }
        clean = clean.replaceAll("[^a-zA-Z0-9.\\-]", "_");
        return clean.replaceAll("_+", "_");
    }

    public static String extractExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return null;
        }
        return filename.substring(filename.lastIndexOf('.') + 1);
    }

    private static Set<String> allowedExtensionsFor(StorageCategory category) {
        return switch (category) {
            case IMAGE -> ALLOWED_IMAGE_EXTENSIONS;
            case DOCUMENT -> ALLOWED_DOCUMENT_EXTENSIONS;
            case VIDEO -> ALLOWED_VIDEO_EXTENSIONS;
            case GENERAL -> ALLOWED_GENERAL_EXTENSIONS;
        };
    }

    private static long maxBytesFor(StorageCategory category) {
        return switch (category) {
            case IMAGE -> MAX_IMAGE_BYTES;
            case VIDEO -> MAX_VIDEO_BYTES;
            case DOCUMENT -> MAX_DOCUMENT_BYTES;
            case GENERAL -> MAX_GENERAL_BYTES;
        };
    }

    private static void validateNoHiddenDangerousExtension(String filename) {
        String lower = filename.toLowerCase(Locale.ROOT);
        String[] parts = lower.split("\\.");
        for (int i = 0; i < parts.length - 1; i++) {
            if (DANGEROUS_EXTENSIONS.contains(parts[i])) {
                throw new IllegalArgumentException("Suspicious file name with dangerous extension: " + parts[i]);
            }
        }
    }

    private static void validateMimeType(MultipartFile file, StorageCategory category, String extension) {
        String contentType = file.getContentType();
        if (contentType == null || contentType.isBlank() || contentType.equals("application/octet-stream")) {
            return;
        }
        contentType = contentType.toLowerCase(Locale.ROOT);

        if (contentType.contains("html") || contentType.contains("javascript") || contentType.contains("svg")
                || contentType.contains("php") || contentType.contains("jsp") || contentType.contains("executable")) {
            throw new IllegalArgumentException("MIME type not allowed: " + contentType);
        }

        switch (category) {
            case IMAGE -> {
                if (!contentType.startsWith("image/")) {
                    throw new IllegalArgumentException("Expected an image MIME type, got: " + contentType);
                }
            }
            case VIDEO -> {
                if (!contentType.startsWith("video/") && !contentType.startsWith("audio/")) {
                    throw new IllegalArgumentException("Expected a video MIME type, got: " + contentType);
                }
            }
            case DOCUMENT -> {
                boolean docMime = contentType.startsWith("application/") || contentType.startsWith("text/");
                if (!docMime) {
                    throw new IllegalArgumentException("Expected a document MIME type, got: " + contentType);
                }
            }
            default -> {}
        }
    }

    private static void validateFileSignature(MultipartFile file, String extension, StorageCategory category) {
        byte[] header = new byte[512];
        int read;
        try (InputStream is = file.getInputStream()) {
            read = is.read(header);
        } catch (IOException e) {
            throw new IllegalArgumentException("Could not read file for validation", e);
        }

        if (read < 3) {
            throw new IllegalArgumentException("File is too small or corrupted");
        }

        switch (extension) {
            case "jpg", "jpeg" -> {
                if (!isJpeg(header, read)) {
                    throw new IllegalArgumentException("File signature does not match JPEG image");
                }
            }
            case "png" -> {
                if (!isPng(header, read)) {
                    throw new IllegalArgumentException("File signature does not match PNG image");
                }
            }
            case "gif" -> {
                if (!isGif(header, read)) {
                    throw new IllegalArgumentException("File signature does not match GIF image");
                }
            }
            case "webp" -> {
                if (!isWebp(header, read)) {
                    throw new IllegalArgumentException("File signature does not match WebP image");
                }
            }
            case "pdf" -> {
                if (!isPdf(header, read)) {
                    throw new IllegalArgumentException("File signature does not match PDF document");
                }
            }
            case "mp4", "mov", "3gp" -> {
                if (!isIsoMedia(header, read)) {
                    throw new IllegalArgumentException("File signature does not match MP4/MOV video");
                }
            }
            case "webm", "mkv" -> {
                if (!isEbml(header, read)) {
                    throw new IllegalArgumentException("File signature does not match WebM/MKV video");
                }
            }
            case "txt", "csv" -> {
                // Ensure text file does not contain executable/script content
                String preview = new String(header, 0, Math.min(read, 512), StandardCharsets.ISO_8859_1).toLowerCase(Locale.ROOT);
                if (preview.contains("<script") || preview.contains("<?php") || preview.contains("<%@") || preview.contains("<html") || preview.contains("<svg")) {
                    throw new IllegalArgumentException("File contains forbidden script or HTML content");
                }
            }
            default -> {
                // For other binary formats like docx/xlsx, ensure no HTML/script
                String preview = new String(header, 0, Math.min(read, 512), StandardCharsets.ISO_8859_1).toLowerCase(Locale.ROOT);
                if (preview.contains("<script") || preview.contains("<?php") || preview.contains("<%@") || preview.contains("<html") || preview.contains("<svg")) {
                    throw new IllegalArgumentException("File contains forbidden script or HTML content");
                }
            }
        }
    }

    private static boolean isJpeg(byte[] h, int len) {
        return len >= 3 && (h[0] & 0xFF) == 0xFF && (h[1] & 0xFF) == 0xD8 && (h[2] & 0xFF) == 0xFF;
    }

    private static boolean isPng(byte[] h, int len) {
        return len >= 8 && (h[0] & 0xFF) == 0x89 && h[1] == 0x50 && h[2] == 0x4E && h[3] == 0x47
                && h[4] == 0x0D && h[5] == 0x0A && h[6] == 0x1A && h[7] == 0x0A;
    }

    private static boolean isGif(byte[] h, int len) {
        return len >= 6 && h[0] == 'G' && h[1] == 'I' && h[2] == 'F' && h[3] == '8'
                && (h[4] == '7' || h[4] == '9') && h[5] == 'a';
    }

    private static boolean isWebp(byte[] h, int len) {
        return len >= 12 && h[0] == 'R' && h[1] == 'I' && h[2] == 'F' && h[3] == 'F'
                && h[8] == 'W' && h[9] == 'E' && h[10] == 'B' && h[11] == 'P';
    }

    private static boolean isPdf(byte[] h, int len) {
        return len >= 4 && h[0] == '%' && h[1] == 'P' && h[2] == 'D' && h[3] == 'F';
    }

    private static boolean isIsoMedia(byte[] h, int len) {
        if (len < 8) return false;
        // Check for 'ftyp' in bytes 4-7
        if (h[4] == 'f' && h[5] == 't' && h[6] == 'y' && h[7] == 'p') {
            return true;
        }
        // Some MP4/3GP/MOV start with zero box size or moov
        return len >= 4 && (h[0] == 0 && h[1] == 0 && h[2] == 0);
    }

    private static boolean isEbml(byte[] h, int len) {
        return len >= 4 && (h[0] & 0xFF) == 0x1A && (h[1] & 0xFF) == 0x45 && (h[2] & 0xFF) == 0xDF && (h[3] & 0xFF) == 0xA3;
    }
}
