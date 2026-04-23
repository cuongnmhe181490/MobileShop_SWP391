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

        StringBuilder errors = new StringBuilder();
        
        if (idSupplier == null || idSupplier.isEmpty()) {
            errors.append("Mã thương hiệu không được để trống. ");
        } else if (dao.checkIdSupplierExist(idSupplier)) {
            errors.append("Mã thương hiệu đã tồn tại. ");
        }

        if (name == null || name.isEmpty()) {
            errors.append("Tên thương hiệu không được để trống. ");
        } else if (name.length() < 2 || name.length() > 100) {
            errors.append("Tên thương hiệu phải từ 2-100 ký tự. ");
        } else if (dao.checkSupplierNameExist(name)) {
            errors.append("Tên thương hiệu này đã tồn tại trong hệ thống. ");
        }

        if (email == null || email.isEmpty()) {
            errors.append("Email không được để trống. ");
        }

        // Handle File Upload
        Part filePart = request.getPart("logoFile");
        String logoPath = null;

        if (filePart == null || filePart.getSize() <= 0) {
            errors.append("Vui lòng chọn logo thương hiệu. ");
        } else {
            if (filePart.getSize() > 500 * 1024) {
                errors.append("Logo quá lớn! Vui lòng chọn file dưới 500KB. ");
            } else {
                logoPath = CloudinaryUtil.upload(filePart);
                if (logoPath == null) {
                    errors.append("Lỗi tải logo lên Cloudinary. ");
                }
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("brand_config/config-brand-add.jsp").forward(request, response);
            return;
        }

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