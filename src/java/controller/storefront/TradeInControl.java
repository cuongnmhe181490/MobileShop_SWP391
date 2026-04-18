//package controller.storefront;
//
//import dao.DAO;
//import entity.Product;
//import entity.TradeInQuote;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.util.Arrays;
//import java.util.List;
//import util.TradeInSupport;
//
//@WebServlet(name = "TradeInControl", urlPatterns = {"/tradein"})
//public class TradeInControl extends HttpServlet {
//
//    private static final List<String> BRANDS = Arrays.asList("Apple", "Samsung", "Xiaomi", "Oppo", "Realme", "Huawei", "Google");
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        prepareBaseRequest(request);
//        request.getRequestDispatcher("tradein.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        prepareBaseRequest(request);
//
//        String brand = trim(request.getParameter("brand"));
//        String modelName = trim(request.getParameter("modelName"));
//        String condition = trim(request.getParameter("condition"));
//        DAO dao = new DAO();
//        Product matchedProduct = dao.getProductByBrandAndName(brand, modelName);
//        TradeInQuote quote = TradeInSupport.buildQuote(brand, modelName, condition, matchedProduct);
//
//        request.setAttribute("selectedBrand", brand);
//        request.setAttribute("modelName", modelName);
//        request.setAttribute("selectedCondition", quote.getConditionKey());
//        request.setAttribute("tradeInQuote", quote);
//        
//        // Save to session so the value "jumps" to other pages
//        request.getSession().setAttribute("tradeInQuote", quote);
//        
//        request.getRequestDispatcher("tradein.jsp").forward(request, response);
//    }
//
//    private void prepareBaseRequest(HttpServletRequest request) {
//        request.setAttribute("brands", BRANDS);
//        request.setAttribute("conditionLabels", TradeInSupport.getConditionLabels());
//    }
//
//    private String trim(String value) {
//        return value == null ? "" : value.trim();
//    }
//}
