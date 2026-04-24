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

    public static String upload(Part filePart) {
        return uploadImage(filePart, 0, 0, null);
    }

    /**
     * Upload with transformation (Resize/Crop)
     */
    public static String upload(Part filePart, int width, int height, String cropMode) {
        return uploadImage(filePart, width, height, cropMode);
    }

    private static String uploadImage(Part filePart, int width, int height, String cropMode) {
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

            // Transformation options
            Map params = ObjectUtils.emptyMap();
            if (width > 0 && height > 0) {
                params = ObjectUtils.asMap(
                    "transformation", new com.cloudinary.Transformation()
                        .width(width)
                        .height(height)
                        .crop(cropMode != null ? cropMode : "fill")
                        .gravity("center")
                );
            }

            @SuppressWarnings("rawtypes")
            Map uploadResult = cloudinary.uploader().upload(tempFile, params);
            Object secureUrl = uploadResult.get("secure_url");
            return secureUrl == null ? null : secureUrl.toString();
        } catch (Exception e) {
            e.printStackTrace();
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

