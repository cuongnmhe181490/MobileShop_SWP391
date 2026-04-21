package controller.review;

import dao.ProductDAO;
import dao.ReviewDAO;
import entity.ProductReview;
import entity.ReviewImage;
import entity.User;
import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import util.CloudinaryUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * /review/write?pid=...        → Màn 2: Viết mới
 * /review/edit?id=...          → Màn 3: Chỉnh sửa
 * POST cả hai đều về đây
 */
@WebServlet("/review/write")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB (Total for 5 images)
)
public class ReviewWriteServlet extends HttpServlet {

    private final ReviewDAO dao = new ReviewDAO();
    private final ProductDAO pDao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // ... (existing doGet code remains the same)
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
                idProduct = review.getIdProduct(); // Lấy pid từ review cũ để fetch info
            } else {
                // ... (Màn 2 logic)
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

            // Fetch Product Info for Display
            if (idProduct != null) {
                Map<String, Object> product = pDao.getProductById(idProduct);
                if (product != null) {
                    req.setAttribute("productName",  product.get("ProductName"));
                    req.setAttribute("productImage", product.get("ImagePath"));
                }
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
        String rankingStr  = req.getParameter("ranking");
        int    ranking     = (rankingStr != null) ? Integer.parseInt(rankingStr) : 5;

        // Xử lý upload ảnh server-side (Giống HeroAdd)
        List<String> uploadedUrls = new ArrayList<>();
        Collection<Part> parts = req.getParts();
        for (Part part : parts) {
            if ("imageFiles".equals(part.getName()) && part.getSize() > 0) {
                String resultUrl = CloudinaryUtil.upload(part);
                if (resultUrl != null) {
                    uploadedUrls.add(resultUrl);
                }
            }
        }

        try {
            if ("edit".equals(mode)) {
                int reviewId = Integer.parseInt(req.getParameter("reviewId"));
                ProductReview existing = dao.getById(reviewId);

                if (existing == null || existing.getUserId() != acc.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                dao.updateReview(reviewId, content, ranking);

                // Nếu có ảnh mới thì cập nhật (xóa cũ, thêm mới)
                if (!uploadedUrls.isEmpty()) {
                    dao.deleteImages(reviewId);
                    dao.insertImages(buildImageList(reviewId, uploadedUrls));
                }

                resp.sendRedirect(req.getContextPath() + "/review/mine?success=updated");

            } else {
                String idProduct = req.getParameter("pid");

                if (dao.hasReviewed(acc.getId(), idProduct)) {
                    resp.sendRedirect(req.getContextPath() + "/reviews?pid=" + idProduct + "&error=duplicate");
                    return;
                }

                ProductReview r = new ProductReview();
                r.setIdProduct(idProduct);
                r.setUserId(acc.getId());
                r.setReviewContent(content);
                r.setRanking(ranking);

                int newId = dao.insertReview(r);

                if (!uploadedUrls.isEmpty()) {
                    dao.insertImages(buildImageList(newId, uploadedUrls));
                }

                resp.sendRedirect(req.getContextPath() + "/reviews?pid=" + idProduct + "&success=created");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private List<ReviewImage> buildImageList(int reviewId, List<String> urls) {
        List<ReviewImage> list = new ArrayList<>();
        for (int i = 0; i < urls.size(); i++) {
            list.add(new ReviewImage(reviewId, urls.get(i), i));
        }
        return list;
    }
}
