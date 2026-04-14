/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import config.DBContext;
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
    Connection conn = null; // kết nối vs sql
    PreparedStatement ps = null; // ném query sang sql
    ResultSet rs = null; // nhận kết quả trả về
    
    public User login(String user, String pass) {
        String query = "SELECT * FROM [User]\n"
                + "WHERE Username = ?\n"
                + "AND [Password] = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, pass);
            rs = ps.executeQuery();
            
            // Dùng if thay vì while vì Username là duy nhất, chỉ trả về tối đa 1 kết quả
            if (rs.next()) {
                return new User(
                        rs.getInt("UserId"),
                        rs.getString("Username"),
                        rs.getString("Gender"),
                        rs.getString("Password"),
                        rs.getString("Address"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("FullName"),
                        rs.getDate("Birthday"), 
                        rs.getInt("Role")
                );
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra log của Tomcat thay vì để trống (nuốt lỗi)
        } finally {
            // BEST PRACTICE: Bắt buộc đóng kết nối sau khi dùng xong để tránh sập Server
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
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
}