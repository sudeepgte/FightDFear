package in.sp.main.Util;

import org.springframework.web.util.HtmlUtils;

/**
 * Strips markup and HTML-escapes user-submitted form fields before persistence.
 */
public final class FormSanitizer {

    private FormSanitizer() {}

    public static String stripTags(String input) {
        if (input == null) {
            return "";
        }
        return input.replaceAll("(?i)<script[^>]*>.*?</script>", "")
                .replaceAll("<[^>]+>", "")
                .trim();
    }

    public static String sanitize(String input) {
        return HtmlUtils.htmlEscape(stripTags(input));
    }
}
