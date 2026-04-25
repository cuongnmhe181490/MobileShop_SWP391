package controller.review;

import dao.ReviewDAO;
import entity.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Admin logic for managing GeneralReview (Product & Service).
 */
@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final ReviewDAO dao = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String statusFilter = req.getParameter("status"); // "VISIBLE"|"HIDDEN"|null
        String typeFilter   = req.getParameter("type");   // "PRODUCT"|"SERVICE"|null
        
        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        try {
            List<Review> reviews = dao.adminGetAll(statusFilter, typeFilter, page, PAGE_SIZE);
            int total      = dao.adminCount(statusFilter, typeFilter);
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

            req.setAttribute("reviews",      reviews);
            req.setAttribute("totalReviews", total);
            req.setAttribute("totalPages",   totalPages);
            req.setAttribute("currentPage",  page);
            req.setAttribute("statusFilter", statusFilter);
            req.setAttribute("typeFilter",   typeFilter);

            req.getRequestDispatcher("/admin/adminReviews.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action   = req.getParameter("action");
        int    reviewId = Integer.parseInt(req.getParameter("reviewId"));

        try {
            if ("toggle".equals(action)) {
                Review current = dao.getById(reviewId);
                String newStatus = "VISIBLE".equals(current.getStatus()) ? "HIDDEN" : "VISIBLE";
                dao.updateStatus(reviewId, newStatus);

            } else if ("reply".equals(action)) {
                String replyContent = req.getParameter("replyContent");
                if (replyContent != null && !replyContent.isBlank()) {
                    dao.saveReply(reviewId, replyContent);
                }
            }

            // Redirect back with filters
            String redirect = req.getContextPath() + "/admin/reviews";
            String page   = req.getParameter("page");
            String status = req.getParameter("statusFilter");
            String type   = req.getParameter("typeFilter");
            
            StringBuilder sb = new StringBuilder(redirect);
            sb.append("?page=").append(page != null ? page : "1");
            if (status != null && !status.isEmpty()) sb.append("&status=").append(status);
            if (type != null && !type.isEmpty())     sb.append("&type=").append(type);

            resp.sendRedirect(sb.toString());

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
