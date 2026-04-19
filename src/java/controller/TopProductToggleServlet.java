package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
                    System.out.println("✅ Removed from Top: " + productId);
                } else {
                    System.err.println("❌ Failed to remove from Top: " + productId);
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid status parameter: " + statusStr);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect về trang danh sách Top products
        response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
    }
}