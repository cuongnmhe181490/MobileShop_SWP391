/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import config.DBContext;
import entity.ProductModel;
import entity.ProductReview;
import entity.Role;
import java.sql.SQLException;
import entity.User;
import java.util.*;
import java.lang.*;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import entity.Supplier;




/**
 *
 * @author ADMIN
 */
public class DAO {
    Connection conn = null; 
    PreparedStatement ps = null; 
    ResultSet rs = null; 
    
    
    public void signup(String user, String gender, String pass, String address, String email, String phone, String name, String birthday) {
    // Đã thêm danh sách cột rõ ràng để tránh lỗi IDENTITY của SQL Server
    String query = "INSERT INTO [User] (Username, Gender, [Password], [Address], "
                 + "Email, PhoneNumber, FullName, Birthday, [RoleId]) \n"
                 + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)"; // 0 ở cuối là Role mặc định (Khách hàng)
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        ps.setString(1, user);
        ps.setString(2, gender);
        ps.setString(3, pass);
        ps.setString(4, address);
        ps.setString(5, email);
        ps.setString(6, phone);
        ps.setString(7, name);
        ps.setString(8, birthday);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace(); // Rất quan trọng: In lỗi ra để biết nếu SQL bị sai
    }
}
    
    public User checkUserExist(String user) {
        String query = "SELECT u.*, r.RoleName \n"
                 + "FROM [User] u \n"
                 + "INNER JOIN [Role] r ON u.RoleId = r.RoleId \n"
                 + "WHERE u.Username = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            rs = ps.executeQuery();
            if (rs.next()) {
                // 2. Khởi tạo Role
                Role r = new Role();
                r.setRoleId(rs.getInt("RoleId"));
                r.setRoleName(rs.getString("RoleName"));
                
                User u = new User();
                u.setId(rs.getInt("UserId"));
                u.setUser(rs.getString("Username"));
                u.setGender(rs.getString("Gender"));
                u.setPass(rs.getString("Password"));
                u.setAddress(rs.getString("Address"));
                u.setEmail(rs.getString("Email"));
                u.setPhone(rs.getString("PhoneNumber"));
                u.setName(rs.getString("FullName"));
                u.setBirthday(rs.getDate("Birthday"));

                // 4. Gắn Role vào User
                u.setRole(r);

            return u;
            }
        } catch (Exception e) {
        }
        return null;
    }
    
    public User getUserByEmail(String email) {
    // Truy vấn JOIN để lấy tên Role cùng lúc
    String sql = "SELECT u.*, r.RoleName " +
                 "FROM [User] u " +
                 "INNER JOIN [Role] r ON u.RoleId = r.RoleId " +
                 "WHERE u.Email = ?";
    try {
        conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // 1. Khởi tạo đối tượng Role từ dữ liệu JOIN
            Role role = new Role();
            role.setRoleId(rs.getInt("RoleId"));
            role.setRoleName(rs.getString("RoleName"));

            // 2. Khởi tạo đối tượng User và gán các trường
            User user = new User();
            user.setId(rs.getInt("UserId"));
            user.setEmail(rs.getString("Email"));
            user.setPass(rs.getString("Password")); // Lấy pass đã mã hóa để check BCrypt
            user.setName(rs.getNString("FullName"));
            user.setPhone(rs.getString("PhoneNumber"));
            user.setAddress(rs.getNString("Address"));
            user.setGender(rs.getString("Gender"));
            user.setBirthday(rs.getDate("Birthday"));
            
            // 3. GÁN ĐỐI TƯỢNG ROLE VÀO USER
            user.setRole(role);

            return user;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    
    public boolean checkEmailExist(String email) {
        String query = "SELECT * FROM [User] WHERE Email = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) return true; // Có tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkPhoneExist(String phone) {
        String query = "SELECT * FROM [User] WHERE Phone = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, phone);
            rs = ps.executeQuery();
            if (rs.next()) return true; // Có tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private ProductModel mapProduct(ResultSet rs) throws SQLException {
        return new ProductModel(
                rs.getString("IdProduct"),
                rs.getString("ProductName"),
                rs.getDouble("Price"),
                rs.getInt("Quantity"),
                rs.getString("ReleaseDate"),
                rs.getString("Screen"),
                rs.getString("OperatingSystem"),
                rs.getString("CPU"),
                String.valueOf(rs.getInt("RAM")),
                rs.getString("Camera"),
                rs.getString("Battery"),
                rs.getString("Description"),
                rs.getDouble("Discount"),
                rs.getString("IdSupplier"),
                rs.getString("ImagePath")
        );
    }
    
    private ProductReview mapReview(ResultSet rs) throws SQLException {
        return new ProductReview(
                rs.getString("IdProduct"),
                rs.getInt("UserId"),
                rs.getString("ReviewerName"),
                rs.getString("ReviewDate"),
                rs.getString("Review"),
                rs.getInt("Ranking")
        );
    }


    private List<ProductModel> queryProducts(String sql, SqlConsumer<PreparedStatement> binder) {
        List<ProductModel> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            binder.accept(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<ProductModel> getFeaturedProducts(int limit) {
        return queryProducts(
                "SELECT * FROM ProductDetail ORDER BY ReleaseDate DESC, Price DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY",
                ps -> ps.setInt(1, limit)
        );
    }

    public List<ProductModel> getLatestProducts(int limit) {
        return getFeaturedProducts(limit);
    }

    public ProductModel getProductByID(String id) {
        String query = "SELECT * FROM ProductDetail WHERE IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public ProductModel getProductByBrandAndName(String brand, String modelName) {
        String query = "SELECT TOP 1 * FROM ProductDetail WHERE IdSupplier = ? AND ProductName LIKE ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, brand);
            ps.setString(2, "%" + modelName + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    
    public int countProductReviews(String productId, Integer ranking) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS Total FROM ProductReview WHERE IdProduct = ? ");
        if (ranking != null) {
            sql.append("AND Ranking = ?");
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, productId);
            if (ranking != null) {
                ps.setInt(2, ranking);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Total");
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }
    
    public List<ProductReview> getProductReviews(String productId, Integer ranking, int offset, int pageSize) {
        List<ProductReview> reviews = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT pr.IdProduct, pr.UserId, pr.ReviewDate, pr.Review, pr.Ranking, u.FullName AS ReviewerName ");
        sql.append("FROM ProductReview pr ");
        sql.append("LEFT JOIN [User] u ON u.UserId = pr.UserId ");
        sql.append("WHERE pr.IdProduct = ? ");
        if (ranking != null) {
            sql.append("AND pr.Ranking = ? ");
        }
        sql.append("ORDER BY pr.ReviewDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setString(index++, productId);
            if (ranking != null) {
                ps.setInt(index++, ranking);
            }
            ps.setInt(index++, offset);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapReview(rs));
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return reviews;
    }

    public Map<Integer, Integer> getReviewCountsByRating(String productId) {
        Map<Integer, Integer> counts = new LinkedHashMap<>();
        for (int star = 5; star >= 1; star--) {
            counts.put(star, 0);
        }

        String query = "SELECT Ranking, COUNT(*) AS Total FROM ProductReview WHERE IdProduct = ? GROUP BY Ranking";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    counts.put(rs.getInt("Ranking"), rs.getInt("Total"));
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return counts;
    }
    
    public double getAverageRating(String productId) {
        String query = "SELECT COALESCE(AVG(CAST(Ranking AS FLOAT)), 0) AS AverageRating FROM ProductReview WHERE IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("AverageRating");
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0d;
    }
    
    public int getReviewCount(String productId) {
        String query = "SELECT COUNT(*) AS TotalReview FROM ProductReview WHERE IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalReview");
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }
    @FunctionalInterface
    private interface SqlConsumer<T> {
        void accept(T value) throws Exception;
    }
    
    // 1. Hàm tạo và lưu Token mới (Có hiệu lực 10 phút)
    public void saveResetToken(String email, String token) {
        // DATEADD(minute, 10, GETDATE()) là lệnh của SQL Server để cộng thêm 15 phút từ giờ hiện tại
        String sql = "UPDATE [User] SET ResetToken = ?, ResetTokenExpiry = DATEADD(minute, 10, GETDATE()) WHERE Email = ?";
        try {
            conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 2. Hàm kiểm tra Token khi khách hàng click vào link
    public User getUserByResetToken(String token) {
        // Chỉ lấy User nếu Token khớp VÀ thời gian hiện tại vẫn nhỏ hơn thời gian hết hạn
        // Sửa tạm để test
        String sql = "SELECT * FROM [User] WHERE ResetToken = ?";
        try {
            conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("UserId"));
                u.setEmail(rs.getString("Email"));
                u.setName(rs.getNString("FullName"));
                // ... (bạn có thể set thêm các trường khác nếu cần)
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Hàm lưu mật khẩu mới và Xóa Token (Chỉ dùng 1 lần)
    public void updatePasswordAndClearToken(String email, String newHashedPassword) {
        // Đổi pass xong thì đưa Token về NULL để vô hiệu hóa link cũ
        String sql = "UPDATE [User] SET [Password] = ?, ResetToken = NULL, ResetTokenExpiry = NULL WHERE Email = ?";
        try {
            conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int getTotalProducts() {
        String query = "SELECT COUNT(*) FROM ProductDetail";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingOrdersCount() {
        String query = "SELECT COUNT(*) FROM [Order] WHERE OrderStatus = N'Chờ xử lý'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public String getMonthlyRevenue() {
        String query = "SELECT SUM(TotalPrice) FROM [Order] WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE()) AND OrderStatus = N'Hoàn thành'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double total = rs.getDouble(1);
                if (total >= 1000000) return String.format("%.1fM", total / 1000000.0);
                return String.format("%.0f", total);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "0";
    }

    public List<Map<String, String>> getRecentOrders(int limit) {
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

    public List<Map<String, String>> getBestSellers(int limit) {
        List<Map<String, String>> list = new ArrayList<>();
        String query = "SELECT TOP (?) p.ProductName, p.IdSupplier, p.Quantity, SUM(od.Quantity) as Sold " +
                      "FROM ProductDetail p JOIN OrderDetail od ON p.IdProduct = od.IdProduct " +
                      "GROUP BY p.ProductName, p.IdSupplier, p.Quantity " +
                      "ORDER BY Sold DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("name", rs.getString("ProductName"));
                    map.put("brand", rs.getString("IdSupplier"));
                    map.put("stock", "Còn " + rs.getInt("Quantity") + " máy");
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Supplier> getAllSuppliers() throws SQLException, Exception{
        List<Supplier> list = new ArrayList<>();
        String query = "SELECT* FROM SUPPLIER";
        try {
            conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Supplier s = new Supplier(
                rs.getString("IdSupplier"),
                rs.getString("Name"),
                rs.getString("Address"),
                rs.getString("Email"),
                rs.getString("PhoneNumber"),
                rs.getString("LogoPath")
                );
                list.add(s);
            }
        }catch (Exception e){
           e.printStackTrace();
        }
        return list;
    }
    
    public int getNewProductsThisMonthCount() {
        // Đếm sản phẩm trong 30 ngày gần nhất để con số "nhảy" linh hoạt hơn
        String query = "SELECT COUNT(*) FROM ProductDetail WHERE ReleaseDate >= DATEADD(day, -30, GETDATE())";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Integer> getOrderStatusStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        // Khởi tạo các trạng thái mặc định
        stats.put("Hoàn thành", 0);
        stats.put("Chờ xử lý", 0);
        stats.put("Đã hủy", 0);
        
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

    public int getNewUsersThisMonthCount() {
        String query = "SELECT COUNT(*) FROM [User] WHERE MONTH(Birthday) = MONTH(GETDATE())"; 
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getNewOrdersThisMonthCount() {
        String query = "SELECT COUNT(*) FROM [Order] WHERE OrderDate >= DATEADD(day, -30, GETDATE())";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double getRevenueGrowth() {
        String sqlPrev = "SELECT SUM(TotalPrice) FROM [Order] WHERE MONTH(OrderDate) = MONTH(DATEADD(month, -1, GETDATE())) AND YEAR(OrderDate) = YEAR(DATEADD(month, -1, GETDATE())) AND OrderStatus = N'Hoàn thành'";
        String sqlCurr = "SELECT SUM(TotalPrice) FROM [Order] WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE()) AND OrderStatus = N'Hoàn thành'";
        try (Connection conn = new DBContext().getConnection()) {
            double prev = 0, curr = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlPrev); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) prev = rs.getDouble(1);
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlCurr); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) curr = rs.getDouble(1);
            }
            if (prev == 0) return curr > 0 ? 100.0 : 0.0;
            return ((curr - prev) / prev) * 100.0;
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }
}
