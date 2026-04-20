package controller.review;

import dao.ReviewDAO;
import entity.ProductReview;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * GET  /review/mine          → Màn 6: Danh sách review của tôi
 * POST /review/mine?action=delete → Xóa review
 */
@WebServlet("/review/mine")
public class MyReviewServlet extends HttpServlet {

    private final ReviewDAO dao = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<ProductReview> reviews = dao.getByUser(acc.getId());
            req.setAttribute("reviews", reviews);
            req.setAttribute("successMsg", req.getParameter("success"));

            req.getRequestDispatcher("/customer/myReviews.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int reviewId = Integer.parseInt(req.getParameter("reviewId"));
                dao.deleteReview(reviewId, acc.getId()); // tự kiểm tra ownership
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/review/mine");
    }
}
