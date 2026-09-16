package in.sp.main.Controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import in.sp.main.Config.CorrelationIdFilter;
import in.sp.main.Util.LogSanitizer;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class GlobalErrorController implements ErrorController {

    private static final Logger log = LoggerFactory.getLogger(GlobalErrorController.class);

    @RequestMapping("/error")
    public Object handleError(HttpServletRequest request, HttpServletResponse response, Model model) {
        Integer statusCode = (Integer) request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        if (statusCode == null) {
            statusCode = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
        }

        String correlationId = (String) request.getAttribute(CorrelationIdFilter.CORRELATION_ID_KEY);
        if (correlationId == null || correlationId.isBlank()) {
            correlationId = (String) request.getAttribute(CorrelationIdFilter.REQUEST_ID_KEY);
        }
        if (correlationId == null || correlationId.isBlank()) {
            correlationId = "none";
        }

        String safeMessage = getSafeMessage(statusCode);
        String requestUri = (String) request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);
        if (requestUri == null) {
            requestUri = request.getRequestURI();
        }

        if (statusCode >= 500) {
            Throwable throwable = (Throwable) request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
            log.error("Internal server error correlationId={} uri={} status={}: ",
                    correlationId, LogSanitizer.sanitize(requestUri), statusCode, throwable);
        } else if (statusCode == 404 || statusCode == 400) {
            log.debug("Client error correlationId={} uri={} status={}",
                    correlationId, LogSanitizer.sanitize(requestUri), statusCode);
        } else {
            log.warn("Security/client error correlationId={} uri={} status={}",
                    correlationId, LogSanitizer.sanitize(requestUri), statusCode);
        }

        if (isJsonRequest(request, requestUri)) {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", false);
            body.put("status", statusCode);
            body.put("error", safeMessage);
            body.put("correlationId", correlationId);
            return ResponseEntity.status(statusCode)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body);
        }

        model.addAttribute("status", statusCode);
        model.addAttribute("error", safeMessage);
        model.addAttribute("correlationId", correlationId);
        response.setStatus(statusCode);
        return "error";
    }

    private boolean isJsonRequest(HttpServletRequest request, String requestUri) {
        if (requestUri != null) {
            if (requestUri.startsWith("/api/")
                    || requestUri.startsWith("/payment/")
                    || requestUri.startsWith("/actuator/")
                    || requestUri.startsWith("/chat/")) {
                return true;
            }
        }
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains(MediaType.APPLICATION_JSON_VALUE)) {
            return true;
        }
        String contentType = request.getHeader("Content-Type");
        return contentType != null && contentType.contains(MediaType.APPLICATION_JSON_VALUE);
    }

    private String getSafeMessage(int statusCode) {
        return switch (statusCode) {
            case 400 -> "Bad request. Please verify your input.";
            case 401 -> "Unauthorized. Authentication is required.";
            case 403 -> "Access denied. You do not have permission to view this resource.";
            case 404 -> "The requested resource was not found.";
            case 405 -> "HTTP method not allowed.";
            case 429 -> "Too many requests. Please try again later.";
            default -> "An unexpected error occurred. Please try again later.";
        };
    }
}
