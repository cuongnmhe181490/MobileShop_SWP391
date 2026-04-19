package controller;

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
 * Servlet xử lý chỉnh sửa Hero Banner.
 *
 * GET  /HeroEditServlet          → load danh sách banner + banner đang chọn vào form
 * GET  /HeroEditServlet?id=N     → load banner có id=N vào form để sửa
 * POST /HeroEditServlet          → cập nhật banner rồi redirect về AdminHomeConfigServlet
 */
@WebServlet(name = "HeroEditServlet", urlPatterns = {"/HeroEditServlet"})
public class HeroEditServlet extends HttpServlet {

    private final HeroBannerDAO dao = new HeroBannerDAO();

    // ── GET: hiển thị form sửa ────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách tất cả banner để hiển thị dropdown chọn
        List<HeroBanner> banners = new ArrayList<>();
        try {
            banners = dao.getAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("banners", banners);

        // Nếu có param id thì load banner đó; không thì lấy banner active
        HeroBanner selected = null;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                selected = dao.getById(Integer.parseInt(idParam));
            } catch (Exception ignored) {}
        }
        if (selected == null) {
            try {
                selected = dao.getActiveBanner();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("hero", selected);
        request.getRequestDispatcher("/config-hero-edit.jsp").forward(request, response);
    }

    // ── POST: lưu chỉnh sửa ──────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/HeroEditServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/HeroEditServlet?id=");
            return;
        }

        String eyebrow      = trim(request.getParameter("eyebrow"));
        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String ctaPrimary   = trim(request.getParameter("ctaPrimary"));
        String ctaSecondary = trim(request.getParameter("ctaSecondary"));
        String imageUrl     = trim(request.getParameter("imageUrl"));
        String stat1        = trim(request.getParameter("stat1"));
        String stat2        = trim(request.getParameter("stat2"));
        String stat3        = trim(request.getParameter("stat3"));

        // Validation đầy đủ
        StringBuilder errors = new StringBuilder();
        
        // Title: bắt buộc, 5-120 ký tự
        if (title == null || title.isEmpty()) {
            errors.append("Tiêu đề không được để trống. ");
        } else if (title.length() < 5 || title.length() > 120) {
            errors.append("Tiêu đề phải từ 5-120 ký tự. ");
        }

        // CTA Primary: bắt buộc, max 30 ký tự
        if (ctaPrimary == null || ctaPrimary.isEmpty()) {
            errors.append("CTA chính không được để trống. ");
        } else if (ctaPrimary.length() > 30) {
            errors.append("CTA chính tối đa 30 ký tự. ");
        }

        // Optional fields: max length checks
        if (eyebrow != null && eyebrow.length() > 50) {
            errors.append("Nhãn phụ tối đa 50 ký tự. ");
        }
        if (ctaSecondary != null && ctaSecondary.length() > 30) {
            errors.append("CTA phụ tối đa 30 ký tự. ");
        }
        if (description == null || description.isEmpty()) {
            errors.append("Mô tả ngắn không được để trống. ");
        } else if (description.length() > 300) {
            errors.append("Mô tả tối đa 300 ký tự. ");
        }
        
        // Image URL: nếu nhập thì phải là URL hợp lệ
        if (imageUrl == null || imageUrl.isEmpty()) {
            errors.append("Ảnh visual không được để trống. ");
        } else if (!imageUrl.matches("(?i)^https?://.+\\.(jpg|jpeg|png|gif|webp|svg)(\\?.*)?$")) {
            errors.append("URL ảnh phải là đường dẫn hình ảnh hợp lệ (jpg, png, gif, webp, svg). ");
        }

        // Nếu có lỗi
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            List<HeroBanner> banners = new ArrayList<>();
            try { banners = dao.getAll(); } catch (Exception e) { e.printStackTrace(); }
            request.setAttribute("banners", banners);

            HeroBanner current = null;
            try { current = dao.getById(id); } catch (Exception e) { e.printStackTrace(); }
            request.setAttribute("hero", current);

            request.getRequestDispatcher("/config-hero-edit.jsp").forward(request, response);
            return;
        }

        HeroBanner banner = new HeroBanner();
        banner.setId(id);
        banner.setEyebrow(eyebrow);
        banner.setTitle(title);
        banner.setDescription(description);
        banner.setCtaPrimary(ctaPrimary);
        banner.setCtaSecondary(ctaSecondary);
        banner.setImageUrl(imageUrl);
        banner.setStat1Label(stat1);
        banner.setStat2Label(stat2);
        banner.setStat3Label(stat3);
        banner.setActive(true);

        boolean success = false;
        try {
            success = dao.update(banner);
        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flashSuccess", "Cập nhật Hero banner thành công!");
        } else {
            session.setAttribute("flashError", "Cập nhật Hero banner thất bại. Vui lòng thử lại.");
        }

        // ✅ Sửa: redirect về Servlet (không phải JSP trực tiếp)
        response.sendRedirect(request.getContextPath() + "/AdminHomeConfigServlet");
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}
