package controller;

import config.DBContext;
import dao.HeroBannerDAO;
import dao.SupplierDAO;
import entity.HeroBanner;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Servlet phục vụ trang chủ (HomePage.jsp). Cập nhật: Truy vấn LIVE mỗi lần
 * load trang thay vì dùng init().
 */
@WebServlet(name = "HomePageServlet", urlPatterns = {"/home", "/HomePage"})
public class HomePageServlet extends HttpServlet {

    private final HeroBannerDAO heroBannerDAO = new HeroBannerDAO();
    private final dao.ProductDAO productDAO = new dao.ProductDAO();
    private final dao.SupplierDAO supplierDAO = new dao.SupplierDAO();
    private final dao.TradeInConfigDAO tradeInDAO = new dao.TradeInConfigDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Load Hero Banner mới nhất ──────────────────────────────
        // Lấy banner đang active để hiển thị trên Hero section của HomePage.jsp
        try {
            HeroBanner activeBanner = heroBannerDAO.getActiveBanner();
            request.setAttribute("heroBanner", activeBanner);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("heroBanner", null);
        }

        // ── 2. Tính điểm hài lòng LIVE ────────────────────────────────
        // Thực hiện AVG(Ranking) trực tiếp từ bảng ProductReview [cite: 10, 11]
        request.setAttribute("satisfactionRate", getLiveSatisfactionRate());

        // ── 3. Đếm số mẫu máy LIVE ────────────────────────────────────
        // Thực hiện COUNT(*) trực tiếp từ bảng ProductDetail [cite: 16, 17]
        request.setAttribute("productCount", getLiveProductCount());
        // ── 3.1. Load danh sách Thương hiệu (Suppliers) cho slider ───
        List<Supplier> listBrands = supplierDAO.getAllSuppliers();
        request.setAttribute("listCC", listBrands);

        // ── 3.5. Lấy danh sách Top Product bán chạy ───────────────────
        try {
            java.util.List<java.util.Map<String, Object>> featuredProducts = productDAO.getFeaturedProductsPaging("", 1, 8); // Lấy 8 sản phẩm
            request.setAttribute("featuredProducts", featuredProducts);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ── 3.6. Lấy cấu hình Trade-in ────────────────────────────────
        try {
            java.util.Map<String, Object> tradeInConfig = tradeInDAO.getConfig();
            request.setAttribute("tradeInConfig", tradeInConfig);
        } catch (Exception e) {
            e.printStackTrace();
        }

// ── 4. Chuyển hướng dữ liệu sang trang JSP ────────────────────
        request.getRequestDispatcher("/HomePage.jsp").forward(request, response);
    }

    /**
     * Tính điểm hài lòng trung bình từ DB.
     */
    private String getLiveSatisfactionRate() {
        String sql = "SELECT AVG(CAST(Ranking AS FLOAT)) AS Average FROM GeneralReview WHERE [Status] = 'VISIBLE' AND (ReviewTopic IS NULL OR ReviewTopic != 'Q&A')";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
     * Đếm tổng số sản phẩm từ DB.
     */
    private int getLiveProductCount() {
        String sql = "SELECT COUNT(*) FROM ProductDetail";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
