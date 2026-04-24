package dao.order;

import config.DBContext;
import entity.CartItem;
import entity.Product;
import entity.ProductModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserCartDAO {

    public void ensureSchema() {
        String uniqueSql = "IF NOT EXISTS ("
                + "SELECT 1 FROM sys.indexes i "
                + "JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id "
                + "JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id "
                + "WHERE i.object_id = OBJECT_ID(N'dbo.ProductDetail') AND i.is_unique = 1 AND c.name = N'IdProduct') "
                + "BEGIN ALTER TABLE dbo.ProductDetail ADD CONSTRAINT UQ_ProductDetail_IdProduct UNIQUE (IdProduct); END";
        String tableSql = "IF OBJECT_ID(N'dbo.UserCart', N'U') IS NULL "
                + "BEGIN CREATE TABLE dbo.UserCart ("
                + "UserId INT NOT NULL, "
                + "IdProduct NVARCHAR(50) NOT NULL, "
                + "Quantity INT NOT NULL CHECK (Quantity > 0), "
                + "IsReserved BIT NOT NULL CONSTRAINT DF_UserCart_IsReserved DEFAULT 0, "
                + "ExpiresAt DATETIME NULL, "
                + "CONSTRAINT PK_UserCart PRIMARY KEY (UserId, IdProduct), "
                + "CONSTRAINT FK_UserCart_User FOREIGN KEY (UserId) REFERENCES dbo.[User](UserId), "
                + "CONSTRAINT FK_UserCart_Product FOREIGN KEY (IdProduct) REFERENCES dbo.ProductDetail(IdProduct)"
                + "); END";
        try (Connection conn = new DBContext().getConnection();
             Statement st = conn.createStatement()) {
            st.execute(uniqueSql);
            st.execute(tableSql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<CartItem> getCartItems(int userId) {
        ensureSchema();
        releaseExpiredReservations();
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT uc.IdProduct, uc.Quantity, p.ProductName, p.Price, p.OriginalQuantity, p.CurrentQuantity, "
                + "p.ReleaseDate, p.Screen, p.OperatingSystem, p.CPU, p.RAM, p.Camera, p.Battery, "
                + "p.Description, p.Discount, p.IdSupplier, p.ImagePath, p.idCat, p.IsFeatured "
                + "FROM UserCart uc JOIN ProductDetail p ON uc.IdProduct = p.IdProduct "
                + "WHERE uc.UserId = ? ORDER BY uc.IdProduct";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String productId = rs.getString("IdProduct");
                    ProductModel product = mapProduct(rs);
                    int available = getAvailableQuantity(productId, userId);
                    items.add(new CartItem(product, rs.getInt("Quantity"), product.getQuantity(), available));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public int countCartQuantity(int userId) {
        ensureSchema();
        String sql = "SELECT COALESCE(SUM(Quantity), 0) FROM UserCart WHERE UserId = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ProductModel mapProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getString("IdProduct"),
                rs.getString("ProductName"),
                rs.getDouble("Price"),
                rs.getInt("OriginalQuantity"),
                rs.getInt("CurrentQuantity"),
                rs.getString("ReleaseDate"),
                rs.getString("Screen"),
                rs.getString("OperatingSystem"),
                rs.getString("CPU"),
                rs.getObject("RAM") == null ? "" : String.valueOf(rs.getInt("RAM")),
                rs.getString("Camera"),
                rs.getString("Battery"),
                rs.getString("Description"),
                rs.getDouble("Discount"),
                rs.getString("IdSupplier"),
                rs.getString("ImagePath"),
                rs.getInt("idCat"),
                rs.getInt("IsFeatured")
        );
    }

    public int getAvailableQuantity(String productId, int userId) {
        ensureSchema();
        releaseExpiredReservations();
        String sql = "SELECT COALESCE(p.CurrentQuantity, 0) - COALESCE(("
                + "SELECT SUM(uc.Quantity) FROM UserCart uc "
                + "WHERE uc.IdProduct = p.IdProduct AND uc.UserId <> ? "
                + "AND uc.IsReserved = 1 AND uc.ExpiresAt > GETDATE()), 0) AS AvailableQuantity "
                + "FROM ProductDetail p WHERE p.IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Math.max(0, rs.getInt("AvailableQuantity"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String addItem(int userId, String productId, int quantity) {
        ensureSchema();
        releaseExpiredReservations();
        int existing = getItemQuantity(userId, productId);
        int requested = existing + quantity;
        int available = getAvailableQuantity(productId, userId);
        if (requested > available) {
            return "Số lượng chọn vượt quá tồn kho khả dụng.";
        }
        String sql = "MERGE UserCart AS target "
                + "USING (SELECT ? AS UserId, ? AS IdProduct) AS source "
                + "ON target.UserId = source.UserId AND target.IdProduct = source.IdProduct "
                + "WHEN MATCHED THEN UPDATE SET Quantity = ?, IsReserved = 0, ExpiresAt = NULL "
                + "WHEN NOT MATCHED THEN INSERT (UserId, IdProduct, Quantity, IsReserved, ExpiresAt) VALUES (?, ?, ?, 0, NULL);";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, productId);
            ps.setInt(3, requested);
            ps.setInt(4, userId);
            ps.setString(5, productId);
            ps.setInt(6, requested);
            ps.executeUpdate();
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return "Không thể cập nhật giỏ hàng. Vui lòng thử lại.";
        }
    }

    public String updateItem(int userId, String productId, int quantity) {
        ensureSchema();
        releaseExpiredReservations();
        int available = getAvailableQuantity(productId, userId);
        if (quantity > available) {
            return "Số lượng cập nhật vượt quá tồn kho khả dụng.";
        }
        String sql = "UPDATE UserCart SET Quantity = ?, IsReserved = 0, ExpiresAt = NULL WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setString(3, productId);
            return ps.executeUpdate() > 0 ? null : "Không tìm thấy sản phẩm trong giỏ hàng.";
        } catch (Exception e) {
            e.printStackTrace();
            return "Không thể cập nhật giỏ hàng. Vui lòng thử lại.";
        }
    }

    public void removeItem(int userId, String productId) {
        ensureSchema();
        String sql = "DELETE FROM UserCart WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String reserveLowStockItems(int userId) {
        ensureSchema();
        releaseExpiredReservations();
        for (CartItem item : getCartItems(userId)) {
            if (item.getQuantity() > item.getMaxQuantity()) {
                return "Sản phẩm " + item.getProduct().getProductName() + " không còn đủ số lượng khả dụng.";
            }
        }
        String sql = "UPDATE uc SET IsReserved = 1, ExpiresAt = DATEADD(MINUTE, 15, GETDATE()) "
                + "FROM UserCart uc JOIN ProductDetail p ON uc.IdProduct = p.IdProduct "
                + "WHERE uc.UserId = ? AND COALESCE(p.CurrentQuantity, 0) <= 5";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return "Không thể giữ hàng. Vui lòng thử lại.";
        }
    }

    public Timestamp getReservationExpiresAt(int userId) {
        ensureSchema();
        releaseExpiredReservations();
        String sql = "SELECT MIN(ExpiresAt) FROM UserCart WHERE UserId = ? AND IsReserved = 1 AND ExpiresAt > GETDATE()";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getTimestamp(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean hasMissingOrExpiredLowStockReservation(int userId) {
        ensureSchema();
        releaseExpiredReservations();
        String sql = "SELECT TOP 1 1 "
                + "FROM UserCart uc JOIN ProductDetail p ON uc.IdProduct = p.IdProduct "
                + "WHERE uc.UserId = ? AND COALESCE(p.CurrentQuantity, 0) <= 100 "
                + "AND (uc.IsReserved = 0 OR uc.ExpiresAt IS NULL OR uc.ExpiresAt <= GETDATE())";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void releaseReservations(int userId) {
        ensureSchema();
        String sql = "UPDATE UserCart SET IsReserved = 0, ExpiresAt = NULL WHERE UserId = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void releaseExpiredReservations() {
        String sql = "IF OBJECT_ID(N'dbo.UserCart', N'U') IS NOT NULL "
                + "UPDATE UserCart SET IsReserved = 0, ExpiresAt = NULL WHERE IsReserved = 1 AND ExpiresAt <= GETDATE()";
        try (Connection conn = new DBContext().getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int getItemQuantity(int userId, String productId) {
        String sql = "SELECT Quantity FROM UserCart WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Quantity");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    static void releaseExpiredReservations(Connection conn) throws SQLException {
        try (Statement st = conn.createStatement()) {
            st.executeUpdate("UPDATE UserCart SET IsReserved = 0, ExpiresAt = NULL WHERE IsReserved = 1 AND ExpiresAt <= GETDATE()");
        }
    }
}
