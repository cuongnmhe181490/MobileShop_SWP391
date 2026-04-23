package controller.storefront;

import dao.DAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import util.CatalogViewSupport;

@WebServlet(name = "LoadProduct", urlPatterns = {"/product"})
public class LoadProduct extends HttpServlet {

    private static final int PAGE_SIZE = 9;
    private static final int PAGE_WINDOW = 4;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        DAO dao = new DAO();
        String keyword = normalizeTextInput(request.getParameter("txt"));
        String brand = normalizeTextInput(request.getParameter("brand"));
        String storage = normalizeTextInput(request.getParameter("storage"));
        String year = normalizeTextInput(request.getParameter("year"));
        String sort = normalizeTextInput(request.getParameter("sort"));
        String minPrice = normalizeNumberInput(request.getParameter("minPrice"));
        String maxPrice = normalizeNumberInput(request.getParameter("maxPrice"));
        int currentPage = parseIntOrDefault(request.getParameter("page"), 1);
        if (currentPage < 1) {
            currentPage = 1;
        }

        String startDate = normalizeTextInput(request.getParameter("startDate"));
        String endDate = normalizeTextInput(request.getParameter("endDate"));
        
        List<Product> allProducts = dao.getCatalogProducts(keyword, brand, storage, year, minPrice, maxPrice, sort, startDate, endDate);
        int totalProducts = allProducts.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalProducts / (double) PAGE_SIZE));
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int startIndex = (currentPage - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalProducts);
        List<Product> pagedProducts = totalProducts == 0
                ? List.of()
                : allProducts.subList(startIndex, endIndex);

        request.setAttribute("product", pagedProducts);
        request.setAttribute("validatedKeyword", keyword);
        request.setAttribute("validatedBrand", brand);
        request.setAttribute("validatedStorage", storage);
        request.setAttribute("validatedYear", year);
        request.setAttribute("validatedSort", sort);
        request.setAttribute("validatedMinPrice", minPrice);
        request.setAttribute("validatedMaxPrice", maxPrice);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCatalogProducts", totalProducts);
        request.setAttribute("pageSize", PAGE_SIZE);
        populatePaginationAttributes(request, currentPage, totalPages);
        CatalogViewSupport.prepareCatalogRequest(request, allProducts);
        request.getRequestDispatcher("shop-grid.jsp").forward(request, response);
    }

    private void populatePaginationAttributes(HttpServletRequest request, int currentPage, int totalPages) {
        int startPage;
        int endPage;

        if (totalPages <= PAGE_WINDOW + 1) {
            startPage = 1;
            endPage = totalPages;
        } else if (currentPage <= 3) {
            startPage = 1;
            endPage = Math.min(totalPages, PAGE_WINDOW);
        } else if (currentPage >= totalPages - 2) {
            endPage = totalPages;
            startPage = Math.max(1, totalPages - (PAGE_WINDOW - 1));
        } else {
            startPage = currentPage - 1;
            endPage = currentPage + 1;
        }

        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("prevPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        request.setAttribute("showFirstPage", startPage > 1);
        request.setAttribute("showLeadingEllipsis", startPage > 2);
        request.setAttribute("showLastPage", endPage < totalPages);
        request.setAttribute("showTrailingEllipsis", endPage < totalPages - 1);
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

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(normalizeTextInput(value));
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
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
