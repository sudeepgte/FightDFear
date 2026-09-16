package in.sp.main.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import in.sp.main.Util.LogSanitizer;

@Service
public class SecurityAuditLogger {

    private static final Logger log = LoggerFactory.getLogger(SecurityAuditLogger.class);

    public void logAuthSuccess(String authType, Object userId, String email, String role, String ip) {
        log.info("[SECURITY-AUDIT] event=AUTH_SUCCESS authType={} userId={} email={} role={} ip={}",
                LogSanitizer.sanitize(authType),
                LogSanitizer.sanitize(userId),
                LogSanitizer.sanitize(email),
                LogSanitizer.sanitize(role),
                LogSanitizer.sanitize(ip));
    }

    public void logAuthFailure(String authType, String email, String reason, String ip) {
        log.warn("[SECURITY-AUDIT] event=AUTH_FAILURE authType={} email={} reason={} ip={}",
                LogSanitizer.sanitize(authType),
                LogSanitizer.sanitize(email),
                LogSanitizer.sanitize(reason),
                LogSanitizer.sanitize(ip));
    }

    public void logAuthzDenied(Object userId, String resource, Object resourceId, String action, String ip) {
        log.warn("[SECURITY-AUDIT] event=AUTHORIZATION_DENIED userId={} resource={} resourceId={} action={} ip={}",
                LogSanitizer.sanitize(userId),
                LogSanitizer.sanitize(resource),
                LogSanitizer.sanitize(resourceId),
                LogSanitizer.sanitize(action),
                LogSanitizer.sanitize(ip));
    }

    public void logOtpFailure(String target, String purpose, String reason, String ip) {
        log.warn("[SECURITY-AUDIT] event=OTP_FAILURE target={} purpose={} reason={} ip={}",
                LogSanitizer.sanitize(target),
                LogSanitizer.sanitize(purpose),
                LogSanitizer.sanitize(reason),
                LogSanitizer.sanitize(ip));
    }

    public void logOtpSuccess(String target, String purpose, String ip) {
        log.info("[SECURITY-AUDIT] event=OTP_SUCCESS target={} purpose={} ip={}",
                LogSanitizer.sanitize(target),
                LogSanitizer.sanitize(purpose),
                LogSanitizer.sanitize(ip));
    }

    public void logPaymentEvent(String event, Object userId, Object targetId, String orderId, String paymentId, String result) {
        if ("SUCCESS".equalsIgnoreCase(result)) {
            log.info("[SECURITY-AUDIT] event=PAYMENT_{} userId={} targetId={} orderId={} paymentId={} result={}",
                    LogSanitizer.sanitize(event),
                    LogSanitizer.sanitize(userId),
                    LogSanitizer.sanitize(targetId),
                    LogSanitizer.sanitize(orderId),
                    LogSanitizer.sanitize(paymentId),
                    LogSanitizer.sanitize(result));
        } else {
            log.warn("[SECURITY-AUDIT] event=PAYMENT_{} userId={} targetId={} orderId={} paymentId={} result={}",
                    LogSanitizer.sanitize(event),
                    LogSanitizer.sanitize(userId),
                    LogSanitizer.sanitize(targetId),
                    LogSanitizer.sanitize(orderId),
                    LogSanitizer.sanitize(paymentId),
                    LogSanitizer.sanitize(result));
        }
    }

    public void logUploadBlocked(Object userId, String filename, String category, String reason) {
        log.warn("[SECURITY-AUDIT] event=UPLOAD_BLOCKED userId={} filename={} category={} reason={}",
                LogSanitizer.sanitize(userId),
                LogSanitizer.sanitizeFilename(filename),
                LogSanitizer.sanitize(category),
                LogSanitizer.sanitize(reason));
    }

    public void logAdminAction(Object adminId, String action, String targetType, Object targetId, String result) {
        log.info("[SECURITY-AUDIT] event=ADMIN_ACTION adminId={} action={} targetType={} targetId={} result={}",
                LogSanitizer.sanitize(adminId),
                LogSanitizer.sanitize(action),
                LogSanitizer.sanitize(targetType),
                LogSanitizer.sanitize(targetId),
                LogSanitizer.sanitize(result));
    }
}
