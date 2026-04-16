package entity;

public class ProductReview {

    private final String productId;
    private final int userId;
    private final String reviewerName;
    private final String reviewDate;
    private final String review;
    private final int ranking;

    public ProductReview(String productId, int userId, String reviewerName, String reviewDate, String review, int ranking) {
        this.productId = productId;
        this.userId = userId;
        this.reviewerName = reviewerName;
        this.reviewDate = reviewDate;
        this.review = review;
        this.ranking = ranking;
    }

    public String getProductId() {
        return productId;
    }

    public int getUserId() {
        return userId;
    }

    public String getReviewerName() {
        return reviewerName;
    }

    public String getReviewDate() {
        return reviewDate;
    }

    public String getReview() {
        return review;
    }

    public int getRanking() {
        return ranking;
    }
}
