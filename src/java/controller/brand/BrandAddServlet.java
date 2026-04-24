package controller.brand;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import dao.SupplierDAO;
import entity.Supplier;
import jakarta.servlet.annotation.MultipartConfig;
import java.util.Map;
import util.CloudinaryUtil;

@WebServlet(name = "BrandAddServlet", urlPatterns = {"/BrandAddServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15   // 15MB
)

public class BrandAddServlet extends HttpServlet {

    private final SupplierDAO dao = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("brand_config/config-brand-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idSupplier = trim(request.getParameter("idSupplier"));
        String name = trim(request.getParameter("name"));
        String address = trim(request.getParameter("address"));
        String email = trim(request.getParameter("email"));
        String phoneNumber = trim(request.getParameter("phoneNumber"));

        Map<String, String> errors = new java.util.HashMap<>();
        
        if (idSupplier == null || idSupplier.isBlank()) {
            errors.put("idSupplier", "Mã thương hiệu không được để trống.");
        } else if (dao.checkIdSupplierExist(idSupplier)) {
            errors.put("idSupplier", "Mã thương hiệu đã tồn tại.");
        }

        if (name == null || name.isBlank()) {
            errors.put("name", "Tên thương hiệu không được để trống.");
        } else if (name.length() < 2 || name.length() > 100) {
            errors.put("name", "Tên thương hiệu phải từ 2-100 ký tự.");
        } else if (dao.checkSupplierNameExist(name)) {
            errors.put("name", "Tên thương hiệu đã tồn tại.");
        }

        if (email == null || email.isBlank()) {
            errors.put("email", "Email không được để trống.");
        } else if (email.length() > 100) {
            errors.put("email", "Email tối đa 100 ký tự.");
        } else if (!util.ValidationUtil.isValidEmail(email)) {
            errors.put("email", "Định dạng email không hợp lệ.");
        }

        if (phoneNumber != null && !phoneNumber.isBlank()) {
            if (phoneNumber.length() > 15) {
                errors.put("phoneNumber", "Số điện thoại tối đa 15 ký tự.");
            } else if (!util.ValidationUtil.isValidPhone(phoneNumber)) {
                errors.put("phoneNumber", "Số điện thoại không hợp lệ.");
            }
        }

        if (address != null && address.length() > 255) {
            errors.put("address", "Địa chỉ tối đa 255 ký tự.");
        }

        // Handle File Upload
        Part filePart = request.getPart("logoFile");
        String logoPath = null;

        if (filePart == null || filePart.getSize() <= 0) {
            errors.put("logoFile", "Vui lòng chọn logo thương hiệu.");
        } else {
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                errors.put("logoFile", "File logo không hợp lệ.");
            } else if (filePart.getSize() > 500 * 1024) {
                errors.put("logoFile", "Logo quá lớn! Vui lòng chọn file dưới 500KB.");
            } else {
                logoPath = CloudinaryUtil.upload(filePart, 400, 400, "fill");
                if (logoPath == null) {
                    errors.put("logoFile", "Lỗi tải logo lên Cloudinary.");
                }
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("supplier", new Supplier(idSupplier, name, address, email, phoneNumber, logoPath));
            request.getRequestDispatcher("brand_config/config-brand-add.jsp").forward(request, response);
            return;
        }

        // Sanitization
        name = util.ValidationUtil.escapeHtml(name);
        address = util.ValidationUtil.escapeHtml(address);
        email = util.ValidationUtil.escapeHtml(email);
        phoneNumber = util.ValidationUtil.escapeHtml(phoneNumber);

        Supplier s = new Supplier(idSupplier, name, address, email, phoneNumber, logoPath);
        boolean success = dao.insertSupplier(s);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flashSuccess", "Thêm thương hiệu thành công!");
        } else {
            session.setAttribute("flashError", "Thêm thương hiệu thất bại. Kiểm tra ID hoặc Email trùng lặp.");
        }

        response.sendRedirect(request.getContextPath() + "/BrandListServlet");
    }


    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}