package in.sp.main.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service for WhatsApp alert dispatch via Meta WhatsApp Business Platform Cloud API
 * with direct WhatsApp link fallback (wa.me / api.whatsapp.com).
 */
@Service
public class WhatsAppService {

    private static final Logger log = LoggerFactory.getLogger(WhatsAppService.class);

    @Value("${whatsapp.cloud-api.enabled:false}")
    private boolean enabled;

    @Value("${whatsapp.cloud-api.phone-number-id:}")
    private String phoneNumberId;

    @Value("${whatsapp.cloud-api.access-token:}")
    private String accessToken;

    @Value("${whatsapp.cloud-api.api-version:v21.0}")
    private String apiVersion;

    public boolean isConfigured() {
        return enabled && phoneNumberId != null && !phoneNumberId.isBlank()
                && accessToken != null && !accessToken.isBlank();
    }

    /**
     * Attempts to send the SOS location alert to the recipient WhatsApp number.
     * If Meta Cloud API is configured, dispatches an automated message via HTTP POST.
     * If not configured, returns a fallback WhatsApp URL containing the pre-filled emergency alert
     * for the user to review and send.
     */
    public Map<String, Object> sendSOSLocationAlert(String recipientWhatsapp, String userName, String userPhone, String mapsLink, double lat, double lon) {
        Map<String, Object> result = new LinkedHashMap<>();

        String cleanNumber = recipientWhatsapp == null ? "" : recipientWhatsapp.replaceAll("\\D", "");
        if (cleanNumber.isEmpty()) {
            result.put("success", false);
            result.put("status", "INVALID_NUMBER");
            result.put("error", "No valid WhatsApp number provided");
            return result;
        }

        String safeUserName = (userName != null && !userName.isBlank()) ? userName.trim() : "Fight D Fear User";
        String safeUserPhone = (userPhone != null && !userPhone.isBlank()) ? userPhone.trim() : "Unknown";
        String safeMapsLink = (mapsLink != null && !mapsLink.isBlank()) ? mapsLink.trim() : "https://www.google.com/maps?q=" + lat + "," + lon;

        String messageBody = "🚨 *EMERGENCY SOS ALERT!* 🚨\n\n"
                + "*User:* " + safeUserName + "\n"
                + "*Contact Phone:* " + safeUserPhone + "\n"
                + "*Live Location:* " + safeMapsLink + "\n"
                + "*Coordinates:* " + lat + ", " + lon + "\n\n"
                + "⚠️ Immediate assistance is requested. Please check location and provide urgent help.";

        String fallbackUrl = "https://api.whatsapp.com/send?phone=" + cleanNumber + "&text=" + URLEncoder.encode(messageBody, StandardCharsets.UTF_8);
        result.put("fallbackUrl", fallbackUrl);
        result.put("whatsappNumber", recipientWhatsapp);
        result.put("cleanNumber", cleanNumber);
        result.put("messageBody", messageBody);

        if (!isConfigured()) {
            log.info("WhatsApp Cloud API not configured on server. Returning review & send fallback for {}", cleanNumber);
            result.put("success", false);
            result.put("configured", false);
            result.put("status", "NOT_CONFIGURED");
            result.put("message", "WhatsApp Cloud API is not configured on this server. Click the button to review and send the alert via WhatsApp.");
            return result;
        }

        try {
            String cleanVersion = (apiVersion != null && !apiVersion.isBlank()) ? apiVersion.trim() : "v21.0";
            if (!cleanVersion.startsWith("v")) {
                cleanVersion = "v" + cleanVersion;
            }
            String endpoint = "https://graph.facebook.com/" + cleanVersion + "/" + phoneNumberId.trim() + "/messages";

            String jsonPayload = "{"
                    + "\"messaging_product\":\"whatsapp\","
                    + "\"recipient_type\":\"individual\","
                    + "\"to\":\"" + cleanNumber + "\","
                    + "\"type\":\"text\","
                    + "\"text\":{\"preview_url\":true,\"body\":\"" + escapeJson(messageBody) + "\"}"
                    + "}";

            HttpURLConnection conn = (HttpURLConnection) URI.create(endpoint).toURL().openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken.trim());
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(12000);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonPayload.getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
            String responseStr = "";
            if (is != null) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                    responseStr = reader.lines().collect(Collectors.joining("\n"));
                }
            }

            if (code >= 200 && code < 300) {
                log.info("WhatsApp SOS alert delivered via Cloud API to {}: {}", cleanNumber, responseStr);
                result.put("success", true);
                result.put("configured", true);
                result.put("status", "SENT");
                result.put("response", responseStr);
                result.put("message", "SOS location alert delivered successfully to WhatsApp (" + recipientWhatsapp + ") via Meta Cloud API.");
            } else {
                log.warn("WhatsApp Cloud API rejected request with HTTP {}: {}", code, responseStr);
                result.put("success", false);
                result.put("configured", true);
                result.put("status", "FAILED");
                result.put("httpCode", code);
                result.put("error", "WhatsApp Cloud API returned error code " + code + ". You can send the alert manually using the review & send button.");
                result.put("response", responseStr);
            }
        } catch (Exception e) {
            log.error("Failed to connect to WhatsApp Cloud API: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("configured", true);
            result.put("status", "ERROR");
            result.put("error", "Communication failure with WhatsApp Cloud API: " + e.getMessage() + ". You can send the alert manually using the review & send button.");
        }

        return result;
    }

    private String escapeJson(String raw) {
        if (raw == null) return "";
        return raw.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
