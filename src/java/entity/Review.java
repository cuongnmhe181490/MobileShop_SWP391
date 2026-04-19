package entity;

import java.sql.Timestamp;

/**
 * Entity mapping bảng ProductReview.
 */
public class Review {
    private int idReview;
    private int idProduct;
    private int idAccount;
    private String reviewerName;      // Tên người đánh giá
    private int ranking;              // Số sao (1-5)
    private String review;            // Nội dung đánh giá (Comment)
    private Timestamp reviewDate;     // Ngày đánh giá
    private boolean isVerified;       // Đã xác nhận mua hàng
    private String replyContent;      // Phản hồi của Admin
    private Timestamp replyDate;      // Ngày phản hồi

    public Review() {}

    public Review(int idReview, int idProduct, int idAccount, String reviewerName,
                  int ranking, String review, Timestamp reviewDate, boolean isVerified) {
        this.idReview = idReview;
        this.idProduct = idProduct;
        this.idAccount = idAccount;
        this.reviewerName = reviewerName;
        this.ranking = ranking;
        this.review = review;
        this.reviewDate = reviewDate;
        this.isVerified = isVerified;
    }

    // Getters and Setters
    public int getIdReview() { return idReview; }
    public void setIdReview(int idReview) { this.idReview = idReview; }

    public int getIdProduct() { return idProduct; }
    public void setIdProduct(int idProduct) { this.idProduct = idProduct; }

    public int getIdAccount() { return idAccount; }
    public void setIdAccount(int idAccount) { this.idAccount = idAccount; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public int getRanking() { return ranking; }
    public void setRanking(int ranking) { this.ranking = ranking; }

    public String getReview() { return review; }
    public void setReview(String review) { this.review = review; }

    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public String getReplyContent() { return replyContent; }
    public void setReplyContent(String replyContent) { this.replyContent = replyContent; }

    public Timestamp getReplyDate() { return replyDate; }
    public void setReplyDate(Timestamp replyDate) { this.replyDate = replyDate; }
}