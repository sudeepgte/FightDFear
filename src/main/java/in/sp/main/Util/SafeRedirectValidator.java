package in.sp.main.Util;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

/**
 * Utility to validate redirect targets and prevent Open Redirect vulnerabilities.
 * Enforces strictly local, relative paths without authority components, schemes,
 * protocol-relative slashes, backslashes, or CRLF characters.
 */
public final class SafeRedirectValidator {

    private SafeRedirectValidator() {}

    /**
     * Checks whether the given redirect URL is a safe local relative path.
     *
     * @param redirect the candidate redirect target
     * @return true if redirect is safe and local, false otherwise
     */
    public static boolean isSafeRedirect(String redirect) {
        if (redirect == null || redirect.isBlank()) {
            return false;
        }

        // Reject null bytes, CRLF, and unprintable control characters
        for (int i = 0; i < redirect.length(); i++) {
            char c = redirect.charAt(i);
            if (c <= 31 || c == 127) {
                return false;
            }
        }

        String trimmed = redirect.trim();

        // Must start with exactly one forward slash, not //, /\, or \
        if (!trimmed.startsWith("/") || trimmed.startsWith("//") || trimmed.startsWith("/\\") || trimmed.startsWith("\\")) {
            return false;
        }

        // Must not contain scheme delimiter or backslashes
        if (trimmed.contains(":") || trimmed.contains("\\")) {
            return false;
        }

        // Validate decoded variant to prevent URL-encoded bypasses (e.g., %2f%2f, %5c, %0d%0a)
        try {
            String decoded = URLDecoder.decode(trimmed, StandardCharsets.UTF_8);
            if (!decoded.startsWith("/") || decoded.startsWith("//") || decoded.startsWith("/\\") || decoded.startsWith("\\")) {
                return false;
            }
            if (decoded.contains(":") || decoded.contains("\\")) {
                return false;
            }
            for (int i = 0; i < decoded.length(); i++) {
                char c = decoded.charAt(i);
                if (c <= 31 || c == 127) {
                    return false;
                }
            }
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    /**
     * Returns the redirect URL if safe; otherwise returns the provided default fallback path.
     *
     * @param redirect the candidate redirect target
     * @param defaultPath the fallback path if candidate is invalid/unsafe
     * @return sanitized redirect target
     */
    public static String getSafeLocalRedirect(String redirect, String defaultPath) {
        if (isSafeRedirect(redirect)) {
            return redirect.trim();
        }
        return defaultPath;
    }
}
