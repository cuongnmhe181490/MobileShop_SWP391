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
        String query = "INSERT INTO Blog (Title, SubTitle, Summary, Content, ThumbnailPath, UserId, IdSupplier, CreatedDate) \n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, blog.getTitle().trim());
            ps.setString(2, blog.getSubTitle() != null ? blog.getSubTitle().trim() : "");
            ps.setString(3, blog.getSummary() != null ? blog.getSummary().trim() : "");
            ps.setString(4, blog.getContent());
            ps.setString(5, blog.getThumbnailPath());
            ps.setInt(6, blog.getUserId());
            ps.setString(7, blog.getIdSupplier().trim());
            
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
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
                        rs.getString("Title"),
                        rs.getString("SubTitle"),
                        rs.getString("Summary"),
                        rs.getString("Content"),
                        rs.getString("ThumbnailPath"),
                        rs.getDate("CreatedDate"),
                        rs.getInt("UserId"),
                        rs.getString("IdSupplier")
                ));
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
                            rs.getString("Title"),
                            rs.getString("SubTitle"),
                            rs.getString("Summary"),
                            rs.getString("Content"),
                            rs.getString("ThumbnailPath"),
                            rs.getDate("CreatedDate"),
                            rs.getInt("UserId"),
                            rs.getString("IdSupplier")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== R: READ ONE ==================
    public BlogPost getBlogById(int idPost) {
        String query = "SELECT * FROM Blog WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, idPost);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BlogPost(
                            rs.getInt("IdPost"),
                            rs.getString("Title"),
                            rs.getString("SubTitle"),
                            rs.getString("Summary"),
                            rs.getString("Content"),
                            rs.getString("ThumbnailPath"),
                            rs.getDate("CreatedDate"),
                            rs.getInt("UserId"),
                            rs.getString("IdSupplier")
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
                + "UserId = ?, IdSupplier = ? WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, blog.getTitle().trim());
            ps.setString(2, blog.getSubTitle() != null ? blog.getSubTitle().trim() : "");
            ps.setString(3, blog.getSummary() != null ? blog.getSummary().trim() : "");
            ps.setString(4, blog.getContent());
            ps.setString(5, blog.getThumbnailPath());
            ps.setInt(6, blog.getUserId());
            ps.setString(7, blog.getIdSupplier().trim());
            ps.setInt(8, blog.getIdPost());
            
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================== D: DELETE ==================
    public boolean deleteBlog(int idPost) {
        String query = "DELETE FROM Blog WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, idPost);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getActiveSuppliers() {
        List<String> list = new ArrayList<>();
        String query = "SELECT DISTINCT IdSupplier FROM Supplier";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String id = rs.getString(1);
                if (id != null) {
                    list.add(id.trim());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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
}
