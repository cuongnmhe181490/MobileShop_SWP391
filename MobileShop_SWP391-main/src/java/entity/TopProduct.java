package entity;

/**
 * Entity cho bảng TopProduct - sản phẩm nổi bật hiển thị trên trang chủ
 */
public class TopProduct {
    private int id;
    private String productName;
    private String productImage;
    private double price;
    private double originalPrice;
    private int displayOrder;
    private boolean isActive;
    private int discountPercent; // % giảm giá (0-100)

    public TopProduct() {
    }

    public TopProduct(int id, String productName, String productImage, 
                      double price, double originalPrice, int displayOrder, boolean isActive, int discountPercent) {
        this.id = id;
        this.productName = productName;
        this.productImage = productImage;
        this.price = price;
        this.originalPrice = originalPrice;
        this.displayOrder = displayOrder;
        this.isActive = isActive;
        this.discountPercent = discountPercent;
    }

    // Getters
    public int getId() { return id; }
    public String getProductName() { return productName; }
    public String getProductImage() { return productImage; }
    public double getPrice() { return price; }
    public double getOriginalPrice() { return originalPrice; }
    public int getDisplayOrder() { return displayOrder; }
    public boolean isActive() { return isActive; }
    public int getDiscountPercent() { return discountPercent; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setProductName(String productName) { this.productName = productName; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    public void setPrice(double price) { this.price = price; }
    public void setOriginalPrice(double originalPrice) { this.originalPrice = originalPrice; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
    public void setActive(boolean active) { this.isActive = active; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }
}