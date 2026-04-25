package controller.hero;

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
import config.DBContext;
import dao.HeroBannerDAO;
import entity.HeroBanner;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import util.CloudinaryUtil;

@WebServlet(name = "HeroAddServlet", urlPatterns = {"/HeroAddServlet"})

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15   // 15MB
)
public class HeroAddServlet extends HttpServlet {

    private final HeroBannerDAO dao = new HeroBannerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("satisfactionRate", getLiveSatisfactionRate());
        request.setAttribute("productCount", getLiveProductCount());
        request.getRequestDispatcher("hero_config/config-hero-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String eyebrow      = trim(request.getParameter("eyebrow"));
        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String ctaPrimary   = trim(request.getParameter("ctaPrimary"));
        String ctaSecondary = trim(request.getParameter("ctaSecondary"));
        String stat2        = trim(request.getParameter("stat2"));

        StringBuilder errors = new StringBuilder();
        
        if (title == null || title.isEmpty()) {
            errors.append("Tiêu đề không được để trống. ");
        } else if (title.length() < 5 || title.length() > 120) {
            errors.append("Tiêu đề phải từ 5-120 ký tự. ");
        }

        if (ctaPrimary == null || ctaPrimary.isEmpty()) {
            errors.append("CTA chính không được để trống. ");
        } else if (ctaPrimary.length() > 30) {
            errors.append("CTA chính tối đa 30 ký tự. ");
        }

        if (description == null || description.isEmpty()) {
            errors.append("Mô tả ngắn không được để trống. ");
        } else if (description.length() > 300) {
            errors.append("Mô tả tối đa 300 ký tự. ");
        }
        
        if (stat2 == null || stat2.isEmpty()) {
            errors.append("Thời gian phản hồi không được để trống. ");
        }

        // Xử lý File Upload
        Part filePart = request.getPart("imageFile");
        String imageUrl = null;

        if (filePart == null || filePart.getSize() == 0) {
            errors.append("Vui lòng chọn ảnh visual. ");
        } else {
            // Validate size (500 KB)
            if (filePart.getSize() > 500 * 1024) {
                errors.append("Kích thước ảnh vượt quá giới hạn 500 KB. ");
            } else {
                // Upload to Cloudinary
                imageUrl = CloudinaryUtil.upload(filePart);
                if (imageUrl == null) {
                    errors.append("Lỗi tải ảnh lên Cloudinary. ");
                }
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("satisfactionRate", getLiveSatisfactionRate());
            request.setAttribute("productCount", getLiveProductCount());
            request.getRequestDispatcher("hero_config/config-hero-add.jsp").forward(request, response);
            return;
        }

        HeroBanner banner = new HeroBanner();
        banner.setEyebrow(eyebrow);
        banner.setTitle(title);
        banner.setDescription(description);
        banner.setCtaPrimary(ctaPrimary);
        banner.setCtaSecondary(ctaSecondary);
        banner.setImageUrl(imageUrl);
        banner.setStat1Label(null);
        banner.setStat2Label(stat2);
        banner.setStat3Label(null);
        banner.setActive(true);

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
            session.setAttribute("flashError", "Thêm Hero banner thất bại.");
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