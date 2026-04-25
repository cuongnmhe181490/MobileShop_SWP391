package controller.hero;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import dao.HeroBannerDAO;
import entity.HeroBanner;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import util.CloudinaryUtil;

@WebServlet(name = "HeroEditServlet", urlPatterns = {"/HeroEditServlet"})

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15   // 15MB
)
public class HeroEditServlet extends HttpServlet {

    private final HeroBannerDAO dao = new HeroBannerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<HeroBanner> banners = new ArrayList<>();
        try {
            banners = dao.getAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("banners", banners);

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
        request.getRequestDispatcher("hero_config/config-hero-edit.jsp").forward(request, response);
    }

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
            response.sendRedirect(request.getContextPath() + "/HeroEditServlet");
            return;
        }

        // Lấy banner cũ từ DB để lấy imageUrl cũ nếu k upload mới
        HeroBanner oldBanner = null;
        try {
            oldBanner = dao.getById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (oldBanner == null) {
            response.sendRedirect(request.getContextPath() + "/HeroEditServlet");
            return;
        }

        String eyebrow      = trim(request.getParameter("eyebrow"));
        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String ctaPrimary   = trim(request.getParameter("ctaPrimary"));
        String ctaSecondary = trim(request.getParameter("ctaSecondary"));
        String stat1        = trim(request.getParameter("stat1"));
        String stat2        = trim(request.getParameter("stat2"));
        String stat3        = trim(request.getParameter("stat3"));

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

        // Xử lý File Upload (tùy chọn)
        Part filePart = request.getPart("imageFile");
        String imageUrl = oldBanner.getImageUrl(); // Mặc định dùng cái cũ

        if (filePart != null && filePart.getSize() > 0) {
            if (filePart.getSize() > 500 * 1024) {
                errors.append("Kích thước ảnh vượt quá giới hạn 500 KB. ");
            } else {
                String uploadedUrl = CloudinaryUtil.upload(filePart);
                if (uploadedUrl != null) {
                    imageUrl = uploadedUrl;
                } else {
                    errors.append("Lỗi tải ảnh lên Cloudinary. ");
                }
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            List<HeroBanner> banners = new ArrayList<>();
            try { banners = dao.getAll(); } catch (Exception e) { e.printStackTrace(); }
            request.setAttribute("banners", banners);
            request.setAttribute("hero", oldBanner);
            request.getRequestDispatcher("hero_config/config-hero-edit.jsp").forward(request, response);
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
            session.setAttribute("flashError", "Cập nhật Hero banner thất bại.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminHomeConfigServlet");
    }


    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}
