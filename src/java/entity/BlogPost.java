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
    private String idSupplier;  // Hãng / Category
    private Date createdDate;

    public BlogPost() {
    }

    public BlogPost(int blogId, int userId, String title, String subTitle, String description, String content, String imagePath, String idSupplier, Date createdDate) {
        this.blogId = blogId;
        this.userId = userId;
        this.title = title;
        this.subTitle = subTitle;
        this.description = description;
        this.content = content;
        this.imagePath = imagePath;
        this.idSupplier = idSupplier;
        this.createdDate = createdDate;
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

    public String getIdSupplier() { return idSupplier; }
    public void setIdSupplier(String idSupplier) { this.idSupplier = idSupplier; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}
