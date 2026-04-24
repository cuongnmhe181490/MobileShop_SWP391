package controller.order;

import dao.DAO;
import dao.order.OrderDAO;
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
import java.util.List;
import util.CartSupport;

@WebServlet(name = "PlaceOrderController", urlPatterns = {"/order/place"})
public class PlaceOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DAO productDao = new DAO();
        UserCartDAO cartDao = new UserCartDAO();
        List<CartItem> cartItems = CartSupport.buildCartItems(session, productDao);
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String address = trim(request.getParameter("address"));
        String note = trim(request.getParameter("note"));

        boolean hasError = false;
        if (fullName.isEmpty()) {
            request.setAttribute("errorFullName", "H\u1ecd t\u00ean kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng");
            hasError = true;
        }
        if (email.isEmpty() || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorEmail", "Email kh\u00f4ng h\u1ee3p l\u1ec7");
            hasError = true;
        }
        if (!phone.matches("[0-9]{10,11}")) {
            request.setAttribute("errorPhone", "S\u1ed1 \u0111i\u1ec7n tho\u1ea1i ph\u1ea3i t\u1eeb 10-11 ch\u1eef s\u1ed1");
            hasError = true;
        }
        if (address.isEmpty()) {
            request.setAttribute("errorAddress", "Vui l\u00f2ng nh\u1eadp \u0111\u1ecba ch\u1ec9 nh\u1eadn h\u00e0ng");
            hasError = true;
        }

        double cartTotal = 0;
        for (CartItem item : cartItems) {
            cartTotal += item.getSubtotal();
        }

        if (cartDao.hasMissingOrExpiredLowStockReservation(user.getId())) {
            cartDao.releaseReservations(user.getId());
            request.setAttribute("formError", "Đã hết thời gian giữ hàng 15 phút. Vui lòng vào lại trang thanh toán để giữ hàng lại.");
            forwardCheckout(request, response, cartItems, cartTotal, fullName, email, phone, address, note);
            return;
        }

        if (hasError) {
            forwardCheckout(request, response, cartItems, cartTotal, fullName, email, phone, address, note);
            return;
        }

        try {
            int orderId = new OrderDAO().createOrder(user.getId(), fullName, phone, address, cartTotal, cartItems);
            session.setAttribute("lastOrderId", orderId);
            CartSupport.syncCartSize(session);
            response.sendRedirect(request.getContextPath() + "/confirm.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("formError", "Kh\u00f4ng th\u1ec3 l\u01b0u \u0111\u01a1n h\u00e0ng. Vui l\u00f2ng th\u1eed l\u1ea1i.");
            forwardCheckout(request, response, cartItems, cartTotal, fullName, email, phone, address, note);
        }
    }

    private void forwardCheckout(HttpServletRequest request, HttpServletResponse response,
            List<CartItem> cartItems, double cartTotal, String fullName, String email,
            String phone, String address, String note) throws ServletException, IOException {
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("note", note);
        java.sql.Timestamp reservationExpiresAt = new UserCartDAO().getReservationExpiresAt(((User) request.getSession().getAttribute("acc")).getId());
        if (reservationExpiresAt != null) {
            request.setAttribute("reservationExpiresAt", reservationExpiresAt);
            request.setAttribute("reservationExpiresAtMillis", reservationExpiresAt.getTime());
        }
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
