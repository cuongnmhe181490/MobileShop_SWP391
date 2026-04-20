package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryUtil {

    private static final config.DBContext db = new config.DBContext();

    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", db.CLOUD_NAME,
            "api_key", db.CLOUD_API_KEY,
            "api_secret", db.CLOUD_API_SECRET,
            "secure", true
    ));

    /**
     * Hàm xử lý upload file từ Servlet Part lên Cloudinary
     * @param filePart Đối tượng Part nhận từ request.getPart()
     * @return String URL của ảnh sau khi upload thành công, hoặc null nếu lỗi
     */
    public static String upload(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        try {
            // Chuyển Part thành File tạm để upload
            String fileName = filePart.getSubmittedFileName();
            File tempFile = File.createTempFile("temp_upload_", fileName);
            
            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(tempFile)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            // Upload lên Cloudinary
            Map uploadResult = cloudinary.uploader().upload(tempFile, ObjectUtils.emptyMap());
            
            // Xóa file tạm sau khi upload xong
            tempFile.delete();

            // Trả về URL được bảo mật (https)
            return (String) uploadResult.get("secure_url");
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
