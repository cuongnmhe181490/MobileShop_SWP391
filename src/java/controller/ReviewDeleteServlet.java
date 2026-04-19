package controller;

import dao.ReviewDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet xóa review.
 * GET /ReviewDeleteServlet -> redirect về danh sách
 * POST /ReviewDeleteServlet -> xóa review theo id
 */
@WebServlet(name = "ReviewDeleteServlet", urlPatterns = {"/ReviewDeleteServlet"})
public class ReviewDeleteServlet extends HttpServlet {

    private final ReviewDao dao = new ReviewDao();

    // GET: redirect về danh sách
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
    }

    // POST: xóa review
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        
        HttpSession session = request.getSession();
        
        if (idStr == null || idStr.isEmpty()) {
            session.setAttribute("flashError", "ID review không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "ID review không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
            return;
        }

        boolean success = dao.delete(id);

        if (success) {
            session.setAttribute("flashSuccess", "Xóa review thành công!");
        } else {
            session.setAttribute("flashError", "Xóa review thất bại. Vui lòng thử lại.");
        }

        // Redirect về trang danh sách
        response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
    }
}