package controller.topproduct;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


/**
 * Servlet bật/tắt trạng thái Featured của sản phẩm.
 * 
 * GET/POST /TopProductToggleServlet?productId=XXX&status=0 → Đưa sản phẩm ra khỏi Top
 * (Đưa vào Top được xử lý bởi TopProductAddServlet)
 */
@WebServlet(name = "TopProductToggleServlet", urlPatterns = {"/TopProductToggleServlet"})
public class TopProductToggleServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productId = request.getParameter("productId");
        String statusStr = request.getParameter("status");
        jakarta.servlet.http.HttpSession session = request.getSession();

        if (productId == null || productId.isEmpty() || statusStr == null || statusStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
            return;
        }

        try {
            int status = Integer.parseInt(statusStr);
            // Chỉ cho phép tắt (status = 0) - đưa sản phẩm ra khỏi Top
            if (status == 0) {
                boolean success = productDAO.updateFeaturedStatus(productId, 0);
                if (success) {
                    session.setAttribute("flashSuccess", "Đã gỡ sản phẩm " + productId + " khỏi Top thành công!");
                } else {
                    session.setAttribute("flashError", "Gỡ sản phẩm thất bại.");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Tham số không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashError", "Lỗi: " + e.getMessage());
        }

        // Redirect về trang danh sách Top products
        response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
    }

}