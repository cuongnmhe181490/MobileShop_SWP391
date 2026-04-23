package entity;

public class OrderDetail {
    private int idOrder;
    private String idProduct;
    private int quantity;
    private double unitPrice;

    public OrderDetail() {
    }

    public OrderDetail(int idOrder, String idProduct, int quantity, double unitPrice) {
        this.idOrder = idOrder;
        this.idProduct = idProduct;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getIdOrder() {
        return idOrder;
    }

    public void setIdOrder(int idOrder) {
        this.idOrder = idOrder;
    }

    public String getIdProduct() {
        return idProduct;
    }

    public void setIdProduct(String idProduct) {
        this.idProduct = idProduct;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
}
