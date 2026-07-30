package in.sp.main.Service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;

class PasswordServiceTest {

    private PasswordService passwordService;

    @BeforeEach
    void setUp() {
        passwordService = new PasswordService(new BCryptPasswordEncoder());
    }

    @Test
    void encodeProducesBcryptHash() {
        String hash = passwordService.encode("Secret123!");
        assertTrue(passwordService.isBcryptEncoded(hash));
        assertTrue(passwordService.matches("Secret123!", hash));
        assertFalse(passwordService.matches("wrong", hash));
    }

    @Test
    void matchesLegacyPlaintext() {
        assertTrue(passwordService.matches("oldpass", "oldpass"));
        assertFalse(passwordService.matches("oldpass", "other"));
    }

    @Test
    void matchesAndUpgradeMigratesPlaintext() {
        AtomicReference<String> upgraded = new AtomicReference<>();
        assertTrue(passwordService.matchesAndUpgrade("legacy", "legacy", upgraded::set));
        assertNotNull(upgraded.get());
        assertTrue(passwordService.isBcryptEncoded(upgraded.get()));
        assertTrue(passwordService.matches("legacy", upgraded.get()));
    }

    @Test
    void matchesAndUpgradeDoesNotRewriteBcrypt() {
        String hash = passwordService.encode("keep");
        AtomicReference<String> upgraded = new AtomicReference<>();
        assertTrue(passwordService.matchesAndUpgrade("keep", hash, upgraded::set));
        assertNull(upgraded.get());
    }

    @Test
    void nullOrBlankNeverMatches() {
        assertFalse(passwordService.matches(null, "x"));
        assertFalse(passwordService.matches("x", null));
        assertFalse(passwordService.matches("x", "   "));
    }
}
