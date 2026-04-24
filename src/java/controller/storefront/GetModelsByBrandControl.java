package controller.storefront;

import dao.DAO;
import entity.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "GetModelsByBrandControl", urlPatterns = {"/getModelsByBrand"})
public class GetModelsByBrandControl extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String brandId = request.getParameter("brand");
            if (brandId != null) brandId = brandId.trim();
            
            DAO dao = new DAO();
            List<ProductModel> products = dao.getProductsByBrand(brandId);

            List<String> modelNames = products.stream()
                    .map(ProductModel::getProductName)
                    .filter(name -> name != null)
                    .distinct()
                    .collect(Collectors.toList());

            // Manually build JSON array to avoid library dependency issues
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < modelNames.size(); i++) {
                json.append("\"").append(modelNames.get(i).replace("\"", "\\\"")).append("\"");
                if (i < modelNames.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            // Return error message as first element for debugging
            response.getWriter().write("[\"ERROR: " + e.getMessage().replace("\"", "'") + "\"]");
        }
    }
}
