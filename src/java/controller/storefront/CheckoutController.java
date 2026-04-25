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
        DAO dao = new DAO();
        List<CartItem> cartItems = CartSupport.buildCartItems(session, dao);
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        User user = (User) session.getAttribute("acc");
        if (user != null) {
            UserCartDAO cartDao = new UserCartDAO();
            String reservationError = cartDao.reserveLowStockItems(user.getId());
            if (reservationError != null) {
                request.setAttribute("formError", reservationError);
            }
            Timestamp reservationExpiresAt = cartDao.getReservationExpiresAt(user.getId());
            if (reservationExpiresAt != null) {
                request.setAttribute("reservationExpiresAt", reservationExpiresAt);
                request.setAttribute("reservationExpiresAtMillis", reservationExpiresAt.getTime());
            }
            CartSupport.syncCartSize(session);
        }

        double cartTotal = 0;
        for (CartItem item : cartItems) {
            cartTotal += item.getSubtotal();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}
