package dao.product;

import config.DBContext;
import entity.Product;
import entity.ProductModel;
import entity.ProductReview;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public class ProductStorefrontDAO extends ProductBaseDAO {

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

    public List<Product> getCatalogProducts(String keyword, String brand, String storage,
            String year, String minPrice, String maxPrice, String sort) {
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
}
