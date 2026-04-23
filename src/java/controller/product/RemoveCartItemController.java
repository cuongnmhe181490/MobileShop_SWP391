package controller.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import util.CartSupport;

@WebServlet(name = "RemoveCartItemController", urlPatterns = {"/cart/remove"})
public class RemoveCartItemController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<String, Integer> cart = CartSupport.getCart(session);
        String productId = request.getParameter("idProduct");

        if (productId != null) {
            cart.remove(productId.trim());
        }

        CartSupport.syncCartSize(session);
        CartSupport.setSuccess(session, "Đã xóa sản phẩm khỏi giỏ hàng.");
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
