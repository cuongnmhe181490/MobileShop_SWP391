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

    Connection conn = null; // kết nối vs sql
    PreparedStatement ps = null; // ném query sang sql
    ResultSet rs = null; // nhận kết quả trả về

    public User getAccountByUser(String user) {
        String sql = "SELECT u.*, r.RoleName " +
                 "FROM [User] u " +
                 "INNER JOIN [Role] r ON u.RoleId = r.RoleId " +
                 "WHERE u.Username = ?";
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, user);
        rs = ps.executeQuery();

        if (rs.next()) {
            // 2. Tạo đối tượng Role trước
            Role r = new Role();
            r.setRoleId(rs.getInt("RoleId"));
            r.setRoleName(rs.getString("RoleName"));
            
            User u = new User();
            u.setId(rs.getInt("UserId"));
            u.setUser(rs.getString("Username"));
            u.setGender(rs.getString("Gender"));
            u.setPass(rs.getString("Password")); // Lấy pass mã hóa lên
            u.setAddress(rs.getString("Address"));
            u.setEmail(rs.getString("Email"));
            u.setPhone(rs.getString("PhoneNumber"));
            u.setName(rs.getString("FullName"));
            u.setBirthday(rs.getDate("Birthday"));
            
            // 4. Nhét cục Role vào trong User
            u.setRole(r);

            return u;
        }
    } catch (Exception e) {
        System.out.println("Lỗi tại getAccountByUser: " + e.getMessage());
    }
    return null;
    }
 
    public int getTotalUsers() {
        String query = "SELECT COUNT(*) FROM [User]";
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
}
