/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import config.DBContext;
import entity.Product;
import entity.ProductReview;
import java.sql.SQLException;
import entity.User;
import java.util.*;
import java.lang.*;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



/**
 *
 * @author ADMIN
 */
public class DAO {
    Connection conn = null; 
    PreparedStatement ps = null; 
    ResultSet rs = null; 
    
    public User checkLogin(String user) {
    String query = "SELECT * FROM [User] WHERE Username = ?";
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        ps.setString(1, user);
        rs = ps.executeQuery();
        if (rs.next()) {
            // Nhớ map đúng các cột, đặc biệt là cột Password
            return new User(rs.getInt(1), 
                            rs.getString(2), 
                            rs.getString(3), 
                            rs.getString(4), // Cột Password (đã băm)
                            rs.getString(5), 
                            rs.getString(6), 
                            rs.getString(7), 
                            rs.getString(8), 
                            rs.getDate(9), 
                            rs.getInt(10));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    
    public void signup(String user, String gender, String pass, String address, String email, String phone, String name, String birthday) {
    // Đã thêm danh sách cột rõ ràng để tránh lỗi IDENTITY của SQL Server
    String query = "INSERT INTO [User] (Username, Gender, [Password], [Address], "
                 + "Email, PhoneNumber, FullName, Birthday, [Role]) \n"
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
        String query = "select * from [User]\n"
                + "where Username = ?\n";
        try {
            conn = new DBContext().getConnection();//mo ket noi voi sql
            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            rs = ps.executeQuery();
            while (rs.next()) {
                return new User(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getString(7),
                        rs.getString(8),
                        rs.getDate(9),
                        rs.getInt(10));
            }
        } catch (Exception e) {
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

    private Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
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


    private List<Product> queryProducts(String sql, SqlConsumer<PreparedStatement> binder) {
        List<Product> list = new ArrayList<>();
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

    public List<Product> getFeaturedProducts(int limit) {
        return queryProducts(
                "SELECT * FROM ProductDetail ORDER BY ReleaseDate DESC, Price DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY",
                ps -> ps.setInt(1, limit)
        );
    }

    public List<Product> getLatestProducts(int limit) {
        return getFeaturedProducts(limit);
    }

    public Product getProductByID(String id) {
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

    @FunctionalInterface
    private interface SqlConsumer<T> {
        void accept(T value) throws Exception;
    }
}