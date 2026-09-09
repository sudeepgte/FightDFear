package in.sp.main;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class ActuatorSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void testActuatorHealth_IsPubliclyAccessibleWithoutInternalDetails() throws Exception {
        MvcResult res = mockMvc.perform(get("/actuator/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").exists())
                .andReturn();

        String body = res.getResponse().getContentAsString();
        assertFalse(body.contains("diskSpace"), "Health details must be hidden");
        assertFalse(body.contains("database"), "Database details must be hidden in public health");
        assertFalse(body.contains("db"), "DB details must be hidden in public health");
    }

    @Test
    void testActuatorInfo_IsAccessibleWithoutEnvironmentSecrets() throws Exception {
        MvcResult res = mockMvc.perform(get("/actuator/info"))
                .andExpect(status().isOk())
                .andReturn();

        String body = res.getResponse().getContentAsString();
        assertFalse(body.contains("password"), "Info must not contain passwords");
        assertFalse(body.contains("secret"), "Info must not contain secrets");
        assertFalse(body.contains("key"), "Info must not contain API keys");
        assertFalse(body.contains("os"), "OS details must be disabled");
        assertFalse(body.contains("java.version"), "Java system properties must not be exposed");
    }

    private void assertBlockedFromPublicAccess(String endpoint) throws Exception {
        mockMvc.perform(get(endpoint))
                .andExpect(result -> {
                    int status = result.getResponse().getStatus();
                    assertTrue(status == 302 || (status >= 400 && status < 500),
                            "Endpoint " + endpoint + " must be blocked for anonymous access (got HTTP " + status + ")");
                });
    }

    @Test
    void testActuatorEnv_IsBlockedFromPublicAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator/env");
    }

    @Test
    void testActuatorConfigProps_IsBlockedFromPublicAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator/configprops");
    }

    @Test
    void testActuatorBeans_IsBlockedFromPublicAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator/beans");
    }

    @Test
    void testActuatorHeapdump_IsBlockedFromPublicAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator/heapdump");
    }

    @Test
    void testActuatorThreaddump_IsBlockedFromPublicAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator/threaddump");
    }

    @Test
    void testActuatorLoggers_IsBlockedFromPublicAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator/loggers");
    }

    @Test
    void testActuatorRoot_IsBlockedFromAnonymousAccess() throws Exception {
        assertBlockedFromPublicAccess("/actuator");
    }
}
