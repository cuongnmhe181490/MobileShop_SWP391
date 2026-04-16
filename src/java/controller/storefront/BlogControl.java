package controller.storefront;

import dao.BlogDAO;
import entity.BlogPost;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "BlogControl", urlPatterns = {"/blog"})
public class BlogControl extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        BlogDAO dao = new BlogDAO();
        String brand = request.getParameter("brand");
        List<BlogPost> blogPosts;
        
        if (brand != null && !brand.isEmpty()) {
            blogPosts = dao.getBlogsBySupplier(brand);
        } else {
            blogPosts = dao.getAllBlogs();
        }
        
        List<String> supList = dao.getActiveSuppliers();
        
        request.setAttribute("blogPosts", blogPosts);
        request.setAttribute("supList", supList);
        request.setAttribute("selectedBrand", brand);
        request.setAttribute("activePage", "blog");
        request.getRequestDispatcher("blog.jsp").forward(request, response);
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
