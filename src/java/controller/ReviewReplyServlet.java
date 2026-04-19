package controller;

import dao.ReviewDao;
import entity.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet Admin phản hồi review.
 * GET /ReviewReplyServlet -> hiển thị form phản hồi
 * GET /ReviewReplyServlet?id=N -> load review vào form
 * POST /ReviewReplyServlet -> lưu phản hồi
 * 
 * Lưu ý: Admin KHÔNG sửa nội dung review của khách, chỉ phản hồi.
 */
@WebServlet(name = "ReviewReplyServlet", urlPatterns = {"/ReviewReplyServlet"})
public class ReviewReplyServlet extends HttpServlet {

    private final ReviewDao dao = new ReviewDao();

    // GET: hiển thị form phản hồi
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Review review = null;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                review = dao.getById(id);
            } catch (Exception ignored) {}
        }

        if (review == null) {
            response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
            return;
        }

        request.setAttribute("review", review);
        request.getRequestDispatcher("/admin-review-reply.jsp").forward(request, response);
    }

    // POST: lưu phản hồi
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
            return;
        }

        String replyContent = trim(request.getParameter("replyContent"));

        if (replyContent == null || replyContent.isEmpty()) {
            request.setAttribute("error", "Nội dung phản hồi không được để trống.");
            Review review = dao.getById(id);
            request.setAttribute("review", review);
            request.getRequestDispatcher("/admin-review-reply.jsp").forward(request, response);
            return;
        }

        boolean success = dao.updateReply(id, replyContent);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flashSuccess", "Phản hồi review thành công!");
        } else {
            session.setAttribute("flashError", "Phản hồi thất bại. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}