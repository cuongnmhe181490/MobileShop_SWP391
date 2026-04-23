/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import config.DBContext;
import entity.Role;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class UserDAO extends DBContext{

    public User getAccountByUser(String user) {
        String sql = "SELECT u.*, r.RoleName " +
                 "FROM [User] u " +
                 "INNER JOIN [Role] r ON u.RoleId = r.RoleId " +
                 "WHERE u.Username = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
                    u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    u.setRole(r);
                    return u;
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại getAccountByUser: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateProfile(int userId, String name, String phone, String address, String gender, String birthday) {
        String sql = "UPDATE [User] SET FullName = ?, PhoneNumber = ?, Address = ?, Gender = ?, Birthday = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, gender);
            if (birthday != null && !birthday.isEmpty()) {
                ps.setDate(5, java.sql.Date.valueOf(birthday));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }
            ps.setInt(6, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean changePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE [User] SET [Password] = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Đếm tổng số người dùng (Không lọc theo ngày - Dùng cho con số tổng quát)
     */
    public int getTotalUsers() {
        String query = "SELECT COUNT(*) FROM [User]";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Đếm số lượng người dùng đăng ký mới trong khoảng thời gian xác định
     */
    public int getTotalUsersByDate(java.sql.Date startDate, java.sql.Date endDate) {
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
}
