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
 * Servlet thêm mới review.
 * GET /ReviewAddServlet -> hiển thị form thêm review
 * POST /ReviewAddServlet -> lưu review mới
 */
@WebServlet(name = "ReviewAddServlet", urlPatterns = {"/ReviewAddServlet"})
public class ReviewAddServlet extends HttpServlet {

    private final ReviewDao dao = new ReviewDao();

    // GET: hiển thị form thêm
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin-review-add.jsp").forward(request, response);
    }

    // POST: lưu review mới
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String idProductStr = request.getParameter("idProduct");
        String idAccountStr = request.getParameter("idAccount");
        String reviewerName = trim(request.getParameter("reviewerName"));
        String rankingStr = request.getParameter("ranking");
        String review = trim(request.getParameter("review"));
        String isVerifiedStr = request.getParameter("isVerified");

        // Validation
        if (reviewerName == null || reviewerName.isEmpty()) {
            request.setAttribute("error", "Tên người đánh giá không được để trống.");
            request.getRequestDispatcher("/admin-review-add.jsp").forward(request, response);
            return;
        }

        if (rankingStr == null || rankingStr.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn số sao.");
            request.getRequestDispatcher("/admin-review-add.jsp").forward(request, response);
            return;
        }

        int idProduct, idAccount, ranking;
        try {
            idProduct = Integer.parseInt(idProductStr);
            idAccount = Integer.parseInt(idAccountStr);
            ranking = Integer.parseInt(rankingStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            request.getRequestDispatcher("/admin-review-add.jsp").forward(request, response);
            return;
        }

        if (ranking < 1 || ranking > 5) {
            request.setAttribute("error", "Số sao phải từ 1 đến 5.");
            request.getRequestDispatcher("/admin-review-add.jsp").forward(request, response);
            return;
        }

        // Tạo review object
        Review newReview = new Review();
        newReview.setIdProduct(idProduct);
        newReview.setIdAccount(idAccount);
        newReview.setReviewerName(reviewerName);
        newReview.setRanking(ranking);
        newReview.setReview(review != null ? review : "");
        newReview.setVerified("on".equals(isVerifiedStr));

        // Lưu vào DB
        int newId = dao.insert(newReview);

        HttpSession session = request.getSession();
        if (newId > 0) {
            session.setAttribute("flashSuccess", "Thêm review thành công!");
        } else {
            session.setAttribute("flashError", "Thêm review thất bại. Vui lòng thử lại.");
        }

        // Redirect về trang danh sách
        response.sendRedirect(request.getContextPath() + "/ReviewListServlet");
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}