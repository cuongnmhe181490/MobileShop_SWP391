package controller.storefront;

import dao.DAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class DetailControl extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("pid");
        DAO dao = new DAO();
        Product product = dao.getProductByID(id);
        if (product == null) {
            if (!dao.canAccessProductData()) {
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Product data is temporarily unavailable.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/product");
            return;
        }

        List<Product> relatedProducts = dao.getRelatedProducts(product.getIdSupplier(), product.getIdProduct(), 4);
        Map<String, String> relatedPriceLabels = new LinkedHashMap<>();
        for (Product item : relatedProducts) {
            relatedPriceLabels.put(item.getIdProduct(), formatCurrency(item.getPrice()));
        }

        request.setAttribute("detail", product);
        request.setAttribute("detailPriceLabel", formatCurrency(product.getPrice()));
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("relatedPriceLabels", relatedPriceLabels);
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
