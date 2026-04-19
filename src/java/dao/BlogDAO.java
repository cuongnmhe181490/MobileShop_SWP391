package dao;

import config.DBContext;
import entity.BlogPost;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO extends DBContext {

    // ================== C: CREATE ==================
    public boolean insertBlog(BlogPost blog) {
        String query = "INSERT INTO Blog (UserId, Title, SubTitle, Summary, Content, ThumbnailPath, IdSupplier, CreatedDate) \n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, blog.getUserId());
            ps.setString(2, blog.getTitle());
            ps.setString(3, blog.getSubTitle());
            ps.setString(4, blog.getDescription());
            ps.setString(5, blog.getContent());
            ps.setString(6, blog.getImagePath());
            ps.setString(7, blog.getIdSupplier());
            
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("Lỗi insertBlog: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ================== R: READ ALL ==================
    public List<BlogPost> getAllBlogs() {
        List<BlogPost> list = new ArrayList<>();
        String query = "SELECT * FROM Blog ORDER BY IdPost DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new BlogPost(
                        rs.getInt("IdPost"),
                        rs.getInt("UserId"),
                        rs.getString("Title"),
                        rs.getString("SubTitle"),
                        rs.getString("Summary"),
                        rs.getString("Content"),
                        rs.getString("ThumbnailPath"),
                        rs.getString("IdSupplier"),
                        rs.getDate("CreatedDate")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== R: READ ONE ==================
    public BlogPost getBlogById(int blogId) {
        String query = "SELECT * FROM Blog WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, blogId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BlogPost(
                            rs.getInt("IdPost"),
                            rs.getInt("UserId"),
                            rs.getString("Title"),
                            rs.getString("SubTitle"),
                            rs.getString("Summary"),
                            rs.getString("Content"),
                            rs.getString("ThumbnailPath"),
                            rs.getString("IdSupplier"),
                            rs.getDate("CreatedDate")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ================== U: UPDATE ==================
    public boolean updateBlog(BlogPost blog) {
        String query = "UPDATE Blog SET Title = ?, SubTitle = ?, Summary = ?, Content = ?, ThumbnailPath = ?, \n"
                + "IdSupplier = ?, UserId = ? WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getSubTitle());
            ps.setString(3, blog.getDescription());
            ps.setString(4, blog.getContent());
            ps.setString(5, blog.getImagePath());
            ps.setString(6, blog.getIdSupplier());
            ps.setInt(7, blog.getUserId());
            ps.setInt(8, blog.getBlogId());
            
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================== D: DELETE ==================
    public boolean deleteBlog(int blogId) {
        String query = "DELETE FROM Blog WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, blogId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalBlogs() {
        String query = "SELECT COUNT(*) FROM Blog";
        try (Connection conn = getConnection();
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

    public List<String> getActiveSuppliers() {
        List<String> list = new ArrayList<>();
        String query = "SELECT DISTINCT IdSupplier FROM Supplier";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String id = rs.getString(1);
                if (id != null) list.add(id.trim());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<BlogPost> getBlogsBySupplier(String supplierId) {
        List<BlogPost> list = new ArrayList<>();
        String query = "SELECT * FROM Blog WHERE IdSupplier = ? ORDER BY IdPost DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new BlogPost(
                            rs.getInt("IdPost"),
                            rs.getInt("UserId"),
                            rs.getString("Title"),
                            rs.getString("SubTitle"),
                            rs.getString("Summary"),
                            rs.getString("Content"),
                            rs.getString("ThumbnailPath"),
                            rs.getString("IdSupplier"),
                            rs.getDate("CreatedDate")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
