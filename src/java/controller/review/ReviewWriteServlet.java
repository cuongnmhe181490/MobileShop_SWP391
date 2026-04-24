package controller.review;

import dao.ProductDAO;
import dao.ReviewDAO;
import entity.Review;
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
 * Handlers writing/editing for both PRODUCT and SERVICE reviews.
 * Form entry: 
 *   /review/write?pid=... (Product mode)
 *   /review/write?type=SERVICE (Service mode)
 */
@WebServlet("/review/write")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class ReviewWriteServlet extends HttpServlet {

    private final ReviewDAO dao = new ReviewDAO();
    private final ProductDAO pDao = new ProductDAO();

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
        String type       = req.getParameter("type"); // Can be "SERVICE"
        String reviewIdStr = req.getParameter("id");  // Edit mode

        if (type == null) type = "PRODUCT"; // Default

        try {
            if (reviewIdStr != null) {
                // ── Mode: EDIT ──
                int reviewId = Integer.parseInt(reviewIdStr);
                Review review = dao.getById(reviewId);

                if (review == null || review.getUserId() != acc.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                req.setAttribute("review", review);
                req.setAttribute("mode",   "edit");
                type = review.getReviewType();
                idProduct = review.getIdProduct();
            } else {
                // ── Mode: CREATE ──
                // Check if already reviewed
                boolean already = dao.hasReviewed(acc.getId(), idProduct, type);
                if (already) {
                    req.setAttribute("errorMsg", "SERVICE".equals(type) ? 
                        "Bạn đã gửi đánh giá dịch vụ trước đó rồi." : 
                        "Bạn đã đánh giá sản phẩm này rồi.");
                }
                req.setAttribute("mode", "create");
            }

            // Fetch metadata for UI
            req.setAttribute("type", type);
            req.setAttribute("pid",  idProduct);

            if ("PRODUCT".equals(type) && idProduct != null) {
                Map<String, Object> product = pDao.getProductById(idProduct);
                if (product != null) {
                    req.setAttribute("productName",  product.get("ProductName"));
                    req.setAttribute("productImage", product.get("ImagePath"));
                    req.setAttribute("productPrice", product.get("Price"));
                }
            }

            req.getRequestDispatcher("/reviewForm.jsp").forward(req, resp);

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

        String type        = req.getParameter("type");         // "PRODUCT" | "SERVICE"
        String mode        = req.getParameter("mode");         // "create" | "edit"
        String content     = req.getParameter("reviewContent");
        String rankingStr  = req.getParameter("ranking");
        int    ranking     = (rankingStr != null) ? Integer.parseInt(rankingStr) : 5;
        
        // Handle multiple topics (for service mode)
        String[] topicsArr = req.getParameterValues("topics");
        String finalTopic  = (topicsArr != null) ? String.join(", ", topicsArr) : null;

        // Image Upload
        List<String> uploadedUrls = new ArrayList<>();
        Collection<Part> parts = req.getParts();
        for (Part part : parts) {
            if ("imageFiles".equals(part.getName()) && part.getSize() > 0) {
                String resultUrl = CloudinaryUtil.upload(part);
                if (resultUrl != null) uploadedUrls.add(resultUrl);
            }
        }

        try {
            if ("edit".equals(mode)) {
                int reviewId = Integer.parseInt(req.getParameter("reviewId"));
                Review existing = dao.getById(reviewId);

                if (existing == null || existing.getUserId() != acc.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                // Topic update only matters for Service, but we store it for consistency
                dao.updateReview(reviewId, content, ranking, finalTopic);

                if (!uploadedUrls.isEmpty()) {
                    dao.deleteImages(reviewId);
                    dao.insertImages(buildImageList(reviewId, uploadedUrls));
                }

                resp.sendRedirect(req.getContextPath() + "/review/mine?success=updated");

            } else {
                String idProduct = req.getParameter("pid");

                if (dao.hasReviewed(acc.getId(), idProduct, type)) {
                    String redirect = "PRODUCT".equals(type) ? 
                        "/reviews?pid=" + idProduct + "&error=duplicate" :
                        "/reviews?type=SERVICE&error=duplicate";
                    resp.sendRedirect(req.getContextPath() + redirect);
                    return;
                }

                Review r = new Review();
                r.setReviewType(type);
                r.setIdProduct(idProduct);
                r.setUserId(acc.getId());
                r.setReviewContent(content);
                r.setReviewTopic(finalTopic);
                r.setRanking(ranking);

                int newId = dao.insertReview(r);
                if (!uploadedUrls.isEmpty()) {
                    dao.insertImages(buildImageList(newId, uploadedUrls));
                }

                String redirect = "PRODUCT".equals(type) ? 
                    "/reviews?pid=" + idProduct + "&success=created" :
                    "/reviews?type=SERVICE&success=created";
                resp.sendRedirect(req.getContextPath() + redirect);
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
