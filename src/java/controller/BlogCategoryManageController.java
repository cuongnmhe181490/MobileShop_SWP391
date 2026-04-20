package controller;

import dao.BlogDAO;
import entity.BlogCategory;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "BlogCategoryManageController", urlPatterns = {"/blog-category-manage"})
public class BlogCategoryManageController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");
        BlogDAO dao = new BlogDAO();
        PrintWriter out = response.getWriter();

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            if (name != null && !name.trim().isEmpty()) {
                boolean success = dao.insertBlogCategory(name);
                if (success) {
                    out.print("{\"status\":\"success\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Không thể thêm danh mục\"}");
                }
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            try {
                int id = Integer.parseInt(idStr);
                boolean success = dao.deleteBlogCategory(id);
                if (success) {
                    out.print("{\"status\":\"success\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Danh mục đang được sử dụng hoặc không tồn tại\"}");
                }
            } catch (Exception e) {
                out.print("{\"status\":\"error\", \"message\":\"ID không hợp lệ\"}");
            }
        } else if ("list".equals(action)) {
            List<BlogCategory> list = dao.getAllBlogCategories();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                BlogCategory c = list.get(i);
                json.append("{\"id\":").append(c.getIdBlogCat()).append(", \"name\":\"").append(c.getCategoryName()).append("\"}");
                if (i < list.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
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
}
