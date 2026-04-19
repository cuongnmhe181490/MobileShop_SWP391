package controller; // Tên package của bạn

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import config.CloudinaryConfig; // Import class config bạn đã tạo trước đó

@WebServlet("/UploadHandler")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class UploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 1. Lấy file từ thẻ <input type="file" name="file"> ở JSP
            Part filePart = request.getPart("file"); 
            if (filePart == null || filePart.getSize() == 0) {
                response.getWriter().println("Chưa chọn file!");
                return;
            }
            
            // 2. Chuyển file thành mảng byte
            byte[] data = filePart.getInputStream().readAllBytes();
            
            // 3. Upload lên Cloudinary
            Cloudinary cloudinary = CloudinaryConfig.getCloudinary();
            Map uploadResult = cloudinary.uploader().upload(data, ObjectUtils.emptyMap());
            
            // 4. Lấy Link URL trả về
            String url = (String) uploadResult.get("secure_url");
            
            // 5. In ra test thử (sau này bạn viết lệnh INSERT SQL vào đây)
            System.out.println("Upload thành công! URL: " + url);
            response.getWriter().println("Thanh cong! Link: " + url);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Loi: " + e.getMessage());
        }
    }
}