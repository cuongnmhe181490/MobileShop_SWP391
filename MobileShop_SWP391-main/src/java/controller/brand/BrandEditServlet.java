package controller.brand;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.List;
import dao.SupplierDAO;
import entity.Supplier;
import jakarta.servlet.annotation.MultipartConfig;
import util.CloudinaryUtil;

@WebServlet(name = "BrandEditServlet", urlPatterns = {"/BrandEditServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15   // 15MB
)

public class BrandEditServlet extends HttpServlet {

    private final SupplierDAO dao = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Supplier> brands = dao.getAllSuppliers();
        request.setAttribute("brands", brands);

        String idParam = request.getParameter("id");
        Supplier selected = null;
        if (idParam != null && !idParam.isEmpty()) {
            selected = dao.getSupplierById(idParam);
        }
        
        if (selected == null && !brands.isEmpty()) {
            selected = brands.get(0);
        }

        request.setAttribute("brand", selected);
        request.getRequestDispatcher("brand_config/config-brand-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idSupplier = request.getParameter("idSupplier");
        if (idSupplier == null || idSupplier.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BrandListServlet");
            return;
        }

        Supplier oldSupplier = dao.getSupplierById(idSupplier);
        if (oldSupplier == null) {
            response.sendRedirect(request.getContextPath() + "/BrandListServlet");
            return;
        }

        String name = trim(request.getParameter("name"));
        String address = trim(request.getParameter("address"));
        String email = trim(request.getParameter("email"));
        String phoneNumber = trim(request.getParameter("phoneNumber"));

        StringBuilder errors = new StringBuilder();
        
        if (name == null || name.isEmpty()) {
            errors.append("Tên thương hiệu không được để trống. ");
        }

        if (email == null || email.isEmpty()) {
            errors.append("Email không được để trống. ");
        }

        // Handle File Upload (Optional)
        Part filePart = request.getPart("logoFile");
        String logoPath = oldSupplier.getLogoPath(); // Default to old

        if (filePart != null && filePart.getSize() > 0) {
            if (filePart.getSize() > 500 * 1024) {
                errors.append("Logo quá lớn! Vui lòng chọn file dưới 500KB. ");
            } else {
                String uploadedUrl = CloudinaryUtil.upload(filePart);
                if (uploadedUrl != null) {
                    logoPath = uploadedUrl;
                } else {
                    errors.append("Lỗi tải logo lên Cloudinary. ");
                }
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("brands", dao.getAllSuppliers());
            request.setAttribute("brand", oldSupplier);
            request.getRequestDispatcher("brand_config/config-brand-edit.jsp").forward(request, response);
            return;
        }

        Supplier updated = new Supplier(idSupplier, name, address, email, phoneNumber, logoPath);
        boolean success = dao.updateSupplier(updated);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flashSuccess", "Cập nhật thương hiệu thành công!");
        } else {
            session.setAttribute("flashError", "Cập nhật thương hiệu thất bại.");
        }

        response.sendRedirect(request.getContextPath() + "/BrandListServlet");
    }


    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}