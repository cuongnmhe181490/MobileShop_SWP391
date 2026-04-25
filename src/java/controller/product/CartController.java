package controller.product;

import dao.product.ProductStorefrontDAO;
import entity.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import util.CartSupport;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductStorefrontDAO dao = new ProductStorefrontDAO();
        List<CartItem> cartItems = CartSupport.buildCartItems(request.getSession(), dao);
        double cartTotal = 0;

        for (CartItem item : cartItems) {
            cartTotal += item.getSubtotal();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
