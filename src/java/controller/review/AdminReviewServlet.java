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

        String action       = req.getParameter("action");
        String statusFilter = req.getParameter("status"); // "VISIBLE"|"HIDDEN"|null
        String typeFilter   = req.getParameter("type");   // "PRODUCT"|"SERVICE"|null
        Integer starFilter  = null;
        try {
            String starStr = req.getParameter("star");
            if (starStr != null && !starStr.isEmpty()) {
                starFilter = Integer.parseInt(starStr);
            }
        } catch (Exception ignored) {}
        
        if ("export".equals(action)) {
            exportToCSV(resp, statusFilter, typeFilter, starFilter);
            return;
        }

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        try {
            List<Review> reviews = dao.adminGetAll(statusFilter, typeFilter, starFilter, page, PAGE_SIZE);
            int total      = dao.adminCount(statusFilter, typeFilter, starFilter);
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

            req.setAttribute("reviews",      reviews);
            req.setAttribute("totalReviews", total);
            req.setAttribute("totalPages",   totalPages);
            req.setAttribute("currentPage",  page);
            req.setAttribute("statusFilter", statusFilter);
            req.setAttribute("typeFilter",   typeFilter);
            req.setAttribute("starFilter",   starFilter);

            req.getRequestDispatcher("/admin/adminReviews.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void exportToCSV(HttpServletResponse resp, String statusFilter, String typeFilter, Integer starFilter) {
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"reviews_export.csv\"");

        try {
            // Write BOM for UTF-8 support in Excel
            resp.getOutputStream().write(0xEF);
            resp.getOutputStream().write(0xBB);
            resp.getOutputStream().write(0xBF);

            try (java.io.PrintWriter writer = new java.io.PrintWriter(new java.io.OutputStreamWriter(resp.getOutputStream(), "UTF-8"))) {
                writer.println("ID,Loại,Sản phẩm,Người đánh giá,Nội dung,Số sao,Trạng thái,Ngày ghép");
                
                // Fetch a large number of rows for export instead of paginating
                List<Review> exportList = dao.adminGetAll(statusFilter, typeFilter, starFilter, 1, 100000);
                for(Review r : exportList) {
                    writer.printf("%d,%s,\"%s\",\"%s\",\"%s\",%d,%s,\"%s\"\n",
                            r.getReviewId(),
                            r.getReviewType() != null ? r.getReviewType() : "",
                            r.getProductName() != null ? r.getProductName().replace("\"", "\"\"") : "",
                            r.getReviewerName() != null ? r.getReviewerName().replace("\"", "\"\"") : "",
                            r.getReviewContent() != null ? r.getReviewContent().replace("\"", "\"\"").replace("\n", " ").replace("\r", "") : "",
                            r.getRanking(),
                            r.getStatus() != null ? r.getStatus() : "",
                            r.getReviewDate() != null ? r.getReviewDate().toString() : ""
                    );
                }
                writer.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
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
            String star   = req.getParameter("starFilter");
            
            StringBuilder sb = new StringBuilder(redirect);
            sb.append("?page=").append(page != null ? page : "1");
            if (status != null && !status.isEmpty()) sb.append("&status=").append(status);
            if (type != null && !type.isEmpty())     sb.append("&type=").append(type);
            if (star != null && !star.isEmpty())     sb.append("&star=").append(star);

            resp.sendRedirect(sb.toString());

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
