package in.sp.main.Controller;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Config.CorrelationIdFilter;
import in.sp.main.Exception.RateLimitExceededException;
import in.sp.main.Util.LogSanitizer;
import jakarta.persistence.PersistenceException;

@RestControllerAdvice
public class ApiExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(ApiExceptionHandler.class);

    private String getCorrelationId() {
        String id = MDC.get(CorrelationIdFilter.REQUEST_ID_KEY);
        if (id == null || id.isBlank()) {
            id = MDC.get(CorrelationIdFilter.CORRELATION_ID_KEY);
        }
        return (id != null && !id.isBlank()) ? id : "none";
    }

    @ExceptionHandler(RateLimitExceededException.class)
    public ResponseEntity<Map<String, Object>> handleRateLimit(RateLimitExceededException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", ex.getMessage());
        return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(body);
    }

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Map<String, Object>> handleResponseStatus(ResponseStatusException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        String reason = ex.getReason() != null ? ex.getReason() : "Request failed";
        body.put("error", reason);
        return ResponseEntity.status(ex.getStatusCode()).body(body);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> handleAccessDenied(AccessDeniedException ex) {
        String correlationId = getCorrelationId();
        log.warn("Access denied correlationId={}: {}", correlationId, LogSanitizer.sanitize(ex.getMessage()));
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", "Access denied");
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(body);
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<Map<String, Object>> handleAuthentication(AuthenticationException ex) {
        String correlationId = getCorrelationId();
        log.warn("Authentication failure correlationId={}: {}", correlationId, LogSanitizer.sanitize(ex.getMessage()));
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", "Unauthorized");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
    }

    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    public ResponseEntity<Map<String, Object>> handleValidation(Exception ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        String errorMsg = "Validation failed for request arguments.";
        if (ex instanceof MethodArgumentNotValidException manv) {
            FieldError fe = manv.getBindingResult().getFieldError();
            if (fe != null && fe.getDefaultMessage() != null) {
                errorMsg = fe.getDefaultMessage();
            }
        } else if (ex instanceof BindException be) {
            FieldError fe = be.getBindingResult().getFieldError();
            if (fe != null && fe.getDefaultMessage() != null) {
                errorMsg = fe.getDefaultMessage();
            }
        }
        body.put("error", errorMsg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<Map<String, Object>> handleMaxUploadSize(MaxUploadSizeExceededException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", "File exceeds maximum permitted upload size");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler({DataIntegrityViolationException.class, SQLException.class, PersistenceException.class})
    public ResponseEntity<Map<String, Object>> handleDatabaseError(Exception ex) {
        String correlationId = getCorrelationId();
        log.error("Database integrity error correlationId={}: ", correlationId, ex);
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", "A database error occurred. The operation could not be completed.");
        body.put("correlationId", correlationId);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgument(IllegalArgumentException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        String msg = ex.getMessage();
        if (msg == null || msg.contains("org.") || msg.contains("in.sp.") || msg.contains("SELECT") || msg.contains("UPDATE")) {
            msg = "Invalid input parameter.";
        }
        body.put("error", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalState(IllegalStateException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        String msg = ex.getMessage();
        if (msg == null || msg.contains("org.") || msg.contains("in.sp.") || msg.contains("SELECT") || msg.contains("UPDATE")) {
            msg = "Operation could not be processed.";
        }
        body.put("error", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGenericException(Exception ex) {
        String correlationId = getCorrelationId();
        log.error("Unexpected server error correlationId={}: ", correlationId, ex);
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", "An unexpected error occurred.");
        body.put("correlationId", correlationId);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }
}
