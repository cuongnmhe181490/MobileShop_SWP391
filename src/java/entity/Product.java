/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author LENOVO
 */
public class Product {

    
    private String idProduct, productName;
    private double price, discount;
    private int quantity;
    private String releaseDate, screen, operatingSystem, cpu, ram, camera, battery, description, idSupplier,imagePath;

    public Product(int aInt, String string, String string1, double aDouble, String string2, String string3) {
    }

    public Product(String idProduct, String productName, double price, int quantity, String releaseDate, String screen, String operatingSystem, String cpu, String ram, String camera, String battery, String description, double discount, String idSupplier, String imagePath) {
        this.idProduct = idProduct;
        this.productName = productName;
        this.price = price;
        this.discount = discount;
        this.quantity = quantity;
        this.releaseDate = releaseDate;
        this.screen = screen;
        this.operatingSystem = operatingSystem;
        this.cpu = cpu;
        this.ram = ram;
        this.camera = camera;
        this.battery = battery;
        this.description = description;
        this.idSupplier = idSupplier;
        this.imagePath = imagePath;
    }

    public String getIdProduct() {
        return idProduct;
    }

    public void setIdProduct(String idProduct) {
        this.idProduct = idProduct;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getScreen() {
        return screen;
    }

    public void setScreen(String screen) {
        this.screen = screen;
    }

    public String getOperatingSystem() {
        return operatingSystem;
    }

    public void setOperatingSystem(String operatingSystem) {
        this.operatingSystem = operatingSystem;
    }

    public String getCpu() {
        return cpu;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public String getRam() {
        return ram;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public String getCamera() {
        return camera;
    }

    public void setCamera(String camera) {
        this.camera = camera;
    }

    public String getBattery() {
        return battery;
    }

    public void setBattery(String battery) {
        this.battery = battery;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIdSupplier() {
        return idSupplier;
    }

    public void setIdSupplier(String idSupplier) {
        this.idSupplier = idSupplier;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    @Override
    public String toString() {
        return "Product{" + "idProduct=" + idProduct + ", productName=" + productName + ", price=" + price + ", discount=" + discount + ", quantity=" + quantity + ", releaseDate=" + releaseDate + ", screen=" + screen + ", operatingSystem=" + operatingSystem + ", cpu=" + cpu + ", ram=" + ram + ", camera=" + camera + ", battery=" + battery + ", description=" + description + ", idSupplier=" + idSupplier + ", imagePath=" + imagePath + '}';
    }

    
    
}
