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
        UserDAO userDAO = new UserDAO();
        BlogDAO blogDAO = new BlogDAO();

        // 1. Lấy tham số ngày từ Request (Dạng yyyy-MM-dd)
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        java.sql.Date sDate, eDate;

        // 2. Logic: Nếu chưa chọn ngày, mặc định lấy 30 ngày gần nhất
        if (startDateStr == null || startDateStr.isEmpty()) {
            // Tính toán 30 ngày trước bằng Milis
            long thirtyDaysAgo = System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000);
            sDate = new java.sql.Date(thirtyDaysAgo);
            eDate = new java.sql.Date(System.currentTimeMillis());
        } else {
            // Chuyển đổi String sang java.sql.Date
            try {
                sDate = java.sql.Date.valueOf(startDateStr);
                eDate = java.sql.Date.valueOf(endDateStr);
            } catch (Exception e) {
                // Nếu lỗi định dạng, quay về mặc định
                sDate = new java.sql.Date(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000));
                eDate = new java.sql.Date(System.currentTimeMillis());
            }
        }

        // 3. Tính số ngày chênh lệch để hiển thị text "(X ngày)"
        long diff = Math.abs(eDate.getTime() - sDate.getTime());
        long diffDays = diff / (1000 * 60 * 60 * 24);

        // 4. Lấy dữ liệu thống kê (Sử dụng các hàm có tham số ngày)
        int totalProducts = dao.getTotalProducts();
        int totalUsers = userDAO.getTotalUsersByDate(sDate, eDate);
        int totalBlogs = blogDAO.getTotalBlogs();
        int pendingOrders = dao.getPendingOrdersCount();
        
        List<Map<String, String>> recentOrders = dao.getRecentOrders(5);
        List<Map<String, String>> bestSellers = dao.getBestSellers(5);
        
        // 5. Gửi dữ liệu sang JSP
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("monthlyRevenue", dao.getMonthlyRevenue());
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("bestSellers", bestSellers);
        
        request.setAttribute("startDate", sDate);
        request.setAttribute("endDate", eDate);
        request.setAttribute("diffDays", diffDays);
        
        // Các thống kê khác
        request.setAttribute("newProductsMonth", dao.getNewProductsThisMonthCount());
        request.setAttribute("newUsersMonth", dao.getNewUsersThisMonthCount());
        request.setAttribute("newOrdersMonth", dao.getNewOrdersThisMonthCount());
        request.setAttribute("revenueGrowth", dao.getRevenueGrowth());
        
        Map<String, Integer> orderStats = dao.getOrderStatusStatistics();
        request.setAttribute("orderStats", orderStats);
        
        // Lấy doanh thu theo ngày cho biểu đồ
        Map<String, Double> dailyRevenue = dao.getDailyRevenue(sDate, eDate);
        request.setAttribute("dailyRevenue", dailyRevenue);
        
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
