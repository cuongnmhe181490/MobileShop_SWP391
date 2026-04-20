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

/**
 * GET  /admin/reviews              → Màn 4: Danh sách
 * POST /admin/reviews?action=reply → Màn 5: Phản hồi
 * POST /admin/reviews?action=toggle→ Màn 5: Đổi status
 */
@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final ReviewDAO dao = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String statusFilter = req.getParameter("status"); // "VISIBLE"|"HIDDEN"|null
        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        try {
            List<ProductReview> reviews = dao.adminGetAll(statusFilter, page, PAGE_SIZE);
            int total      = dao.adminCount(statusFilter);
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

            req.setAttribute("reviews",      reviews);
            req.setAttribute("totalReviews", total);
            req.setAttribute("totalPages",   totalPages);
            req.setAttribute("currentPage",  page);
            req.setAttribute("statusFilter", statusFilter);

            req.getRequestDispatcher("/admin/adminReviews.jsp")
               .forward(req, resp);

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
                // Đổi VISIBLE ↔ HIDDEN
                ProductReview current = dao.getById(reviewId);
                String newStatus = "VISIBLE".equals(current.getStatus()) ? "HIDDEN" : "VISIBLE";
                dao.updateStatus(reviewId, newStatus);

            } else if ("reply".equals(action)) {
                String replyContent = req.getParameter("replyContent");
                if (replyContent != null && !replyContent.isBlank()) {
                    dao.saveReply(reviewId, replyContent);
                }
            }

            // Redirect về trang admin, giữ lại filter & page
            String redirect = req.getContextPath() + "/admin/reviews";
            String page   = req.getParameter("page");
            String status = req.getParameter("statusFilter");
            if (page != null)   redirect += "?page="   + page;
            if (status != null) redirect += (redirect.contains("?") ? "&" : "?") + "status=" + status;

            resp.sendRedirect(redirect);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
