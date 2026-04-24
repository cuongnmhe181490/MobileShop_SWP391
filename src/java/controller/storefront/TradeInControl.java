package controller.storefront;

import dao.BlogDAO;
import dao.DAO;
import entity.ProductModel;
import entity.TradeInQuote;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import util.TradeInSupport;

@WebServlet(name = "TradeInControl", urlPatterns = {"/trade-in", "/tradein"})
public class TradeInControl extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareBaseRequest(request);
        request.getRequestDispatcher("tradein.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareBaseRequest(request);

        String brand = trim(request.getParameter("brand"));
        String modelName = trim(request.getParameter("modelName"));
        String condition = trim(request.getParameter("condition"));
        DAO dao = new DAO();
        ProductModel matchedProduct = dao.getProductByBrandAndName(brand, modelName);
        TradeInQuote quote = TradeInSupport.buildQuote(brand, modelName, condition, matchedProduct);

        request.setAttribute("selectedBrand", brand);
        request.setAttribute("modelName", modelName);
        request.setAttribute("selectedCondition", quote.getConditionKey());
        request.setAttribute("tradeInQuote", quote);
        
        // Save to session so the value "jumps" to other pages
        request.getSession().setAttribute("tradeInQuote", quote);
        

        request.getRequestDispatcher("/tradein.jsp").forward(request, response);

    }

    private void prepareBaseRequest(HttpServletRequest request) {
        DAO dao = new DAO();
        List<String> dynamicBrands = dao.getActiveSuppliers();
        request.setAttribute("brands", dynamicBrands);
        request.setAttribute("conditionLabels", TradeInSupport.getConditionLabels());


        // Also fetch models for the current selected brand if any
        String selectedBrand = (String) request.getAttribute("selectedBrand");
        if (selectedBrand == null) {
             selectedBrand = request.getParameter("brand");
        }
        if (selectedBrand == null && !dynamicBrands.isEmpty()) {
            selectedBrand = dynamicBrands.get(0);
        }
        
        if (selectedBrand != null) {
            List<ProductModel> products = dao.getProductsByBrand(selectedBrand);
            List<String> models = products.stream()
                    .map(ProductModel::getProductName)
                    .distinct()
                    .collect(java.util.stream.Collectors.toList());
            request.setAttribute("models", models);
            request.setAttribute("selectedBrand", selectedBrand);
        }

    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
