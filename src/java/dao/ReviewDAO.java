package dao;

import entity.Review;
import entity.ReviewImage;
import config.DBContext;

import java.sql.*;
import java.util.*;

public class ReviewDAO {

    // ─────────────────────────────────────────────
    // MÀN 1: Chi tiết & Lọc sao (Product Reviews)
    // ─────────────────────────────────────────────

    /** Lấy danh sách review VISIBLE của 1 sản phẩm, có lọc sao + phân trang */
    public List<Review> getVisibleReviews(String idProduct, Integer star,
                                             int page, int pageSize) throws Exception {
        List<Review> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.ReviewId, r.UserId, r.ReviewDate, r.ReviewContent, r.ReviewTopic, " +
            "       r.Ranking, r.ReplyContent, r.ReplyDate, u.FullName " +
            "FROM GeneralReview r " +
            "JOIN [User] u ON r.UserId = u.UserId " +
            "WHERE r.IdProduct = ? AND r.[Status] = 'VISIBLE' AND r.ReviewType = 'PRODUCT' AND (r.ReviewTopic IS NULL OR r.ReviewTopic != 'Q&A') "
        );
        if (star != null) sql.append("AND r.Ranking = ? ");
        sql.append("ORDER BY r.ReviewDate DESC ");
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
                Review r = mapRow(rs);
                r.setIdProduct(idProduct);
                r.setReviewType("PRODUCT");
                list.add(r);
            }
        }
        return list;
    }

    /** Đếm tổng review VISIBLE theo sản phẩm + lọc sao (dùng phân trang) */
    public int countVisibleReviews(String idProduct, Integer star) throws Exception {
        String sql = "SELECT COUNT(*) FROM GeneralReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE' AND ReviewType = 'PRODUCT' AND (ReviewTopic IS NULL OR ReviewTopic != 'Q&A') " +
                     (star != null ? " AND Ranking = ?" : "");
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            if (star != null) ps.setInt(2, star);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Tính điểm trung bình của 1 sản phẩm */
    public double getAverageRating(String idProduct) throws Exception {
        String sql = "SELECT AVG(CAST(Ranking AS FLOAT)) FROM GeneralReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE' AND ReviewType = 'PRODUCT' AND (ReviewTopic IS NULL OR ReviewTopic != 'Q&A')";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    /** Lấy danh sách câu hỏi (Q&A) của 1 sản phẩm */
    public List<Review> getQuestions(String idProduct, int page, int pageSize) throws Exception {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.ReviewId, r.UserId, r.ReviewDate, r.ReviewContent, r.ReviewTopic, " +
                     "       r.Ranking, r.ReplyContent, r.ReplyDate, u.FullName " +
                     "FROM GeneralReview r " +
                     "JOIN [User] u ON r.UserId = u.UserId " +
                     "WHERE r.IdProduct = ? AND r.[Status] = 'VISIBLE' AND r.ReviewType = 'PRODUCT' AND r.ReviewTopic = 'Q&A' " +
                     "ORDER BY r.ReviewDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = mapRow(rs);
                r.setIdProduct(idProduct);
                r.setReviewType("QUESTION"); // map back as QUESTION for logic
                r.setReviewTopic("Q&A");
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                list.add(r);
            }
        }
        return list;
    }

    /** Đếm tổng số câu hỏi (Q&A) của sản phẩm */
    public int countQuestions(String idProduct) throws Exception {
        String sql = "SELECT COUNT(*) FROM GeneralReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE' AND ReviewType = 'PRODUCT' AND ReviewTopic = 'Q&A'";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ─────────────────────────────────────────────
    // MÀN 2: Viết review mới (Product & Service)
    // ─────────────────────────────────────────────

    /** Kiểm tra user đã review sản phẩm này chưa (nếu pid != null) 
     *  Hoặc đã review dịch vụ chưa (nếu pid == null) 
     */
    public boolean hasReviewed(int userId, String idProduct, String type) throws Exception {
        String sql;
        if ("PRODUCT".equals(type)) {
            sql = "SELECT 1 FROM GeneralReview WHERE UserId = ? AND IdProduct = ? AND ReviewType = 'PRODUCT'";
        } else {
            sql = "SELECT 1 FROM GeneralReview WHERE UserId = ? AND ReviewType = 'SERVICE'";
        }
        
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if ("PRODUCT".equals(type)) ps.setString(2, idProduct);
            return ps.executeQuery().next();
        }
    }

    /** Kiểm tra xem user đã có đơn hàng TRẠNG THÁI Hoàn thành (có sản phẩm tương ứng) hay chưa */
    public boolean hasPurchasedProduct(int userId, String idProduct) throws Exception {
        String sql = "SELECT TOP 1 1 FROM [Order] o " +
                     "JOIN OrderDetail od ON o.IdOrder = od.IdOrder " +
                     "WHERE o.UserId = ? AND od.IdProduct = ? AND o.OrderStatus = N'Hoàn thành'";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, idProduct);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    /** Tạo review mới, trả về ReviewId vừa insert */
    public int insertReview(Review r) throws Exception {
        String sql = "INSERT INTO GeneralReview (ReviewType, IdProduct, UserId, ReviewContent, ReviewTopic, Ranking, [Status]) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'VISIBLE')";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getReviewType());
            ps.setString(2, r.getIdProduct()); // Might be null for service
            ps.setInt(3,    r.getUserId());
            ps.setString(4, r.getReviewContent());
            ps.setString(5, r.getReviewTopic());
            ps.setInt(6,    r.getRanking());
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
    public Review getById(int reviewId) throws Exception {
        String sql = "SELECT r.*, u.FullName FROM GeneralReview r " +
                     "JOIN [User] u ON r.UserId = u.UserId " +
                     "WHERE r.ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review r = mapRow(rs);
                r.setIdProduct(rs.getString("IdProduct"));
                r.setReviewType(rs.getString("ReviewType"));
                r.setReviewTopic(rs.getString("ReviewTopic"));
                r.setStatus(rs.getString("Status"));
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                return r;
            }
            return null;
        }
    }

    /** Cập nhật nội dung + sao + topic */
    public void updateReview(int reviewId, String content, int ranking, String topic) throws Exception {
        String sql = "UPDATE GeneralReview SET ReviewContent = ?, Ranking = ?, ReviewTopic = ? WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.setInt(2,    ranking);
            ps.setString(3, topic);
            ps.setInt(4,    reviewId);
            ps.executeUpdate();
        }
    }

    /** Xóa toàn bộ ảnh cũ của review */
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

    /** Admin: lấy tất cả review (lọc status + type + star) + phân trang */
    public List<Review> adminGetAll(String statusFilter, String typeFilter, Integer starFilter, int page, int pageSize) throws Exception {
        List<Review> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.ReviewId, r.ReviewType, r.IdProduct, r.UserId, r.ReviewDate, " +
            "       r.ReviewContent, r.ReviewTopic, r.Ranking, r.[Status], " +
            "       r.ReplyContent, r.ReplyDate, " +
            "       u.FullName, pd.ProductName " +
            "FROM GeneralReview r " +
            "JOIN [User] u ON r.UserId = u.UserId " +
            "LEFT JOIN ProductDetail pd ON r.IdProduct = pd.IdProduct " +
            "WHERE 1=1 "
        );
        if (statusFilter != null && !statusFilter.isEmpty()) sql.append("AND r.[Status] = ? ");
        if (typeFilter != null && !typeFilter.isEmpty()) {
            if ("QUESTION".equals(typeFilter)) {
                sql.append("AND r.ReviewType = 'PRODUCT' AND r.ReviewTopic = 'Q&A' ");
            } else if ("PRODUCT".equals(typeFilter)) {
                sql.append("AND r.ReviewType = ? AND (r.ReviewTopic IS NULL OR r.ReviewTopic != 'Q&A') ");
            } else {
                sql.append("AND r.ReviewType = ? ");
            }
        }
        if (starFilter != null) sql.append("AND r.Ranking = ? ");
        
        sql.append("ORDER BY r.ReviewDate DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) ps.setString(idx++, statusFilter);
            if (typeFilter != null && !typeFilter.isEmpty()) {
                if (!"QUESTION".equals(typeFilter)) {
                    ps.setString(idx++, typeFilter);
                }
            }
            if (starFilter != null) ps.setInt(idx++, starFilter);
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx,   pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = mapRow(rs);
                String dbType = rs.getString("ReviewType");
                String dbTopic = rs.getString("ReviewTopic");
                if ("PRODUCT".equals(dbType) && "Q&A".equals(dbTopic)) {
                    r.setReviewType("QUESTION");
                } else {
                    r.setReviewType(dbType);
                }
                r.setIdProduct(rs.getString("IdProduct"));
                r.setReviewTopic(dbTopic);
                r.setStatus(rs.getString("Status"));
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                r.setProductName(rs.getString("ProductName"));
                list.add(r);
            }
        }
        return list;
    }

    /** Admin: đếm tổng review theo filter */
    public int adminCount(String statusFilter, String typeFilter, Integer starFilter) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM GeneralReview WHERE 1=1 ");
        if (statusFilter != null && !statusFilter.isEmpty()) sql.append("AND [Status] = ? ");
        if (typeFilter != null && !typeFilter.isEmpty()) {
            if ("QUESTION".equals(typeFilter)) {
                sql.append("AND ReviewType = 'PRODUCT' AND ReviewTopic = 'Q&A' ");
            } else if ("PRODUCT".equals(typeFilter)) {
                sql.append("AND ReviewType = ? AND (ReviewTopic IS NULL OR ReviewTopic != 'Q&A') ");
            } else {
                sql.append("AND ReviewType = ? ");
            }
        }
        if (starFilter != null) sql.append("AND Ranking = ? ");
        
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) ps.setString(idx++, statusFilter);
            if (typeFilter != null && !typeFilter.isEmpty()) {
                if (!"QUESTION".equals(typeFilter)) {
                    ps.setString(idx++, typeFilter);
                }
            }
            if (starFilter != null) ps.setInt(idx++, starFilter);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Admin: đổi trạng thái VISIBLE ↔ HIDDEN */
    public void updateStatus(int reviewId, String status) throws Exception {
        String sql = "UPDATE GeneralReview SET [Status] = ? WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2,    reviewId);
            ps.executeUpdate();
        }
    }

    /** Admin: lưu phản hồi */
    public void saveReply(int reviewId, String replyContent) throws Exception {
        String sql = "UPDATE GeneralReview SET ReplyContent = ?, ReplyDate = GETDATE() WHERE ReviewId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, replyContent);
            ps.setInt(2,    reviewId);
            ps.executeUpdate();
        }
    }

    // ─────────────────────────────────────────────
    // MÀN 6: Review của tôi
    // ─────────────────────────────────────────────

    /** Lấy toàn bộ review của 1 user */
    public List<Review> getByUser(int userId) throws Exception {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, pd.ProductName, pd.ImagePath, u.FullName FROM GeneralReview r " +
                     "LEFT JOIN ProductDetail pd ON r.IdProduct = pd.IdProduct " +
                     "JOIN [User] u ON r.UserId = u.UserId " +
                     "WHERE r.UserId = ? ORDER BY r.ReviewDate DESC";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = mapRow(rs);
                r.setReviewType(rs.getString("ReviewType"));
                r.setIdProduct(rs.getString("IdProduct"));
                r.setProductName(rs.getString("ProductName"));
                r.setProductImage(rs.getString("ImagePath"));
                r.setStatus(rs.getString("Status"));
                r.setReviewTopic(rs.getString("ReviewTopic"));
                r.setReplyContent(rs.getString("ReplyContent"));
                r.setReplyDate(rs.getTimestamp("ReplyDate"));
                list.add(r);
            }
        }
        return list;
    }

    /** Xóa review (có kiểm tra UserId để bảo mật) */
    public void deleteReview(int reviewId, int userId) throws Exception {
        String sql = "DELETE FROM GeneralReview WHERE ReviewId = ? AND UserId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    /** Thống kê số lượng theo từng mức sao cho 1 sản phẩm */
    public Map<Integer, Integer> countByStar(String idProduct) throws Exception {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 1; i <= 5; i++) map.put(i, 0);
        
        String sql = "SELECT Ranking, COUNT(*) FROM GeneralReview " +
                     "WHERE IdProduct = ? AND [Status] = 'VISIBLE' AND ReviewType = 'PRODUCT' AND (ReviewTopic IS NULL OR ReviewTopic != 'Q&A') " +
                     "GROUP BY Ranking";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, idProduct);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getInt(1), rs.getInt(2));
            }
        }
        return map;
    }

    // ─────────────────────────────────────────────
    // Helper
    // ─────────────────────────────────────────────
    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("ReviewId"));
        r.setUserId(rs.getInt("UserId"));
        r.setReviewDate(rs.getTimestamp("ReviewDate"));
        r.setReviewContent(rs.getString("ReviewContent"));
        r.setRanking(rs.getInt("Ranking"));
        r.setReviewerName(rs.getString("FullName"));
        return r;
    }
}
