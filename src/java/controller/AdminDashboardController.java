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
        
        int totalProducts = dao.getTotalProducts();
        int totalUsers = userDAO.getTotalUsers();
        int totalBlogs = blogDAO.getTotalBlogs();
        int pendingOrders = dao.getPendingOrdersCount();
        String monthlyRevenue = dao.getMonthlyRevenue();
        
        List<Map<String, String>> recentOrders = dao.getRecentOrders(5);
        List<Map<String, String>> bestSellers = dao.getBestSellers(5);
        
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("bestSellers", bestSellers);
        
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
