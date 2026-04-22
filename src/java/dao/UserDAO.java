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
                    u.setRole(r);
                    u.setStatus(rs.getString("Status"));
                    u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    u.setLockReason(rs.getString("LockReason"));
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
    
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM [User] u INNER JOIN [Role] r ON u.RoleId = r.RoleId ORDER BY u.RoleId ASC, u.UserId DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("RoleId"));
                r.setRoleName(rs.getString("RoleName"));

                User u = new User();
                u.setId(rs.getInt("UserId"));
                u.setUser(rs.getString("Username"));
                u.setEmail(rs.getString("Email"));
                u.setPhone(rs.getString("PhoneNumber"));
                u.setName(rs.getString("FullName"));
                u.setRole(r);
                u.setStatus(rs.getString("Status"));
                u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                u.setLockReason(rs.getString("LockReason"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean lockUser(int userId, String reason) {
        String sql = "UPDATE [User] SET Status = N'Không hoạt động', LockReason = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean unlockUser(int userId) {
        String sql = "UPDATE [User] SET Status = N'Hoạt động', LockReason = NULL WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changeUserRole(int userId, int roleId) {
        String sql = "UPDATE [User] SET RoleId = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public User getUserById(int userId) {
        String sql = "SELECT u.*, r.RoleName FROM [User] u INNER JOIN [Role] r ON u.RoleId = r.RoleId WHERE u.UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role r = new Role();
                    r.setRoleId(rs.getInt("RoleId"));
                    r.setRoleName(rs.getString("RoleName"));

                    User u = new User();
                    u.setId(rs.getInt("UserId"));
                    u.setUser(rs.getString("Username"));
                    u.setEmail(rs.getString("Email"));
                    u.setPhone(rs.getString("PhoneNumber"));
                    u.setName(rs.getString("FullName"));
                    u.setAddress(rs.getString("Address")); 
                    u.setGender(rs.getString("Gender"));  
                    u.setBirthday(rs.getDate("Birthday"));
                    u.setRole(r);
                    u.setStatus(rs.getString("Status"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

   public boolean updateUserByAdmin(int userId, String fullName, String phone, String address, String gender, String birthday, int roleId) {
        String sql = "UPDATE [User] SET FullName = ?, PhoneNumber = ?, Address = ?, Gender = ?, Birthday = ?, RoleId = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, gender);

            if (birthday != null && !birthday.trim().isEmpty()) {
                ps.setDate(5, java.sql.Date.valueOf(birthday));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            ps.setInt(6, roleId);
            ps.setInt(7, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("Lỗi tại updateUserByAdmin: " + e.getMessage());
            return false;
        }
    }
   
    public String checkDuplicateForAdmin(String username, String email, String phone) {
        try (Connection conn = getConnection()) {
            String sqlUser = "SELECT 1 FROM [User] WHERE Username = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUser)) {
                ps.setString(1, username);
                if (ps.executeQuery().next()) return "Tên đăng nhập này đã tồn tại!";
            }
            
            String sqlEmail = "SELECT 1 FROM [User] WHERE Email = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlEmail)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) return "Địa chỉ Email này đã được sử dụng!";
            }

            String sqlPhone = "SELECT 1 FROM [User] WHERE PhoneNumber = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlPhone)) {
                ps.setString(1, phone);
                if (ps.executeQuery().next()) return "Số điện thoại này đã được sử dụng!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi kiểm tra cơ sở dữ liệu!";
        }
        return null; 
    }

    public boolean addUserByAdmin(String username, String password, String email, String fullName, String phone, String address, String gender, String birthday, int roleId) {
        
        // Đã xóa Status và CreatedDate, để DB tự động lấy giá trị mặc định (Default)
        String sql = "INSERT INTO [User] (Username, [Password], Email, FullName, PhoneNumber, Address, Gender, Birthday, RoleId) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password); 
            ps.setString(3, email);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            ps.setString(6, address);
            ps.setString(7, gender);
            
            if (birthday != null && !birthday.trim().isEmpty()) {
                ps.setDate(8, java.sql.Date.valueOf(birthday));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }
            
            ps.setInt(9, roleId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            // NẾU CÒN LỖI, NÓ SẼ IN CHỮ ĐỎ RA CỬA SỔ OUTPUT CỦA NETBEANS
            System.out.println("====== LỖI DATABASE TẠI addUserByAdmin ======");
            e.printStackTrace();
            return false;
        }
    }
    
    public List<User> searchUsers(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM [User] u INNER JOIN [Role] r ON u.RoleId = r.RoleId " +
                     "WHERE (u.FullName LIKE ? OR u.Email LIKE ? OR u.PhoneNumber LIKE ?) " +
                     "ORDER BY u.RoleId ASC, u.UserId DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Role r = new Role();
                    r.setRoleId(rs.getInt("RoleId"));
                    r.setRoleName(rs.getString("RoleName"));

                    User u = new User();
                    u.setId(rs.getInt("UserId"));
                    u.setUser(rs.getString("Username"));
                    u.setEmail(rs.getString("Email"));
                    u.setPhone(rs.getString("PhoneNumber"));
                    u.setName(rs.getString("FullName"));
                    u.setRole(r);
                    u.setStatus(rs.getString("Status"));
                    u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    u.setLockReason(rs.getString("LockReason"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}