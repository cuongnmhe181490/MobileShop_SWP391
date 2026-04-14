package entity;

public class BlogPost {

    private final String slug;
    private final String category;
    private final String title;
    private final String excerpt;
    private final String publishDate;
    private final String imageUrl;

    public BlogPost(String slug, String category, String title, String excerpt, String publishDate, String imageUrl) {
        this.slug = slug;
        this.category = category;
        this.title = title;
        this.excerpt = excerpt;
        this.publishDate = publishDate;
        this.imageUrl = imageUrl;
    }

    public String getSlug() {
        return slug;
    }

    public String getCategory() {
        return category;
    }

    public String getTitle() {
        return title;
    }

    public String getExcerpt() {
        return excerpt;
    }

    public String getPublishDate() {
        return publishDate;
    }

    public String getImageUrl() {
        return imageUrl;
    }
}
