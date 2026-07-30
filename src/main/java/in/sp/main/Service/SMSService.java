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
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

/**
 * Production SMS for emergency alerts via Twilio or Msg91.
 * Never reports success unless the provider accepts the message.
 */
@Service
public class SMSService {

    private static final Logger logger = LoggerFactory.getLogger(SMSService.class);

    @Value("${sms.provider:}")
    private String smsProvider;

    @Value("${sms.twilio.account-sid:}")
    private String twilioAccountSid;

    @Value("${sms.twilio.auth-token:}")
    private String twilioAuthToken;

    @Value("${sms.twilio.phone-number:}")
    private String twilioPhoneNumber;

    @Value("${sms.msg91.auth-key:}")
    private String msg91AuthKey;

    @Value("${sms.msg91.sender-id:}")
    private String msg91SenderId;

    @Value("${sms.enabled:false}")
    private boolean smsEnabled;

    @Value("${sms.default-country-code:91}")
    private String defaultCountryCode;

    public boolean isConfigured() {
        if (!smsEnabled) {
            return false;
        }
        String provider = resolveProvider();
        return switch (provider) {
            case "twilio" -> !isBlank(twilioAccountSid) && !isBlank(twilioAuthToken) && !isBlank(twilioPhoneNumber);
            case "msg91" -> !isBlank(msg91AuthKey) && !isBlank(msg91SenderId);
            default -> false;
        };
    }

    /**
     * Send SMS notification. Returns true only when the provider confirms acceptance.
     */
    public boolean sendSMS(String phoneNumber, String message) {
        if (!smsEnabled) {
            logger.warn("SMS disabled (sms.enabled=false). Not sending to {}", maskPhone(phoneNumber));
            return false;
        }

        String normalized = normalizePhone(phoneNumber);
        if (normalized == null) {
            logger.error("Invalid phone number for SMS: {}", maskPhone(phoneNumber));
            return false;
        }

        String provider = resolveProvider();
        if (provider.isEmpty()) {
            logger.error("SMS enabled but provider/credentials are not configured");
            return false;
        }

        try {
            logger.info("Sending SOS SMS via {} to {}", provider, maskPhone(normalized));
            return switch (provider) {
                case "twilio" -> sendViaTwilio(toE164(normalized), message);
                case "msg91" -> sendViaMsg91(toDigits(normalized), message);
                default -> {
                    logger.error("Unknown SMS provider: {}", provider);
                    yield false;
                }
            };
        } catch (Exception e) {
            logger.error("Failed to send SMS to {}: {}", maskPhone(normalized), e.getMessage());
            return false;
        }
    }

    /**
     * Send SOS emergency SMS with accept/reject links.
     */
    public boolean sendSOSSMS(String phoneNumber, String userName, String mapsLink,
                              String acceptToken, String rejectToken, String baseUrl) {
        String safeBase = baseUrl == null ? "" : baseUrl.replaceAll("/$", "");
        String message = String.format(
                "EMERGENCY SOS: %s needs help. Location: %s Accept: %s/sos/respond?token=%s&action=accept Decline: %s/sos/respond?token=%s&action=reject",
                truncate(userName, 40),
                mapsLink,
                safeBase, acceptToken,
                safeBase, rejectToken
        );
        return sendSMS(phoneNumber, message);
    }

    private String resolveProvider() {
        if (smsProvider != null && !smsProvider.isBlank()
                && !"email".equalsIgnoreCase(smsProvider.trim())) {
            return smsProvider.trim().toLowerCase();
        }
        // Auto-pick when credentials exist
        if (!isBlank(twilioAccountSid) && !isBlank(twilioAuthToken) && !isBlank(twilioPhoneNumber)) {
            return "twilio";
        }
        if (!isBlank(msg91AuthKey) && !isBlank(msg91SenderId)) {
            return "msg91";
        }
        return "";
    }

