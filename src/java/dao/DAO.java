package dao;

import config.DBContext;
import entity.Role;
import entity.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Legacy DAO class. 
 * Note: Most logic has been migrated to specialized DAOs (ProductAdminDAO, OrderDAO, etc.).
 * This class now handles authentication and specific dashboard metrics.
 */
public class DAO {

    /**
     */
    public void signup(String user, String gender, String pass, String address, String email, String phone, String name, String birthday) {
        String query = "INSERT INTO [User] (Username, Gender, [Password], [Address], Email, "
                 + "PhoneNumber, FullName, Birthday, [RoleId], [Status], [CreatedDate], [LockReason]) \n"
                 + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, N'Hoạt Động', GETDATE(), NULL)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
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

    /**
     * Kiá»ƒm tra xem Username Ä‘Ã£ tá»“n táº¡i chÆ°a
     */
    public User checkUserExist(String user) {
        String query = "SELECT u.*, r.RoleName FROM [User] u INNER JOIN [Role] r ON u.RoleId = r.RoleId WHERE u.Username = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
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
                    u.setStatus(rs.getString("Status"));
                    u.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    u.setLockReason(rs.getString("LockReason"));
                    u.setRole(r);
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Láº¥y thÃ´ng tin ngÆ°á» i dÃ¹ng dá»±a trÃªn Email
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT u.*, r.RoleName FROM [User] u INNER JOIN [Role] r ON u.RoleId = r.RoleId WHERE u.Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkEmailExist(String email) {
        String query = "SELECT 1 FROM [User] WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkPhoneExist(String phone) {
        String query = "SELECT 1 FROM [User] WHERE PhoneNumber = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void saveResetToken(String email, String token) {
        String sql = "UPDATE [User] SET ResetToken = ?, ResetTokenExpiry = DATEADD(minute, 10, GETDATE()) WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User getUserByResetToken(String token) {
        String sql = "SELECT * FROM [User] WHERE ResetToken = ? AND ResetTokenExpiry > GETDATE()";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updatePasswordAndClearToken(String email, String newHashedPassword) {
        String sql = "UPDATE [User] SET [Password] = ?, ResetToken = NULL, ResetTokenExpiry = NULL WHERE Email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
