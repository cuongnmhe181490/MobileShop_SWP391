package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet hiển thị danh sách Top Products (sản phẩm featured).
 * GET /TopProductListServlet → admin-top-product-list.jsp (có phân trang)
 * 
 * Dữ liệu được lấy từ ProductDetail với IsFeatured = 1
 */
@WebServlet(name = "TopProductListServlet", urlPatterns = {"/TopProductListServlet"})
public class TopProductListServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy search
        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim();
        }

        // Lấy page từ request, mặc định là 1
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        try {
            // Lấy tổng số bản ghi và tính số trang
            int totalCount = productDAO.getFeaturedCount(search);
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Lấy danh sách phân trang
            List<Map<String, Object>> featuredList = productDAO.getFeaturedProductsPaging(search, page, PAGE_SIZE);

            // Set attributes cho JSP
            request.setAttribute("search", search);
            request.setAttribute("featuredProductList", featuredList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalCount);
            request.setAttribute("pageSize", PAGE_SIZE);

            request.getRequestDispatcher("/admin-top-product-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách: " + e.getMessage());
            request.getRequestDispatcher("/admin-top-product-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}