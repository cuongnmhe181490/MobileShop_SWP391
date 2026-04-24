package controller.product;

import dao.product.ProductStorefrontDAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import util.CartSupport;

@WebServlet(name = "DetailControl", urlPatterns = {"/detail"})
public class DetailControl extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("pid");
        ProductStorefrontDAO dao = new ProductStorefrontDAO();
        Product product = dao.getProductByID(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        double averageRating = dao.getAverageRating(id);
        int reviewCount = dao.getReviewCount(id);
        Map<Integer, Integer> reviewCounts = dao.getReviewCountsByRating(id);
        List<Product> relatedProducts = dao.getRelatedProducts(product.getIdSupplier(), product.getIdProduct(), 4);
        Map<String, String> relatedPriceLabels = new LinkedHashMap<>();
        for (Product item : relatedProducts) {
            relatedPriceLabels.put(item.getIdProduct(), formatCurrency(item.getPrice()));
        }

        int detailDisplayStock = CartSupport.getDisplayStock(request.getSession(false), product);
        Map<String, Integer> relatedDisplayStockMap = CartSupport.buildDisplayStockMap(request.getSession(false), relatedProducts);

        request.setAttribute("detail", product);
        request.setAttribute("detailPriceLabel", formatCurrency(product.getPrice()));
        request.setAttribute("detailDisplayStock", detailDisplayStock);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("reviewCounts", reviewCounts);
        request.setAttribute("reviewPreview", dao.getProductReviews(id, null, 0, 3));
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("relatedPriceLabels", relatedPriceLabels);
        request.setAttribute("relatedDisplayStockMap", relatedDisplayStockMap);
        request.getRequestDispatcher("Detail.jsp").forward(request, response);
    }

    private String formatCurrency(double value) {
        return String.format(Locale.forLanguageTag("vi-VN"), "%,.0f đ", value);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Storefront product detail";
    }
}
