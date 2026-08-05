package in.sp.main.Util;

import java.util.Locale;
import java.util.regex.Pattern;

/**
 * Shared validation helpers for mobile JSON auth/register endpoints.
 */
public final class MobileValidation {

    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");
    private static final Pattern PHONE10 = Pattern.compile("^\\d{10}$");
    private static final Pattern PASSWORD =
            Pattern.compile("^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$");

    private MobileValidation() {}

    public static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    public static String normalizeEmail(String email) {
        return trim(email).toLowerCase(Locale.ROOT);
    }

    public static boolean isEmail(String email) {
        String e = trim(email);
        return !e.isEmpty() && EMAIL.matcher(e).matches();
    }

    public static boolean isPhone10(String phone) {
        return PHONE10.matcher(trim(phone)).matches();
    }

    public static boolean isPasswordStrong(String password) {
        return password != null && PASSWORD.matcher(password).matches();
    }

    public static String requireEmail(String email) {
        if (!isEmail(email)) return "Enter a valid email address";
        return null;
    }

    public static String requirePhone(String phone, boolean required) {
        String p = trim(phone);
        if (p.isEmpty()) return required ? "Phone number is required" : null;
        if (!isPhone10(p)) return "Phone number must be exactly 10 digits";
        return null;
    }

    public static String requirePassword(String password) {
        if (password == null || password.isBlank()) return "Password is required";
        if (!isPasswordStrong(password)) {
            return "Password must be at least 6 characters and include a number and special character";
        }
        return null;
    }

    public static String requireConfirm(String password, String confirm) {
        if (confirm == null || confirm.isBlank()) return "Confirm password is required";
        if (!password.equals(confirm)) return "Passwords do not match";
        return null;
    }
}
