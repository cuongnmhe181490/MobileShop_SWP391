package dao;

import config.DBContext;
import entity.HeroBanner;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO cho bảng HeroBanner.
 * Hỗ trợ: lấy tất cả, lấy theo ID, thêm, sửa, xoá.
 */
public class HeroBannerDAO {

    // ──────────────────────────────────────────
    //  HELPER: map ResultSet → HeroBanner
    // ──────────────────────────────────────────
    private HeroBanner mapRow(ResultSet rs) throws SQLException {
        HeroBanner h = new HeroBanner();
        h.setId(rs.getInt("Id"));
        h.setEyebrow(rs.getString("Eyebrow"));
        h.setTitle(rs.getString("Title"));
        h.setDescription(rs.getString("Description"));
        h.setCtaPrimary(rs.getString("CtaPrimary"));
        h.setCtaSecondary(rs.getString("CtaSecondary"));
        h.setImageUrl(rs.getString("ImageUrl"));
        h.setStat1Label(rs.getString("Stat1_Label"));
        h.setStat2Label(rs.getString("Stat2_Label"));
        h.setStat3Label(rs.getString("Stat3_Label"));
        h.setActive(rs.getBoolean("IsActive"));
        return h;
    }

    // ──────────────────────────────────────────
    //  READ: lấy tất cả banner
    // ──────────────────────────────────────────
    public List<HeroBanner> getAll() throws Exception {
        List<HeroBanner> list = new ArrayList<>();
        String sql = "SELECT * FROM HeroBanner ORDER BY Id DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: lấy tất cả banner có phân trang và tìm kiếm
    // ──────────────────────────────────────────
    public List<HeroBanner> getAllPaging(String search, int page, int pageSize) throws Exception {
        List<HeroBanner> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT * FROM HeroBanner";
        if (search != null && !search.trim().isEmpty()) {
            sql += " WHERE Title LIKE ? OR Description LIKE ?";
        }
        sql += " ORDER BY Id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: đếm tổng số banner kèm tìm kiếm
    // ──────────────────────────────────────────
    public int getTotalCount(String search) throws Exception {
        String sql = "SELECT COUNT(*) FROM HeroBanner";
        if (search != null && !search.trim().isEmpty()) {
            sql += " WHERE Title LIKE ? OR Description LIKE ?";
        }
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search.trim() + "%");
                ps.setString(2, "%" + search.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ──────────────────────────────────────────
    //  READ: lấy banner đang active (hiển thị homepage)
    // ──────────────────────────────────────────
    public HeroBanner getActiveBanner() throws Exception {
        String sql = "SELECT TOP 1 * FROM HeroBanner WHERE IsActive = 1 ORDER BY Id DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ──────────────────────────────────────────
    //  READ: lấy theo ID
    // ──────────────────────────────────────────
    public HeroBanner getById(int id) throws Exception {
        String sql = "SELECT * FROM HeroBanner WHERE Id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ──────────────────────────────────────────
    //  CREATE: thêm banner mới
    // ──────────────────────────────────────────
    public boolean insert(HeroBanner h) throws Exception {
        String sql = "INSERT INTO HeroBanner " +
                     "(Eyebrow, Title, Description, CtaPrimary, CtaSecondary, ImageUrl, " +
                     "Stat1_Label, Stat2_Label, Stat3_Label, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getEyebrow());
            ps.setString(2, h.getTitle());
            ps.setString(3, h.getDescription());
            ps.setString(4, h.getCtaPrimary());
            ps.setString(5, h.getCtaSecondary());
            ps.setString(6, h.getImageUrl());
            ps.setString(7, h.getStat1Label());
            ps.setString(8, h.getStat2Label());
            ps.setString(9, h.getStat3Label());
            ps.setBoolean(10, h.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  UPDATE: cập nhật banner theo ID
    // ──────────────────────────────────────────
    public boolean update(HeroBanner h) throws Exception {
        String sql = "UPDATE HeroBanner SET " +
                     "Eyebrow=?, Title=?, Description=?, CtaPrimary=?, CtaSecondary=?, " +
                     "ImageUrl=?, Stat1_Label=?, Stat2_Label=?, Stat3_Label=?, IsActive=? " +
                     "WHERE Id=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getEyebrow());
            ps.setString(2, h.getTitle());
            ps.setString(3, h.getDescription());
            ps.setString(4, h.getCtaPrimary());
            ps.setString(5, h.getCtaSecondary());
            ps.setString(6, h.getImageUrl());
            ps.setString(7, h.getStat1Label());
            ps.setString(8, h.getStat2Label());
            ps.setString(9, h.getStat3Label());
            ps.setBoolean(10, h.isActive());
            ps.setInt(11, h.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  DELETE: xoá banner theo ID
    // ──────────────────────────────────────────
    public boolean delete(int id) throws Exception {
        String sql = "DELETE FROM HeroBanner WHERE Id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

   
    /**
     * Tính điểm hài lòng trung bình LIVE từ bảng ProductReview.
     * Yêu cầu giáo viên: AVG(Ranking), không fix cứng.
     */
    public String getLiveSatisfactionRate() {
        String sql = "SELECT AVG(CAST(Ranking AS FLOAT)) AS Average FROM ProductReview";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double avg = rs.getDouble("Average");
                if (avg > 0) {
                    return String.format("%.1f/5", avg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "0.0/5";
    }

    /**
     * Đếm tổng số sản phẩm LIVE từ bảng ProductDetail.
     * Yêu cầu giáo viên: COUNT(*), không fix số 30.
     */
    public int getLiveProductCount() {
        String sql = "SELECT COUNT(*) FROM ProductDetail";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Null-safe trim */
    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}


