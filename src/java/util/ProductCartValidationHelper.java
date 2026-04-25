package util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Locale;

public final class ProductCartValidationHelper {

    public static final int PRODUCT_NAME_MIN = 2;
    public static final int PRODUCT_NAME_MAX = 200;
    public static final int SCREEN_MAX = 200;
    public static final int OPERATING_SYSTEM_MAX = 100;
    public static final int CPU_MAX = 100;
    public static final int RAM_MAX = 50;
    public static final int CAMERA_MAX = 200;
    public static final int BATTERY_MAX_DIGITS = 5;
    public static final int DESCRIPTION_MAX = 2000;
    public static final int SEARCH_MAX = 100;
    public static final long MAX_IMAGE_SIZE = 500L * 1024L;

    private ProductCartValidationHelper() {
    }

    public static String validateProductName(String value) {
        String normalized = normalize(value);
        if (normalized.isEmpty()) {
            return "Tên sản phẩm không được để trống.";
        }
        if (normalized.length() < PRODUCT_NAME_MIN) {
            return "Tên sản phẩm phải có ít nhất 2 ký tự.";
        }
        if (normalized.length() > PRODUCT_NAME_MAX) {
            return "Tên sản phẩm tối đa 200 ký tự.";
        }
        return null;
    }

    public static String validatePriceRaw(String value) {
        String normalized = normalize(value);
        if (normalized.isEmpty()) {
            return "Giá không được để trống.";
        }
        if (!normalized.matches("[0-9]+")) {
            return "Giá phải là số nguyên dương hợp lệ.";
        }
        if (normalized.length() > 1 && normalized.startsWith("0")) {
            return "Giá không được bắt đầu bằng số 0.";
        }
        try {
            long parsed = Long.parseLong(normalized);
            if (parsed <= 0) {
                return "Giá phải lớn hơn 0.";
            }
        } catch (NumberFormatException ex) {
            return "Giá phải là số nguyên dương hợp lệ.";
        }
        return null;
    }

    public static String validateCurrentQuantityRaw(String value) {
        String normalized = normalize(value);
        if (normalized.isEmpty()) {
            return "Số lượng không được để trống.";
        }
        if (!normalized.matches("-?[0-9]+")) {
            return "Số lượng phải là số nguyên hợp lệ.";
        }
        try {
            int parsed = Integer.parseInt(normalized);
            if (parsed < 0) {
                return "Số lượng phải là số nguyên lớn hơn hoặc bằng 0.";
            }
        } catch (NumberFormatException ex) {
            return "Số lượng phải là số nguyên hợp lệ.";
        }
        return null;
    }

    public static String validateReleaseDate(String value) {
        String normalized = normalize(value);
        if (normalized.isEmpty()) {
            return null;
        }
        try {
            LocalDate releaseDate = LocalDate.parse(normalized);
            if (releaseDate.isAfter(LocalDate.now())) {
                return "Ngày ra mắt không được lớn hơn ngày hiện tại.";
            }
        } catch (DateTimeParseException ex) {
            return "Ngày ra mắt không hợp lệ.";
        }
        return null;
    }

    public static String validateBattery(String value, boolean required) {
        String normalized = normalize(value);
        if (normalized.isEmpty()) {
            return required ? "Pin không được để trống." : null;
        }
        if (!normalized.matches("[0-9]+")) {
            return "Pin phải là giá trị số hợp lệ.";
        }
        if (normalized.length() > 1 && normalized.startsWith("0")) {
            return "Pin không được bắt đầu bằng số 0.";
        }
        if (normalized.length() > BATTERY_MAX_DIGITS) {
            return "Pin tối đa 5 chữ số.";
        }
        try {
            int parsed = Integer.parseInt(normalized);
            if (parsed <= 0) {
                return "Pin phải lớn hơn 0.";
            }
        } catch (NumberFormatException ex) {
            return "Pin phải là giá trị số hợp lệ.";
        }
        return null;
    }

    public static String validateTrimmedOptional(String value, int maxLength, String requiredMessage, String maxMessage) {
        String normalized = normalize(value);
        if (requiredMessage != null && normalized.isEmpty()) {
            return requiredMessage;
        }
        if (normalized.length() > maxLength) {
            return maxMessage;
        }
        return null;
    }

    public static String validateSearchKeyword(String value) {
        String normalized = normalize(value);
        if (normalized.length() > SEARCH_MAX) {
            return "Từ khóa tìm kiếm tối đa 100 ký tự.";
        }
        return null;
    }

    public static String validateImageUpload(String contentType, long size) {
        if (contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
            return "Tệp tải lên phải là ảnh hợp lệ.";
        }
        if (size > MAX_IMAGE_SIZE) {
            return "Ảnh tải lên không được vượt quá 500KB.";
        }
        return null;
    }

    private static String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
