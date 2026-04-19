package controller;

import dao.CartDao;
import entity.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý chỉnh sửa Brand (Category).
 *
 * GET  /BrandEditServlet          → load danh sách brand + brand đang chọn vào form
 * GET  /BrandEditServlet?id=N     → load brand có id=N vào form để sửa
 * POST /BrandEditServlet          → cập nhật brand rồi redirect về AdminHomeConfigServlet
 */
@WebServlet(name = "BrandEditServlet", urlPatterns = {"/BrandEditServlet"})
public class BrandEditServlet extends HttpServlet {

    private final CartDao dao = new CartDao();

    // ── GET: hiển thị form sửa ────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách tất cả brand để hiển thị dropdown chọn
        List<Category> brands = dao.getAllCategories();
        request.setAttribute("brands", brands);

        // Nếu có param id thì load brand đó; không thì lấy brand mới nhất
        Category selected = null;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                selected = dao.getCategoryById(Integer.parseInt(idParam));
            } catch (Exception ignored) {}
        }
        // Nếu không có id hoặc id không tìm thấy → lấy brand mới nhất
        if (selected == null) {
            selected = dao.getLatestCategory();
        }

        request.setAttribute("brand", selected);
        request.getRequestDispatcher("/config-brand-edit.jsp").forward(request, response);
    }

    // ── POST: lưu chỉnh sửa ──────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BrandEditServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/BrandEditServlet");
            return;
        }

        String name = trim(request.getParameter("name"));
        String imagePath = trim(request.getParameter("imagePath"));

        // Validation đầy đủ
        StringBuilder errors = new StringBuilder();
        
        if (name == null || name.isEmpty()) {
            errors.append("Tên thương hiệu không được để trống. ");
        } else if (name.length() < 2 || name.length() > 100) {
            errors.append("Tên thương hiệu phải từ 2-100 ký tự. ");
        } else if (!name.matches("^[A-Za-z0-9À-ỹ\\s\\-_]+$")) {
            errors.append("Tên thương hiệu không được chứa ký tự đặc biệt. ");
        }

        if (imagePath == null || imagePath.isEmpty()) {
            errors.append("URL logo không được để trống. ");
        } else if (!imagePath.matches("(?i)^https?://.+\\.(jpg|jpeg|png|gif|svg|webp)(\\?.*)?$")) {
            errors.append("URL logo phải là đường dẫn hình ảnh hợp lệ (jpg, png, gif, svg, webp). ");
        }

        // Nếu có lỗi
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            List<Category> brands = dao.getAllCategories();
            request.setAttribute("brands", brands);
            Category current = dao.getCategoryById(id);
            request.setAttribute("brand", current);
            request.getRequestDispatcher("/config-brand-edit.jsp").forward(request, response);
            return;
        }

        boolean success = dao.updateCategory(id, name, imagePath);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flashSuccess", "Cập nhật Brand thành công!");
        } else {
            session.setAttribute("flashError", "Cập nhật Brand thất bại. Vui lòng thử lại.");
        }

        // ✅ Redirect về AdminHomeConfigServlet (giống HeroEditServlet)
        response.sendRedirect(request.getContextPath() + "/AdminHomeConfigServlet");
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}