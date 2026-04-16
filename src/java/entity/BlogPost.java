package entity;

import java.sql.Date;

public class BlogPost {
    private int idPost;
    private String title;
    private String subTitle;
    private String summary;
    private String content;
    private String thumbnailPath;
    private Date createdDate;
    
    // Các khóa ngoại
    private int userId;
    private String idSupplier;

    public BlogPost() {
    }

    public BlogPost(int idPost, String title, String subTitle, String summary, String content, String thumbnailPath, Date createdDate, int userId, String idSupplier) {
        this.idPost = idPost;
        this.title = title;
        this.subTitle = subTitle;
        this.summary = summary;
        this.content = content;
        this.thumbnailPath = thumbnailPath;
        this.createdDate = createdDate;
        this.userId = userId;
        this.idSupplier = idSupplier;
    }

    public int getIdPost() { return idPost; }
    public void setIdPost(int idPost) { this.idPost = idPost; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSubTitle() { return subTitle; }
    public void setSubTitle(String subTitle) { this.subTitle = subTitle; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getThumbnailPath() { return thumbnailPath; }
    public void setThumbnailPath(String thumbnailPath) { this.thumbnailPath = thumbnailPath; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getIdSupplier() { return idSupplier; }
    public void setIdSupplier(String idSupplier) { this.idSupplier = idSupplier; }
}
