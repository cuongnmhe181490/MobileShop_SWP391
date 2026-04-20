package controller.topproduct;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;


/**
 * Servlet xử lý thêm sản phẩm vào Top (Featured).
 *
 * GET  /TopProductAddServlet → hiển thị danh sách sản phẩm chưa được ghim (config-top-product-add.jsp)
 * POST /TopProductAddServlet → nhận productId, cập nhật IsFeatured = 1, redirect về TopProductListServlet
 */
@WebServlet(name = "TopProductAddServlet", urlPatterns = {"/TopProductAddServlet"})
public class TopProductAddServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    // ── GET: hiển thị danh sách sản phẩm chưa được ghim ───────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy danh sách sản phẩm chưa được ghim (IsFeatured = 0)
            List<Map<String, Object>> availableList = productDAO.getAvailableToFeature();
            request.setAttribute("availableProductList", availableList);
            request.getRequestDispatcher("topproduct_config/config-top-product-add.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách: " + e.getMessage());
            request.getRequestDispatcher("topproduct_config/config-top-product-add.jsp").forward(request, response);
        }
    }

    // ── POST: ghim sản phẩm lên Top ────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        jakarta.servlet.http.HttpSession session = request.getSession();

        String productId = request.getParameter("productId");

        if (productId == null || productId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/TopProductAddServlet");
            return;
        }

        try {
            // Cập nhật IsFeatured = 1 (ghim lên Top)
            boolean success = productDAO.updateFeaturedStatus(productId, 1);
            if (success) {
                session.setAttribute("flashSuccess", "Đã thêm sản phẩm " + productId + " vào Top thành công!");
            } else {
                session.setAttribute("flashError", "Thêm sản phẩm vào Top thất bại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashError", "Lỗi: " + e.getMessage());
        }

        // Redirect về trang danh sách Top products
        response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
    }

}