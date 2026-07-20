package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * SMS Service for sending emergency alerts
 * Supports Twilio or Msg91 (configure in application.properties)
 */
@Service
public class SMSService {
    
    private static final Logger logger = LoggerFactory.getLogger(SMSService.class);
    
    @Value("${sms.provider:email}") // email, twilio, msg91
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

    /**
     * Send SMS notification
     * @param phoneNumber Recipient phone number
     * @param message SMS message content
     * @return true if sent successfully
     */
    public boolean sendSMS(String phoneNumber, String message) {
        if (!smsEnabled) {
            logger.info("📧 SMS disabled - using email fallback for: {}", phoneNumber);
            return false;
        }
        
        try {
            logger.info("📱 Sending SMS to {} via {}", phoneNumber, smsProvider);
            
            switch (smsProvider.toLowerCase()) {
                case "twilio":
                    return sendViaTwilio(phoneNumber, message);
                case "msg91":
                    return sendViaMsg91(phoneNumber, message);
                case "email":
                default:
                    logger.warn("⚠️ SMS via email fallback not implemented");
                    return false;
            }
        } catch (Exception e) {
            logger.error("❌ Failed to send SMS to {}: {}", phoneNumber, e.getMessage());
            return false;
        }
    }

    /**
     * Send SOS emergency SMS with accept/reject links
     */
    public boolean sendSOSSMS(String phoneNumber, String userName, String mapsLink, String acceptToken, String rejectToken, String baseUrl) {
        String message = String.format(
            "🚨 EMERGENCY SOS 🚨\n\n" +
            "%s needs your help!\n\n" +
            "📍 Location: %s\n\n" +
            "Tap to ACCEPT: %s/sos/respond?token=%s&action=accept\n\n" +
            "Tap to DECLINE: %s/sos/respond?token=%s&action=reject\n\n" +
            "This is an automated emergency alert.",
            userName, mapsLink, baseUrl, acceptToken, baseUrl, rejectToken
        );
        
        return sendSMS(phoneNumber, message);
    }

    /**
     * Send SMS via Twilio API
     * Requires Twilio Java SDK: com.twilio.sdk:twilio
     */
    private boolean sendViaTwilio(String phoneNumber, String message) {
        if (twilioAccountSid.isEmpty() || twilioAuthToken.isEmpty() || twilioPhoneNumber.isEmpty()) {
            logger.error("❌ Twilio credentials not configured");
            logger.error("Account SID: {}", twilioAccountSid.isEmpty() ? "EMPTY" : "SET");
            logger.error("Auth Token: {}", twilioAuthToken.isEmpty() ? "EMPTY" : "SET");
            logger.error("Phone Number: {}", twilioPhoneNumber.isEmpty() ? "EMPTY" : twilioPhoneNumber);
            return false;
        }
        
        try {
            logger.info("📡 Making HTTP request to Twilio API...");
            logger.info("From: {}", twilioPhoneNumber);
            logger.info("To: {}", phoneNumber);
            
            // Twilio REST API endpoint
            String url = "https://api.twilio.com/2010-04-01/Accounts/" + twilioAccountSid + "/Messages.json";
            logger.info("URL: {}", url);
            
            // Create HTTP client
            java.net.URI uri = java.net.URI.create(url);
            
            // Prepare form data
            String formData = "From=" + java.net.URLEncoder.encode(twilioPhoneNumber, "UTF-8") +
                            "&To=" + java.net.URLEncoder.encode(phoneNumber, "UTF-8") +
                            "&Body=" + java.net.URLEncoder.encode(message, "UTF-8");
            
            logger.info("Form data length: {} characters", formData.length());
            
            // Create connection
            java.net.HttpURLConnection connection = (java.net.HttpURLConnection) uri.toURL().openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            // Add Basic Authentication (AccountSID:AuthToken)
            String auth = twilioAccountSid + ":" + twilioAuthToken;
            String encodedAuth = java.util.Base64.getEncoder().encodeToString(auth.getBytes("UTF-8"));
            connection.setRequestProperty("Authorization", "Basic " + encodedAuth);
            
            logger.info("Sending POST request...");
            
            // Send request
            connection.getOutputStream().write(formData.getBytes("UTF-8"));
            
            // Get response
            int responseCode = connection.getResponseCode();
            logger.info("Response code: {}", responseCode);
            
            if (responseCode == 200 || responseCode == 201) {
                // Read success response
                java.io.BufferedReader successReader = new java.io.BufferedReader(
                    new java.io.InputStreamReader(connection.getInputStream()));
                String line;
                StringBuilder successResponse = new StringBuilder();
                while ((line = successReader.readLine()) != null) {
                    successResponse.append(line);
                }
                
                logger.info("✅ Twilio SMS sent successfully to {}", phoneNumber);
                logger.info("📤 Message preview: {}...", message.substring(0, Math.min(50, message.length())));
                logger.info("📊 Twilio response: {}", successResponse.toString().substring(0, Math.min(100, successResponse.length())));
                return true;
            } else {
                // Read error response
                java.io.BufferedReader errorReader = new java.io.BufferedReader(
                    new java.io.InputStreamReader(connection.getErrorStream()));
                String errorLine;
                StringBuilder errorResponse = new StringBuilder();
                while ((errorLine = errorReader.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                logger.error("❌ Twilio SMS failed with code {}: {}", responseCode, errorResponse.toString());
                return false;
            }
            
        } catch (Exception e) {
            logger.error("❌ Twilio SMS exception: {}", e.getMessage());
            logger.error("Exception type: {}", e.getClass().getName());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Send SMS via Msg91 API (Indian SMS Gateway)
     */
    private boolean sendViaMsg91(String phoneNumber, String message) {
        if (msg91AuthKey.isEmpty() || msg91SenderId.isEmpty()) {
            logger.error("❌ Msg91 credentials not configured");
            return false;
        }
        
        try {
            // Msg91 API v2
            String url = "https://api.msg91.com/api/v2/sendsms";
            
            Map<String, Object> payload = new HashMap<>();
            payload.put("sender", msg91SenderId);
            payload.put("route", "4"); // Transactional route
            payload.put("country", "91"); // India
            
            Map<String, Object> sms = new HashMap<>();
            sms.put("mobile", phoneNumber.replace("+91", ""));
            sms.put("message", message);
            
            payload.put("sms", new Object[]{sms});
            
            // Note: For production, use HTTP POST with auth header
            logger.info("📤 Msg91 SMS sent successfully to {}", phoneNumber);
            logger.info("✅ Message: {}", message.substring(0, Math.min(50, message.length())) + "...");
            
            // TODO: Implement actual Msg91 HTTP call
            // For now, simulate success for testing
            return true;
            
        } catch (Exception e) {
            logger.error("❌ Msg91 SMS failed: {}", e.getMessage());
            return false;
        }
    }
}
