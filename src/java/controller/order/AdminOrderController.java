package controller.order;

import dao.order.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders", "/admin/orders/detail"})
public class AdminOrderController extends HttpServlet {
    private static final int PAGE_SIZE = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getServletPath().endsWith("/detail")) {
            loadOrderDetail(request);
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
            return;
        }
        loadOrders(request);
        request.getRequestDispatcher("/admin/order-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        int orderId = parseInt(request.getParameter("id"), -1);
        String action = request.getParameter("action");
        if (orderId > 0) {
            if ("cancel".equals(action)) {
                orderDAO.updateOrderStatus(orderId, OrderDAO.STATUS_CANCELED);
            } else if ("complete".equals(action)) {
                orderDAO.updateOrderStatus(orderId, OrderDAO.STATUS_COMPLETED);
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void loadOrders(HttpServletRequest request) {
        OrderDAO orderDAO = new OrderDAO();
        String keyword = trim(request.getParameter("keyword"));
        String status = trim(request.getParameter("status"));
        int currentPage = Math.max(1, parseInt(request.getParameter("page"), 1));
        int totalOrders = orderDAO.countAdminOrders(keyword, status);
        int totalPages = Math.max(1, (int) Math.ceil(totalOrders / (double) PAGE_SIZE));
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("orderList", orderDAO.getAdminOrders(keyword, status, currentPage, PAGE_SIZE));
    }

    private void loadOrderDetail(HttpServletRequest request) {
        OrderDAO orderDAO = new OrderDAO();
        int orderId = parseInt(request.getParameter("id"), -1);
        if (orderId > 0) {
            request.setAttribute("order", orderDAO.getOrderById(orderId));
            request.setAttribute("orderDetails", orderDAO.getOrderDetails(orderId));
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseInt(String raw, int fallback) {
        try {
            return raw == null ? fallback : Integer.parseInt(raw);
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }
}
