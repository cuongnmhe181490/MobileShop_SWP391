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
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet cho trang tổng quan quản lý homepage (admin-home-config.jsp).
 *
 * GET /AdminHomeConfigServlet → load số lượng banner rồi forward đến admin-home-config.jsp
 */
@WebServlet(name = "AdminHomeConfigServlet", urlPatterns = {"/AdminHomeConfigServlet"})
public class AdminHomeConfigServlet extends HttpServlet {

    private final HeroBannerDAO heroDAO = new HeroBannerDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy danh sách hero banners để hiển thị thống kê nhanh
            List<HeroBanner> heroes = heroDAO.getAll();
            request.setAttribute("heroList", heroes);
            request.setAttribute("heroCount", heroes.size());

            // Banner đang active
            HeroBanner activeHero = heroDAO.getActiveBanner();
            request.setAttribute("activeHero", activeHero);

            // Lấy thương hiệu mới nhất để link nút Sửa trên overview
            List<Supplier> suppliers = supplierDAO.getAllSuppliersPaging(null, 1, 1);
            if (!suppliers.isEmpty()) {
                request.setAttribute("latestSupplier", suppliers.get(0));
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("heroList", new ArrayList<>());
            request.setAttribute("heroCount", 0);
            request.setAttribute("activeHero", null);
        }


        // Điểm hài lòng: tính LIVE từ DB, không fix cứng
        request.setAttribute("satisfactionRate", getLiveSatisfactionRate());

        // Số sản phẩm hiện có trong kho
        request.setAttribute("productCount", getLiveProductCount());

        request.getRequestDispatcher("/admin-home-config.jsp").forward(request, response);
    }

    /**
     * Tính điểm hài lòng trung bình từ bảng ProductReview (yêu cầu giáo viên).
     * Công thức: AVG(Ranking) làm tròn 1 chữ số thập phân, ví dụ "4.8/5"
     */
    private String getLiveSatisfactionRate() {
        return heroDAO.getLiveSatisfactionRate();
    }

    /**
     * Lấy tổng số sản phẩm trong kho từ bảng ProductDetail.
     */
    private int getLiveProductCount() {
        return heroDAO.getLiveProductCount();
    }
}
