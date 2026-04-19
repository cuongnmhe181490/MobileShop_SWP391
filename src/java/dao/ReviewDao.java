package dao;

import config.DBContext;
import entity.Review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý CRUD cho bảng ProductReview.
 */
public class ReviewDao {
    Connection conn = null;
    PreparedStatement ps = null;

    // ──────────────────────────────────────────
    //  CREATE: Thêm mới review
    // ──────────────────────────────────────────
    public int insert(Review review) {
        String query = "INSERT INTO ProductReview ([idProduct], [idAccount], [reviewerName], [ranking], [review], [reviewDate], [isVerified]) "
                     + "VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, review.getIdProduct());
            ps.setInt(2, review.getIdAccount());
            ps.setString(3, review.getReviewerName());
            ps.setInt(4, review.getRanking());
            ps.setString(5, review.getReview());
            ps.setBoolean(6, review.isVerified());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy tất cả review (có phân trang)
    // ──────────────────────────────────────────
    public List<Review> getAll(int page, int pageSize) {
        List<Review> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String query = "SELECT * FROM ProductReview ORDER BY reviewDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy tất cả review (không phân trang)
    // ──────────────────────────────────────────
    public List<Review> getAll() {
        List<Review> list = new ArrayList<>();
        String query = "SELECT * FROM ProductReview ORDER BY reviewDate DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy review theo ID
    // ──────────────────────────────────────────
    public Review getById(int id) {
        String query = "SELECT * FROM ProductReview WHERE idReview = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy review theo ID sản phẩm
    // ──────────────────────────────────────────
    public List<Review> getByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        String query = "SELECT * FROM ProductReview WHERE idProduct = ? ORDER BY reviewDate DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  UPDATE: Admin phản hồi review (không sửa nội dung review)
    // ──────────────────────────────────────────
    public boolean updateReply(int id, String replyContent) {
        String query = "UPDATE ProductReview SET [replyContent] = ?, [replyDate] = GETDATE() WHERE idReview = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, replyContent);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  UPDATE: Người dùng sửa review của chính mình (chỉ sửa ranking và review)
    // ──────────────────────────────────────────
    public boolean updateUserReview(int id, int ranking, String review) {
        String query = "UPDATE ProductReview SET [ranking] = ?, [review] = ? WHERE idReview = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, ranking);
            ps.setString(2, review);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  DELETE: Xóa review (phía Admin)
    // ──────────────────────────────────────────
    public boolean delete(int id) {
        String query = "DELETE FROM ProductReview WHERE idReview = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  READ: Đếm tổng số review
    // ──────────────────────────────────────────
    public int count() {
        String query = "SELECT COUNT(*) FROM ProductReview";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy review theo số sao
    // ──────────────────────────────────────────
    public List<Review> getByStar(int star, int page, int pageSize) {
        List<Review> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String query = "SELECT * FROM ProductReview WHERE ranking = ? ORDER BY reviewDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, star);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: Đếm review theo số sao
    // ──────────────────────────────────────────
    public int countByStar(int star) {
        String query = "SELECT COUNT(*) FROM ProductReview WHERE ranking = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, star);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ──────────────────────────────────────────
    //  Helper: Map ResultSet to Review object
    // ──────────────────────────────────────────
    private Review mapResultSet(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setIdReview(rs.getInt("idReview"));
        r.setIdProduct(rs.getInt("idProduct"));
        r.setIdAccount(rs.getInt("idAccount"));
        r.setReviewerName(rs.getString("reviewerName"));
        r.setRanking(rs.getInt("ranking"));
        r.setReview(rs.getString("review"));
        r.setReviewDate(rs.getTimestamp("reviewDate"));
        r.setVerified(rs.getBoolean("isVerified"));
        r.setReplyContent(rs.getString("replyContent"));
        r.setReplyDate(rs.getTimestamp("replyDate"));
        return r;
    }
}