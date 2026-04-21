package controller.storefront;

import dao.DAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import util.CatalogViewSupport;

public class LoadProduct extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DAO dao = new DAO();
        String keyword = normalizeTextInput(request.getParameter("txt"));
        String brand = normalizeTextInput(request.getParameter("brand"));
        String storage = normalizeTextInput(request.getParameter("storage"));
        String year = normalizeTextInput(request.getParameter("year"));
        String sort = normalizeTextInput(request.getParameter("sort"));
        String minPrice = normalizeNumberInput(request.getParameter("minPrice"));
        String maxPrice = normalizeNumberInput(request.getParameter("maxPrice"));

        boolean productDataAvailable = dao.canAccessProductData();
        List<Product> products = productDataAvailable
                ? dao.getCatalogProducts(keyword, brand, storage, year, minPrice, maxPrice, sort)
                : Collections.emptyList();
        request.setAttribute("product", products);
        request.setAttribute("validatedKeyword", keyword);
        request.setAttribute("validatedBrand", brand);
        request.setAttribute("validatedStorage", storage);
        request.setAttribute("validatedYear", year);
        request.setAttribute("validatedSort", sort);
        request.setAttribute("validatedMinPrice", minPrice);
        request.setAttribute("validatedMaxPrice", maxPrice);
        if (!productDataAvailable) {
            request.setAttribute("productDataError", "Khong the tai du lieu san pham tu co so du lieu. Vui long kiem tra cau hinh DB.");
        }
        CatalogViewSupport.prepareCatalogRequest(request, products);
        request.getRequestDispatcher("shop-grid.jsp").forward(request, response);
    }

    private String normalizeTextInput(String value) {
        if (value == null) {
            return "";
        }
        String normalized = value.trim().replaceAll("\\s+", " ");
        return normalized;
    }

    private String normalizeNumberInput(String value) {
        String normalized = normalizeTextInput(value);
        if (normalized.isEmpty()) {
            return "";
        }
        return normalized.replaceAll("[^0-9]", "");
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
        return "Storefront product catalog";
    }
}
