package entity;

public class HeroBanner {
    private int id;
    private String eyebrow;
    private String title;
    private String description;
    private String ctaPrimary;
    private String ctaSecondary;
    private String imageUrl;
    private String stat1Label;
    private String stat2Label;
    private String stat3Label;
    private boolean isActive;

    public HeroBanner() {}

    public HeroBanner(int id, String eyebrow, String title, String description,
                      String ctaPrimary, String ctaSecondary, String imageUrl,
                      String stat1Label, String stat2Label, String stat3Label, boolean isActive) {
        this.id = id;
        this.eyebrow = eyebrow;
        this.title = title;
        this.description = description;
        this.ctaPrimary = ctaPrimary;
        this.ctaSecondary = ctaSecondary;
        this.imageUrl = imageUrl;
        this.stat1Label = stat1Label;
        this.stat2Label = stat2Label;
        this.stat3Label = stat3Label;
        this.isActive = isActive;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEyebrow() { return eyebrow; }
    public void setEyebrow(String eyebrow) { this.eyebrow = eyebrow; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCtaPrimary() { return ctaPrimary; }
    public void setCtaPrimary(String ctaPrimary) { this.ctaPrimary = ctaPrimary; }

    public String getCtaSecondary() { return ctaSecondary; }
    public void setCtaSecondary(String ctaSecondary) { this.ctaSecondary = ctaSecondary; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getStat1Label() { return stat1Label; }
    public void setStat1Label(String stat1Label) { this.stat1Label = stat1Label; }

    public String getStat2Label() { return stat2Label; }
    public void setStat2Label(String stat2Label) { this.stat2Label = stat2Label; }

    public String getStat3Label() { return stat3Label; }
    public void setStat3Label(String stat3Label) { this.stat3Label = stat3Label; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}