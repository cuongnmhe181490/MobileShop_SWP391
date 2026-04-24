package dao.order;

import config.DBContext;
import entity.CartItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class OrderDAO {
    public static final String STATUS_DELIVERING = "\u0110ang giao h\u00e0ng";
    public static final String STATUS_COMPLETED = "\u0110\u00e3 ho\u00e0n th\u00e0nh";
    public static final String STATUS_CANCELED = "\u0110\u00e3 h\u1ee7y";
    public static final String STATUS_PENDING = "Pending";

    public int createOrder(int userId, String receiverName, String receiverPhone,
            String receiverAddress, double totalPrice, List<CartItem> items) throws Exception {
        String orderSql = "INSERT INTO [Order] (UserId, OrderDate, TotalPrice, ReceiverName, ReceiverPhone, ReceiverAddress, OrderStatus) "
                + "VALUES (?, CAST(GETDATE() AS date), ?, ?, ?, ?, ?)";
        String detailSql = "INSERT INTO OrderDetail (IdOrder, IdProduct, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
        String stockSql = "UPDATE ProductDetail SET CurrentQuantity = CurrentQuantity - ? WHERE IdProduct = ? AND CurrentQuantity >= ?";
        String deleteCartSql = "DELETE FROM UserCart WHERE UserId = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                UserCartDAO.releaseExpiredReservations(conn);
                for (CartItem item : items) {
                    int available = getAvailableQuantityForUpdate(conn, item.getProduct().getIdProduct(), userId);
                    if (item.getQuantity() > available) {
                        throw new SQLException("Sản phẩm " + item.getProduct().getProductName() + " không còn đủ số lượng khả dụng.");
                    }
                }

                orderPs.setInt(1, userId);
                orderPs.setDouble(2, totalPrice);
                orderPs.setString(3, receiverName);
                orderPs.setString(4, receiverPhone);
                orderPs.setString(5, receiverAddress);
                orderPs.setString(6, STATUS_DELIVERING);
                orderPs.executeUpdate();

                int orderId;
                try (ResultSet keys = orderPs.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Cannot read generated IdOrder.");
                    }
                    orderId = keys.getInt(1);
                }

                try (PreparedStatement detailPs = conn.prepareStatement(detailSql)) {
                    // Cập nhật cả 2 cột để đảm bảo đồng bộ dữ liệu ở mọi màn hình quản lý
                    boolean hasQuantity = hasProductDetailColumn(conn, "Quantity");
                    boolean hasOriginalQuantity = hasProductDetailColumn(conn, "OriginalQuantity");
                    
                    String updateStockSql;
                    if (hasQuantity) {
                        updateStockSql = "UPDATE ProductDetail SET CurrentQuantity = CurrentQuantity - ?, Quantity = Quantity - ? WHERE TRY_CAST(IdProduct AS INT) = TRY_CAST(? AS INT) AND CurrentQuantity >= ?";
                    } else {
                        updateStockSql = "UPDATE ProductDetail SET CurrentQuantity = CurrentQuantity - ? WHERE TRY_CAST(IdProduct AS INT) = TRY_CAST(? AS INT) AND CurrentQuantity >= ?";
                    }
                    
                    try (PreparedStatement stockPs = conn.prepareStatement(updateStockSql)) {
                        for (CartItem item : items) {
                            detailPs.setInt(1, orderId);
                            detailPs.setString(2, item.getProduct().getIdProduct());
                            detailPs.setInt(3, item.getQuantity());
                            detailPs.setDouble(4, item.getProduct().getPrice());
                            detailPs.addBatch();

                            if (hasQuantity) {
                                stockPs.setInt(1, item.getQuantity());
                                stockPs.setInt(2, item.getQuantity());
                                stockPs.setString(3, item.getProduct().getIdProduct());
                                stockPs.setInt(4, item.getQuantity());
                            } else {
                                stockPs.setInt(1, item.getQuantity());
                                stockPs.setString(2, item.getProduct().getIdProduct());
                                stockPs.setInt(3, item.getQuantity());
                            }
                            stockPs.addBatch();
                        }
                        detailPs.executeBatch();
                        int[] results = stockPs.executeBatch();
                        for (int res : results) {
                            if (res == 0) throw new SQLException("Không thể cập nhật tồn kho cho sản phẩm (có thể do ID không khớp hoặc hết hàng).");
                        }
                    }
                }

                try (PreparedStatement deleteCartPs = conn.prepareStatement(deleteCartSql)) {
                    deleteCartPs.setInt(1, userId);
                    deleteCartPs.executeUpdate();
                }

                conn.commit();
                return orderId;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<Map<String, Object>> getOrdersByUser(int userId) {
        return getOrdersByUser(userId, 1, Integer.MAX_VALUE);
    }

    public List<Map<String, Object>> getOrdersByUser(int userId, int page, int pageSize) {
        List<Map<String, Object>> orders = new ArrayList<>();
        String sql = "SELECT o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, "
                + "o.ReceiverAddress, o.OrderStatus, COUNT(od.IdProduct) AS ItemCount "
                + "FROM [Order] o LEFT JOIN OrderDetail od ON o.IdOrder = od.IdOrder "
                + "WHERE o.UserId = ? "
                + "GROUP BY o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, o.ReceiverAddress, o.OrderStatus "
                + "ORDER BY o.IdOrder DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, Math.max(0, (page - 1) * pageSize));
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int countOrdersByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE UserId = ?";
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

    public List<Map<String, Object>> getAdminOrders(String keyword, String status) {
        return getAdminOrders(keyword, status, 1, Integer.MAX_VALUE);
    }

    public List<Map<String, Object>> getAdminOrders(String keyword, String status, int page, int pageSize) {
        List<Map<String, Object>> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, ");
        sql.append("o.ReceiverAddress, o.OrderStatus, COUNT(od.IdProduct) AS ItemCount ")
                .append("FROM [Order] o LEFT JOIN OrderDetail od ON o.IdOrder = od.IdOrder WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String like = "%" + keyword.trim() + "%";
            sql.append("AND (CAST(o.IdOrder AS varchar(20)) LIKE ? OR o.ReceiverName LIKE ? OR o.ReceiverPhone LIKE ?) ");
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND o.OrderStatus = ? ");
            params.add(status);
        }
        sql.append("GROUP BY o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, o.ReceiverAddress, o.OrderStatus ")
                .append("ORDER BY o.IdOrder DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(Math.max(0, (page - 1) * pageSize));
        params.add(pageSize);

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int countAdminOrders(String keyword, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM [Order] o WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String like = "%" + keyword.trim() + "%";
            sql.append("AND (CAST(o.IdOrder AS varchar(20)) LIKE ? OR o.ReceiverName LIKE ? OR o.ReceiverPhone LIKE ?) ");
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND o.OrderStatus = ? ");
            params.add(status);
        }
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
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

    public Map<String, Object> getOrderById(int orderId) {
        String sql = "SELECT o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, "
                + "o.ReceiverAddress, o.OrderStatus, COUNT(od.IdProduct) AS ItemCount "
                + "FROM [Order] o LEFT JOIN OrderDetail od ON o.IdOrder = od.IdOrder "
                + "WHERE o.IdOrder = ? "
                + "GROUP BY o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, o.ReceiverAddress, o.OrderStatus";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrder(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> getOrderDetails(int orderId) {
        List<Map<String, Object>> details = new ArrayList<>();
        String sql = "SELECT od.IdOrder, od.IdProduct, p.ProductName, p.ImagePath, od.Quantity, od.UnitPrice, "
                + "(od.Quantity * od.UnitPrice) AS Subtotal "
                + "FROM OrderDetail od LEFT JOIN ProductDetail p ON od.IdProduct = p.IdProduct "
                + "WHERE od.IdOrder = ? ORDER BY od.IdProduct";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("idOrder", rs.getInt("IdOrder"));
                    row.put("idProduct", rs.getString("IdProduct"));
                    row.put("productName", rs.getString("ProductName"));
                    row.put("imagePath", rs.getString("ImagePath"));
                    row.put("quantity", rs.getInt("Quantity"));
                    row.put("unitPrice", rs.getDouble("UnitPrice"));
                    row.put("subtotal", rs.getDouble("Subtotal"));
                    details.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        if (!isAllowedStatus(status)) {
            return false;
        }
        String sql = "UPDATE [Order] SET OrderStatus = ? WHERE IdOrder = ?";
        String restockSql = "UPDATE p SET p.CurrentQuantity = p.CurrentQuantity + od.Quantity "
                + "FROM ProductDetail p JOIN OrderDetail od ON p.IdProduct = od.IdProduct WHERE od.IdOrder = ?";
        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, orderId);
                System.out.println("Updating Order ID: " + orderId + " to Status: " + status);
                boolean updated = ps.executeUpdate() > 0;
                System.out.println("Update result: " + updated);
                if (updated && STATUS_CANCELED.equals(status)) {
                    try (PreparedStatement restockPs = conn.prepareStatement(restockSql)) {
                        restockPs.setInt(1, orderId);
                        restockPs.executeUpdate();
                    }
                }
                conn.commit();
                return updated;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private int getAvailableQuantityForUpdate(Connection conn, String productId, int userId) throws SQLException {
        String sql = "SELECT COALESCE(p.CurrentQuantity, 0) - COALESCE(("
                + "SELECT SUM(uc.Quantity) FROM UserCart uc "
                + "WHERE uc.IdProduct = p.IdProduct AND uc.UserId <> ? "
                + "AND uc.IsReserved = 1 AND uc.ExpiresAt > GETDATE()), 0) AS AvailableQuantity "
                + "FROM ProductDetail p WITH (UPDLOCK, HOLDLOCK) WHERE TRY_CAST(p.IdProduct AS INT) = TRY_CAST(? AS INT)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Math.max(0, rs.getInt("AvailableQuantity")) : 0;
            }
        }
    }

    public boolean isAllowedStatus(String status) {
        return status != null && !status.trim().isEmpty();
    }

    public int getPendingOrdersCount() {
        String query = "SELECT COUNT(*) FROM [Order] WHERE OrderStatus = ? OR OrderStatus = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, STATUS_DELIVERING);
            ps.setString(2, STATUS_PENDING);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getSoldOrdersCount(java.sql.Date startDate, java.sql.Date endDate) {
        String query = "SELECT COUNT(*) FROM [Order] WHERE OrderStatus IN (?, ?) AND OrderDate >= ? AND OrderDate <= ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, STATUS_COMPLETED);
            ps.setString(2, STATUS_DELIVERING);
            ps.setDate(3, startDate);
            ps.setDate(4, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public String getRevenueByDate(java.sql.Date startDate, java.sql.Date endDate) {
        String query = "SELECT SUM(TotalPrice) FROM [Order] WHERE OrderDate >= ? AND OrderDate <= ? AND OrderStatus IN (?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            ps.setString(3, STATUS_COMPLETED);
            ps.setString(4, STATUS_DELIVERING);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double total = rs.getDouble(1);
                    if (total >= 1000000) return String.format("%.1fM", total / 1000000.0);
                    if (total >= 1000) return String.format("%.0fK", total / 1000.0);
                    return String.format("%.0f", total);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "0";
    }

    public List<Map<String, String>> getRecentOrdersDashboard(int limit) {
        List<Map<String, String>> list = new ArrayList<>();
        String query = "SELECT TOP (?) o.IdOrder, u.FullName, o.OrderDate, o.TotalPrice, o.OrderStatus " +
                      "FROM [Order] o JOIN [User] u ON o.UserId = u.UserId " +
                      "ORDER BY o.IdOrder DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm dd/MM");
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("id", "#DH" + String.format("%04d", rs.getInt("IdOrder")));
                    map.put("name", rs.getString("FullName"));
                    map.put("time", sdf.format(rs.getTimestamp("OrderDate")));
                    map.put("price", String.format("%.1fM", rs.getDouble("TotalPrice") / 1000000.0));
                    map.put("status", rs.getString("OrderStatus"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Map<String, Integer> getOrderStatusStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put(STATUS_COMPLETED, 0);
        stats.put(STATUS_DELIVERING, 0);
        stats.put(STATUS_PENDING, 0);
        stats.put(STATUS_CANCELED, 0);
        
        String query = "SELECT OrderStatus, COUNT(*) as Total FROM [Order] GROUP BY OrderStatus";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("OrderStatus"), rs.getInt("Total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public Map<String, Double> getMonthlyRevenueData() {
        Map<String, Double> stats = new java.util.LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) {
            stats.put("T" + i, 0.0);
        }
        String query = "SELECT MONTH(OrderDate) as Month, SUM(TotalPrice) as Revenue " +
                      "FROM [Order] " +
                      "WHERE OrderDate >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1) " +
                      "AND OrderDate <= DATEFROMPARTS(YEAR(GETDATE()), 12, 31) " +
                      "AND OrderStatus = ? " +
                      "GROUP BY MONTH(OrderDate) " +
                      "ORDER BY Month ASC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, STATUS_COMPLETED);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    stats.put("T" + rs.getInt("Month"), rs.getDouble("Revenue"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public int getNewOrdersCount(java.sql.Date startDate, java.sql.Date endDate) {
        String query = "SELECT COUNT(*) FROM [Order] WHERE OrderDate >= ? AND OrderDate <= ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private Map<String, Object> mapOrder(ResultSet rs) throws SQLException {
        Map<String, Object> row = new HashMap<>();
        row.put("idOrder", rs.getInt("IdOrder"));
        row.put("customerName", rs.getString("ReceiverName"));
        row.put("receiverName", rs.getString("ReceiverName"));
        row.put("receiverPhone", rs.getString("ReceiverPhone"));
        row.put("receiverAddress", rs.getString("ReceiverAddress"));
        row.put("orderDate", rs.getDate("OrderDate"));
        row.put("totalPrice", rs.getDouble("TotalPrice"));
        row.put("status", rs.getString("OrderStatus"));
        row.put("itemCount", rs.getInt("ItemCount"));
        return row;
    }

    private boolean hasProductDetailColumn(Connection conn, String columnName) {
        try (ResultSet rs = conn.getMetaData().getColumns(null, null, "ProductDetail", columnName)) {
            return rs.next();
        } catch (Exception e) {
            return false;
        }
    }
}
