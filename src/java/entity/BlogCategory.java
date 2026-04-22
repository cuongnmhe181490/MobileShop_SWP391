package entity;

public class BlogCategory {
    private int idBlogCat;
    private String categoryName;

    public BlogCategory() {
    }

    public BlogCategory(int idBlogCat, String categoryName) {
        this.idBlogCat = idBlogCat;
        this.categoryName = categoryName;
    }

    public int getIdBlogCat() {
        return idBlogCat;
    }

    public void setIdBlogCat(int idBlogCat) {
        this.idBlogCat = idBlogCat;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
