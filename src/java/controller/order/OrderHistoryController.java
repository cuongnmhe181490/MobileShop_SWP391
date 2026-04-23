package controller.order;

import dao.order.OrderDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderHistoryController", urlPatterns = {"/my-orders", "/myOrders"})
public class OrderHistoryController extends HttpServlet {
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        int currentPage = Math.max(1, parseInt(request.getParameter("page"), 1));
        int totalOrders = orderDAO.countOrdersByUser(user.getId());
        int totalPages = Math.max(1, (int) Math.ceil(totalOrders / (double) PAGE_SIZE));
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        List<Map<String, Object>> orders = orderDAO.getOrdersByUser(user.getId(), currentPage, PAGE_SIZE);
        Map<Integer, List<Map<String, Object>>> detailsByOrder = new HashMap<>();
        for (Map<String, Object> order : orders) {
            Object value = order.get("idOrder");
            if (value instanceof Number) {
                int orderId = ((Number) value).intValue();
                detailsByOrder.put(orderId, orderDAO.getOrderDetails(orderId));
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("detailsByOrder", detailsByOrder);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);

        request.getRequestDispatcher("/order-history.jsp").forward(request, response);
    }

    private int parseInt(String raw, int fallback) {
        try {
            return raw == null ? fallback : Integer.parseInt(raw);
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }
}
