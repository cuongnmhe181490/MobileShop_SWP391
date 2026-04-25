package controller.storefront;

import dao.DAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GetProductsByBrandController", urlPatterns = {"/get-products-by-brand"})
public class GetProductsByBrandController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String brand = request.getParameter("brand");
        
        DAO dao = new DAO();
        List<entity.ProductModel> products = dao.getProductsBySupplier(brand);
        
        PrintWriter out = response.getWriter();
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < products.size(); i++) {
            entity.ProductModel p = products.get(i);
            json.append("{")
                .append("\"name\":\"").append(p.getProductName().replace("\"", "\\\"")).append("\",")
                .append("\"price\":").append(p.getPrice())
                .append("}");
            if (i < products.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        out.print(json.toString());
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
}
