package entity;

public class TradeInQuote {

    private final String brand;
    private final String modelName;
    private final String conditionKey;
    private final String conditionLabel;
    private final double estimatedValue;
    private final ProductModel matchedProduct;

    public TradeInQuote(String brand, String modelName, String conditionKey, String conditionLabel, double estimatedValue, ProductModel matchedProduct) {
        this.brand = brand;
        this.modelName = modelName;
        this.conditionKey = conditionKey;
        this.conditionLabel = conditionLabel;
        this.estimatedValue = estimatedValue;
        this.matchedProduct = matchedProduct;
    }

    public String getBrand() {
        return brand;
    }

    public String getModelName() {
        return modelName;
    }

    public String getConditionKey() {
        return conditionKey;
    }

    public String getConditionLabel() {
        return conditionLabel;
    }

    public double getEstimatedValue() {
        return estimatedValue;
    }

    public ProductModel getMatchedProduct() {
        return matchedProduct;
    }
}
