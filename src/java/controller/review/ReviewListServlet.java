package controller.review;

import dao.ReviewDAO;
import entity.Review;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
        try {
            page = Math.max(1, Integer.parseInt(req.getParameter("page")));
        } catch (Exception ignored) {
        }

        try {
            List<Review> reviews = dao.getVisibleReviews(idProduct, star, page, PAGE_SIZE);
            for (Review r : reviews) {
                r.setImages(dao.getImages(r.getReviewId()));
            }
            int totalReviews = dao.countVisibleReviews(idProduct, null);
            int filteredCount = dao.countVisibleReviews(idProduct, star);
            int totalPages = (int) Math.ceil((double) filteredCount / PAGE_SIZE);
            double averageRating = dao.getAverageRating(idProduct);
            Map<Integer, Integer> starMap = dao.countByStar(idProduct);

            req.setAttribute("reviews", reviews);
            req.setAttribute("reviewCount", totalReviews);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", page);
            req.setAttribute("averageRating", averageRating);
            req.setAttribute("reviewCounts", starMap);
            req.setAttribute("selectedStar", star);
            req.setAttribute("pid", idProduct);
            
            int qPage = 1;
            try {
                qPage = Math.max(1, Integer.parseInt(req.getParameter("qpage")));
            } catch (Exception ignored) {
            }
            
            List<Review> questions = dao.getQuestions(idProduct, qPage, PAGE_SIZE);
            int totalQuestions = dao.countQuestions(idProduct);
            int totalQPages = (int) Math.ceil((double) totalQuestions / PAGE_SIZE);
            
            req.setAttribute("questions", questions);
            req.setAttribute("totalQuestions", totalQuestions);
            req.setAttribute("totalQPages", totalQPages);
            req.setAttribute("currentQPage", qPage);

            HttpSession session = req.getSession(false);
            boolean loggedIn = (session != null && session.getAttribute("acc") != null);
            boolean hasPurchased = false;
            
            if (loggedIn) {
                User acc = (User) session.getAttribute("acc");
                hasPurchased = dao.hasPurchasedProduct(acc.getId(), idProduct);
            }
            
            req.setAttribute("loggedIn", loggedIn);
            req.setAttribute("hasPurchased", hasPurchased);
            
            req.getRequestDispatcher("/reviewList.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idProduct = req.getParameter("pid");
        String questionContent = req.getParameter("questionContent");
        
        if (idProduct == null || idProduct.isBlank() || questionContent == null || questionContent.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/reviews?pid=" + idProduct + "&error=empty");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect(req.getContextPath() + "/reviews?pid=" + idProduct + "&error=login");
            return;
        }
        
        User acc = (User) session.getAttribute("acc");
        
        Review q = new Review();
        q.setReviewType("PRODUCT"); // Used to pass CHK_ReviewType constraint
        q.setIdProduct(idProduct);
        q.setUserId(acc.getId());
        q.setReviewContent(questionContent);
        q.setReviewTopic("Q&A"); // Marker for question logic
        q.setRanking(5); // Set to 5 to bypass DB CHECK (Ranking 1-5). Stars are hidden in UI for QUESTION.
        
        try {
            dao.insertReview(q);
            resp.sendRedirect(req.getContextPath() + "/reviews?pid=" + idProduct + "&success=asked#qa-tab");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
