package util;

import dao.DAO;
import dao.order.UserCartDAO;
import entity.CartItem;

import entity.ProductModel;
import entity.User;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class CartSupport {

    public static final String CART_SESSION_KEY = "cart";
    public static final String CART_SIZE_SESSION_KEY = "size";
    public static final String CART_MESSAGE_SESSION_KEY = "cartMessage";
    public static final String CART_ERROR_SESSION_KEY = "cartError";

    private CartSupport() {
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Integer> getCart(HttpSession session) {
        Object stored = session.getAttribute(CART_SESSION_KEY);
        if (stored instanceof Map<?, ?>) {
            return (Map<String, Integer>) stored;
        }
        Map<String, Integer> cart = new LinkedHashMap<>();
        session.setAttribute(CART_SESSION_KEY, cart);
        return cart;
    }

    public static int getReservedQuantity(HttpSession session, String productId) {
        if (session == null || productId == null) {
            return 0;
        }
        return getCart(session).getOrDefault(productId, 0);
    }

    public static int getDisplayStock(HttpSession session, ProductModel product) {
        if (product == null) {
            return 0;
        }
        return Math.max(0, product.getQuantity());
    }

    public static Map<String, Integer> buildDisplayStockMap(HttpSession session, List<? extends ProductModel> products) {
        Map<String, Integer> stockMap = new LinkedHashMap<>();
        if (products == null) {
            return stockMap;
        }
        for (ProductModel product : products) {
            if (product != null) {
                stockMap.put(product.getIdProduct(), getDisplayStock(session, product));
            }
        }
        return stockMap;
    }

    public static List<CartItem> buildCartItems(HttpSession session, DAO dao) {
        Integer userId = getLoggedInUserId(session);
        if (userId != null) {
            List<CartItem> dbItems = new UserCartDAO().getCartItems(userId);
            syncCartSize(session);
            return dbItems;
        }

        Map<String, Integer> cart = getCart(session);
        List<CartItem> items = new ArrayList<>();
        List<String> invalidKeys = new ArrayList<>();

        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            Integer quantity = entry.getValue();
            if (quantity == null || quantity <= 0) {
                invalidKeys.add(entry.getKey());
                continue;
            }

            ProductModel product = dao.getProductByID(entry.getKey());
            if (product == null) {
                invalidKeys.add(entry.getKey());
                continue;
            }

            int displayStock = Math.max(0, product.getQuantity() - quantity);
            items.add(new CartItem(product, quantity, displayStock));
        }

        for (String invalidKey : invalidKeys) {
            cart.remove(invalidKey);
        }

        syncCartSize(session);
        return items;
    }

    public static int getTotalQuantity(Map<String, Integer> cart) {
        int total = 0;
        for (Integer quantity : cart.values()) {
            if (quantity != null && quantity > 0) {
                total += quantity;
            }
        }
        return total;
    }

    public static void syncCartSize(HttpSession session) {
        Integer userId = getLoggedInUserId(session);
        int total = userId == null
                ? getTotalQuantity(getCart(session))
                : new UserCartDAO().countCartQuantity(userId);
        session.setAttribute(CART_SIZE_SESSION_KEY, total);
    }

    public static void setSuccess(HttpSession session, String message) {
        session.setAttribute(CART_MESSAGE_SESSION_KEY, message);
        session.removeAttribute(CART_ERROR_SESSION_KEY);
    }

    public static void setError(HttpSession session, String message) {
        session.setAttribute(CART_ERROR_SESSION_KEY, message);
        session.removeAttribute(CART_MESSAGE_SESSION_KEY);
    }

    public static Integer getLoggedInUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object acc = session.getAttribute("acc");
        if (acc instanceof User) {
            return ((User) acc).getId();
        }
        return null;
    }
}
