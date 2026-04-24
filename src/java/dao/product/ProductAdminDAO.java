package dao.product;

import config.DBContext;
import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductAdminDAO extends ProductStorefrontDAO {

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

    public void syncInventory() {
        boolean hasQuantity = hasProductDetailColumn("Quantity");
        String sql = "UPDATE ProductDetail " +
                     "SET CurrentQuantity = OriginalQuantity - ISNULL((" +
                     "    SELECT SUM(od.Quantity) " +
                     "    FROM OrderDetail od " +
                     "    JOIN [Order] o ON od.IdOrder = o.IdOrder " +
                     "    WHERE TRY_CAST(od.IdProduct AS INT) = TRY_CAST(ProductDetail.IdProduct AS INT) " +
                     "    AND o.OrderStatus != N'Đã hủy'" +
                     "), 0)" +
                     (hasQuantity ? ", Quantity = OriginalQuantity - ISNULL((" +
                     "    SELECT SUM(od.Quantity) " +
                     "    FROM OrderDetail od " +
                     "    JOIN [Order] o ON od.IdOrder = o.IdOrder " +
                     "    WHERE TRY_CAST(od.IdProduct AS INT) = TRY_CAST(ProductDetail.IdProduct AS INT) " +
                     "    AND o.OrderStatus != N'Đã hủy'" +
                     "), 0)" : "");
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
