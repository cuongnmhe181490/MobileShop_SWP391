package util;

import dao.product.ProductStorefrontDAO;
import entity.Product;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.time.Year;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class CatalogViewSupport {

    private static final Pattern YEAR_PATTERN = Pattern.compile("(19|20)\\d{2}");

    private CatalogViewSupport() {
    }

    public static void prepareCatalogRequest(HttpServletRequest request, List<Product> products) {
        ProductStorefrontDAO dao = new ProductStorefrontDAO();
        HttpSession session = request.getSession(false);
        List<String> brandOptions = dao.getAvailableBrands();
        request.setAttribute("brandOptions", brandOptions);
        request.setAttribute("brandLabels", buildBrandLabels(brandOptions));
        request.setAttribute("ramOptions", dao.getAvailableRamOptions());
        request.setAttribute("recentYears", resolveRecentYears(dao, products));
        request.setAttribute("catalogPriceLabels", buildPriceLabels(products));
        request.setAttribute("catalogDisplayStockMap", CartSupport.buildDisplayStockMap(session, products));
        request.setAttribute("catalogPriceBounds", buildPriceBounds(products));
        request.setAttribute("selectedBrand", firstNotBlank(request.getAttribute("validatedBrand"), request.getParameter("brand")));
        request.setAttribute("selectedStorage", firstNotBlank(request.getAttribute("validatedStorage"), request.getParameter("storage")));
        request.setAttribute("selectedYear", firstNotBlank(request.getAttribute("validatedYear"), request.getParameter("year")));
        request.setAttribute("selectedSort", firstNotBlank(request.getAttribute("validatedSort"), request.getParameter("sort")));
        request.setAttribute("searchQuery", firstNotBlank(request.getAttribute("validatedKeyword"), request.getParameter("txt")));
        request.setAttribute("selectedMinPrice", firstNotBlank(request.getAttribute("validatedMinPrice"), request.getParameter("minPrice")));
        request.setAttribute("selectedMaxPrice", firstNotBlank(request.getAttribute("validatedMaxPrice"), request.getParameter("maxPrice")));
    }

    private static List<Integer> resolveRecentYears(ProductStorefrontDAO dao, List<Product> products) {
        List<Integer> years = dao.getAvailableReleaseYears(3);
        if (!years.isEmpty()) {
            return years;
        }

        TreeSet<Integer> fallbackYears = new TreeSet<>(Comparator.reverseOrder());
        if (products != null) {
            for (Product product : products) {
                int parsedYear = parseYear(product == null ? null : product.getReleaseDate());
                if (parsedYear > 0 && parsedYear <= Year.now().getValue() + 1) {
                    fallbackYears.add(parsedYear);
                }
            }
        }

        List<Integer> resolved = new ArrayList<>(fallbackYears);
        return resolved.subList(0, Math.min(3, resolved.size()));
    }

    private static int parseYear(String value) {
        if (value == null || value.isBlank()) {
            return -1;
        }
        Matcher matcher = YEAR_PATTERN.matcher(value);
        if (!matcher.find()) {
            return -1;
        }
        try {
            return Integer.parseInt(matcher.group());
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static String firstNotBlank(Object preferred, String fallback) {
        String preferredValue = preferred == null ? "" : String.valueOf(preferred).trim();
        if (!preferredValue.isEmpty()) {
            return preferredValue;
        }
        return trim(fallback);
    }

    private static Map<String, String> buildPriceLabels(List<Product> products) {
        Map<String, String> labels = new LinkedHashMap<>();
        if (products == null) {
            return labels;
        }
        for (Product product : products) {
            if (product != null) {
                labels.put(product.getIdProduct(), formatCurrency(product.getPrice()));
            }
        }
        return labels;
    }

    private static Map<String, String> buildBrandLabels(List<String> brandOptions) {
        Map<String, String> labels = new HashMap<>();
        if (brandOptions == null) {
            return labels;
        }
        for (String brandOption : brandOptions) {
            if (brandOption != null) {
                labels.put(brandOption, brandOption.trim());
            }
        }
        return labels;
    }

    private static Map<String, Double> buildPriceBounds(List<Product> products) {
        Map<String, Double> bounds = new HashMap<>();
        double min = 0d;
        double max = 0d;
        if (products != null && !products.isEmpty()) {
            min = products.stream().mapToDouble(Product::getPrice).min().orElse(0d);
            max = products.stream().mapToDouble(Product::getPrice).max().orElse(0d);
        }
        bounds.put("min", Math.max(0d, min));
        bounds.put("max", Math.max(0d, max));
        return bounds;
    }

    private static String formatCurrency(double value) {
        return String.format(Locale.forLanguageTag("vi-VN"), "%,.0f đ", value);
    }
}
