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
import java.util.Map;
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

        Map<String, String> errors = new java.util.HashMap<>();
        
        if (eyebrow != null && eyebrow.length() > 50) {
            errors.put("eyebrow", "Nhãn phụ tối đa 50 ký tự.");
        }

        if (title == null || title.isBlank()) {
            errors.put("title", "Tiêu đề không được để trống.");
        } else if (title.length() < 5 || title.length() > 120) {
            errors.put("title", "Tiêu đề phải từ 5-120 ký tự.");
        }

        if (ctaPrimary == null || ctaPrimary.isBlank()) {
            errors.put("ctaPrimary", "CTA chính không được để trống.");
        } else if (ctaPrimary.length() > 30) {
            errors.put("ctaPrimary", "CTA chính tối đa 30 ký tự.");
        }

        if (ctaSecondary != null && ctaSecondary.length() > 30) {
            errors.put("ctaSecondary", "CTA phụ tối đa 30 ký tự.");
        }

        if (description == null || description.isBlank()) {
            errors.put("description", "Mô tả ngắn không được để trống.");
        } else if (description.length() > 300) {
            errors.put("description", "Mô tả tối đa 300 ký tự.");
        }
        
        if (stat2 == null || stat2.isBlank()) {
            errors.put("stat2", "Thời gian phản hồi không được để trống.");
        } else if (stat2.length() > 20) {
            errors.put("stat2", "Thời gian phản hồi tối đa 20 ký tự.");
        }

        // Xử lý File Upload
        Part filePart = request.getPart("imageFile");
        String imageUrl = null;

        if (filePart == null || filePart.getSize() == 0) {
            errors.put("imageFile", "Vui lòng chọn ảnh visual.");
        } else {
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                errors.put("imageFile", "Định dạng file không hợp lệ. Vui lòng chọn ảnh.");
            } else if (filePart.getSize() > 500 * 1024) {
                errors.put("imageFile", "Kích thước ảnh vượt quá giới hạn 500 KB.");
            } else {
                imageUrl = CloudinaryUtil.upload(filePart, 600, 800, "fill");
                if (imageUrl == null) {
                    errors.put("imageFile", "Lỗi tải ảnh lên Cloudinary.");
                }
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            HeroBanner tempHero = new HeroBanner();
            tempHero.setEyebrow(eyebrow);
            tempHero.setTitle(title);
            tempHero.setDescription(description);
            tempHero.setCtaPrimary(ctaPrimary);
            tempHero.setCtaSecondary(ctaSecondary);
            tempHero.setImageUrl(imageUrl);
            tempHero.setStat2Label(stat2);
            request.setAttribute("hero", tempHero);
            request.setAttribute("satisfactionRate", getLiveSatisfactionRate());
            request.setAttribute("productCount", getLiveProductCount());
            request.getRequestDispatcher("hero_config/config-hero-add.jsp").forward(request, response);
            return;
        }

        // Sanitization
        title = util.ValidationUtil.escapeHtml(title);
        description = util.ValidationUtil.escapeHtml(description);
        eyebrow = util.ValidationUtil.escapeHtml(eyebrow);
        ctaPrimary = util.ValidationUtil.escapeHtml(ctaPrimary);
        ctaSecondary = util.ValidationUtil.escapeHtml(ctaSecondary);
        stat2 = util.ValidationUtil.escapeHtml(stat2);

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
        return dao.getLiveSatisfactionRate();
    }

    /**
     * Đếm tổng số sản phẩm LIVE từ bảng ProductDetail.
     * Yêu cầu giáo viên: COUNT(*), không fix số 30.
     */
    private int getLiveProductCount() {
        return dao.getLiveProductCount();
    }

    /** Null-safe trim */
    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}