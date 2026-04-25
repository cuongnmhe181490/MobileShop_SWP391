package testcases;

import java.time.LocalDate;
import org.junit.Test;
import static org.junit.Assert.*;
import util.ProductCartValidationHelper;

public class ProductCartValidationTest {

    @Test
    public void productNameRulesAreApplied() {
        assertNotNull(ProductCartValidationHelper.validateProductName("a"));
        assertNull(ProductCartValidationHelper.validateProductName("ab"));
        assertNotNull(ProductCartValidationHelper.validateProductName(" ".repeat(5)));
        assertNotNull(ProductCartValidationHelper.validateProductName("x".repeat(201)));
    }

    @Test
    public void priceRulesAreApplied() {
        assertNotNull(ProductCartValidationHelper.validatePriceRaw("0123"));
        assertNotNull(ProductCartValidationHelper.validatePriceRaw("0"));
        assertNotNull(ProductCartValidationHelper.validatePriceRaw("-1"));
        assertNotNull(ProductCartValidationHelper.validatePriceRaw("abc"));
        assertNull(ProductCartValidationHelper.validatePriceRaw("123123"));
    }

    @Test
    public void batteryRulesAreApplied() {
        assertNotNull(ProductCartValidationHelper.validateBattery("0005000", true));
        assertNotNull(ProductCartValidationHelper.validateBattery("abc", true));
        assertNull(ProductCartValidationHelper.validateBattery("5000", true));
        assertNotNull(ProductCartValidationHelper.validateBattery("   ", true));
    }

    @Test
    public void currentQuantityRulesAreApplied() {
        assertNotNull(ProductCartValidationHelper.validateCurrentQuantityRaw("-1"));
        assertNull(ProductCartValidationHelper.validateCurrentQuantityRaw("0"));
        assertNull(ProductCartValidationHelper.validateCurrentQuantityRaw("10"));
    }

    @Test
    public void releaseDateRulesAreApplied() {
        assertNotNull(ProductCartValidationHelper.validateReleaseDate(LocalDate.now().plusDays(1).toString()));
        assertNull(ProductCartValidationHelper.validateReleaseDate(LocalDate.now().toString()));
    }

    @Test
    public void imageUploadRulesAreApplied() {
        assertNull(ProductCartValidationHelper.validateImageUpload("image/png", 500L * 1024L));
        assertNotNull(ProductCartValidationHelper.validateImageUpload("image/png", 500L * 1024L + 1));
        assertNotNull(ProductCartValidationHelper.validateImageUpload("text/plain", 100));
    }
}
