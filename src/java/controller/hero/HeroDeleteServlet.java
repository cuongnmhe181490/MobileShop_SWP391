package controller.hero;

import dao.HeroBannerDAO;
import entity.HeroBanner;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet xử lý xoá Hero Banner.
 *
 * GET  /HeroDeleteServlet        → load danh sách banner ra trang xác nhận
 * GET  /HeroDeleteServlet?id=N   → load banner N vào trang xác nhận xoá
 * POST /HeroDeleteServlet        → thực hiện xoá rồi redirect
 */
@WebServlet(name = "HeroDeleteServlet", urlPatterns = {"/HeroDeleteServlet"})
public class HeroDeleteServlet extends HttpServlet {

    private final HeroBannerDAO dao = new HeroBannerDAO();

    // ── GET: hiển thị trang xác nhận xoá ────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Truyền danh sách banner để admin chọn muốn xoá cái nào
        List<HeroBanner> banners = new ArrayList<>();
        try {
            banners = dao.getAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("banners", banners);

        // Nếu có id thì preselect banner đó
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                HeroBanner selected = dao.getById(Integer.parseInt(idParam));
                request.setAttribute("selectedHero", selected);
            } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("hero_config/config-hero-delete.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        HttpSession session = request.getSession();

        if (idStr == null || idStr.isEmpty()) {
            session.setAttribute("flashError", "Không tìm thấy banner cần xoá.");
            response.sendRedirect(request.getContextPath() + "/HeroDeleteServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "ID banner không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/HeroDeleteServlet");
            return;
        }

        boolean success = false;
        try {
            success = dao.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (success) {
            session.setAttribute("flashSuccess", "Xoá Hero banner thành công!");
        } else {
            session.setAttribute("flashError", "Xoá Hero banner thất bại. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminHomeConfigServlet");
    }
}
