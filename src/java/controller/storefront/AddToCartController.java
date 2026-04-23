package controller.storefront;

import dao.DAO;
import dao.order.UserCartDAO;
import entity.Product;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import util.CartSupport;

@WebServlet(name = "AddToCartController", urlPatterns = {"/cart/add"})
public class AddToCartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("acc");
        if (user == null) {
            String notice = URLEncoder.encode("Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/login?notice=" + notice);
            return;
        }

        String productId = safeTrim(request.getParameter("idProduct"));
        int quantity = parseQuantity(request.getParameter("quantity"));
        if (productId.isEmpty()) {
            CartSupport.setError(session, "Không thể thêm vào giỏ hàng vì sản phẩm không hợp lệ.");
            redirectBack(request, response, request.getContextPath() + "/product");
            return;
        }
        if (quantity <= 0) {
            CartSupport.setError(session, "Số lượng thêm vào giỏ phải là số nguyên lớn hơn 0.");
            redirectBack(request, response, request.getContextPath() + "/detail?pid=" + productId);
            return;
        }

        Product product = new DAO().getProductByID(productId);
        if (product == null) {
            CartSupport.setError(session, "Sản phẩm không tồn tại hoặc đã bị gỡ khỏi hệ thống.");
            redirectBack(request, response, request.getContextPath() + "/product");
            return;
        }
        if (product.getQuantity() <= 0) {
            CartSupport.setError(session, "Sản phẩm này hiện đã hết hàng.");
            redirectBack(request, response, request.getContextPath() + "/detail?pid=" + productId);
            return;
        }

        UserCartDAO cartDao = new UserCartDAO();
        if (quantity > cartDao.getAvailableQuantity(productId, user.getId())) {
            CartSupport.setError(session, "Số lượng chọn vượt quá tồn kho khả dụng.");
            redirectBack(request, response, request.getContextPath() + "/detail?pid=" + productId);
            return;
        }

        String cartError = cartDao.addItem(user.getId(), productId, quantity);
        if (cartError != null) {
            CartSupport.setError(session, cartError);
            redirectBack(request, response, request.getContextPath() + "/detail?pid=" + productId);
            return;
        }

        CartSupport.syncCartSize(session);
        CartSupport.setSuccess(session, "Đã thêm sản phẩm vào giỏ hàng.");
        redirectBack(request, response, request.getContextPath() + "/cart");
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

    private void redirectBack(HttpServletRequest request, HttpServletResponse response, String fallbackUrl)
            throws IOException {
        String referer = request.getHeader("referer");
        if (referer != null && !referer.isBlank() && referer.contains(request.getContextPath())) {
            response.sendRedirect(referer);
            return;
        }
        response.sendRedirect(fallbackUrl);
    }
}
