package entity;

import java.sql.Timestamp;

public class ProductReview {
    private int reviewId;
    private String idProduct;
    private int userId;
    private Timestamp reviewDate;
    private String reviewContent;
    private int ranking;
    private String status;       // 'VISIBLE' | 'HIDDEN'
    private String replyContent;
    private Timestamp replyDate;

    // Join fields (không lưu DB, chỉ dùng để hiển thị)
    private String reviewerName;   // User.FullName
    private String productName;    // ProductDetail.ProductName
    private String productImage;   // ProductDetail.ImagePath

    public ProductReview() {}

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public String getIdProduct() { return idProduct; }
    public void setIdProduct(String idProduct) { this.idProduct = idProduct; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }

    public String getReviewContent() { return reviewContent; }
    public void setReviewContent(String reviewContent) { this.reviewContent = reviewContent; }

    public int getRanking() { return ranking; }
    public void setRanking(int ranking) { this.ranking = ranking; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReplyContent() { return replyContent; }
    public void setReplyContent(String replyContent) { this.replyContent = replyContent; }

    public Timestamp getReplyDate() { return replyDate; }
    public void setReplyDate(Timestamp replyDate) { this.replyDate = replyDate; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    private java.util.List<ReviewImage> images;
    public java.util.List<ReviewImage> getImages() { return images; }
    public void setImages(java.util.List<ReviewImage> images) { this.images = images; }
}
