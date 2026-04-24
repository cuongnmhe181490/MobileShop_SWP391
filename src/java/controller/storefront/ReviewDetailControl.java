package controller.storefront;

import dao.DAO;
import dao.product.ProductStorefrontDAO;
import entity.ProductModel;
import entity.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReviewDetailControl", urlPatterns = {"/reviews-v1"})
public class ReviewDetailControl extends HttpServlet {

    private static final int PAGE_SIZE = 4;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String productId = request.getParameter("pid");
        ProductStorefrontDAO dao = new ProductStorefrontDAO();
        ProductModel product = dao.getProductByID(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        Integer ranking = parseRanking(request.getParameter("star"));
        int page = parsePage(request.getParameter("page"));
        int totalReviews = dao.countProductReviews(productId, ranking);
        int totalPages = Math.max(1, (int) Math.ceil(totalReviews / (double) PAGE_SIZE));
        int safePage = Math.min(page, totalPages);
        int offset = (safePage - 1) * PAGE_SIZE;

        List<Review> reviews = dao.getProductReviews(productId, ranking, offset, PAGE_SIZE);
        Map<Integer, Integer> reviewCounts = dao.getReviewCountsByRating(productId);

        request.setAttribute("detailProduct", product);
        request.setAttribute("averageRating", dao.getAverageRating(productId));
        request.setAttribute("reviewCount", dao.getReviewCount(productId));
        request.setAttribute("reviewCounts", reviewCounts);
        request.setAttribute("reviews", reviews);
        request.setAttribute("selectedStar", ranking);
        request.setAttribute("currentPage", safePage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.getRequestDispatcher("reviews.jsp").forward(request, response);
    }

    private Integer parseRanking(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            int parsed = Integer.parseInt(value);
            return parsed >= 1 && parsed <= 5 ? parsed : null;
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private int parsePage(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed < 1 ? 1 : parsed;
        } catch (NumberFormatException ex) {
            return 1;
        }
    }
}
