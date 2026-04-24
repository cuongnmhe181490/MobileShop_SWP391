package entity;

import java.sql.Date;

public class BlogPost {
    private int blogId;
    private int userId;
    private String title;
    private String subTitle;    // Phụ đề (NVARCHAR(255))
    private String description; // Tóm tắt ngắn (NVARCHAR(MAX))
    private String content;     // Nội dung chi tiết (NVARCHAR(4000))
    private String imagePath;   // Ảnh bìa
    private int idBlogCat;      // Mã danh mục mới (FK to BlogCategory)
    private String categoryName; // Tên danh mục (để hiển thị)
    private Date createdDate;
    private String status;

    public BlogPost() {
    }

    public BlogPost(int blogId, int userId, String title, String subTitle, String description, String content, String imagePath, int idBlogCat, Date createdDate,String status) {
        this.blogId = blogId;
        this.userId = userId;
        this.title = title;
        this.subTitle = subTitle;
        this.description = description;
        this.content = content;
        this.imagePath = imagePath;
        this.idBlogCat = idBlogCat;
        this.createdDate = createdDate;
        this.status = status;
    }

    public int getBlogId() { return blogId; }
    public void setBlogId(int blogId) { this.blogId = blogId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSubTitle() { return subTitle; }
    public void setSubTitle(String subTitle) { this.subTitle = subTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public int getIdBlogCat() { return idBlogCat; }
    public void setIdBlogCat(int idBlogCat) { this.idBlogCat = idBlogCat; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}
