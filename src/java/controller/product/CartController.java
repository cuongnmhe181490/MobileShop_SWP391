package controller.storefront;

import dao.DAO;
import entity.CartItem;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import util.CartSupport;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAO dao = new DAO();
        User user = (User) request.getSession().getAttribute("acc");
        if (user == null) {
            request.setAttribute("cartItems", Collections.emptyList());
            request.setAttribute("cartTotal", 0);
            CartSupport.syncCartSize(request.getSession());
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }
        List<CartItem> cartItems = CartSupport.buildCartItems(request.getSession());
        double cartTotal = 0;

        for (CartItem item : cartItems) {
            cartTotal += item.getSubtotal();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
