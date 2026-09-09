package in.sp.main.Util;

import java.util.regex.Pattern;

public final class LogSanitizer {

    private static final int DEFAULT_MAX_LENGTH = 128;
    private static final Pattern CONTROL_CHARS = Pattern.compile("[\\r\\n\\t\\u0000-\\u001F\\u007F-\\u009F]");

    private LogSanitizer() {
    }

    /**
     * Sanitizes user-controlled inputs for safe logging.
     * Replaces CR, LF, tabs, null bytes, and all control characters with underscores
     * and truncates to a maximum length to prevent log injection / log flooding.
     */
    public static String sanitize(Object input) {
        return sanitize(input, DEFAULT_MAX_LENGTH);
    }

    public static String sanitize(Object input, int maxLength) {
        if (input == null) {
            return "null";
        }
        String s = input.toString();
        String cleaned = CONTROL_CHARS.matcher(s).replaceAll("_");
        if (maxLength > 0 && cleaned.length() > maxLength) {
            return cleaned.substring(0, maxLength) + "...";
        }
        return cleaned;
    }

    /**
     * Sanitizes a filename for logging, stripping directory paths and control characters.
     */
    public static String sanitizeFilename(String filename) {
        if (filename == null || filename.isBlank()) {
            return "empty";
        }
        // Extract base name if path was provided
        String base = filename.trim().replace('\\', '/');
        int lastSlash = base.lastIndexOf('/');
        if (lastSlash >= 0 && lastSlash < base.length() - 1) {
            base = base.substring(lastSlash + 1);
        }
        return sanitize(base, 64);
    }
}
