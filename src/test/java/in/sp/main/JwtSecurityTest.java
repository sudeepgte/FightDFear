package in.sp.main;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.flyway.enabled=false",
        "spring.datasource.url=jdbc:h2:mem:jwt_sec_test;MODE=MySQL;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE;NON_KEYWORDS=USER",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "spring.profiles.active=default",
        "jwt.secret=test-jwt-secret-key-at-least-32-characters-long",
        "app.base-url=http://localhost:8084",
        "sms.enabled=false",
        "razorpay.key.id=",
        "razorpay.key.secret=",
        "google.maps.apiKey=unused"
})
class JwtSecurityTest {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    private User testUser;

    @BeforeEach
    void setup() {
        userRepository.deleteAll();
        User u = new User();
        u.setFullName("JWT Test User");
        u.setEmail("jwtuser@test.com");
        u.setPassword("Pass@1234");
        testUser = userRepository.save(u);
    }

    @Test
    void validJwtTokenIsAcceptedAndParsed() {
        String token = jwtUtil.generateToken("jwtuser@test.com", "USER");
        assertNotNull(token);
        assertTrue(jwtUtil.validateToken(token));
        assertEquals("jwtuser@test.com", jwtUtil.extractUsername(token));
        assertEquals("USER", jwtUtil.extractRole(token));
    }

    @Test
    void expiredJwtTokenIsRejected() {
        String expiredToken = jwtUtil.generateToken("jwtuser@test.com", "USER", -10000L);
        assertNotNull(expiredToken);
        assertFalse(jwtUtil.validateToken(expiredToken));
    }

    @Test
    void tamperedSignatureJwtIsRejected() {
        String token = jwtUtil.generateToken("jwtuser@test.com", "USER");
        int lastDot = token.lastIndexOf('.');
        String tamperedToken = token.substring(0, lastDot + 1) + "corruptedSignaturePayload123456";
        assertFalse(jwtUtil.validateToken(tamperedToken));
    }

    @Test
    void malformedJwtIsRejected() {
        assertFalse(jwtUtil.validateToken(null));
        assertFalse(jwtUtil.validateToken(""));
        assertFalse(jwtUtil.validateToken("   "));
        assertFalse(jwtUtil.validateToken("header.payload"));
        assertFalse(jwtUtil.validateToken("not-a-token"));
    }

    @Test
    void tokenSignedWithDifferentSecretIsRejected() {
        Key foreignKey = Keys.hmacShaKeyFor("different-foreign-secret-key-at-least-32-chars".getBytes(StandardCharsets.UTF_8));
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", "USER");
        String forgedToken = Jwts.builder()
                .setClaims(claims)
                .setSubject("jwtuser@test.com")
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 3600000))
                .signWith(foreignKey)
                .compact();

        assertFalse(jwtUtil.validateToken(forgedToken));
    }

    @Test
    void jwtAuthenticationFilterAuthenticatesValidToken() throws Exception {
        String token = jwtUtil.generateToken("jwtuser@test.com", "USER");

        mockMvc.perform(get("/api/me")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    void jwtAuthenticationFilterRejectsInvalidBearerToken() throws Exception {
        mockMvc.perform(get("/api/me")
                .header("Authorization", "Bearer invalid-tampered-token"))
                .andExpect(status().isUnauthorized());
    }
}