    private boolean sendViaTwilio(String e164Phone, String message) throws Exception {
        if (isBlank(twilioAccountSid) || isBlank(twilioAuthToken) || isBlank(twilioPhoneNumber)) {
            logger.error("Twilio credentials incomplete");
            return false;
        }

        String url = "https://api.twilio.com/2010-04-01/Accounts/" + twilioAccountSid + "/Messages.json";
        String formData = "From=" + urlEncode(twilioPhoneNumber)
                + "&To=" + urlEncode(e164Phone)
                + "&Body=" + urlEncode(message);

        HttpURLConnection connection = (HttpURLConnection) URI.create(url).toURL().openConnection();
        connection.setRequestMethod("POST");
        connection.setDoOutput(true);
        connection.setConnectTimeout(15000);
        connection.setReadTimeout(20000);
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        String auth = twilioAccountSid + ":" + twilioAuthToken;
        String encodedAuth = java.util.Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
        connection.setRequestProperty("Authorization", "Basic " + encodedAuth);

        try (OutputStream os = connection.getOutputStream()) {
            os.write(formData.getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = connection.getResponseCode();
        String body = readBody(responseCode >= 400 ? connection.getErrorStream() : connection.getInputStream());
        if (responseCode == 200 || responseCode == 201) {
            logger.info("Twilio accepted SMS to {}", maskPhone(e164Phone));
            return true;
        }
        logger.error("Twilio SMS failed ({}): {}", responseCode, truncate(body, 300));
        return false;
    }

    private boolean sendViaMsg91(String mobileDigits, String message) throws Exception {
        if (isBlank(msg91AuthKey) || isBlank(msg91SenderId)) {
            logger.error("Msg91 credentials incomplete");
            return false;
        }

        // Msg91 sendhttp (transactional) — real provider call, no simulated success
        String url = "https://api.msg91.com/api/sendhttp.php"
                + "?authkey=" + urlEncode(msg91AuthKey)
                + "&mobiles=" + urlEncode(mobileDigits)
                + "&message=" + urlEncode(message)
                + "&sender=" + urlEncode(msg91SenderId)
                + "&route=4"
                + "&country=" + urlEncode(defaultCountryCode);

        HttpURLConnection connection = (HttpURLConnection) URI.create(url).toURL().openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(15000);
        connection.setReadTimeout(20000);

        int responseCode = connection.getResponseCode();
        String body = readBody(responseCode >= 400 ? connection.getErrorStream() : connection.getInputStream()).trim();

        // Msg91 returns a request id on success; error codes are short numeric strings
        if (responseCode == 200 && body.length() > 8 && !body.toLowerCase().contains("error")) {
            logger.info("Msg91 accepted SMS to {} (id={})", maskPhone(mobileDigits), truncate(body, 40));
            return true;
        }
        logger.error("Msg91 SMS failed ({}): {}", responseCode, truncate(body, 300));
        return false;
    }

    /**
     * Normalize to digits with country code when possible. Returns null if unusable.
     */
    String normalizePhone(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String digits = raw.replaceAll("[^0-9+]", "");
        if (digits.startsWith("+")) {
            digits = digits.substring(1).replaceAll("[^0-9]", "");
        } else {
            digits = digits.replaceAll("[^0-9]", "");
        }
        if (digits.length() == 10) {
            digits = defaultCountryCode + digits;
        }
        if (digits.length() < 10 || digits.length() > 15) {
            return null;
        }
        return digits;
    }

    private String toE164(String digitsWithCountry) {
        return "+" + digitsWithCountry;
    }

    private String toDigits(String digitsWithCountry) {
        return digitsWithCountry;
    }

    private static String readBody(InputStream stream) {
        if (stream == null) {
            return "";
        }
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            return reader.lines().collect(Collectors.joining("\n"));
        } catch (Exception e) {
            return "";
        }
    }

    private static String urlEncode(String value) throws Exception {
        return java.net.URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

    private static String truncate(String s, int max) {
        if (s == null) return "";
        return s.length() <= max ? s : s.substring(0, max) + "...";
    }

    private static String maskPhone(String phone) {
        if (phone == null || phone.length() < 4) return "****";
        return "****" + phone.substring(phone.length() - 4);
    }
}
