package in.sp.main.Service;

import java.io.IOException;

import java.util.Locale;
import java.util.UUID;


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

    /**
     * Ensures the upload is a real PNG or JPEG image (magic bytes), not only by extension/MIME.
     * @return null if valid, otherwise a user-facing error message
     */
    public String validatePngOrJpegImage(MultipartFile file, long maxBytes) {
        if (file == null || file.isEmpty()) {
            return null;
        }
        if (file.getSize() > maxBytes) {
            long maxMb = Math.max(1, maxBytes / (1024 * 1024));
            return "Profile photo must be at most " + maxMb + " MB.";
        }

        String contentType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);
        boolean declaredOk = contentType.equals("image/jpeg")
                || contentType.equals("image/jpg")
                || contentType.equals("image/png");
        if (!declaredOk && !contentType.isEmpty() && !contentType.equals("application/octet-stream")) {
            return "Profile photo must be a JPG/JPEG or PNG image.";
        }

        byte[] data;
        try {
            data = file.getBytes();
        } catch (IOException e) {
            return "Could not read the uploaded profile photo.";
        }
        if (data.length < 3) {
            return "Profile photo file is invalid or corrupted.";
        }

        boolean jpeg = isJpegHeader(data);
        boolean png = data.length >= 8 && isPngHeader(data);
        if (!jpeg && !png) {
            return "Profile photo must be a JPG/JPEG or PNG image (PDF and other formats are not allowed).";
        }

        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        if (!name.isEmpty()) {
            boolean extOk = name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png");
            if (!extOk) {
                return "Profile photo filename must end with .jpg, .jpeg, or .png.";
            }
        }
        return null;
    }

    private static boolean isJpegHeader(byte[] h) {
        return (h[0] & 0xFF) == 0xFF && (h[1] & 0xFF) == 0xD8 && (h[2] & 0xFF) == 0xFF;
    }

    private static boolean isPngHeader(byte[] h) {
        return (h[0] & 0xFF) == 0x89 && h[1] == 0x50 && h[2] == 0x4E && h[3] == 0x47
                && h[4] == 0x0D && h[5] == 0x0A && h[6] == 0x1A && h[7] == 0x0A;
    }
}
