package controller;

import config.DBContext;
import dao.HeroBannerDAO;
import entity.HeroBanner;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet xử lý thêm mới Hero Banner.
 *
 * GET  /HeroAddServlet → hiển thị form thêm (config-hero-add.jsp)
 *                        kèm satisfactionRate và productCount tính LIVE từ DB
 * POST /HeroAddServlet → lưu banner rồi redirect về AdminHomeConfigServlet
 */
@WebServlet(name = "HeroAddServlet", urlPatterns = {"/HeroAddServlet"})
public class HeroAddServlet extends HttpServlet {

    private final HeroBannerDAO dao = new HeroBannerDAO();

    // ── GET: mở form thêm, truyền live stats ──────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tính LIVE từ DB, không fix cứng
        request.setAttribute("satisfactionRate", getLiveSatisfactionRate());
        request.setAttribute("productCount", getLiveProductCount());

        request.getRequestDispatcher("/config-hero-add.jsp").forward(request, response);
    }

    // ── POST: lưu banner mới ──────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Đọc các trường từ form
        String eyebrow      = trim(request.getParameter("eyebrow"));
        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String ctaPrimary   = trim(request.getParameter("ctaPrimary"));
        String ctaSecondary = trim(request.getParameter("ctaSecondary"));
        String imageUrl     = trim(request.getParameter("imageUrl"));
        String stat2 = trim(request.getParameter("stat2")); // Thời gian phản hồi – admin nhập
        // stat1 (điểm hài lòng) và stat3 (số mẫu máy) KHÔNG lưu cố định vào DB
        // Giá trị luôn được tính LIVE từ DB khi cần hiển thị (AVG/COUNT)

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
        // Thời gian phản hồi: bắt buộc, tối đa 20 ký tự
        if (stat2 == null || stat2.isEmpty()) {
            errors.append("Thời gian phản hồi không được để trống. ");
        } else if (stat2.length() > 20) {
            errors.append("Thời gian phản hồi tối đa 20 ký tự. ");
        }

        // Nếu có lỗi
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("satisfactionRate", getLiveSatisfactionRate());
            request.setAttribute("productCount", getLiveProductCount());
            request.getRequestDispatcher("/config-hero-add.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng banner
        HeroBanner banner = new HeroBanner();
        banner.setEyebrow(eyebrow);
        banner.setTitle(title);
        banner.setDescription(description);
        banner.setCtaPrimary(ctaPrimary);
        banner.setCtaSecondary(ctaSecondary);
        banner.setImageUrl(imageUrl);
        banner.setStat1Label(null);  // Không lưu cố định – tính live từ AVG(Ranking)
        banner.setStat2Label(stat2);
        banner.setStat3Label(null);  // Không lưu cố định – tính live từ COUNT(*)
        banner.setActive(true);     // Banner mới mặc định active

        boolean success = false;
        try {
            success = dao.insert(banner);
        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flashSuccess", "Thêm Hero banner thành công!");
        } else {
            session.setAttribute("flashError", "Thêm Hero banner thất bại. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminHomeConfigServlet");
    }

    /**
     * Tính điểm hài lòng trung bình LIVE từ bảng ProductReview.
     * Yêu cầu giáo viên: AVG(Ranking), không fix cứng.
     */
    private String getLiveSatisfactionRate() {
        String sql = "SELECT AVG(CAST(Ranking AS FLOAT)) AS Average FROM ProductReview";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double avg = rs.getDouble("Average");
                if (avg > 0) {
                    return String.format("%.1f/5", avg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "0.0/5";
    }

    /**
     * Đếm tổng số sản phẩm LIVE từ bảng ProductDetail.
     * Yêu cầu giáo viên: COUNT(*), không fix số 30.
     */
    private int getLiveProductCount() {
        String sql = "SELECT COUNT(*) FROM ProductDetail";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Null-safe trim */
    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}