package controller;

import dao.BlogDAO;
import dao.DAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        DAO dao = new DAO();
        
        // 1. Lấy tham số ngày từ Request
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        java.sql.Date sDate, eDate;

        if (startDateStr == null || startDateStr.isEmpty()) {
            sDate = new java.sql.Date(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000));
            eDate = new java.sql.Date(System.currentTimeMillis());
        } else {
            try {
                sDate = java.sql.Date.valueOf(startDateStr);
                eDate = java.sql.Date.valueOf(endDateStr);
            } catch (Exception e) {
                sDate = new java.sql.Date(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000));
                eDate = new java.sql.Date(System.currentTimeMillis());
            }
        }

        long diffDays = Math.abs(eDate.getTime() - sDate.getTime()) / (1000 * 60 * 60 * 24);

        dao.order.OrderDAO orderDAO = new dao.order.OrderDAO();
        dao.product.ProductAdminDAO productDAO = new dao.product.ProductAdminDAO();
        


        try {
            // 3. Các thống kê và chỉ số theo khoảng ngày đã chọn
            request.setAttribute("totalProducts", dao.getNewProductsCount(sDate, eDate));
            request.setAttribute("totalUsers", dao.getNewUsersCount(sDate, eDate));
            request.setAttribute("soldOrders", orderDAO.getSoldOrdersCount(sDate, eDate));
            request.setAttribute("monthlyRevenue", orderDAO.getRevenueByDate(sDate, eDate));
            
            // Các dữ liệu khác có thể vẫn giữ nguyên hoặc lọc thêm nếu cần
            request.setAttribute("totalBlogs", dao.getTotalBlogs());
            request.setAttribute("recentOrders", orderDAO.getRecentOrdersDashboard(5));
            request.setAttribute("bestSellers", dao.getBestSellers(5, sDate, eDate));
            request.setAttribute("monthlyRevenueData", orderDAO.getMonthlyRevenueData());
            request.setAttribute("orderStats", orderDAO.getOrderStatusStatistics());
            
            // Thống kê phụ
            request.setAttribute("newProductsMonth", dao.getNewProductsCount(sDate, eDate));
            request.setAttribute("newUsersMonth", dao.getNewUsersCount(sDate, eDate));
            request.setAttribute("newOrdersMonth", orderDAO.getNewOrdersCount(sDate, eDate));
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR IN AdminDashboardController:");
            e.printStackTrace();
            // Cung cấp các giá trị mặc định để tránh lỗi JSP
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("totalProducts", 0);
            request.setAttribute("totalUsers", 0);
            request.setAttribute("totalBlogs", 0);
            request.setAttribute("soldOrders", 0);
            request.setAttribute("monthlyRevenue", "0");
            request.setAttribute("revenueGrowth", 0.0);
            request.setAttribute("recentOrders", new java.util.ArrayList<>());
            request.setAttribute("bestSellers", new java.util.ArrayList<>());
            request.setAttribute("monthlyRevenueData", new java.util.LinkedHashMap<>());
            request.setAttribute("orderStats", new java.util.HashMap<>());
        }
        
        request.setAttribute("startDate", sDate);
        request.setAttribute("endDate", eDate);
        request.setAttribute("diffDays", diffDays);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
