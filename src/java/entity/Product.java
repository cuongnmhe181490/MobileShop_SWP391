package entity;

public class Product extends ProductModel {

    public Product() {
        super();
    }

    public Product(String idProduct, String productName, double price, int quantity,
            String releaseDate, String screen, String operatingSystem, String cpu,
            String ram, String camera, String battery, String description,
            double discount, String idSupplier, String imagePath) {
        super(idProduct, productName, price, quantity, releaseDate, screen, operatingSystem,
                cpu, ram, camera, battery, description, discount, idSupplier, imagePath);
    }

    public Product(String idProduct, String productName, double price, int quantity,
            String releaseDate, String screen, String operatingSystem, String cpu,
            String ram, String camera, String battery, String description,
            double discount, String idSupplier, String imagePath, int idCat) {
        super(idProduct, productName, price, quantity, releaseDate, screen, operatingSystem,
                cpu, ram, camera, battery, description, discount, idSupplier, imagePath, idCat);
    }

    public Product(String idProduct, String productName, double price, int originalQuantity,
            int currentQuantity, String releaseDate, String screen, String operatingSystem,
            String cpu, String ram, String camera, String battery, String description,
            double discount, String idSupplier, String imagePath, int idCat, int isFeatured) {
        super(idProduct, productName, price, originalQuantity, currentQuantity, releaseDate, screen,
                operatingSystem, cpu, ram, camera, battery, description, discount, idSupplier,
                imagePath, idCat, isFeatured);
    }
}
