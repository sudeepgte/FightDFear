package in.sp.main.Util;

import java.util.Locale;
import java.util.regex.Pattern;

import in.sp.main.Entities.Gender;

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

    /**
     * Member registration on Fight D Fear — women-only; gender is required (Female or Other).
     */
    public static String requireWomenMemberGender(String genderRaw) {
        if (genderRaw == null || genderRaw.isBlank()) {
            return "Gender is required. Fight D Fear is a women-only platform.";
        }
        try {
            Gender g = Gender.valueOf(genderRaw.trim().toUpperCase(Locale.ROOT));
            if (g == Gender.MALE) {
                return "This platform is for women only.";
            }
            if (g != Gender.FEMALE && g != Gender.OTHER) {
                return "Please select Female.";
            }
            return null;
        } catch (IllegalArgumentException e) {
            return "Please select a valid gender.";
        }
    }

    public static Gender parseWomenMemberGender(String genderRaw) {
        String err = requireWomenMemberGender(genderRaw);
        if (err != null) {
            throw new IllegalArgumentException(err);
        }
        return Gender.valueOf(genderRaw.trim().toUpperCase(Locale.ROOT));
    }

    private static final Pattern VALID_NAME = Pattern.compile("^[a-zA-Z\\s.'\\-]+$");

    public static String requireEmergencyContactName(String name) {
        String n = trim(name);
        if (n.isEmpty()) {
            return "Emergency contact name is required.";
        }
        if (n.length() < 2 || n.length() > 70) {
            return "Emergency contact name must be between 2 and 70 characters.";
        }
        if (!VALID_NAME.matcher(n).matches()) {
            return "Emergency contact name can only contain letters, spaces, hyphens, and dots.";
        }
        return null;
    }

    public static String requireEmergencyContactPhone(String phone) {
        String p = trim(phone);
        if (p.isEmpty()) {
            return "Emergency contact phone number is required.";
        }
        if (!isPhone10(p)) {
            return "Emergency contact phone number must be exactly 10 digits.";
        }
        if (p.matches("^(\\d)\\1{9}$")) {
            return "Please enter a valid 10-digit emergency contact phone number.";
        }
        return null;
    }

    public static String requireEmergencyContactEmail(String email) {
        String e = trim(email);
        if (e.isEmpty()) {
            return "Emergency contact email is required.";
        }
        if (e.length() > 100) {
            return "Emergency contact email must not exceed 100 characters.";
        }
        if (!isEmail(e)) {
            return "Enter a valid emergency contact email address (e.g. name@example.com).";
        }
        return null;
    }

    private static final Pattern WHATSAPP_CHARS = Pattern.compile("^\\+?[0-9\\s\\-().]{8,25}$");

    public static String requireWhatsappNumber(String whatsapp) {
        String w = trim(whatsapp);
        if (w.isEmpty()) {
            return "WhatsApp number is required.";
        }
        if (!WHATSAPP_CHARS.matcher(w).matches()) {
            return "WhatsApp number can only contain digits, spaces, and an optional leading '+'.";
        }
        String digitsOnly = w.replaceAll("\\D", "");
        if (digitsOnly.length() < 8 || digitsOnly.length() > 15) {
            return "WhatsApp number must contain between 8 and 15 digits with country code.";
        }
        if (digitsOnly.matches("^(\\d)\\1{7,}$")) {
            return "Please enter a valid WhatsApp number with country code.";
        }
        return null;
    }

    public static String normalizeWhatsappNumber(String whatsapp) {
        String w = trim(whatsapp);
        if (w.isEmpty()) {
            return "";
        }
        boolean hasLeadingPlus = w.startsWith("+");
        String digitsOnly = w.replaceAll("\\D", "");
        if (digitsOnly.isEmpty()) {
            return "";
        }
        if (hasLeadingPlus) {
            return "+" + digitsOnly;
        }
        if (digitsOnly.length() == 10) {
            return "+91" + digitsOnly; // Default to India (+91) if 10 national digits provided
        }
        return "+" + digitsOnly;
    }
}


