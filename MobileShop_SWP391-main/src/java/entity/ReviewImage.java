package entity;

public class ReviewImage {
    private int id;
    private int reviewId;
    private String imageUrl;
    private int sortOrder;

    public ReviewImage() {}

    public ReviewImage(int reviewId, String imageUrl, int sortOrder) {
        this.reviewId  = reviewId;
        this.imageUrl  = imageUrl;
        this.sortOrder = sortOrder;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
}
