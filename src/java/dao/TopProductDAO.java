package dao;

import config.DBContext;
import entity.TopProduct;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho bảng TopProduct.
 * Hỗ trợ: lấy tất cả, lấy theo ID, thêm, sửa, xoá, sắp xếp theo thứ tự.
 */
public class TopProductDAO {

    // ──────────────────────────────────────────
    //  HELPER: map ResultSet → TopProduct
    // ──────────────────────────────────────────
    private TopProduct mapRow(ResultSet rs) throws SQLException {
        TopProduct t = new TopProduct();
        t.setId(rs.getInt("Id"));
        t.setProductName(rs.getString("ProductName"));
        t.setProductImage(rs.getString("ProductImage"));
        t.setPrice(rs.getDouble("Price"));
        t.setOriginalPrice(rs.getDouble("OriginalPrice"));
        t.setDisplayOrder(rs.getInt("DisplayOrder"));
        try {
            t.setActive(rs.getBoolean("IsActive"));
        } catch (SQLException e) {
            t.setActive(true);
        }
        // Lấy % giảm giá, mặc định = 0
        try {
            t.setDiscountPercent(rs.getInt("DiscountPercent"));
        } catch (SQLException e) {
            t.setDiscountPercent(0);
        }
        return t;
    }

    // ──────────────────────────────────────────
    //  READ: lấy tất cả sản phẩm nổi bật
    // ──────────────────────────────────────────
    public List<TopProduct> getAll() throws Exception {
        List<TopProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM TopProduct ORDER BY DisplayOrder ASC";
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
    //  READ: lấy sản phẩm đang active (hiển thị homepage)
    // ──────────────────────────────────────────
    public List<TopProduct> getActiveProducts() throws Exception {
        List<TopProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM TopProduct WHERE IsActive = 1 ORDER BY DisplayOrder ASC";
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
    //  READ: lấy theo ID
    // ──────────────────────────────────────────
    public TopProduct getById(int id) throws Exception {
        String sql = "SELECT * FROM TopProduct WHERE Id = ?";
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
    //  CREATE: thêm mới sản phẩm nổi bật
    // ──────────────────────────────────────────
    public boolean insert(TopProduct topProduct) throws Exception {
        String sql = "INSERT INTO TopProduct (ProductName, ProductImage, Price, OriginalPrice, DisplayOrder, IsActive) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, topProduct.getProductName());
            ps.setString(2, topProduct.getProductImage() != null ? topProduct.getProductImage() : "");
            ps.setDouble(3, topProduct.getPrice());
            ps.setDouble(4, topProduct.getOriginalPrice() > 0 ? topProduct.getOriginalPrice() : 0);
            ps.setInt(5, topProduct.getDisplayOrder());
            ps.setBoolean(6, topProduct.isActive());
            int rows = ps.executeUpdate();
            System.out.println("✅ Inserted TopProduct, rows affected: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error inserting TopProduct: " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw để servlet hiển thị lỗi
        }
    }

    // ──────────────────────────────────────────
    //  UPDATE: cập nhật sản phẩm nổi bật
    // ──────────────────────────────────────────
    public boolean update(TopProduct topProduct) throws Exception {
        String sql = "UPDATE TopProduct SET ProductName = ?, ProductImage = ?, Price = ?, "
                   + "OriginalPrice = ?, DisplayOrder = ?, IsActive = ?, DiscountPercent = ? WHERE Id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, topProduct.getProductName());
            ps.setString(2, topProduct.getProductImage());
            ps.setDouble(3, topProduct.getPrice());
            ps.setDouble(4, topProduct.getOriginalPrice());
            ps.setInt(5, topProduct.getDisplayOrder());
            ps.setBoolean(6, topProduct.isActive());
            ps.setInt(7, topProduct.getDiscountPercent());
            ps.setInt(8, topProduct.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  DELETE: xoá sản phẩm nổi bật
    // ──────────────────────────────────────────
    public boolean delete(int id) throws Exception {
        String sql = "DELETE FROM TopProduct WHERE Id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  READ: lấy số thứ tự lớn nhất hiện tại
    // ──────────────────────────────────────────
    public int getMaxDisplayOrder() throws Exception {
        String sql = "SELECT MAX(DisplayOrder) FROM TopProduct";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}