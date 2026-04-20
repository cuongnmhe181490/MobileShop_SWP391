package dao;

import entity.ProductReview;
import entity.ReviewImage;
import config.DBContext;

import java.sql.*;
import java.util.*;

public class ReviewDAO {

    // ─────────────────────────────────────────────
    // MÀN 1: Chi tiết & Lọc sao
    // ─────────────────────────────────────────────

    /** Lấy danh sách review VISIBLE của 1 sản phẩm, có lọc sao + phân trang */
    public List<ProductReview> getVisibleReviews(String idProduct, Integer star,
                                                  int page, int pageSize) throws Exception {
        List<ProductReview> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT pr.ReviewId, pr.UserId, pr.ReviewDate, pr.ReviewContent, " +
            "       pr.Ranking, pr.ReplyContent, pr.ReplyDate, u.FullName " +
            "FROM ProductReview pr " +
            "JOIN [User] u ON pr.UserId = u.UserId " +
            "WHERE pr.IdProduct = ? AND pr.[Status] = 'VISIBLE' "
        );
        if (star != null) sql.append("AND pr.Ranking = ? ");
        sql.append("ORDER BY pr.ReviewDate DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setString(idx++, idProduct);
            if (star != null) ps.setInt(idx++, star);
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx,   pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductReview r = mapRow(rs);
                r.setIdProduct(idProduct);
                list.add(r);
            }
        }
        return list;
    }

    /** Đếm tổng review VISIBLE theo sản phẩm + lọc sao (dùng phân trang) */
    public int countVisibleReviews(String idProduct, Integer star) throws Exception {
        String sql = "SELECT COUNT(*) FROM ProductReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE'" +
                     (star != null ? " AND Ranking = ?" : "");
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            if (star != null) ps.setInt(2, star);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Đếm review theo từng mức sao của 1 sản phẩm (dùng cho filter chips) */
    public Map<Integer, Integer> countByStar(String idProduct) throws Exception {
        Map<Integer, Integer> map = new LinkedHashMap<>();
        // Khởi tạo 5→1 để hiển thị đúng thứ tự
        for (int i = 5; i >= 1; i--) map.put(i, 0);

        String sql = "SELECT Ranking, COUNT(*) AS cnt " +
                     "FROM ProductReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE' " +
                     "GROUP BY Ranking";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) map.put(rs.getInt("Ranking"), rs.getInt("cnt"));
        }
        return map;
    }

    /** Tính điểm trung bình của 1 sản phẩm */
    public double getAverageRating(String idProduct) throws Exception {
        String sql = "SELECT AVG(CAST(Ranking AS FLOAT)) FROM ProductReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE'";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    // ─────────────────────────────────────────────
    // MÀN 2: Viết review mới
    // ─────────────────────────────────────────────

    /** Kiểm tra user đã review sản phẩm này chưa */
    public boolean hasReviewed(int userId, String idProduct) throws Exception {
        String sql = "SELECT 1 FROM ProductReview WHERE UserId = ? AND IdProduct = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, idProduct);
            return ps.executeQuery().next();
        }
    }

    /** Tạo review mới, trả về ReviewId vừa insert */
    public int insertReview(ProductReview r) throws Exception {
        String sql = "INSERT INTO ProductReview (IdProduct, UserId, ReviewContent, Ranking, [Status]) " +
                     "VALUES (?, ?, ?, ?, 'VISIBLE')";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getIdProduct());
            ps.setInt(2,    r.getUserId());
            ps.setString(3, r.getReviewContent());
            ps.setInt(4,    r.getRanking());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            return keys.next() ? keys.getInt(1) : -1;
        }
    }

    /** Lưu danh sách ảnh cho 1 review */
    public void insertImages(List<ReviewImage> images) throws Exception {
        String sql = "INSERT INTO ReviewImage (ReviewId, ImageUrl, SortOrder) VALUES (?, ?, ?)";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            for (ReviewImage img : images) {
                ps.setInt(1,    img.getReviewId());
                ps.setString(2, img.getImageUrl());
                ps.setInt(3,    img.getSortOrder());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // ─────────────────────────────────────────────
    // MÀN 3: Chỉnh sửa review
    // ─────────────────────────────────────────────

    /** Lấy 1 review theo ID (dùng load form sửa) */
    public ProductReview getById(int reviewId) throws Exception {
        String sql = "SELECT pr.*, u.FullName FROM ProductReview pr " +
                     "JOIN [User] u ON pr.UserId = u.UserId " +
                     "WHERE pr.ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductReview r = mapRow(rs);
                r.setIdProduct(rs.getString("IdProduct"));
                r.setStatus(rs.getString("Status"));
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                return r;
            }
            return null;
        }
    }

    /** Cập nhật nội dung + sao (chỉ cho phép sửa content & ranking) */
    public void updateReview(int reviewId, String content, int ranking) throws Exception {
        String sql = "UPDATE ProductReview SET ReviewContent = ?, Ranking = ? WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.setInt(2,    ranking);
            ps.setInt(3,    reviewId);
            ps.executeUpdate();
        }
    }

    /** Xóa toàn bộ ảnh cũ của review (trước khi insert ảnh mới) */
    public void deleteImages(int reviewId) throws Exception {
        String sql = "DELETE FROM ReviewImage WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.executeUpdate();
        }
    }

    /** Lấy danh sách ảnh của 1 review */
    public List<ReviewImage> getImages(int reviewId) throws Exception {
        List<ReviewImage> list = new ArrayList<>();
        String sql = "SELECT * FROM ReviewImage WHERE ReviewId = ? ORDER BY SortOrder";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReviewImage img = new ReviewImage();
                img.setId(rs.getInt("Id"));
                img.setReviewId(rs.getInt("ReviewId"));
                img.setImageUrl(rs.getString("ImageUrl"));
                img.setSortOrder(rs.getInt("SortOrder"));
                list.add(img);
            }
        }
        return list;
    }

    // ─────────────────────────────────────────────
    // MÀN 4+5: Admin quản lý & phản hồi
    // ─────────────────────────────────────────────

    /** Admin: lấy tất cả review (có thể lọc status) + phân trang */
    public List<ProductReview> adminGetAll(String statusFilter, int page, int pageSize) throws Exception {
        List<ProductReview> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT pr.ReviewId, pr.IdProduct, pr.UserId, pr.ReviewDate, " +
            "       pr.ReviewContent, pr.Ranking, pr.[Status], " +
            "       pr.ReplyContent, pr.ReplyDate, " +
            "       u.FullName, pd.ProductName " +
            "FROM ProductReview pr " +
            "JOIN [User] u ON pr.UserId = u.UserId " +
            "JOIN ProductDetail pd ON pr.IdProduct = pd.IdProduct "
        );
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("WHERE pr.[Status] = ? ");
        }
        sql.append("ORDER BY pr.ReviewDate DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) ps.setString(idx++, statusFilter);
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx,   pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductReview r = mapRow(rs);
                r.setIdProduct(rs.getString("IdProduct"));
                r.setStatus(rs.getString("Status"));
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                r.setProductName(rs.getString("ProductName"));
                list.add(r);
            }
        }
        return list;
    }

    /** Admin: đếm tổng review (dùng phân trang) */
    public int adminCount(String statusFilter) throws Exception {
        String sql = "SELECT COUNT(*) FROM ProductReview" +
                     (statusFilter != null && !statusFilter.isEmpty() ? " WHERE [Status] = ?" : "");
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            if (statusFilter != null && !statusFilter.isEmpty()) ps.setString(1, statusFilter);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Admin: đổi trạng thái VISIBLE ↔ HIDDEN */
    public void updateStatus(int reviewId, String status) throws Exception {
        String sql = "UPDATE ProductReview SET [Status] = ? WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2,    reviewId);
            ps.executeUpdate();
        }
    }

    /** Admin: lưu phản hồi */
    public void saveReply(int reviewId, String replyContent) throws Exception {
        String sql = "UPDATE ProductReview SET ReplyContent = ?, ReplyDate = GETDATE() WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, replyContent);
            ps.setInt(2,    reviewId);
            ps.executeUpdate();
        }
    }

    // ─────────────────────────────────────────────
    // MÀN 6: Đánh giá của tôi (Customer)
    // ─────────────────────────────────────────────

    /** Lấy tất cả review của 1 user kèm tên sản phẩm + ảnh sản phẩm */
    public List<ProductReview> getByUser(int userId) throws Exception {
        List<ProductReview> list = new ArrayList<>();
        String sql =
            "SELECT pr.ReviewId, pr.IdProduct, pr.ReviewDate, pr.ReviewContent, " +
            "       pr.Ranking, pr.[Status], pr.ReplyContent, pr.ReplyDate, " +
            "       u.FullName, pd.ProductName, pd.ImagePath " +
            "FROM ProductReview pr " +
            "JOIN [User] u ON pr.UserId = u.UserId " +
            "JOIN ProductDetail pd ON pr.IdProduct = pd.IdProduct " +
            "WHERE pr.UserId = ? " +
            "ORDER BY pr.ReviewDate DESC";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductReview r = mapRow(rs);
                r.setIdProduct(rs.getString("IdProduct"));
                r.setStatus(rs.getString("Status"));
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                r.setProductName(rs.getString("ProductName"));
                r.setProductImage(rs.getString("ImagePath"));
                r.setUserId(userId);
                list.add(r);
            }
        }
        return list;
    }

    /** Xóa review (chỉ cho phép nếu userId khớp) */
    public void deleteReview(int reviewId, int userId) throws Exception {
        String sql = "DELETE FROM ProductReview WHERE ReviewId = ? AND UserId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    // ─────────────────────────────────────────────
    // Helper
    // ─────────────────────────────────────────────
    private ProductReview mapRow(ResultSet rs) throws SQLException {
        ProductReview r = new ProductReview();
        r.setReviewId(rs.getInt("ReviewId"));
        r.setUserId(rs.getInt("UserId"));
        r.setReviewDate(rs.getTimestamp("ReviewDate"));
        r.setReviewContent(rs.getString("ReviewContent"));
        r.setRanking(rs.getInt("Ranking"));
        r.setReviewerName(rs.getString("FullName"));
        return r;
    }
}
