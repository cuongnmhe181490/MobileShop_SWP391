package controller.review;

import dao.ReviewDAO;
import entity.ProductReview;
import entity.ReviewImage;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * /review/write?pid=...        → Màn 2: Viết mới
 * /review/edit?id=...          → Màn 3: Chỉnh sửa
 * POST cả hai đều về đây
 */
@WebServlet("/review/write")
public class ReviewWriteServlet extends HttpServlet {

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

        String idProduct  = req.getParameter("pid");
        String reviewIdStr = req.getParameter("id");  // có id → chế độ sửa

        try {
            if (reviewIdStr != null) {
                // ── Màn 3: Load form sửa ──
                int reviewId = Integer.parseInt(reviewIdStr);
                ProductReview review = dao.getById(reviewId);

                // Bảo vệ: chỉ chủ review mới được sửa
                if (review == null || review.getUserId() != acc.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                List<ReviewImage> images = dao.getImages(reviewId);
                req.setAttribute("review", review);
                req.setAttribute("images", images);
                req.setAttribute("mode",   "edit");
            } else {
                // ── Màn 2: Form viết mới ──
                if (idProduct == null || idProduct.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/");
                    return;
                }

                boolean already = dao.hasReviewed(acc.getId(), idProduct);
                if (already) {
                    req.setAttribute("errorMsg", "Bạn đã đánh giá sản phẩm này rồi.");
                }

                req.setAttribute("pid",  idProduct);
                req.setAttribute("mode", "create");
            }

            req.getRequestDispatcher("/reviewForm.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("acc") : null;
        if (acc == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String mode        = req.getParameter("mode");         // "create" | "edit"
        String content     = req.getParameter("reviewContent");
        int    ranking     = Integer.parseInt(req.getParameter("ranking"));
        // imageUrls được gửi lên từ client sau khi upload Cloudinary thành công
        String[] imageUrls = req.getParameterValues("imageUrls");

        try {
            if ("edit".equals(mode)) {
                int reviewId = Integer.parseInt(req.getParameter("reviewId"));
                ProductReview existing = dao.getById(reviewId);

                if (existing == null || existing.getUserId() != acc.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                dao.updateReview(reviewId, content, ranking);

                // Cập nhật ảnh nếu có upload mới
                if (imageUrls != null && imageUrls.length > 0) {
                    dao.deleteImages(reviewId);
                    List<ReviewImage> imgs = buildImageList(reviewId, imageUrls);
                    dao.insertImages(imgs);
                }

                resp.sendRedirect(req.getContextPath() +
                    "/review/mine?success=updated");

            } else {
                String idProduct = req.getParameter("pid");

                if (dao.hasReviewed(acc.getId(), idProduct)) {
                    resp.sendRedirect(req.getContextPath() +
                        "/reviews?pid=" + idProduct + "&error=duplicate");
                    return;
                }

                ProductReview r = new ProductReview();
                r.setIdProduct(idProduct);
                r.setUserId(acc.getId());
                r.setReviewContent(content);
                r.setRanking(ranking);

                int newId = dao.insertReview(r);

                if (imageUrls != null && imageUrls.length > 0) {
                    dao.insertImages(buildImageList(newId, imageUrls));
                }

                resp.sendRedirect(req.getContextPath() +
                    "/reviews?pid=" + idProduct + "&success=created");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private List<ReviewImage> buildImageList(int reviewId, String[] urls) {
        List<ReviewImage> list = new ArrayList<>();
        for (int i = 0; i < urls.length; i++) {
            if (urls[i] != null && !urls[i].isBlank()) {
                list.add(new ReviewImage(reviewId, urls[i], i));
            }
        }
        return list;
    }
}
