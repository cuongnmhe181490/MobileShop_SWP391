/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.ResultSet;
import config.DBContext;
import entity.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

public class CartDao {
    Connection conn = null;
    PreparedStatement ps = null;

    public void insertCategory(String name, String imagePath) {
        String query = "INSERT INTO Category ([name], [imagePath]) VALUES (?, ?)";
        try {
            conn = new DBContext().getConnection(); // Kết nối DB
            ps = conn.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, imagePath);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String query = "SELECT * FROM Category";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ResultSet rs = null;
            rs = ps.executeQuery();
            while (rs.next()) {
                // Giả sử class Category của bạn có Constructor: id, name, imagePath
                // Hoặc dùng các hàm set tương ứng
                list.add(new Category(
                    rs.getInt("idCat"),      // Tên cột id trong DB
                    rs.getString("name"),    // Tên cột name trong DB
                    rs.getString("imagePath")// Tên cột imagePath trong DB
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: lấy category có phân trang
    // ──────────────────────────────────────────
    // ──────────────────────────────────────────
    //  READ: lấy category có phân trang
    // ──────────────────────────────────────────
    public List<Category> getAllCategoriesPaging(String search, int page, int pageSize) {
        List<Category> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String query = "SELECT * FROM Category";
        if (search != null && !search.trim().isEmpty()) {
            query += " WHERE name LIKE ?";
        }
        query += " ORDER BY idCat DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(
                    rs.getInt("idCat"),
                    rs.getString("name"),
                    rs.getString("imagePath")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ──────────────────────────────────────────
    //  READ: đếm tổng số category
    // ──────────────────────────────────────────
    // ──────────────────────────────────────────
    //  READ: đếm tổng số category
    // ──────────────────────────────────────────
    public int getTotalCount(String search) {
        String query = "SELECT COUNT(*) FROM Category";
        if (search != null && !search.trim().isEmpty()) {
            query += " WHERE name LIKE ?";
        }
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search.trim() + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ──────────────────────────────────────────
    //  READ: lấy category theo ID
    // ──────────────────────────────────────────
    public Category getCategoryById(int id) {
        String query = "SELECT * FROM Category WHERE idCat = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Category(
                    rs.getInt("idCat"),
                    rs.getString("name"),
                    rs.getString("imagePath")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ──────────────────────────────────────────
    //  UPDATE: cập nhật category theo ID
    // ──────────────────────────────────────────
    public boolean updateCategory(int id, String name, String imagePath) {
        String query = "UPDATE Category SET [name] = ?, [imagePath] = ? WHERE idCat = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, imagePath);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  DELETE: xoa category theo ID
    // ──────────────────────────────────────────
    public boolean deleteCategory(int id) {
        String query = "DELETE FROM Category WHERE idCat = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ──────────────────────────────────────────
    //  READ: lấy category mới nhất (id lớn nhất)
    // ──────────────────────────────────────────
    public Category getLatestCategory() {
        String query = "SELECT TOP 1 * FROM Category ORDER BY idCat DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Category(
                    rs.getInt("idCat"),
                    rs.getString("name"),
                    rs.getString("imagePath")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
