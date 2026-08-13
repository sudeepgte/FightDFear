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

@Component
public class JwtUtil {

    @Value("${jwt.secret:Xp3Iu2umGV20AJykfcM/0n+CPJ61pgSdnjk20OYGDeeniBkVR+s+fKEWRnsuih/i1lGl/DS9w9mw/Z4UNJwBNw==}")
    private String jwtSecret;

    private Key secretKey;

    @PostConstruct
    void initSigningKey() {
        // Empty JWT_SECRET env var can resolve to blank and override the property default.
        String secret = jwtSecret == null ? "" : jwtSecret.trim();
        if (secret.isBlank()) {
            secret = "Xp3Iu2umGV20AJykfcM/0n+CPJ61pgSdnjk20OYGDeeniBkVR+s+fKEWRnsuih/i1lGl/DS9w9mw/Z4UNJwBNw==";
        }
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            throw new IllegalStateException(
                    "jwt.secret / JWT_SECRET must be at least 32 characters for HS256. Generate one with: openssl rand -base64 48");
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
        return extractExpiration(token).before(new Date());
    }

    public String generateToken(String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);
        return createToken(claims, username);
    }

    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                // Set expiration to 10 years (essentially doesn't expire until logout)
                .setExpiration(new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 365 * 10))
                .signWith(secretKey)
                .compact();
    }

    public Boolean validateToken(String token) {
        try {
            return !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }
}
