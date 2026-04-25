package dao;

import config.DBContext;
import entity.Supplier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String query = "SELECT * FROM Supplier";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Supplier(
                        rs.getString("IdSupplier"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("LogoPath")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Supplier> getAllSuppliersPaging(String search, int page, int pageSize) {
        List<Supplier> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String query = "SELECT * FROM Supplier";
        if (search != null && !search.trim().isEmpty()) {
            query += " WHERE Name LIKE ? OR IdSupplier LIKE ?";
        }
        query += " ORDER BY IdSupplier OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Supplier(
                            rs.getString("IdSupplier"),
                            rs.getString("Name"),
                            rs.getString("Address"),
                            rs.getString("Email"),
                            rs.getString("PhoneNumber"),
                            rs.getString("LogoPath")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCount(String search) {
        String query = "SELECT COUNT(*) FROM Supplier";
        if (search != null && !search.trim().isEmpty()) {
            query += " WHERE Name LIKE ? OR IdSupplier LIKE ?";
        }
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search.trim() + "%");
                ps.setString(2, "%" + search.trim() + "%");
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

    public Supplier getSupplierById(String id) {
        String query = "SELECT * FROM Supplier WHERE IdSupplier = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Supplier(
                            rs.getString("IdSupplier"),
                            rs.getString("Name"),
                            rs.getString("Address"),
                            rs.getString("Email"),
                            rs.getString("PhoneNumber"),
                            rs.getString("LogoPath")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertSupplier(Supplier s) {
        String query = "INSERT INTO Supplier (IdSupplier, Name, Address, Email, PhoneNumber, LogoPath) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, s.getIdSupplier());
            ps.setString(2, s.getName());
            ps.setString(3, s.getAddress());
            ps.setString(4, s.getEmail());
            ps.setString(5, s.getPhoneNumber());
            ps.setString(6, s.getLogoPath());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSupplier(Supplier s) {
        String query = "UPDATE Supplier SET Name = ?, Address = ?, Email = ?, PhoneNumber = ?, LogoPath = ? WHERE IdSupplier = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getAddress());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getPhoneNumber());
            ps.setString(5, s.getLogoPath());
            ps.setString(6, s.getIdSupplier());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSupplier(String id) {
        String query = "DELETE FROM Supplier WHERE IdSupplier = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
