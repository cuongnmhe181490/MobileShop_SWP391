/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import config.DBContext;
import entity.Product;
import entity.ProductModel;
import entity.Review;
import entity.Role;
import entity.Order;
import entity.OrderDetail;
import java.sql.SQLException;
import java.sql.Statement;
import entity.User;
import java.util.*;
import java.lang.*;
import java.io.*;
import java.text.NumberFormat;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.regex.Matcher;

import java.util.regex.Pattern;
import java.util.logging.Level;
import java.util.logging.Logger;
import entity.Supplier;




/**
 *
 * @author ADMIN
 */
public class DAO {
    private static final Pattern RELEASE_YEAR_PATTERN = Pattern.compile("(19|20)\\d{2}");

    
    
    /**
     * ÄÄƒng kÃ½ tÃ i khoáº£n ngÆ°á»i dÃ¹ng má»›i
     */
    public void signup(String user, String gender, String pass, String address, String email, String phone, String name, String birthday) {
    // ÄÃ£ thÃªm danh sÃ¡ch cá»™t rÃµ rÃ ng Ä‘á»ƒ trÃ¡nh lá»—i IDENTITY cá»§a SQL Server
    String query = "INSERT INTO [User] (Username, Gender, [Password], [Address], Email, "
             + "PhoneNumber, FullName, Birthday, [RoleId], [Status], [CreatedDate], [LockReason]) \n"
             + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, N'Hoáº¡t Ä‘á»™ng', GETDATE(), NULL)";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
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
        e.printStackTrace(); // Ráº¥t quan trá»ng: In lá»—i ra Ä‘á»ƒ biáº¿t náº¿u SQL bá»‹ sai
    }
}
    
    /**
     * Kiá»ƒm tra xem Username Ä‘Ã£ tá»“n táº¡i chÆ°a, náº¿u cÃ³ thÃ¬ tráº£ vá» Ä‘á»‘i tÆ°á»£ng User Ä‘áº§y Ä‘á»§ kÃ¨m Role
     */
    public User checkUserExist(String user) {
        String query = "SELECT u.*, r.RoleName \n"
                 + "FROM [User] u \n"
                 + "INNER JOIN [Role] r ON u.RoleId = r.RoleId \n"
                 + "WHERE u.Username = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
                    u.setStatus(rs.getString("Status"));
                    u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    u.setLockReason(rs.getString("LockReason"));
                    u.setRole(r);

                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Láº¥y thÃ´ng tin ngÆ°á»i dÃ¹ng dá»±a trÃªn Email (dÃ¹ng cho Login/Reset Pass)
     */
    public User getUserByEmail(String email) {
    // Truy váº¥n JOIN Ä‘á»ƒ láº¥y tÃªn Role cÃ¹ng lÃºc
    String sql = "SELECT u.*, r.RoleName " +
                 "FROM [User] u " +
                 "INNER JOIN [Role] r ON u.RoleId = r.RoleId " +
                 "WHERE u.Email = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("RoleId"));
                role.setRoleName(rs.getString("RoleName"));

                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setEmail(rs.getString("Email"));
                user.setPass(rs.getString("Password")); 
                user.setName(rs.getNString("FullName"));
                user.setPhone(rs.getString("PhoneNumber"));
                user.setAddress(rs.getNString("Address"));
                user.setGender(rs.getString("Gender"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setStatus(rs.getString("Status"));
                user.setCreatedDate(rs.getTimestamp("CreatedDate"));
                user.setLockReason(rs.getString("LockReason"));
                user.setRole(role);

                return user;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    
    /**
     * Kiá»ƒm tra xem Email Ä‘Ã£ cÃ³ ngÆ°á»i sá»­ dá»¥ng chÆ°a
     */
    public boolean checkEmailExist(String email) {
        String query = "SELECT 1 FROM [User] WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiá»ƒm tra xem Sá»‘ Ä‘iá»‡n thoáº¡i Ä‘Ã£ cÃ³ ngÆ°á»i sá»­ dá»¥ng chÆ°a
     */
    public boolean checkPhoneExist(String phone) {
        String query = "SELECT 1 FROM [User] WHERE PhoneNumber = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Chuyá»ƒn Ä‘á»•i dá»¯ liá»‡u tá»« ResultSet sang Ä‘á»‘i tÆ°á»£ng Product
     */
    private Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getString("IdProduct"),
                rs.getString("ProductName"),
                rs.getDouble("Price"),
                readQuantity(rs, "OriginalQuantity", "Quantity"),
                readQuantity(rs, "CurrentQuantity", "Quantity"),
                rs.getString("ReleaseDate"),
                rs.getString("Screen"),
                rs.getString("OperatingSystem"),
                rs.getString("CPU"),
                rs.getObject("RAM") == null ? "" : String.valueOf(rs.getInt("RAM")),
                rs.getString("Camera"),
                rs.getString("Battery"),
                rs.getString("Description"),
                readDouble(rs, "Discount"),
                rs.getString("IdSupplier"),
                rs.getString("ImagePath"),
                readQuantity(rs, "idCat"),
                readQuantity(rs, "IsFeatured")
        );
    }
    

    /**
     * Chuyá»ƒn Ä‘á»•i dá»¯ liá»‡u tá»« ResultSet sang Ä‘á»‘i tÆ°á»£ng ProductReview (ÄÃ¡nh giÃ¡)
     */


    private Review mapReview(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setIdProduct(rs.getString("IdProduct"));
        r.setUserId(rs.getInt("UserId"));
        r.setReviewerName(rs.getString("ReviewerName"));
        r.setReviewDate(rs.getTimestamp("ReviewDate"));
        r.setReviewContent(rs.getString("Review"));
        r.setRanking(rs.getInt("Ranking"));
        return r;
    }


    /**
     * HÃ m chung Ä‘á»ƒ thá»±c thi cÃ¡c cÃ¢u lá»‡nh SELECT vÃ  tráº£ vá» danh sÃ¡ch sáº£n pháº©m
     */
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

    /**
     * Láº¥y danh sÃ¡ch sáº£n pháº©m ná»•i báº­t (theo ngÃ y phÃ¡t hÃ nh vÃ  giÃ¡)
     */
    public List<ProductModel> getFeaturedProducts(int limit) {
        return new ArrayList<>(queryProducts(
                "SELECT * FROM ProductDetail ORDER BY ReleaseDate DESC, Price DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY",
                ps -> ps.setInt(1, limit)
        ));
    }

    /**
     * Láº¥y danh sÃ¡ch sáº£n pháº©m má»›i nháº¥t
     */
    public List<ProductModel> getLatestProducts(int limit) {
        return getFeaturedProducts(limit);
    }

    /**
     * TÃ¬m sáº£n pháº©m theo ID
     */
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

    /**
     * TÃ¬m sáº£n pháº©m theo hÃ£ng vÃ  tÃªn (DÃ¹ng cho Trade-in hoáº·c gá»£i Ã½)
     */
    public Product getProductByBrandAndName(String brand, String modelName) {
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

    /**
     * Láº¥y danh sÃ¡ch táº¥t cáº£ cÃ¡c hÃ£ng hiá»‡n cÃ³ trong há»‡ thá»‘ng
     */
    public List<String> getAvailableBrands() {
        List<String> brands = new ArrayList<>();
        String query = "SELECT DISTINCT IdSupplier FROM ProductDetail "
                + "WHERE IdSupplier IS NOT NULL AND LTRIM(RTRIM(IdSupplier)) <> '' ORDER BY IdSupplier";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                brands.add(rs.getString("IdSupplier"));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return brands;
    }

    /**
     * Láº¥y cÃ¡c tÃ¹y chá»n RAM hiá»‡n cÃ³ (Ä‘á»ƒ lÃ m bá»™ lá»c)
     */
    public List<Integer> getAvailableRamOptions() {
        List<Integer> ramOptions = new ArrayList<>();
        String query = "SELECT DISTINCT RAM FROM ProductDetail WHERE RAM IS NOT NULL";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int ramValue = parseMemoryValue(rs.getString("RAM"));
                if (ramValue > 0 && !ramOptions.contains(ramValue)) {
                    ramOptions.add(ramValue);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        Collections.sort(ramOptions);
        return ramOptions;
    }

    /**
     * Láº¥y cÃ¡c nÄƒm phÃ¡t hÃ nh hiá»‡n cÃ³ (Ä‘á»ƒ lÃ m bá»™ lá»c)
     */
    public List<Integer> getAvailableReleaseYears(int limit) {
        Set<Integer> yearSet = new TreeSet<>(Comparator.reverseOrder());
        String query = "SELECT ReleaseDate FROM ProductDetail WHERE ReleaseDate IS NOT NULL";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int releaseYear = parseReleaseYear(rs.getString("ReleaseDate"));
                if (releaseYear > 0) {
                    yearSet.add(releaseYear);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        List<Integer> years = new ArrayList<>(yearSet);
        if (limit > 0 && years.size() > limit) {
            return new ArrayList<>(years.subList(0, limit));
        }
        return years;
    }

    /**
     * HÃ m tÃ¬m kiáº¿m vÃ  lá»c sáº£n pháº©m tá»•ng há»£p (keyword, brand, ram, year, price, sort)
     */
    public List<Product> getCatalogProducts(String keyword, String brand, String storage, String year, String minPrice, String maxPrice, String sort, String startDate, String endDate) {
        List<Product> products = new ArrayList<>();
        String normalizedKeyword = normalizeKeyword(keyword);
        String normalizedBrand = normalizeIdentifier(brand);
        int storageValue = parseMemoryValue(storage);
        int releaseYear = parseReleaseYear(year);
        Double minPriceValue = parsePriceValue(minPrice);
        Double maxPriceValue = parsePriceValue(maxPrice);
        if (minPriceValue != null && maxPriceValue != null && minPriceValue > maxPriceValue) {
            double temp = minPriceValue;
            minPriceValue = maxPriceValue;
            maxPriceValue = temp;
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM ProductDetail WHERE 1 = 1");
        List<Object> parameters = new ArrayList<>();

        if (!normalizedKeyword.isEmpty()) {
            String sqlKeyword = toSqlLikeKeyword(normalizedKeyword);
            sql.append(" AND (");
            sql.append("REPLACE(REPLACE(LOWER(ProductName), ' ', ''), '-', '') LIKE ? ");
            sql.append("OR REPLACE(REPLACE(LOWER(IdSupplier), ' ', ''), '-', '') LIKE ? ");
            sql.append("OR REPLACE(REPLACE(LOWER(CONCAT(IdSupplier, ProductName)), ' ', ''), '-', '') LIKE ? ");
            sql.append("OR REPLACE(REPLACE(LOWER(ProductName), ' ', ''), '-', '') LIKE ?");
            sql.append(")");
            parameters.add("%" + sqlKeyword + "%");
            parameters.add("%" + sqlKeyword + "%");
            parameters.add("%" + sqlKeyword + "%");
            parameters.add("%" + sqlKeyword + "%");
        }

        if (!normalizedBrand.isEmpty()) {
            sql.append(" AND IdSupplier = ?");
            parameters.add(normalizedBrand);
        }

        if (storageValue > 0) {
            sql.append(" AND RAM = ?");
            parameters.add(storageValue);
        }

        if (releaseYear > 0) {
            sql.append(" AND ReleaseDate LIKE ?");
            parameters.add("%" + releaseYear + "%");
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND ReleaseDate >= ?");
            parameters.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND ReleaseDate <= ?");
            parameters.add(endDate);
        }

        if (minPriceValue != null) {
            sql.append(" AND Price >= ?");
            parameters.add(minPriceValue);
        }

        if (maxPriceValue != null) {
            sql.append(" AND Price <= ?");
            parameters.add(maxPriceValue);
        }

        sql.append(" ORDER BY ");
        switch (normalizeIdentifier(sort)) {
            case "price-asc":
                sql.append("Price ASC, ReleaseDate DESC");
                break;
            case "price-desc":
                sql.append("Price DESC, ReleaseDate DESC");
                break;
            case "year-asc":
                sql.append("YEAR(ReleaseDate) ASC, Price DESC");
                break;
            case "year-desc":
                sql.append("YEAR(ReleaseDate) DESC, Price DESC");
                break;
            default:
                sql.append("ReleaseDate DESC, Price DESC");
                break;
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindParams(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return products;
    }

    /**
     * Láº¥y danh sÃ¡ch sáº£n pháº©m liÃªn quan (cÃ¹ng hÃ£ng)
     */
    public List<Product> getRelatedProducts(String supplier, String excludeId, int limit) {
        return queryProducts(
                "SELECT * FROM ProductDetail WHERE IdSupplier = ? AND IdProduct <> ? "
                + "ORDER BY ReleaseDate DESC, Price DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY",
                ps -> {
                    ps.setString(1, supplier);
                    ps.setString(2, excludeId);
                    ps.setInt(3, limit);
                }
        );
    }

    /**
     * Kiá»ƒm tra xem database cÃ³ dá»¯ liá»‡u sáº£n pháº©m khÃ´ng
     */
    public boolean canAccessProductData() {
        String query = "SELECT TOP 1 1 FROM ProductDetail";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Láº¥y danh sÃ¡ch sáº£n pháº©m cÃ³ phÃ¢n trang (dÃ¹ng cho trang quáº£n lÃ½)
     */
    public List<Product> getProducts(String keyword, String supplierId, String sortBy, int offset, int pageSize, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT * FROM ProductDetail WHERE 1 = 1");
        List<Object> params = new ArrayList<>();
        appendProductFilters(sql, params, keyword, supplierId, startDate, endDate);
        sql.append(" ORDER BY ").append(resolveSortClause(sortBy)).append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        List<Product> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Äáº¿m tá»•ng sá»‘ sáº£n pháº©m dá»±a trÃªn bá»™ lá»c (dÃ¹ng Ä‘á»ƒ tÃ­nh sá»‘ trang)
     */
    public int countProducts(String keyword, String supplierId, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ProductDetail WHERE 1 = 1");
        List<Object> params = new ArrayList<>();
        appendProductFilters(sql, params, keyword, supplierId, startDate, endDate);

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindParams(ps, params);
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

    /**
     * ThÃªm sáº£n pháº©m má»›i vÃ o database
     */
    public boolean addProduct(Product product) {
        boolean splitQuantitySchema = hasProductDetailColumn("OriginalQuantity") && hasProductDetailColumn("CurrentQuantity");
        boolean hasFeaturedColumn = hasProductDetailColumn("IsFeatured");
        String query;
        if (splitQuantitySchema) {
            query = "INSERT INTO ProductDetail (IdProduct, ProductName, Price, OriginalQuantity, CurrentQuantity, ReleaseDate, Screen, OperatingSystem, CPU, RAM, Camera, Battery, Description, Discount, ImagePath, IdSupplier, idCat"
                    + (hasFeaturedColumn ? ", IsFeatured" : "")
                    + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"
                    + (hasFeaturedColumn ? ", ?" : "")
                    + ")";
        } else {
            query = "INSERT INTO ProductDetail (IdProduct, ProductName, Price, Quantity, ReleaseDate, Screen, OperatingSystem, CPU, RAM, Camera, Battery, Description, Discount, ImagePath, IdSupplier, idCat) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            bindProduct(ps, product, false, splitQuantitySchema, hasFeaturedColumn);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cáº­p nháº­t thÃ´ng tin sáº£n pháº©m hiá»‡n cÃ³
     */
    public boolean updateProduct(Product product) {
        Product existing = getProductByID(product.getIdProduct());
        if (existing != null) {
            if (product.getOriginalQuantity() < 0) {
                product.setOriginalQuantity(existing.getOriginalQuantity());
            }
            if (product.getCurrentQuantity() < 0) {
                product.setCurrentQuantity(existing.getCurrentQuantity());
            }
            if (product.getIsFeatured() < 0) {
                product.setIsFeatured(existing.getIsFeatured());
            }
        }
        boolean splitQuantitySchema = hasProductDetailColumn("OriginalQuantity") && hasProductDetailColumn("CurrentQuantity");
        boolean hasFeaturedColumn = hasProductDetailColumn("IsFeatured");
        String query;
        if (splitQuantitySchema) {
            query = "UPDATE ProductDetail SET ProductName = ?, Price = ?, OriginalQuantity = ?, CurrentQuantity = ?, ReleaseDate = ?, Screen = ?, OperatingSystem = ?, CPU = ?, RAM = ?, Camera = ?, Battery = ?, Description = ?, Discount = ?, ImagePath = ?, IdSupplier = ?, idCat = ?"
                    + (hasFeaturedColumn ? ", IsFeatured = ?" : "")
                    + " WHERE IdProduct = ?";
        } else {
            query = "UPDATE ProductDetail SET ProductName = ?, Price = ?, Quantity = ?, ReleaseDate = ?, Screen = ?, OperatingSystem = ?, CPU = ?, RAM = ?, Camera = ?, Battery = ?, Description = ?, Discount = ?, ImagePath = ?, IdSupplier = ?, idCat = ? WHERE IdProduct = ?";
        }
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            bindProduct(ps, product, true, splitQuantitySchema, hasFeaturedColumn);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * XÃ³a sáº£n pháº©m khá»i database
     */
    public boolean deleteProduct(String idProduct) {
        String query = "DELETE FROM ProductDetail WHERE IdProduct = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, idProduct);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiá»ƒm tra xem sáº£n pháº©m Ä‘Ã£ tá»“n táº¡i theo tÃªn vÃ  hÃ£ng chÆ°a
     */
    public boolean productExistsByNameAndSupplier(String productName, String supplierId) {
        String query = "SELECT 1 FROM ProductDetail WHERE ProductName = ? AND IdSupplier = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, productName);
            ps.setString(2, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cáº­p nháº­t sá»‘ lÆ°á»£ng tá»“n kho (Restock) cho sáº£n pháº©m Ä‘Ã£ cÃ³
     */
    public boolean restockExistingProduct(String productName, String supplierId, int delta) {
        boolean splitQuantitySchema = hasProductDetailColumn("OriginalQuantity") && hasProductDetailColumn("CurrentQuantity");
        String query = splitQuantitySchema
                ? "UPDATE ProductDetail SET OriginalQuantity = OriginalQuantity + ?, CurrentQuantity = CurrentQuantity + ? WHERE ProductName = ? AND IdSupplier = ?"
                : "UPDATE ProductDetail SET Quantity = Quantity + ? WHERE ProductName = ? AND IdSupplier = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, delta);
            if (splitQuantitySchema) {
                ps.setInt(2, delta);
                ps.setString(3, productName);
                ps.setString(4, supplierId);
            } else {
                ps.setString(2, productName);
                ps.setString(3, supplierId);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Ãnh xáº¡ tÃªn hÃ£ng sang ID danh má»¥c (Hardcoded)
     */
    public Integer getCategoryIdBySupplier(String supplierId) {
        if (supplierId == null) {
            return null;
        }
        switch (supplierId.trim()) {
            case "Apple":
                return 1;
            case "Samsung":
                return 2;
            case "Oppo":
                return 3;
            case "Huawei":
                return 4;
            case "Xiaomi":
                return 5;
            case "Realme":
                return 6;
            case "Google":
                return 7;
            default:
                return null;
        }
    }

    /**
     * Láº¥y danh sÃ¡ch ID cÃ¡c nhÃ  cung cáº¥p
     */
    public List<String> getSupplierIds() {
        List<String> suppliers = new ArrayList<>();
        String query = "SELECT IdSupplier FROM Supplier ORDER BY IdSupplier";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                suppliers.add(rs.getString("IdSupplier"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return suppliers;
    }

    /**
     * Sinh ID tiáº¿p theo cho sáº£n pháº©m má»›i (vÃ­ dá»¥: 0005)
     */
    public String getNextProductId() {
        String query = "SELECT RIGHT('0000' + CAST(ISNULL(MAX(TRY_CAST(IdProduct AS INT)), 0) + 1 AS VARCHAR), 4) AS NextId FROM ProductDetail";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("NextId");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "0001";
    }

    
    /**
     * Äáº¿m sá»‘ lÆ°á»£ng Ä‘Ã¡nh giÃ¡ cá»§a má»™t sáº£n pháº©m (cÃ³ thá»ƒ lá»c theo sá»‘ sao)
     */
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
    

    /**
     * Láº¥y danh sÃ¡ch Ä‘Ã¡nh giÃ¡ cá»§a sáº£n pháº©m cÃ³ phÃ¢n trang
     */
 

    public List<Review> getProductReviews(String productId, Integer ranking, int offset, int pageSize) {
        List<Review> reviews = new ArrayList<>();
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

    /**
     * Thá»‘ng kÃª sá»‘ lÆ°á»£ng Ä‘Ã¡nh giÃ¡ theo tá»«ng má»©c sao (1-5 sao)
     */
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
    
    /**
     * TÃ­nh Ä‘iá»ƒm Ä‘Ã¡nh giÃ¡ trung bÃ¬nh cá»§a sáº£n pháº©m
     */
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
    
    /**
     * Tá»•ng sá»‘ lÆ°á»£ng Ä‘Ã¡nh giÃ¡ cá»§a má»™t sáº£n pháº©m
     */
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

    /**
     * GÃ¡n dá»¯ liá»‡u sáº£n pháº©m vÃ o PreparedStatement Ä‘á»ƒ thá»±c thi SQL
     */
    private void bindProduct(PreparedStatement ps, Product product, boolean updateMode, boolean splitQuantitySchema, boolean hasFeaturedColumn) throws Exception {
        int index = 1;
        int originalQuantity = product.getOriginalQuantity() >= 0 ? product.getOriginalQuantity() : Math.max(0, product.getCurrentQuantity());
        int currentQuantity = Math.max(0, product.getCurrentQuantity());
        double discount = Double.isNaN(product.getDiscount()) ? 0d : Math.max(0d, product.getDiscount());
        int isFeatured = Math.max(0, product.getIsFeatured());

        if (!updateMode) {
            ps.setString(index++, product.getIdProduct());
        }
        ps.setString(index++, product.getProductName());
        ps.setDouble(index++, product.getPrice());
        ps.setInt(index++, splitQuantitySchema ? originalQuantity : currentQuantity);
        if (splitQuantitySchema) {
            ps.setInt(index++, currentQuantity);
        }
        ps.setDate(index++, product.getReleaseDate() == null || product.getReleaseDate().isBlank() ? null : Date.valueOf(product.getReleaseDate()));
        ps.setString(index++, product.getScreen());
        ps.setString(index++, product.getOperatingSystem());
        ps.setString(index++, product.getCpu());
        if (product.getRam() == null || product.getRam().isBlank()) {
            ps.setNull(index++, java.sql.Types.INTEGER);
        } else {
            ps.setInt(index++, Integer.parseInt(product.getRam()));
        }
        ps.setString(index++, product.getCamera());
        ps.setString(index++, product.getBattery());
        ps.setString(index++, product.getDescription());
        ps.setDouble(index++, discount);
        ps.setString(index++, product.getImagePath());
        ps.setString(index++, product.getIdSupplier());
        if (product.getIdCat() <= 0) {
            ps.setNull(index++, java.sql.Types.INTEGER);
        } else {
            ps.setInt(index++, product.getIdCat());
        }
        if (splitQuantitySchema && hasFeaturedColumn) {
            ps.setInt(index++, isFeatured);
        }
        if (updateMode) {
            ps.setString(index, product.getIdProduct());
        }
    }

    /**
     * ThÃªm cÃ¡c Ä‘iá»u kiá»‡n lá»c SQL cho sáº£n pháº©m
     */
    private void appendProductFilters(StringBuilder sql, List<Object> params, String keyword, String supplierId, String startDate, String endDate) {
        String safeKeyword = normalizeKeyword(keyword);
        String safeSupplier = normalizeIdentifier(supplierId);

        if (!safeKeyword.isEmpty()) {
            sql.append(" AND REPLACE(REPLACE(LOWER(ProductName), ' ', ''), '-', '') LIKE ?");
            params.add("%" + toSqlLikeKeyword(safeKeyword) + "%");
        }
        if (!safeSupplier.isEmpty()) {
            sql.append(" AND IdSupplier = ?");
            params.add(safeSupplier);
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND ReleaseDate >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND ReleaseDate <= ?");
            params.add(endDate);
        }
    }

    /**
     * GÃ¡n cÃ¡c tham sá»‘ vÃ o PreparedStatement theo kiá»ƒu dá»¯ liá»‡u tÆ°Æ¡ng á»©ng
     */
    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            Object value = params.get(i);
            int index = i + 1;
            if (value instanceof Integer) {
                ps.setInt(index, (Integer) value);
            } else if (value instanceof Double) {
                ps.setDouble(index, (Double) value);
            } else {
                ps.setString(index, String.valueOf(value));
            }
        }
    }

    /**
     * Xá»­ lÃ½ chuá»—i ORDER BY cho SQL dá»±a trÃªn lá»±a chá»n sáº¯p xáº¿p
     */
    private String resolveSortClause(String sortBy) {
        String quantityColumn = hasProductDetailColumn("CurrentQuantity") ? "CurrentQuantity" : "Quantity";
        if (sortBy == null) {
            return "COALESCE(TRY_CAST(IdProduct AS INT), 2147483647) ASC, IdProduct ASC";
        }
        switch (sortBy.trim()) {
            case "priceAsc":
                return "Price ASC, COALESCE(TRY_CAST(IdProduct AS INT), 2147483647) ASC, IdProduct ASC";
            case "priceDesc":
                return "Price DESC, COALESCE(TRY_CAST(IdProduct AS INT), 2147483647) ASC, IdProduct ASC";
            case "quantityAsc":
                return quantityColumn + " ASC, COALESCE(TRY_CAST(IdProduct AS INT), 2147483647) ASC, IdProduct ASC";
            case "quantityDesc":
                return quantityColumn + " DESC, COALESCE(TRY_CAST(IdProduct AS INT), 2147483647) ASC, IdProduct ASC";
            default:
                return "COALESCE(TRY_CAST(IdProduct AS INT), 2147483647) ASC, IdProduct ASC";
        }
    }

    /**
     * Kiá»ƒm tra xem báº£ng ProductDetail cÃ³ cá»™t cá»¥ thá»ƒ nÃ o khÃ´ng (Ä‘á»ƒ xá»­ lÃ½ linh hoáº¡t cÃ¡c version DB)
     */
    private boolean hasProductDetailColumn(String columnName) {
        try (Connection conn = new DBContext().getConnection();
             ResultSet rs = conn.getMetaData().getColumns(null, null, "ProductDetail", columnName)) {
            return rs.next();
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Chuáº©n hÃ³a chuá»—i (xÃ³a khoáº£ng tráº¯ng thá»«a)
     */
    private String normalizeIdentifier(String value) {
        return value == null ? "" : value.trim();
    }

    /**
     * Chuáº©n hÃ³a tá»« khÃ³a tÃ¬m kiáº¿m (lowercase, xÃ³a dáº¥u cÃ¡ch thá»«a, xá»­ lÃ½ tá»« viáº¿t liá»n)
     */
    private String normalizeKeyword(String value) {
        if (value == null) {
            return "";
        }
        String normalized = value.toLowerCase(Locale.ROOT).trim().replaceAll("\\s+", " ");
        if (normalized.isBlank()) {
            return "";
        }
        normalized = normalized
                .replace("promax", "pro max")
                .replace("plusmax", "plus max")
                .replace("ultra5g", "ultra 5g")
                .replace("samsunggalaxy", "samsung galaxy");
        return normalized.replaceAll("\\s+", " ").trim();
    }

    /**
     * Chuyá»ƒn Ä‘á»•i tá»« khÃ³a sang Ä‘á»‹nh dáº¡ng phÃ¹ há»£p vá»›i cÃ¢u lá»‡nh LIKE trong SQL
     */
    private String toSqlLikeKeyword(String value) {
        return normalizeKeyword(value).replace(" ", "").replace("-", "");
    }

    /**
     * Chuyá»ƒn Ä‘á»•i chuá»—i dung lÆ°á»£ng (vÃ­ dá»¥ "128GB") sang sá»‘ nguyÃªn (128)
     */
    private int parseMemoryValue(String value) {
        String normalized = normalizeIdentifier(value);
        if (normalized.isEmpty()) {
            return -1;
        }
        String digits = normalized.replaceAll("[^0-9]", "");
        if (digits.isEmpty()) {
            return -1;
        }
        try {
            return Integer.parseInt(digits);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    /**
     * TrÃ­ch xuáº¥t nÄƒm phÃ¡t hÃ nh tá»« chuá»—i vÄƒn báº£n báº±ng Regex
     */
    private int parseReleaseYear(String value) {
        String normalized = normalizeIdentifier(value);
        if (normalized.isEmpty()) {
            return -1;
        }
        Matcher matcher = RELEASE_YEAR_PATTERN.matcher(normalized);
        if (!matcher.find()) {
            return -1;
        }
        try {
            return Integer.parseInt(matcher.group());
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    /**
     * Chuyá»ƒn Ä‘á»•i chuá»—i giÃ¡ tiá»n sang kiá»ƒu Double
     */
    private Double parsePriceValue(String value) {
        String normalized = normalizeIdentifier(value);
        if (normalized.isEmpty()) {
            return null;
        }
        String digits = normalized.replaceAll("[^0-9]", "");
        if (digits.isEmpty()) {
            return null;
        }
        try {
            double parsed = Double.parseDouble(digits);
            return parsed < 0 ? null : parsed;
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    /**
     * Äá»c giÃ¡ trá»‹ sá»‘ lÆ°á»£ng tá»« ResultSet (há»— trá»£ nhiá»u tÃªn cá»™t khÃ¡c nhau)
     */
    private int readQuantity(ResultSet rs, String... columnNames) throws SQLException {
        for (String columnName : columnNames) {
            try {
                return rs.getInt(columnName);
            } catch (SQLException ex) {
                // Try the next alias if the current column does not exist.
            }
        }
        return 0;
    }

    /**
     * Äá»c giÃ¡ trá»‹ kiá»ƒu Double tá»« ResultSet an toÃ n
     */
    private double readDouble(ResultSet rs, String columnName) throws SQLException {
        try {
            return rs.getDouble(columnName);
        } catch (SQLException ex) {
            return 0d;
        }
    }

    @FunctionalInterface
    private interface SqlConsumer<T> {
        void accept(T value) throws Exception;
    }
    
    // 1. HÃ m táº¡o vÃ  lÆ°u Token má»›i (CÃ³ hiá»‡u lá»±c 10 phÃºt)
    /**
     * LÆ°u mÃ£ Token khÃ´i phá»¥c máº­t kháº©u vÃ  thá»i gian háº¿t háº¡n (10 phÃºt)
     */
    public void saveResetToken(String email, String token) {
        // DATEADD(minute, 10, GETDATE()) lÃ  lá»‡nh cá»§a SQL Server Ä‘á»ƒ cá»™ng thÃªm 15 phÃºt tá»« giá» hiá»‡n táº¡i
        String sql = "UPDATE [User] SET ResetToken = ?, ResetTokenExpiry = DATEADD(minute, 10, GETDATE()) WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 2. HÃ m kiá»ƒm tra Token khi khÃ¡ch hÃ ng click vÃ o link
    /**
     * TÃ¬m ngÆ°á»i dÃ¹ng dá»±a trÃªn Reset Token (Ä‘á»ƒ xÃ¡c thá»±c link Ä‘á»•i pass)
     */
    public User getUserByResetToken(String token) {

        String sql = "SELECT * FROM [User] WHERE ResetToken = ? AND ResetTokenExpiry > GETDATE()";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("UserId"));
                    u.setEmail(rs.getString("Email"));
                    u.setName(rs.getNString("FullName"));
                    u.setStatus(rs.getString("Status"));
                    u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    u.setLockReason(rs.getString("LockReason"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. HÃ m lÆ°u máº­t kháº©u má»›i vÃ  XÃ³a Token (Chá»‰ dÃ¹ng 1 láº§n)
    /**
     * Cáº­p nháº­t máº­t kháº©u má»›i vÃ  xÃ³a Token khÃ´i phá»¥c
     */
    public void updatePasswordAndClearToken(String email, String newHashedPassword) {
        // Äá»•i pass xong thÃ¬ Ä‘Æ°a Token vá» NULL Ä‘á»ƒ vÃ´ hiá»‡u hÃ³a link cÅ©
        String sql = "UPDATE [User] SET [Password] = ?, ResetToken = NULL, ResetTokenExpiry = NULL WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * Äáº¿m tá»•ng sá»‘ lÆ°á»£ng blog (bÃ i viáº¿t) Ä‘ang hiá»ƒn thá»‹
     */
    public int getTotalBlogs() {
        String query = "SELECT COUNT(*) FROM Blog WHERE (Status = 'VISIBLE' OR Status IS NULL)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Äáº¿m tá»•ng sá»‘ lÆ°á»£ng sáº£n pháº©m trong kho
     */
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

    /**
     * Äáº¿m sá»‘ lÆ°á»£ng Ä‘Æ¡n hÃ ng Ä‘ang chá» xá»­ lÃ½
     */
    public int getPendingOrdersCount() {
        String query = "SELECT COUNT(*) FROM [Order] WHERE OrderStatus = N'Äang giao hÃ ng' OR OrderStatus = 'Pending'";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * TÃ­nh tá»•ng doanh thu trong khoáº£ng thá»i gian xÃ¡c Ä‘á»‹nh (chá»‰ tÃ­nh Ä‘Æ¡n HoÃ n thÃ nh)
     */
    public String getRevenueByDate(Date startDate, Date endDate) {
        String query = "SELECT SUM(TotalPrice) FROM [Order] WHERE OrderDate >= ? AND OrderDate <= ? AND OrderStatus = N'ÄÃ£ hoÃ n thÃ nh'";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
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

    /**
     * Láº¥y danh sÃ¡ch cÃ¡c Ä‘Æ¡n hÃ ng gáº§n Ä‘Ã¢y Ä‘á»ƒ hiá»ƒn thá»‹ Dashboard
     */
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

    /**
     * Láº¥y danh sÃ¡ch sáº£n pháº©m bÃ¡n cháº¡y nháº¥t
     */
    public List<Map<String, String>> getBestSellers(int limit, java.sql.Date startDate, java.sql.Date endDate) {
        List<Map<String, String>> list = new ArrayList<>();
        // Truy vấn dựa trên thực tế bán hàng từ OrderDetail và Order
        // Sử dụng TRY_CAST để khớp ID sản phẩm dù có hay không có số 0 ở đầu (0001 vs 1)
        // Bao gồm cả đơn đã hoàn thành và đang giao hàng để dữ liệu đầy đủ hơn
        String query = "SELECT TOP (?) p.ProductName, p.IdSupplier, " +
                      "SUM(od.Quantity) as Sold, " +
                      "SUM(od.Quantity * od.UnitPrice) as Revenue " +
                      "FROM OrderDetail od " +
                      "JOIN [Order] o ON od.IdOrder = o.IdOrder " +
                      "JOIN ProductDetail p ON TRY_CAST(od.IdProduct AS INT) = TRY_CAST(p.IdProduct AS INT) " +
                      "WHERE o.OrderStatus IN (?, ?) " +
                      "AND o.OrderDate >= ? AND o.OrderDate <= ? " +
                      "GROUP BY p.ProductName, p.IdSupplier " +
                      "ORDER BY Sold DESC, p.ProductName ASC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            ps.setString(2, dao.order.OrderDAO.STATUS_COMPLETED);
            ps.setString(3, dao.order.OrderDAO.STATUS_DELIVERING);
            ps.setDate(4, startDate);
            ps.setDate(5, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                java.text.NumberFormat nf = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("name", rs.getString("ProductName"));
                    map.put("brand", rs.getString("IdSupplier"));
                    map.put("sold", String.valueOf(rs.getInt("Sold")));
                    
                    double rev = rs.getDouble("Revenue");
                    if (rev >= 1000000) {
                        map.put("revenue", String.format("%.1fM", rev / 1000000.0));
                    } else {
                        map.put("revenue", nf.format(rev));
                    }
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Overload cũ để tương thích nếu cần
     */
    public List<Map<String, String>> getBestSellers(int limit) {
        // Mặc định lấy 30 ngày gần nhất nếu không có ngày
        java.sql.Date endDate = new java.sql.Date(System.currentTimeMillis());
        java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000));
        return getBestSellers(limit, startDate, endDate);
    }



    /**
     * Láº¥y toÃ n bá»™ danh sÃ¡ch nhÃ  cung cáº¥p (Supplier)
     */
    public List<Supplier> getAllSuppliers() throws SQLException, Exception{
        List<Supplier> list = new ArrayList<>();
        String query = "SELECT* FROM SUPPLIER";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Äáº¿m sá»‘ sáº£n pháº©m má»›i Ä‘Æ°á»£c ra máº¯t trong khoáº£ng thá»i gian xÃ¡c Ä‘á»‹nh
     */
    public int getNewProductsCount(Date startDate, Date endDate) {
        String query = "SELECT COUNT(*) FROM ProductDetail WHERE ReleaseDate >= ? AND ReleaseDate <= ?";
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

    /**
     * Láº¥y thá»‘ng kÃª sá»‘ lÆ°á»£ng Ä‘Æ¡n hÃ ng theo tá»«ng tráº¡ng thÃ¡i
     */
    public Map<String, Integer> getOrderStatusStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        // Khá»Ÿi táº¡o cÃ¡c tráº¡ng thÃ¡i máº·c Ä‘á»‹nh
        stats.put("ÄÃ£ hoÃ n thÃ nh", 0);
        stats.put("Äang giao hÃ ng", 0);
        stats.put("Pending", 0);
        stats.put("ÄÃ£ há»§y", 0);

        
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

    /**
     * Äáº¿m sá»‘ ngÆ°á»i dÃ¹ng má»›i Ä‘Äƒng kÃ½ trong khoáº£ng thá»i gian xÃ¡c Ä‘á»‹nh
     */
    public int getNewUsersCount(Date startDate, Date endDate) {
        String query = "SELECT COUNT(*) FROM [User] WHERE CreatedDate >= ? AND CreatedDate <= ?"; 
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

    /**
     * Äáº¿m sá»‘ Ä‘Æ¡n hÃ ng má»›i trong khoáº£ng thá»i gian xÃ¡c Ä‘á»‹nh
     */
    public int getNewOrdersCount(Date startDate, Date endDate) {
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

    /**
     * TÃ­nh toÃ¡n tá»· lá»‡ tÄƒng trÆ°á»Ÿng doanh thu so vá»›i thÃ¡ng trÆ°á»›c
     */
    public double getRevenueGrowth() {
        String sqlPrev = "SELECT SUM(TotalPrice) FROM [Order] WHERE MONTH(OrderDate) = MONTH(DATEADD(month, -1, GETDATE())) AND YEAR(OrderDate) = YEAR(DATEADD(month, -1, GETDATE())) AND OrderStatus = N'ÄÃ£ hoÃ n thÃ nh'";

        String sqlCurr = "SELECT SUM(TotalPrice) FROM [Order] WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE()) AND OrderStatus = N'ÄÃ£ hoÃ n thÃ nh'";

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
    /**
     * Láº¥y danh sÃ¡ch tÃªn cÃ¡c thÆ°Æ¡ng hiá»‡u (Supplier) Ä‘ang cÃ³ sáº£n pháº©m
     */
    public List<String> getActiveSuppliers() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT IdSupplier FROM ProductDetail WHERE IdSupplier IS NOT NULL ORDER BY IdSupplier";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("IdSupplier"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public Map<String, Integer> getDashboardSummary(java.sql.Date start, java.sql.Date end) {
        Map<String, Integer> summary = new HashMap<>();
        // Táº¡m thá»i bá» qua báº£ng [Order] náº¿u nÃ³ gÃ¢y lá»—i tráº¯ng trang do thiáº¿u table trong DB
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM ProductDetail WHERE ReleaseDate >= ? AND ReleaseDate <= ?) as products, " +
                     "(SELECT COUNT(*) FROM [User] WHERE CreatedDate >= ? AND CreatedDate <= ?) as users, " +
                     "(SELECT COUNT(*) FROM Blog WHERE (Status = 'VISIBLE' OR Status IS NULL)) as blogs";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, start);
            ps.setDate(2, end);
            ps.setDate(3, start);
            ps.setDate(4, end);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.put("products", rs.getInt("products"));
                    summary.put("users", rs.getInt("users"));
                    summary.put("blogs", rs.getInt("blogs"));
                    summary.put("pending", 0); // Táº¡m thá»i
                    summary.put("newProducts", 0);
                    summary.put("newUsers", 0);
                    summary.put("newOrders", 0);
                }
            }
        } catch (Exception e) { 
            System.err.println("Lá»—i táº¡i getDashboardSummary: " + e.getMessage());
            e.printStackTrace(); 
        }
        return summary;
    }

    public List<ProductModel> getProductsByBrand(String brandId) {
        List<ProductModel> list = new ArrayList<>();
        String sql = "SELECT * FROM ProductDetail WHERE IdSupplier = ? ORDER BY ProductName";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, brandId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductModel pm = new ProductModel();
                    pm.setIdProduct(rs.getString("IdProduct"));
                    pm.setProductName(rs.getString("ProductName"));
                    pm.setPrice(rs.getDouble("Price"));
                    pm.setImagePath(rs.getString("ImagePath"));
                    pm.setIdSupplier(rs.getString("IdSupplier"));
                    list.add(pm);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int addOrder(Order order) {
        String query = "INSERT INTO [Order] (UserId, OrderDate, TotalPrice, ReceiverName, ReceiverPhone, ReceiverAddress, OrderStatus) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            if (order.getUserId() != null && order.getUserId() > 0) {
                ps.setInt(1, order.getUserId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setDate(2, order.getOrderDate());
            ps.setDouble(3, order.getTotalPrice());
            ps.setString(4, order.getReceiverName());
            ps.setString(5, order.getReceiverPhone());
            ps.setString(6, order.getReceiverAddress());
            ps.setString(7, order.getOrderStatus());
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public List<Map<String, Object>> getAdminOrders(String keyword, String status) {
        List<Map<String, Object>> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, ")
                .append("o.ReceiverAddress, o.OrderStatus, COUNT(od.IdProduct) AS ItemCount ")
                .append("FROM [Order] o LEFT JOIN OrderDetail od ON o.IdOrder = od.IdOrder WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (CAST(o.IdOrder AS varchar(20)) LIKE ? OR o.ReceiverName LIKE ? OR o.ReceiverPhone LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (isAllowedOrderStatus(status)) {
            sql.append("AND o.OrderStatus = ? ");
            params.add(status);
        }
        sql.append("GROUP BY o.IdOrder, o.OrderDate, o.TotalPrice, o.ReceiverName, o.ReceiverPhone, o.ReceiverAddress, o.OrderStatus ")
                .append("ORDER BY o.OrderDate DESC, o.IdOrder DESC");
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderRow(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return orders;
    }

    public List<Map<String, Object>> getOrderDetails(int orderId) {
        List<Map<String, Object>> details = new ArrayList<>();
        String sql = "SELECT od.IdOrder, od.IdProduct, p.ProductName, p.ImagePath, od.Quantity, od.UnitPrice, (od.Quantity * od.UnitPrice) AS Subtotal FROM OrderDetail od LEFT JOIN ProductDetail p ON od.IdProduct = p.IdProduct WHERE od.IdOrder = ? ORDER BY od.IdProduct";
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
        } catch (Exception e) { e.printStackTrace(); }
        return details;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        if (!isAllowedOrderStatus(status)) return false;
        String sql = "UPDATE [Order] SET OrderStatus = ? WHERE IdOrder = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean isAllowedOrderStatus(String status) {
        return "Đang giao hàng".equals(status) || "Đã hoàn thành".equals(status) || "Đã hủy".equals(status);
    }

    private Map<String, Object> mapOrderRow(ResultSet rs) throws java.sql.SQLException {
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
