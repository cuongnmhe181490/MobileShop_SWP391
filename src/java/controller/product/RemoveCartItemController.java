package controller.product;

import dao.order.UserCartDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.CartSupport;

@WebServlet(name = "RemoveCartItemController", urlPatterns = {"/cart/remove"})
public class RemoveCartItemController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        String productId = request.getParameter("idProduct");

        if (productId != null) {
            String normalizedProductId = productId.trim();
            if (user != null) {
                new UserCartDAO().removeItem(user.getId(), normalizedProductId);
            } else {
                CartSupport.getCart(session).remove(normalizedProductId);
            }
        }

        CartSupport.syncCartSize(session);
        CartSupport.setSuccess(session, "Đã xóa sản phẩm khỏi giỏ hàng.");
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
