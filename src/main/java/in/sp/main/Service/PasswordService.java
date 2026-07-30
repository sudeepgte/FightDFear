package in.sp.main.Service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.function.Consumer;

/**
 * Single password hashing/verification path for all account types.
 * New passwords are always BCrypt. Legacy plaintext hashes are accepted once and upgraded.
 */
@Service
public class PasswordService {

    private final PasswordEncoder passwordEncoder;

    public PasswordService(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    public String encode(String rawPassword) {
        if (rawPassword == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return passwordEncoder.encode(rawPassword);
    }

    public boolean isBcryptEncoded(String storedPassword) {
        return storedPassword != null
                && (storedPassword.startsWith("$2a$")
                || storedPassword.startsWith("$2b$")
                || storedPassword.startsWith("$2y$"));
    }

    /**
     * Verifies raw password against stored value (BCrypt or legacy plaintext).
     */
    public boolean matches(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null || storedPassword.isBlank()) {
            return false;
        }
        if (isBcryptEncoded(storedPassword)) {
            return passwordEncoder.matches(rawPassword, storedPassword);
        }
        // Legacy plaintext accounts created before BCrypt was enforced
        return storedPassword.equals(rawPassword);
    }

    /**
     * Same as {@link #matches}, and if the stored value was plaintext, calls {@code upgrade}
     * with a fresh BCrypt hash so the account is migrated on successful login.
     */
    public boolean matchesAndUpgrade(String rawPassword, String storedPassword, Consumer<String> upgrade) {
        if (!matches(rawPassword, storedPassword)) {
            return false;
        }
        if (!isBcryptEncoded(storedPassword) && upgrade != null) {
            upgrade.accept(encode(rawPassword));
        }
        return true;
    }
}
