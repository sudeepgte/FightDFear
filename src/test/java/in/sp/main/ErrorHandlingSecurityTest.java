package in.sp.main;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import in.sp.main.Controller.ApiExceptionHandler;
import jakarta.servlet.RequestDispatcher;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class ErrorHandlingSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ApiExceptionHandler apiExceptionHandler;

    @Test
    void testCorrelationIdHeader_AlwaysGeneratedAndReturned() throws Exception {
        mockMvc.perform(get("/api/landing/features"))
                .andExpect(header().exists("X-Correlation-ID"));
    }

    @Test
    void testClientProvidedCorrelationId_SanitizedAndReturned() throws Exception {
        mockMvc.perform(get("/api/landing/features")
                        .header("X-Correlation-ID", "custom-trace-id-12345"))
                .andExpect(header().string("X-Correlation-ID", "custom-trace-id-12345"));
    }

    @Test
    void testMaliciousCorrelationId_RejectedAndReplaced() throws Exception {
        MvcResult res = mockMvc.perform(get("/api/landing/features")
                        .header("X-Correlation-ID", "bad\r\nid\nwith\0injection!@#$%^&*()"))
                .andReturn();

        String returnedHeader = res.getResponse().getHeader("X-Correlation-ID");
        assertNotNull(returnedHeader);
        assertFalse(returnedHeader.contains("\r"));
        assertFalse(returnedHeader.contains("\n"));
        assertFalse(returnedHeader.contains("\0"));
    }

    @Test
    void testApiExceptionHandler_DatabaseErrorDoesNotLeakSqlOrTableNames() {
        DataIntegrityViolationException sqlEx = new DataIntegrityViolationException(
                "Cannot add or update a child row: a foreign key constraint fails (`womenbesafe`.`users`, CONSTRAINT `fk_user` FOREIGN KEY (`id`) REFERENCES `account` (`id`))\nSELECT * FROM users WHERE password = 'secret'");

        var response = apiExceptionHandler.handleDatabaseError(sqlEx);

        assertNotNull(response.getBody());
        String errorMsg = (String) response.getBody().get("error");
        assertNotNull(errorMsg);

        assertFalse(errorMsg.contains("SELECT"), "Response must not contain SQL queries");
        assertFalse(errorMsg.contains("womenbesafe"), "Response must not contain schema names");
        assertFalse(errorMsg.contains("users"), "Response must not contain table names");
        assertFalse(errorMsg.contains("fk_user"), "Response must not contain constraint names");
        assertFalse(errorMsg.contains("secret"), "Response must not contain credential data");
        assertTrue(errorMsg.contains("database error"), "Response must contain generic database error message");
    }

    @Test
    void testApiExceptionHandler_GenericExceptionDoesNotLeakStackTraceOrClassNames() {
        NullPointerException npe = new NullPointerException("Null reference at in.sp.main.Controller.AdminController.login(AdminController.java:330)");

        var response = apiExceptionHandler.handleGenericException(npe);

        assertNotNull(response.getBody());
        String errorMsg = (String) response.getBody().get("error");
        assertNotNull(errorMsg);

        assertFalse(errorMsg.contains("NullPointerException"), "Response must not leak exception class name");
        assertFalse(errorMsg.contains("in.sp.main"), "Response must not leak package names");
        assertFalse(errorMsg.contains("AdminController.java"), "Response must not leak Java source file names");
        assertFalse(errorMsg.contains("at in.sp."), "Response must not leak stack trace elements");
        assertTrue(errorMsg.contains("unexpected error"), "Response must contain safe generic message");
        assertNotNull(response.getBody().get("correlationId"), "Response must provide diagnostic correlation ID");
    }

    @Test
    void testGlobalErrorController_Json404DoesNotLeakInternalDetails() throws Exception {
        mockMvc.perform(get("/error")
                        .accept(MediaType.APPLICATION_JSON)
                        .requestAttr(RequestDispatcher.ERROR_STATUS_CODE, 404)
                        .requestAttr(RequestDispatcher.ERROR_REQUEST_URI, "/api/resource/not-found"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.error").exists())
                .andExpect(jsonPath("$.correlationId").exists());
    }

    @Test
    void testGlobalErrorController_HtmlBrowserErrorReturnsCleanView() throws Exception {
        MvcResult res = mockMvc.perform(get("/error")
                        .accept(MediaType.TEXT_HTML)
                        .requestAttr(RequestDispatcher.ERROR_STATUS_CODE, 500)
                        .requestAttr(RequestDispatcher.ERROR_REQUEST_URI, "/users/dashboard"))
                .andExpect(status().isInternalServerError())
                .andReturn();

        String body = res.getResponse().getContentAsString();
        assertFalse(body.contains("Exception:"), "Browser error must not contain raw Java exceptions");
        assertFalse(body.contains("at in.sp.main"), "Browser error must not contain stack trace paths");
        assertFalse(body.contains("org.springframework"), "Browser error must not contain Spring internals");
        assertFalse(body.contains("SELECT "), "Browser error must not contain SQL statements");
    }
}
