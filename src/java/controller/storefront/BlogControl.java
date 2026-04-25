package controller.storefront;

import dao.BlogDAO;
import entity.BlogPost;
import entity.BlogCategory;
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
        String catStr = request.getParameter("cat");
        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        
        int pageSize = 6;
        int pageIndex = 1;
        try {
            if (pageStr != null) pageIndex = Integer.parseInt(pageStr);
        } catch (Exception e) { pageIndex = 1; }
        if (pageIndex < 1) pageIndex = 1;
        
        int offset = (pageIndex - 1) * pageSize;
        int totalBlogs = 0;
        List<BlogPost> blogPosts;
        
        // Fetch all matching blogs first to handle filtering (for simplicity)
        // Or we could implement dedicated DB search methods
        List<BlogPost> allFiltered;
        if (catStr != null && !catStr.isEmpty()) {
            int catId = Integer.parseInt(catStr);
            allFiltered = dao.getBlogsByCategory(catId);
        } else {
            allFiltered = dao.getAllBlogs();
        }
        
        if (search != null && !search.isEmpty()) {
            String sLower = search.toLowerCase();
            allFiltered = allFiltered.stream()
                    .filter(b -> b.getTitle().toLowerCase().contains(sLower))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        totalBlogs = allFiltered.size();
        blogPosts = allFiltered.stream()
                .skip((long) offset)
                .limit(pageSize)
                .collect(java.util.stream.Collectors.toList());
        
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
        List<BlogCategory> catList = dao.getAllBlogCategories();
        
        request.setAttribute("blogPosts", blogPosts);
        request.setAttribute("catList", catList);
        request.setAttribute("selectedCat", catStr);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
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
