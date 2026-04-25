package controller.product;

import dao.order.UserCartDAO;
import dao.product.ProductStorefrontDAO;
import entity.ProductModel;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.CartSupport;

@WebServlet(name = "UpdateCartController", urlPatterns = {"/cart/update"})
public class UpdateCartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String productId = safeTrim(request.getParameter("idProduct"));
        int quantity = parseQuantity(request.getParameter("quantity"));
        User user = (User) session.getAttribute("acc");

        if (user == null) {
            CartSupport.setError(session, "Vui lòng đăng nhập để cập nhật giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (productId.isEmpty()) {
            CartSupport.setError(session, "Không tìm thấy sản phẩm cần cập nhật trong giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (quantity <= 0) {
            CartSupport.setError(session, "Số lượng phải là số nguyên từ 1 trở lên.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        ProductStorefrontDAO dao = new ProductStorefrontDAO();
        ProductModel product = dao.getProductByID(productId);
        if (product == null) {
            new UserCartDAO().removeItem(user.getId(), productId);
            CartSupport.syncCartSize(session);
            CartSupport.setError(session, "Sản phẩm không còn tồn tại nên đã được gỡ khỏi giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int availableQuantity = CartSupport.getAvailableQuantity(session, productId, product.getQuantity());
        if (quantity > availableQuantity) {
            CartSupport.setError(session, "Số lượng cập nhật vượt quá tồn kho khả dụng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String errorMessage = new UserCartDAO().updateItem(user.getId(), productId, quantity);
        if (errorMessage != null) {
            CartSupport.setError(session, errorMessage);
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

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
