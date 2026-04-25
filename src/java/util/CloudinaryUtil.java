package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryUtil {

    private CloudinaryUtil() {
    }


    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "dovcx8lxl",
            "api_key", "686417178596178",
            "api_secret", "wgqV0cS4ia7kjW8fNJ-n21216hc",
            "secure", true
    ));

    /**
     * Hàm xử lý upload file từ Servlet Part lên Cloudinary
     * @param filePart Đối tượng Part nhận từ request.getPart()
     * @return String URL của ảnh sau khi upload thành công, hoặc null nếu lỗi
     */

    public static String upload(Part filePart) {
        return uploadImage(filePart);
    }

    public static String uploadImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        Cloudinary cloudinary = buildClient();
        if (cloudinary == null) {
            return null;
        }

        File tempFile = null;
        try {
            String fileName = filePart.getSubmittedFileName();
            tempFile = File.createTempFile("mobileshop-upload-", sanitizeExtension(fileName));

            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(tempFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            @SuppressWarnings("rawtypes")
            Map uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());
            Object secureUrl = uploadResult.get("secure_url");
            return secureUrl == null ? null : secureUrl.toString();
        } catch (Exception e) {
            return null;
        } finally {
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
        }
    }

    private static Cloudinary buildClient() {
        String cloudName = readSetting("CLOUDINARY_NAME");
        String apiKey = readSetting("CLOUDINARY_API_KEY");
        String apiSecret = readSetting("CLOUDINARY_API_SECRET");
        if (isBlank(cloudName) || isBlank(apiKey) || isBlank(apiSecret)) {
            return null;
        }
        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true
        ));
    }

    private static String readSetting(String key) {
        String value = System.getenv(key);
        if (isBlank(value)) {
            value = System.getProperty(key);
        }
        return isBlank(value) ? null : value.trim();
    }

    private static String sanitizeExtension(String fileName) {
        if (isBlank(fileName)) {
            return ".tmp";
        }
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return ".tmp";
        }
        return fileName.substring(dotIndex);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

