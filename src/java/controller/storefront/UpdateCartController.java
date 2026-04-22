package controller.storefront;

import dao.DAO;
import entity.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import util.CartSupport;

@WebServlet(name = "UpdateCartController", urlPatterns = {"/cart/update"})
public class UpdateCartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String productId = safeTrim(request.getParameter("idProduct"));
        int quantity = parseQuantity(request.getParameter("quantity"));
        Map<String, Integer> cart = CartSupport.getCart(session);

        if (productId.isEmpty() || !cart.containsKey(productId)) {
            CartSupport.setError(session, "Không tìm thấy sản phẩm cần cập nhật trong giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (quantity <= 0) {
            CartSupport.setError(session, "Số lượng phải là số nguyên từ 1 trở lên.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        DAO dao = new DAO();
        ProductModel product = dao.getProductByID(productId);
        if (product == null) {
            cart.remove(productId);
            CartSupport.syncCartSize(session);
            CartSupport.setError(session, "Sản phẩm không còn tồn tại nên đã được gỡ khỏi giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (quantity > product.getQuantity()) {
            CartSupport.setError(session, "Số lượng cập nhật vượt quá tồn kho hiện có.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        cart.put(productId, quantity);
        CartSupport.syncCartSize(session);
        CartSupport.setSuccess(session, "Đã cập nhật số lượng trong giỏ hàng.");
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private int parseQuantity(String rawValue) {
        try {
            return Integer.parseInt(safeTrim(rawValue));
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
