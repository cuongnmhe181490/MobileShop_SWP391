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
                    try (PreparedStatement stockPs = conn.prepareStatement(stockSql)) {
                    for (CartItem item : items) {
                        detailPs.setInt(1, orderId);
                        detailPs.setString(2, item.getProduct().getIdProduct());
                        detailPs.setInt(3, item.getQuantity());
                        detailPs.setDouble(4, item.getProduct().getPrice());
                        detailPs.addBatch();

                        stockPs.setInt(1, item.getQuantity());
                        stockPs.setString(2, item.getProduct().getIdProduct());
                        stockPs.setInt(3, item.getQuantity());
                        stockPs.addBatch();
                    }
                    detailPs.executeBatch();
                    int[] stockResults = stockPs.executeBatch();
                    for (int result : stockResults) {
                        if (result == 0) {
                            throw new SQLException("Không thể trừ tồn kho vì số lượng không đủ.");
                        }
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
        if (isAllowedStatus(status)) {
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
        if (isAllowedStatus(status)) {
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
        String sql = "UPDATE [Order] SET OrderStatus = ? WHERE IdOrder = ? AND OrderStatus = ?";
        String restockSql = "UPDATE p SET p.CurrentQuantity = p.CurrentQuantity + od.Quantity "
                + "FROM ProductDetail p JOIN OrderDetail od ON p.IdProduct = od.IdProduct WHERE od.IdOrder = ?";
        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, orderId);
                ps.setString(3, STATUS_DELIVERING);
                boolean updated = ps.executeUpdate() > 0;
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
                + "FROM ProductDetail p WITH (UPDLOCK, HOLDLOCK) WHERE p.IdProduct = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Math.max(0, rs.getInt("AvailableQuantity")) : 0;
            }
        }
    }

    public boolean isAllowedStatus(String status) {
        return STATUS_DELIVERING.equals(status) || STATUS_COMPLETED.equals(status) || STATUS_CANCELED.equals(status);
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
}
