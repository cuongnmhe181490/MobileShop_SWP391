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
        DAO dao = new DAO();
        UserDAO userDAO = new UserDAO();
        BlogDAO blogDAO = new BlogDAO();
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        int totalProducts = dao.getTotalProducts(startDate, endDate);
        int totalUsers = userDAO.getTotalUsers(startDate, endDate);
        int totalBlogs = blogDAO.getTotalBlogs();
        int pendingOrders = dao.getPendingOrdersCount();
        
        // Dữ liệu lọc theo ngày
        String monthlyRevenue = dao.getMonthlyRevenue(startDate, endDate);
        List<Map<String, String>> recentOrders = dao.getRecentOrders(5, startDate, endDate);
        List<Map<String, String>> bestSellers = dao.getBestSellers(5, startDate, endDate);
        Map<String, Integer> orderStats = dao.getOrderStatusStatistics(startDate, endDate);
        
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("bestSellers", bestSellers);
        request.setAttribute("orderStats", orderStats);
        request.setAttribute("monthlyRevenueArray", dao.getMonthlyRevenueArray(startDate, endDate));
        
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.setAttribute("revenueGrowth", dao.getRevenueGrowth());
        
        // Add current date for dashboard
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
        request.setAttribute("currentDate", sdf.format(new java.util.Date()));
        
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
