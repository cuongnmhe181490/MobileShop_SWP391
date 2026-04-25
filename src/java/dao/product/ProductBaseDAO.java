package dao.product;

import config.DBContext;
import entity.Product;
import entity.ProductReview;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

abstract class ProductBaseDAO {

    private static final Pattern RELEASE_YEAR_PATTERN = Pattern.compile("(19|20)\\d{2}");

    protected Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getString("IdProduct"),
                rs.getString("ProductName"),
                rs.getDouble("Price"),
                readQuantity(rs, "OriginalQuantity", "Quantity"),
                readQuantity(rs, "CurrentQuantity", "Quantity"),
                readIsoDate(rs, "ReleaseDate"),
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

    protected ProductReview mapReview(ResultSet rs) throws SQLException {
        ProductReview review = new ProductReview();
        review.setIdProduct(rs.getString("IdProduct"));
        review.setUserId(rs.getInt("UserId"));
        review.setReviewerName(rs.getString("ReviewerName"));
        review.setReviewDate(rs.getTimestamp("ReviewDate"));
        review.setReviewContent(rs.getString("Review"));
        review.setRanking(rs.getInt("Ranking"));
        return review;
    }

    protected List<Product> queryProducts(String sql, SqlConsumer<PreparedStatement> binder) {
        List<Product> products = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            binder.accept(ps);
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

    protected void bindProduct(PreparedStatement ps, Product product, boolean updateMode,
            boolean splitQuantitySchema, boolean hasFeaturedColumn) throws Exception {
        int index = 1;
        int originalQuantity = product.getOriginalQuantity() >= 0
                ? product.getOriginalQuantity()
                : Math.max(0, product.getCurrentQuantity());
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
        ps.setDate(index++, product.getReleaseDate() == null || product.getReleaseDate().isBlank()
                ? null
                : Date.valueOf(product.getReleaseDate()));
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

    protected void appendProductFilters(StringBuilder sql, List<Object> params, String keyword, String supplierId) {
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

    protected void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
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

    protected String resolveSortClause(String sortBy) {
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

    protected boolean hasProductDetailColumn(String columnName) {
        try (Connection conn = new DBContext().getConnection();
             ResultSet rs = conn.getMetaData().getColumns(null, null, "ProductDetail", columnName)) {
            return rs.next();
        } catch (Exception e) {
            return false;
        }
    }

    protected String normalizeIdentifier(String value) {
        return value == null ? "" : value.trim();
    }

    protected String normalizeKeyword(String value) {
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

    protected String toSqlLikeKeyword(String value) {
        return normalizeKeyword(value).replace(" ", "").replace("-", "");
    }

    protected int parseMemoryValue(String value) {
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

    protected int parseReleaseYear(String value) {
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

    protected Double parsePriceValue(String value) {
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

    protected int readQuantity(ResultSet rs, String... columnNames) throws SQLException {
        for (String columnName : columnNames) {
            try {
                return rs.getInt(columnName);
            } catch (SQLException ex) {
                // Try next alias.
            }
        }
        return 0;
    }

    protected double readDouble(ResultSet rs, String columnName) throws SQLException {
        try {
            return rs.getDouble(columnName);
        } catch (SQLException ex) {
            return 0d;
        }
    }

    protected String readIsoDate(ResultSet rs, String columnName) throws SQLException {
        try {
            Date dateValue = rs.getDate(columnName);
            return dateValue == null ? "" : dateValue.toLocalDate().toString();
        } catch (SQLException ex) {
            String rawValue = rs.getString(columnName);
            return rawValue == null ? "" : rawValue.trim();
        }
    }

    @FunctionalInterface
    protected interface SqlConsumer<T> {
        void accept(T value) throws Exception;
    }
}
