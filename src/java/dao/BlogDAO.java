package dao;

import config.DBContext;
import entity.BlogPost;
import entity.BlogCategory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO extends DBContext {

    // ================== C: CREATE ==================
    public boolean insertBlog(BlogPost blog) {
        String query = "INSERT INTO Blog (UserId, Title, SubTitle, Summary, Content, ThumbnailPath, IdBlogCat, CreatedDate) \n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, blog.getUserId());
            ps.setString(2, blog.getTitle());
            ps.setString(3, blog.getSubTitle());
            ps.setString(4, blog.getDescription());
            ps.setString(5, blog.getContent());
            ps.setString(6, blog.getImagePath());
            ps.setInt(7, blog.getIdBlogCat());
            
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("Lỗi insertBlog: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ================== R: READ WITH LIMIT (For Home Page) ==================
    public List<BlogPost> getLatestBlogs(int limit) {
        List<BlogPost> list = new ArrayList<>();
        // Không lấy cột Content vì nó nặng (NVARCHAR(MAX)) và không dùng ở Home
        String query = "SELECT TOP (?) b.IdPost, b.UserId, b.Title, b.SubTitle, b.Summary, b.ThumbnailPath, b.IdBlogCat, b.CreatedDate, bc.CategoryName \n" +
                       "FROM Blog b \n" +
                       "LEFT JOIN BlogCategory bc ON b.IdBlogCat = bc.IdBlogCat \n" +
                       "ORDER BY b.IdPost DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BlogPost b = new BlogPost();
                    b.setBlogId(rs.getInt("IdPost"));
                    b.setUserId(rs.getInt("UserId"));
                    b.setTitle(rs.getString("Title"));
                    b.setSubTitle(rs.getString("SubTitle"));
                    b.setDescription(rs.getString("Summary"));
                    b.setImagePath(rs.getString("ThumbnailPath"));
                    b.setIdBlogCat(rs.getInt("IdBlogCat"));
                    b.setCreatedDate(rs.getDate("CreatedDate"));
                    b.setCategoryName(rs.getString("CategoryName"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== R: READ ALL ==================
    public List<BlogPost> getAllBlogs() {
        List<BlogPost> list = new ArrayList<>();
        String query = "SELECT b.*, bc.CategoryName \n" +
                       "FROM Blog b \n" +
                       "LEFT JOIN BlogCategory bc ON b.IdBlogCat = bc.IdBlogCat \n" +
                       "ORDER BY b.IdPost DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BlogPost b = new BlogPost(
                        rs.getInt("IdPost"),
                        rs.getInt("UserId"),
                        rs.getString("Title"),
                        rs.getString("SubTitle"),
                        rs.getString("Summary"),
                        rs.getString("Content"),
                        rs.getString("ThumbnailPath"),
                        rs.getInt("IdBlogCat"),
                        rs.getDate("CreatedDate")
                );
                b.setCategoryName(rs.getString("CategoryName"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== R: READ ONE ==================
    public BlogPost getBlogById(int blogId) {
        String query = "SELECT b.*, bc.CategoryName \n" +
                       "FROM Blog b \n" +
                       "LEFT JOIN BlogCategory bc ON b.IdBlogCat = bc.IdBlogCat \n" +
                       "WHERE b.IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, blogId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BlogPost b = new BlogPost(
                            rs.getInt("IdPost"),
                            rs.getInt("UserId"),
                            rs.getString("Title"),
                            rs.getString("SubTitle"),
                            rs.getString("Summary"),
                            rs.getString("Content"),
                            rs.getString("ThumbnailPath"),
                            rs.getInt("IdBlogCat"),
                            rs.getDate("CreatedDate")
                    );
                    b.setCategoryName(rs.getString("CategoryName"));
                    return b;
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
                + "IdBlogCat = ?, UserId = ? WHERE IdPost = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getSubTitle());
            ps.setString(3, blog.getDescription());
            ps.setString(4, blog.getContent());
            ps.setString(5, blog.getImagePath());
            ps.setInt(6, blog.getIdBlogCat());
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

    public int getTotalBlogsByCategory(int categoryId) {
        String query = "SELECT COUNT(*) FROM Blog WHERE IdBlogCat = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BlogPost> getBlogsWithPagination(int offset, int pageSize) {
        List<BlogPost> list = new ArrayList<>();
        String query = "SELECT b.*, bc.CategoryName FROM Blog b \n" +
                       "LEFT JOIN BlogCategory bc ON b.IdBlogCat = bc.IdBlogCat \n" +
                       "ORDER BY b.IdPost DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BlogPost b = new BlogPost(
                            rs.getInt("IdPost"), rs.getInt("UserId"), rs.getString("Title"),
                            rs.getString("SubTitle"), rs.getString("Summary"), rs.getString("Content"),
                            rs.getString("ThumbnailPath"), rs.getInt("IdBlogCat"), rs.getDate("CreatedDate")
                    );
                    b.setCategoryName(rs.getString("CategoryName"));
                    list.add(b);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<BlogPost> getBlogsByCategoryWithPagination(int categoryId, int offset, int pageSize) {
        List<BlogPost> list = new ArrayList<>();
        String query = "SELECT b.*, bc.CategoryName FROM Blog b \n" +
                       "LEFT JOIN BlogCategory bc ON b.IdBlogCat = bc.IdBlogCat \n" +
                       "WHERE b.IdBlogCat = ? \n" +
                       "ORDER BY b.IdPost DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BlogPost b = new BlogPost(
                            rs.getInt("IdPost"), rs.getInt("UserId"), rs.getString("Title"),
                            rs.getString("SubTitle"), rs.getString("Summary"), rs.getString("Content"),
                            rs.getString("ThumbnailPath"), rs.getInt("IdBlogCat"), rs.getDate("CreatedDate")
                    );
                    b.setCategoryName(rs.getString("CategoryName"));
                    list.add(b);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ================== CATEGORY METHODS ==================
    public List<BlogCategory> getAllBlogCategories() {
        List<BlogCategory> list = new ArrayList<>();
        String query = "SELECT * FROM BlogCategory ORDER BY CategoryName ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BlogCategory(
                        rs.getInt("IdBlogCat"),
                        rs.getString("CategoryName")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<BlogPost> getBlogsByCategory(int categoryId) {
        List<BlogPost> list = new ArrayList<>();
        String query = "SELECT b.*, bc.CategoryName \n" +
                       "FROM Blog b \n" +
                       "LEFT JOIN BlogCategory bc ON b.IdBlogCat = bc.IdBlogCat \n" +
                       "WHERE b.IdBlogCat = ? \n" +
                       "ORDER BY b.IdPost DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BlogPost b = new BlogPost(
                            rs.getInt("IdPost"),
                            rs.getInt("UserId"),
                            rs.getString("Title"),
                            rs.getString("SubTitle"),
                            rs.getString("Summary"),
                            rs.getString("Content"),
                            rs.getString("ThumbnailPath"),
                            rs.getInt("IdBlogCat"),
                            rs.getDate("CreatedDate")
                    );
                    b.setCategoryName(rs.getString("CategoryName"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean insertBlogCategory(String name) {
        String query = "INSERT INTO BlogCategory (CategoryName) VALUES (?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBlogCategory(int id) {
        String query = "DELETE FROM BlogCategory WHERE IdBlogCat = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBlogCategory(int id, String name) {
        String query = "UPDATE BlogCategory SET CategoryName = ? WHERE IdBlogCat = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkBlogCategoryExist(String name) {
        String query = "SELECT * FROM BlogCategory WHERE CategoryName = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
