package entity;

public class Category {
    private int idCat;
    private String name;
    private String imagePath;

    public Category() {}

    public Category(int idCat, String name, String imagePath) {
        this.idCat = idCat;
        this.name = name;
        this.imagePath = imagePath;
    }

    // Getters and Setters
    public int getIdCat() { return idCat; }
    public void setIdCat(int idCat) { this.idCat = idCat; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}