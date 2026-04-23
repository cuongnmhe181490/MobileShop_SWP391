package controller.storefront;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Controller xử lý tính năng so sánh sản phẩm.
 */
@WebServlet(name = "CompareControl", urlPatterns = {"/compare", "/compare/api/list"})
public class CompareControl extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/compare/api/list".equals(path)) {
            handleApiList(request, response);
        } else {
            handleViewCompare(request, response);
        }
    }

    /**
     * Render trang so sánh chi tiết.
     */
    private void handleViewCompare(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pid1 = request.getParameter("pid1");
        String pid2 = request.getParameter("pid2");
        String pid3 = request.getParameter("pid3");

        List<Map<String, Object>> products = new ArrayList<>();
        try {
            if (pid1 != null && !pid1.isEmpty()) products.add(productDAO.getProductById(pid1));
            if (pid2 != null && !pid2.isEmpty()) products.add(productDAO.getProductById(pid2));
            if (pid3 != null && !pid3.isEmpty()) products.add(productDAO.getProductById(pid3));
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("compareProducts", products);
        request.getRequestDispatcher("/compare.jsp").forward(request, response);
    }

    /**
     * Trả về danh sách sản phẩm dạng JSON cho bộ chọn modal.
     */
    private void handleApiList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String search = request.getParameter("q");

        try {
            List<Map<String, Object>> all = productDAO.getAllProducts();
            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            for (Map<String, Object> p : all) {
                String name = (String) p.get("ProductName");
                if (search != null && !search.isEmpty() && !name.toLowerCase().contains(search.toLowerCase())) {
                    continue;
                }

                if (!first) json.append(",");
                json.append("{")
                    .append("\"id\":\"").append(p.get("IdProduct")).append("\",")
                    .append("\"name\":\"").append(name.replace("\"", "\\\"")).append("\",")
                    .append("\"price\":\"").append(p.get("Price")).append("\",")
                    .append("\"image\":\"").append(p.get("ImagePath")).append("\"")
                    .append("}");
                first = false;
            }
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            out.print("[]");
        }
    }
}
