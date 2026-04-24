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
        List<CartItem> cartItems = CartSupport.buildCartItems(session);
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAO dao = new DAO();
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        
        List<CartItem> cartItems = CartSupport.buildCartItems(session);
        double cartTotal = calculateTotal(cartItems);
        
        boolean hasError = false;
        // Validation could go here
        
        if (hasError) {
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("note", note);
            
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } else {
            User account = (User) session.getAttribute("acc");
            
            int orderId = -1;
            try {
                dao.order.OrderDAO orderDAO = new dao.order.OrderDAO();
                orderId = orderDAO.createOrder(
                        account != null ? account.getId() : -1,
                        fullName,
                        phone,
                        address,
                        cartTotal,
                        cartItems
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (orderId > 0) {
                session.removeAttribute(CartSupport.CART_SESSION_KEY);
                CartSupport.syncCartSize(session);
                
                request.setAttribute("orderId", orderId);
                
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('Đặt hàng thành công! Cảm ơn bạn đã mua hàng.');");
                response.getWriter().println("window.location.href='" + request.getContextPath() + "/home';");
                response.getWriter().println("</script>");
            } else {
                request.setAttribute("errorGeneral", "Có lỗi xảy ra khi lưu đơn hàng. Vui lòng thử lại.");
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("cartTotal", cartTotal);
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            }
        }
    }
}