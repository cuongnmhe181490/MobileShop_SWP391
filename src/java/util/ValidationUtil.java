package util;

/**
 * Utility class for common validation and sanitization tasks.
 */
public class ValidationUtil {

    /**
     * Escape HTML characters to prevent XSS.
     */
    public static String escapeHtml(String content) {
        if (content == null) return null;
        return content.replace("&", "&amp;")
                      .replace("<", "&lt;")
                      .replace(">", "&gt;")
                      .replace("\"", "&quot;")
                      .replace("'", "&#x27;");
    }

    /**
     * Simple email format validation.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        String regex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";
        return email.matches(regex);
    }

    /**
     * Simple phone number validation (digits and + only).
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) return true; // Optional field
        return phone.matches("^[\\d +()]{7,20}$");
    }
}
