package controller.review;

import dao.ReviewDAO;
import entity.ProductReview;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/reviews")
public class ReviewListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;
    private final ReviewDAO dao = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idProduct = req.getParameter("pid");
        if (idProduct == null || idProduct.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Lọc sao
        Integer star = null;
        String starParam = req.getParameter("star");
        if (starParam != null && starParam.matches("[1-5]")) {
            star = Integer.parseInt(starParam);
        }

        // Phân trang
        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        try {
            List<ProductReview> reviews    = dao.getVisibleReviews(idProduct, star, page, PAGE_SIZE);
            int totalReviews               = dao.countVisibleReviews(idProduct, null);
            int filteredCount              = dao.countVisibleReviews(idProduct, star);
            int totalPages                 = (int) Math.ceil((double) filteredCount / PAGE_SIZE);
            double averageRating           = dao.getAverageRating(idProduct);
            Map<Integer, Integer> starMap  = dao.countByStar(idProduct);

            req.setAttribute("reviews",       reviews);
            req.setAttribute("reviewCount",   totalReviews);
            req.setAttribute("totalPages",    totalPages);
            req.setAttribute("currentPage",   page);
            req.setAttribute("averageRating", averageRating);
            req.setAttribute("reviewCounts",  starMap);
            req.setAttribute("selectedStar",  star);
            req.setAttribute("pid",           idProduct);

            req.getRequestDispatcher("/reviewList.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
