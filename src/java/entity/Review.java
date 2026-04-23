package entity;

import java.sql.Timestamp;
import java.util.List;

/**
 * Unified Review entity for both Product and Service reviews.
 * Maps to table: GeneralReview
 */
public class Review {
    private int reviewId;
    private String reviewType;   // 'PRODUCT' | 'SERVICE'
    private String idProduct;    // Nullable
    private int userId;
    private Timestamp reviewDate;
    private String reviewContent;
    private String reviewTopic;     // New: comma-separated topics for services
    private int ranking;
    private String status;          // 'VISIBLE' | 'HIDDEN'
    private String replyContent;
    private Timestamp replyDate;

    // Join fields (for display purposes)
    private String reviewerName;    // User.FullName
    private String productName;     // ProductDetail.ProductName
    private String productImage;    // ProductDetail.ImagePath
    private List<ReviewImage> images;

    public Review() {}

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public String getReviewType() { return reviewType; }
    public void setReviewType(String reviewType) { this.reviewType = reviewType; }

    public String getIdProduct() { return idProduct; }
    public void setIdProduct(String idProduct) { this.idProduct = idProduct; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }

    public String getReviewContent() { return reviewContent; }
    public void setReviewContent(String reviewContent) { this.reviewContent = reviewContent; }

    public String getReviewTopic() { return reviewTopic; }
    public void setReviewTopic(String reviewTopic) { this.reviewTopic = reviewTopic; }

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

    public List<ReviewImage> getImages() { return images; }
    public void setImages(List<ReviewImage> images) { this.images = images; }
}