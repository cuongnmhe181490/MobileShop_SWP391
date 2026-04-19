package util;

import entity.ProductModel;
import entity.TradeInQuote;
import java.util.LinkedHashMap;
import java.util.Map;

public final class TradeInSupport {

    private static final Map<String, String> CONDITION_LABELS = new LinkedHashMap<>();
    private static final Map<String, Double> CONDITION_FACTORS = new LinkedHashMap<>();

    static {
        CONDITION_LABELS.put("likenew", "Like new 98-99%");
        CONDITION_LABELS.put("new95", "Mới 95-97%");
        CONDITION_LABELS.put("scratch", "Trầy xước 85-95%");
        CONDITION_LABELS.put("replaced", "Đã thay thế linh kiện 85% đổ xuống");

        CONDITION_FACTORS.put("likenew", 0.8d);
        CONDITION_FACTORS.put("new95", 0.7d);
        CONDITION_FACTORS.put("scratch", 0.6d);
        CONDITION_FACTORS.put("replaced", 0.5d);
    }

    private TradeInSupport() {
    }

    public static Map<String, String> getConditionLabels() {
        return CONDITION_LABELS;
    }

    public static TradeInQuote buildQuote(String brand, String modelName, String conditionKey, ProductModel matchedProduct) {
        String normalizedCondition = CONDITION_LABELS.containsKey(conditionKey) ? conditionKey : "scratch";
        String conditionLabel = CONDITION_LABELS.get(normalizedCondition);
        double baseValue = matchedProduct != null ? matchedProduct.getPrice() : 0.0;
        double factor = CONDITION_FACTORS.get(normalizedCondition);
        double estimatedValue = Math.round(baseValue * factor / 10000d) * 10000d;
        return new TradeInQuote(brand, modelName, normalizedCondition, conditionLabel, estimatedValue, matchedProduct);
    }
}
