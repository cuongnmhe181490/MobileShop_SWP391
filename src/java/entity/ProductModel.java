package entity;

public class ProductModel {

    private String idProduct;
    private String productName;
    private double price;
    private double discount;
    private int originalQuantity = -1;
    private int currentQuantity = -1;
    private int idCat;
    private int isFeatured;
    private String releaseDate;
    private String screen;
    private String operatingSystem;
    private String cpu;
    private String ram;
    private String camera;
    private String battery;
    private String description;
    private String idSupplier;
    private String imagePath;

    public ProductModel() {
    }

    public ProductModel(String idProduct, String productName, double price, int quantity,
            String releaseDate, String screen, String operatingSystem, String cpu, String ram,
            String camera, String battery, String description, double discount,
            String idSupplier, String imagePath) {
        this(idProduct, productName, price, quantity, quantity, releaseDate, screen, operatingSystem,
                cpu, ram, camera, battery, description, discount, idSupplier, imagePath, 0, 0);
    }

    public ProductModel(String idProduct, String productName, double price, int quantity,
            String releaseDate, String screen, String operatingSystem, String cpu, String ram,
            String camera, String battery, String description, double discount,
            String idSupplier, String imagePath, int idCat) {
        this(idProduct, productName, price, quantity, quantity, releaseDate, screen, operatingSystem,
                cpu, ram, camera, battery, description, discount, idSupplier, imagePath, idCat, 0);
    }

    public ProductModel(String idProduct, String productName, double price, int originalQuantity,
            int currentQuantity, String releaseDate, String screen, String operatingSystem,
            String cpu, String ram, String camera, String battery, String description,
            double discount, String idSupplier, String imagePath, int idCat, int isFeatured) {
        this.idProduct = idProduct;
        this.productName = productName;
        this.price = price;
        this.originalQuantity = originalQuantity;
        this.currentQuantity = currentQuantity;
        this.releaseDate = releaseDate;
        this.screen = screen;
        this.operatingSystem = operatingSystem;
        this.cpu = cpu;
        this.ram = ram;
        this.camera = camera;
        this.battery = battery;
        this.description = description;
        this.discount = discount;
        this.idSupplier = idSupplier;
        this.imagePath = imagePath;
        this.idCat = idCat;
        this.isFeatured = isFeatured;
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

    public int getOriginalQuantity() {
        return originalQuantity;
    }

    public void setOriginalQuantity(int originalQuantity) {
        this.originalQuantity = originalQuantity;
    }

    public int getCurrentQuantity() {
        return currentQuantity;
    }

    public void setCurrentQuantity(int currentQuantity) {
        this.currentQuantity = currentQuantity;
    }

    public int getQuantity() {
        return currentQuantity;
    }

    public void setQuantity(int quantity) {
        this.currentQuantity = quantity;
    }

    public int getIdCat() {
        return idCat;
    }

    public void setIdCat(int idCat) {
        this.idCat = idCat;
    }

    public int getIsFeatured() {
        return isFeatured;
    }

    public void setIsFeatured(int isFeatured) {
        this.isFeatured = isFeatured;
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
        return "ProductModel{"
                + "idProduct=" + idProduct
                + ", productName=" + productName
                + ", price=" + price
                + ", discount=" + discount
                + ", originalQuantity=" + originalQuantity
                + ", currentQuantity=" + currentQuantity
                + ", idCat=" + idCat
                + ", isFeatured=" + isFeatured
                + ", releaseDate=" + releaseDate
                + ", screen=" + screen
                + ", operatingSystem=" + operatingSystem
                + ", cpu=" + cpu
                + ", ram=" + ram
                + ", camera=" + camera
                + ", battery=" + battery
                + ", description=" + description
                + ", idSupplier=" + idSupplier
                + ", imagePath=" + imagePath
                + '}';
    }
}
