package in.sp.main.Config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class JwtUtil {

    private static final Logger log = LoggerFactory.getLogger(JwtUtil.class);

    @Value("${jwt.secret:}")
    private String jwtSecret;

    @Value("${jwt.expiration-ms:2592000000}")
    private long jwtExpirationMs;

    private Key secretKey;

    @PostConstruct
    void initSigningKey() {
        String secret = jwtSecret == null ? "" : jwtSecret.trim();
        if (secret.isBlank()) {
            secret = "LOCAL_DEV_ONLY_change_me_min_32_chars_abcdefgh";
        }

        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            throw new IllegalStateException(
                    "jwt.secret / JWT_SECRET must be at least 32 characters (256-bit) for HS256. Generate one with: openssl rand -base64 48");
        }
        this.jwtSecret = secret;
        this.secretKey = Keys.hmacShaKeyFor(keyBytes);
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public String extractRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Boolean isTokenExpired(String token) {
        Date exp = extractExpiration(token);
        return exp != null && exp.before(new Date());
    }

    public String generateToken(String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);
        return createToken(claims, username);
    }

    public String generateToken(String username, String role, long customExpirationMs) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);
        return createToken(claims, username, customExpirationMs);
    }

    private String createToken(Map<String, Object> claims, String subject) {
        return createToken(claims, subject, jwtExpirationMs);
    }

    private String createToken(Map<String, Object> claims, String subject, long expirationDurationMs) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + expirationDurationMs))
                .signWith(secretKey)
                .compact();
    }

    public Boolean validateToken(String token) {
        if (token == null || token.isBlank()) {
            return false;
        }
        try {
            Claims claims = extractAllClaims(token);
            if (claims == null || claims.getSubject() == null || claims.getExpiration() == null) {
                log.warn("[SECURITY-AUDIT] event=JWT_INVALID reason=MISSING_REQUIRED_CLAIMS");
                return false;
            }
            boolean notExpired = !claims.getExpiration().before(new Date());
            if (!notExpired) {
                log.warn("[SECURITY-AUDIT] event=JWT_EXPIRED subject={}",
                        in.sp.main.Util.LogSanitizer.sanitize(claims.getSubject()));
            }
            return notExpired;
        } catch (io.jsonwebtoken.ExpiredJwtException e) {
            String sub = e.getClaims() != null ? e.getClaims().getSubject() : "unknown";
            log.warn("[SECURITY-AUDIT] event=JWT_EXPIRED subject={}", in.sp.main.Util.LogSanitizer.sanitize(sub));
            return false;
        } catch (Exception e) {
            log.warn("[SECURITY-AUDIT] event=JWT_INVALID error={}", in.sp.main.Util.LogSanitizer.sanitize(e.getMessage()));
            return false;
        }
    }
}
