package controller.storefront;

import dao.DAO;
import dao.order.UserCartDAO;
import entity.CartItem;
import entity.CartItem;
import entity.Order;
import entity.OrderDetail;
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
    
        HttpSession session = request.getSession();
        DAO dao = new DAO();
        
        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        
        boolean hasError = false;
        
        // 2. Validate dữ liệu
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorFullName", "Họ tên không được để trống");
            hasError = true;
        }
        
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorEmail", "Email không hợp lệ");
            hasError = true;
        }
        
        if (phone == null || !phone.matches("[0-9]{10,11}")) {
            request.setAttribute("errorPhone", "Số điện thoại phải từ 10-11 chữ số");
            hasError = true;
        }
        
        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("errorAddress", "Vui lòng nhập địa chỉ nhận hàng");
            hasError = true;
        }

        // Lấy lại dữ liệu giỏ hàng để hiển thị nếu có lỗi hoặc để lưu DB
        List<CartItem> cartItems = CartSupport.buildCartItems(session, dao);
        double cartTotal = 0;
        for (CartItem item : cartItems) {
            cartTotal += item.getSubtotal();
        }
        
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
            // 3. Lưu vào Database
            User account = (User) session.getAttribute("acc");
            
            Order order = new Order();
            order.setUserId(account != null ? account.getId() : null);
            order.setOrderDate(new java.sql.Date(System.currentTimeMillis()));
            order.setTotalPrice(cartTotal);
            order.setReceiverName(fullName);
            order.setReceiverPhone(phone);
            order.setReceiverAddress(address);
            order.setCustomerNote(note);
            order.setOrderStatus("Pending");
            order.setPaymentMethod("COD");
            
            int orderId = dao.addOrder(order);
            
            if (orderId > 0) {
                // Lưu OrderDetail
                for (CartItem item : cartItems) {
                    OrderDetail detail = new OrderDetail();
                    detail.setIdOrder(orderId);
                    detail.setIdProduct(item.getProduct().getIdProduct());
                    detail.setQuantity(item.getQuantity());
                    detail.setUnitPrice(item.getProduct().getPrice());
                    dao.addOrderDetail(detail);
                }
                
                // Xóa giỏ hàng sau khi đặt thành công
                session.removeAttribute(CartSupport.CART_SESSION_KEY);
                CartSupport.syncCartSize(session);
                
                // Lưu ID đơn hàng vào session để trang confirm hiển thị (tùy chọn)
                request.setAttribute("orderId", orderId);
                
                response.sendRedirect(request.getContextPath() + "/confirm.jsp?orderId=" + orderId);
            } else {
                request.setAttribute("errorGeneral", "Có lỗi xảy ra khi lưu đơn hàng. Vui lòng thử lại.");
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("cartTotal", cartTotal);
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            }
        }
    }
    
}