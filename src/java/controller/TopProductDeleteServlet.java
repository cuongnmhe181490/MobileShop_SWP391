package controller;

import dao.TopProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet xóa Top Product.
 *
 * GET/POST /TopProductDeleteServlet?id=N → xóa sản phẩm có id=N rồi redirect về TopProductListServlet
 */
@WebServlet(name = "TopProductDeleteServlet", urlPatterns = {"/TopProductDeleteServlet"})
public class TopProductDeleteServlet extends HttpServlet {

    private final TopProductDAO dao = new TopProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            boolean success = dao.delete(id);
            if (!success) {
                System.err.println("Failed to delete TopProduct with id: " + id);
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid id parameter: " + idParam);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
    }
}