package entity;

import java.util.Locale;

public class CartItem {

    private final ProductModel product;
    private final int quantity;
    private final int displayStock;
    private final int maxQuantity;

    public CartItem(ProductModel product, int quantity, int displayStock) {
        this(product, quantity, displayStock, product == null ? 0 : product.getQuantity());
    }

    public CartItem(ProductModel product, int quantity, int displayStock, int maxQuantity) {
        this.product = product;
        this.quantity = quantity;
        this.displayStock = displayStock;
        this.maxQuantity = maxQuantity;
    }

    public ProductModel getProduct() {
        return product;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getDisplayStock() {
        return displayStock;
    }

    public int getMaxQuantity() {
        return maxQuantity;
    }

    public double getSubtotal() {
        return product.getPrice() * quantity;
    }

    public String getPriceLabel() {
        return String.format(Locale.forLanguageTag("vi-VN"), "%,.0f đ", product.getPrice());
    }

    public String getSubtotalLabel() {
        return String.format(Locale.forLanguageTag("vi-VN"), "%,.0f đ", getSubtotal());
    }
}
