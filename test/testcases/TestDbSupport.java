package testcases;

import config.DBContext;
import dao.order.OrderDAO;
import dao.product.ProductAdminDAO;
import entity.Product;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;

final class TestDbSupport {

    private static final String PREFIX = "TEST-CODEX-";

    private TestDbSupport() {
    }

    static Connection openConnection() throws Exception {
        return new DBContext().getConnection();
    }

    static boolean isDatabaseAvailable() {
        try (Connection ignored = openConnection()) {
            return true;
        } catch (Exception ex) {
            return false;
        }
    }

    static int createTestUser(String suffix) throws Exception {
        String username = PREFIX + "USER-" + suffix;
        String sql = "INSERT INTO [User] (Username, Gender, [Password], [Address], Email, PhoneNumber, FullName, Birthday, [RoleId]) "
                + "VALUES (?, 'Other', '12345678', 'Test Address', ?, ?, ?, ?, 0)";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, username.toLowerCase() + "@example.com");
            ps.setString(3, "09" + String.format("%08d", Math.abs(suffix.hashCode()) % 100000000));
            ps.setString(4, username);
            ps.setDate(5, Date.valueOf(LocalDate.of(2000, 1, 1)));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new IllegalStateException("Cannot create test user");
    }

    static Product createTestProduct(String suffix, int originalQuantity, int currentQuantity) throws Exception {
        ProductAdminDAO dao = new ProductAdminDAO();
        Product product = new Product();
        product.setIdProduct(dao.getNextProductId());
        product.setProductName(PREFIX + "PRODUCT-" + suffix);
        product.setPrice(123456d);
        product.setOriginalQuantity(originalQuantity);
        product.setCurrentQuantity(currentQuantity);
        product.setReleaseDate(LocalDate.now().toString());
        product.setScreen("6.7 inch");
        product.setOperatingSystem("Android 15");
        product.setCpu("Snapdragon 8");
        product.setRam("12");
        product.setCamera("50MP");
        product.setBattery("5000");
        product.setDescription("Integration test product " + suffix);
        product.setDiscount(0d);
        product.setIdSupplier("Xiaomi");
        product.setImagePath("/img/categories/cat-1.jpg");
        product.setIdCat(dao.getCategoryIdBySupplier(product.getIdSupplier()));
        product.setIsFeatured(0);
        if (!dao.addProduct(product)) {
            throw new IllegalStateException("Cannot create test product");
        }
        return product;
    }

    static Product getProduct(String idProduct) {
        return new ProductAdminDAO().getProductByID(idProduct);
    }

    static int getAscendingLastProductNumericId() throws Exception {
        String sql = "SELECT TOP 1 TRY_CAST(IdProduct AS INT) AS NumericId "
                + "FROM ProductDetail ORDER BY TRY_CAST(IdProduct AS INT) DESC, IdProduct DESC";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt("NumericId") : 0;
        }
    }

    static int getUserCartQuantity(int userId, String idProduct) throws Exception {
        String sql = "SELECT Quantity FROM UserCart WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, idProduct);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("Quantity") : 0;
            }
        }
    }

    static int countUserCartRows(int userId, String idProduct) throws Exception {
        String sql = "SELECT COUNT(*) FROM UserCart WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, idProduct);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    static boolean isReserved(int userId, String idProduct) throws Exception {
        String sql = "SELECT IsReserved FROM UserCart WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, idProduct);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getBoolean("IsReserved");
            }
        }
    }

    static boolean hasExpiresAt(int userId, String idProduct) throws Exception {
        String sql = "SELECT ExpiresAt FROM UserCart WHERE UserId = ? AND IdProduct = ?";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, idProduct);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getTimestamp("ExpiresAt") != null;
            }
        }
    }

    static int countOrderDetails(int orderId) throws Exception {
        String sql = "SELECT COUNT(*) FROM OrderDetail WHERE IdOrder = ?";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    static String getOrderStatus(int orderId) throws Exception {
        String sql = "SELECT OrderStatus FROM [Order] WHERE IdOrder = ?";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("OrderStatus") : null;
            }
        }
    }

    static void deleteOrder(int orderId) throws Exception {
        try (Connection conn = openConnection()) {
            try (PreparedStatement psDetail = conn.prepareStatement("DELETE FROM OrderDetail WHERE IdOrder = ?");
                 PreparedStatement psOrder = conn.prepareStatement("DELETE FROM [Order] WHERE IdOrder = ?")) {
                psDetail.setInt(1, orderId);
                psDetail.executeUpdate();
                psOrder.setInt(1, orderId);
                psOrder.executeUpdate();
            }
        }
    }

    static void cleanupUser(int userId) throws Exception {
        try (Connection conn = openConnection()) {
            try (PreparedStatement psOrders = conn.prepareStatement("SELECT IdOrder FROM [Order] WHERE UserId = ?")) {
                psOrders.setInt(1, userId);
                try (ResultSet rs = psOrders.executeQuery()) {
                    while (rs.next()) {
                        deleteOrder(rs.getInt("IdOrder"));
                    }
                }
            }
            try (PreparedStatement psCart = conn.prepareStatement("DELETE FROM UserCart WHERE UserId = ?");
                 PreparedStatement psUser = conn.prepareStatement("DELETE FROM [User] WHERE UserId = ?")) {
                psCart.setInt(1, userId);
                psCart.executeUpdate();
                psUser.setInt(1, userId);
                psUser.executeUpdate();
            }
        }
    }

    static void cleanupProduct(String idProduct) throws Exception {
        try (Connection conn = openConnection()) {
            try (PreparedStatement psCart = conn.prepareStatement("DELETE FROM UserCart WHERE IdProduct = ?");
                 PreparedStatement psProduct = conn.prepareStatement("DELETE FROM ProductDetail WHERE IdProduct = ?")) {
                psCart.setString(1, idProduct);
                psCart.executeUpdate();
                psProduct.setString(1, idProduct);
                psProduct.executeUpdate();
            }
        }
    }

    static double computeTotal(Iterable<entity.CartItem> items) {
        double total = 0d;
        for (entity.CartItem item : items) {
            total += item.getSubtotal();
        }
        return total;
    }

    static boolean isDeliveringStatus(String status) {
        return OrderDAO.STATUS_DELIVERING.equals(status);
    }
}
