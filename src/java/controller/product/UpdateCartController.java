package controller.storefront;

import dao.DAO;
import dao.product.ProductStorefrontDAO;
import dao.order.UserCartDAO;
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
        User user = (User) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String productId = safeTrim(request.getParameter("idProduct"));
        int quantity = parseQuantity(request.getParameter("quantity"));
        UserCartDAO cartDao = new UserCartDAO();
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

        ProductModel product = new ProductStorefrontDAO().getProductByID(productId);
        if (product == null) {
            cartDao.removeItem(user.getId(), productId);
            CartSupport.syncCartSize(session);
            CartSupport.setError(session, "Sản phẩm không còn tồn tại nên đã được gỡ khỏi giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        if (quantity > cartDao.getAvailableQuantity(productId, user.getId())) {
            CartSupport.setError(session, "Số lượng cập nhật vượt quá tồn kho khả dụng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String cartError = cartDao.updateItem(user.getId(), productId, quantity);
        if (cartError != null) {
            CartSupport.setError(session, cartError);
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
