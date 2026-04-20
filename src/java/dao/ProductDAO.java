package dao;

import config.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO cho bảng ProductDetail.
 * Xử lý các chức năng liên quan đến sản phẩm và tính năng Featured (Top sản phẩm).
 */
public class ProductDAO {

    // ──────────────────────────────────────────
    //  HELPER: map ResultSet → Map (dynamic columns)
    // ──────────────────────────────────────────
    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> product = new HashMap<>();
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        
        for (int i = 1; i <= columnCount; i++) {
            String columnName = metaData.getColumnLabel(i);
            Object value = rs.getObject(i);
            product.put(columnName, value);
        }
        return product;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy sản phẩm featured (IsFeatured = 1)
    //  Sắp xếp theo số lượng đã bán giảm dần
    // ──────────────────────────────────────────
    public List<Map<String, Object>> getFeaturedProducts() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT *, (OriginalQuantity - CurrentQuantity) AS SoldQuantity " 
                   + "FROM ProductDetail WHERE IsFeatured = 1 ORDER BY SoldQuantity DESC";
        
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
    //  READ: Lấy sản phẩm featured có phân trang
    // ──────────────────────────────────────────
    // ──────────────────────────────────────────
    //  READ: Lấy sản phẩm featured có phân trang
    // ──────────────────────────────────────────
    public List<Map<String, Object>> getFeaturedProductsPaging(String search, int page, int pageSize) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT *, (OriginalQuantity - CurrentQuantity) AS SoldQuantity " 
                   + "FROM ProductDetail WHERE IsFeatured = 1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND ProductName LIKE ?";
        }
        sql += " ORDER BY SoldQuantity DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
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
    //  READ: Đếm tổng số sản phẩm featured
    // ──────────────────────────────────────────
    // ──────────────────────────────────────────
    //  READ: Đếm tổng số sản phẩm featured
    // ──────────────────────────────────────────
    public int getFeaturedCount(String search) throws Exception {
        String sql = "SELECT COUNT(*) FROM ProductDetail WHERE IsFeatured = 1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND ProductName LIKE ?";
        }
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search.trim() + "%");
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
    //  READ: Lấy sản phẩm chưa được ghim (IsFeatured = 0)
    //  Dùng cho trang thêm mới vào Top
    // ──────────────────────────────────────────
    public List<Map<String, Object>> getAvailableToFeature() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM ProductDetail WHERE IsFeatured = 0 ORDER BY ProductName ASC";
        
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
    //  UPDATE: Bật/Tắt tính năng Featured
    //  status = 1 (bật), status = 0 (tắt)
    // ──────────────────────────────────────────
    public boolean updateFeaturedStatus(String productId, int status) throws Exception {
        String sql = "UPDATE ProductDetail SET IsFeatured = ? WHERE IdProduct = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, productId);
            int rows = ps.executeUpdate();
            System.out.println("✅ Updated IsFeatured for " + productId + " to " + status + ", rows: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error updating featured status: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // ──────────────────────────────────────────
    //  READ: Lấy sản phẩm theo ID
    // ──────────────────────────────────────────
    public Map<String, Object> getProductById(String productId) throws Exception {
        String sql = "SELECT * FROM ProductDetail WHERE IdProduct = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productId);
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
    //  READ: Lấy tất cả sản phẩm (dự phòng)
    // ──────────────────────────────────────────
    public List<Map<String, Object>> getAllProducts() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM ProductDetail ORDER BY ProductName ASC";
        
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
}