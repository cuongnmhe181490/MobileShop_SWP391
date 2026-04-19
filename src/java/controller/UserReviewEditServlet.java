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
import java.sql.Timestamp;

/**
 * Servlet người dùng sửa review của chính mình.
 * GET /UserReviewEditServlet -> hiển thị form sửa
 * GET /UserReviewEditServlet?id=N -> load review của chính mình vào form
 * POST /UserReviewEditServlet -> cập nhật review
 * 
 * Lưu ý: Người dùng chỉ được sửa review của chính mình trong vòng 24h.
 */
@WebServlet(name = "UserReviewEditServlet", urlPatterns = {"/UserReviewEditServlet"})
public class UserReviewEditServlet extends HttpServlet {

    private final ReviewDao dao = new ReviewDao();

    // GET: hiển thị form sửa
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object acc = session.getAttribute("acc");
        
        // Kiểm tra user đã đăng nhập chưa
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy idAccount từ session (giả định acc có getId())
        int idAccount = getAccountId(acc);

        Review review = null;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                review = dao.getById(id);
                
                // Kiểm tra review có thuộc về user không
                if (review != null && review.getIdAccount() != idAccount) {
                    request.setAttribute("error", "Bạn không có quyền sửa review này.");
                    request.getRequestDispatcher("/reviews.jsp").forward(request, response);
                    return;
                }
                
                // Kiểm tra thời hạn sửa (24h)
                if (review != null && !canEdit(review.getReviewDate())) {
                    request.setAttribute("error", "Bạn chỉ có thể sửa review trong vòng 24 giờ.");
                    request.getRequestDispatcher("/reviews.jsp").forward(request, response);
                    return;
                }
                
            } catch (Exception ignored) {}
        }

        if (review == null) {
            response.sendRedirect(request.getContextPath() + "/reviews.jsp");
            return;
        }

        request.setAttribute("review", review);
        request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
    }

    // POST: cập nhật review
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        Object acc = session.getAttribute("acc");
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idAccount = getAccountId(acc);

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reviews.jsp");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reviews.jsp");
            return;
        }

        // Lấy review gốc để kiểm tra quyền
        Review existingReview = dao.getById(id);
        if (existingReview == null) {
            response.sendRedirect(request.getContextPath() + "/reviews.jsp");
            return;
        }

        if (existingReview.getIdAccount() != idAccount) {
            request.setAttribute("error", "Bạn không có quyền sửa review này.");
            request.setAttribute("review", existingReview);
            request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
            return;
        }

        if (!canEdit(existingReview.getReviewDate())) {
            request.setAttribute("error", "Bạn chỉ có thể sửa review trong vòng 24 giờ.");
            request.setAttribute("review", existingReview);
            request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
            return;
        }

        String rankingStr = request.getParameter("ranking");
        String review = trim(request.getParameter("review"));

        // Validation
        if (rankingStr == null || rankingStr.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn số sao.");
            request.setAttribute("review", existingReview);
            request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
            return;
        }

        int ranking;
        try {
            ranking = Integer.parseInt(rankingStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số sao không hợp lệ.");
            request.setAttribute("review", existingReview);
            request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
            return;
        }

        if (ranking < 1 || ranking > 5) {
            request.setAttribute("error", "Số sao phải từ 1 đến 5.");
            request.setAttribute("review", existingReview);
            request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
            return;
        }

        // Cập nhật review (chỉ sửa ranking và review content, không sửa các trường khác)
        boolean success = dao.updateUserReview(id, ranking, review != null ? review : "");

        if (success) {
            session.setAttribute("flashSuccess", "Cập nhật đánh giá thành công!");
            // Redirect về trang chi tiết sản phẩm
            String productId = request.getParameter("productId");
            if (productId != null && !productId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/reviews?pid=" + productId);
            } else {
                response.sendRedirect(request.getContextPath() + "/reviews.jsp");
            }
        } else {
            request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
            request.setAttribute("review", existingReview);
            request.getRequestDispatcher("/user-review-edit.jsp").forward(request, response);
        }
    }

    // Kiểm tra có thể sửa trong vòng 24h không
    private boolean canEdit(Timestamp reviewDate) {
        if (reviewDate == null) return false;
        long diff = System.currentTimeMillis() - reviewDate.getTime();
        return diff < 24 * 60 * 60 * 1000; // 24 giờ
    }

    // Lấy idAccount từ object acc (tùy vào cấu trúc của acc)
    private int getAccountId(Object acc) {
        try {
            // Giả định acc có method getId() hoặc tương tự
            java.lang.reflect.Method method = acc.getClass().getMethod("getId");
            return (int) method.invoke(acc);
        } catch (Exception e) {
            // Nếu không lấy được, thử các method khác
            try {
                java.lang.reflect.Method method = acc.getClass().getMethod("getIdAccount");
                return (int) method.invoke(acc);
            } catch (Exception ex) {
                return 0;
            }
        }
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}