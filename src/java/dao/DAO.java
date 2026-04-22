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
import java.sql.SQLException;
import entity.User;
import java.util.*;
import java.lang.*;
import java.io.*;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

    Connection conn = null; 
    PreparedStatement ps = null; 
    ResultSet rs = null; 
    
    
    public void signup(String user, String gender, String pass, String address, String email, String phone, String name, String birthday) {
    String query = "INSERT INTO [User] (Username, Gender, [Password], [Address], Email, "
             + "PhoneNumber, FullName, Birthday, [RoleId], [Status], [CreatedDate], [LockReason]) \n"
             + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, N'Hoạt động', GETDATE(), NULL)";
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
        e.printStackTrace();
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
        } catch (Exception e) {
        }
        return null;
    }
    
    public User getUserByEmail(String email) {
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

    public List<ProductModel> getFeaturedProducts(int limit) {
        return new ArrayList<>(queryProducts(
                "SELECT * FROM ProductDetail ORDER BY ReleaseDate DESC, Price DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY",
                ps -> ps.setInt(1, limit)
        ));
    }

    public List<ProductModel> getLatestProducts(int limit) {
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

    public List<Product> getCatalogProducts(String keyword, String brand, String storage, String year, String minPrice, String maxPrice, String sort) {
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

    public List<Product> getProducts(String keyword, String supplierId, String sortBy, int offset, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM ProductDetail WHERE 1 = 1");
        List<Object> params = new ArrayList<>();
        appendProductFilters(sql, params, keyword, supplierId);
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

    public int countProducts(String keyword, String supplierId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ProductDetail WHERE 1 = 1");
        List<Object> params = new ArrayList<>();
        appendProductFilters(sql, params, keyword, supplierId);

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

    private void appendProductFilters(StringBuilder sql, List<Object> params, String keyword, String supplierId) {
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
    }

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

    private boolean hasProductDetailColumn(String columnName) {
        try (Connection conn = new DBContext().getConnection();
             ResultSet rs = conn.getMetaData().getColumns(null, null, "ProductDetail", columnName)) {
            return rs.next();
        } catch (Exception e) {
            return false;
        }
    }

    private String normalizeIdentifier(String value) {
        return value == null ? "" : value.trim();
    }

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

    private String toSqlLikeKeyword(String value) {
        return normalizeKeyword(value).replace(" ", "").replace("-", "");
    }

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
    
    // 1. Hàm tạo và lưu Token mới (Có hiệu lực 10 phút)
    public void saveResetToken(String email, String token) {
        // DATEADD(minute, 10, GETDATE()) là lệnh của SQL Server để cộng thêm 10 phút từ giờ hiện tại
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

    public User getUserByResetToken(String token) {

        String sql = "SELECT * FROM [User] WHERE ResetToken = ? AND ResetTokenExpiry > GETDATE()";
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
                u.setStatus(rs.getString("Status"));
                u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                u.setLockReason(rs.getString("LockReason"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


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
