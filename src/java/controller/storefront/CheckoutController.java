package controller.storefront;

import dao.DAO;
import dao.order.UserCartDAO;
import entity.CartItem;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import util.CartSupport;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserCartDAO cartDao = new UserCartDAO();
        String reserveError = cartDao.reserveLowStockItems(user.getId());
        List<CartItem> cartItems = CartSupport.buildCartItems(session, new DAO());
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        double cartTotal = calculateTotal(cartItems);
        if (reserveError != null) {
            request.setAttribute("formError", reserveError);
        }
        Timestamp reservationExpiresAt = cartDao.getReservationExpiresAt(user.getId());
        if (reservationExpiresAt != null) {
            request.setAttribute("reservationExpiresAt", reservationExpiresAt);
            request.setAttribute("reservationExpiresAtMillis", reservationExpiresAt.getTime());
        }
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    private double calculateTotal(List<CartItem> cartItems) {
        double total = 0;
        for (CartItem item : cartItems) {
            total += item.getSubtotal();
        }
        return total;
    }
}