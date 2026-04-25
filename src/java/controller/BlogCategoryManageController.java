package controller;

import dao.BlogDAO;
import entity.BlogCategory;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BlogCategoryManageController", urlPatterns = {"/admin/blog-category-manage"})
public class BlogCategoryManageController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");
        BlogDAO dao = new BlogDAO();
        PrintWriter out = response.getWriter();

        try {
            if ("list".equals(action)) {
                List<BlogCategory> list = dao.getAllBlogCategories();
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < list.size(); i++) {
                    json.append("{\"id\":").append(list.get(i).getIdBlogCat())
                        .append(", \"name\":\"").append(list.get(i).getCategoryName()).append("\"}");
                    if (i < list.size() - 1) json.append(",");
                }
                json.append("]");
                out.print(json.toString());
            } else if ("add".equals(action)) {
                String name = request.getParameter("name");
                if (name == null || name.trim().length() < 2 || name.trim().length() > 50) {
                    out.print("{\"status\":\"error\", \"message\":\"Độ dài danh mục từ 2-50 ký tự!\"}");
                } else if (dao.checkCategoryExist(name.trim())) {
                    out.print("{\"status\":\"error\", \"message\":\"Tên danh mục này đã tồn tại!\"}");
                } else {
                    boolean success = dao.insertBlogCategory(name.trim());
                    out.print(success ? "{\"status\":\"success\"}" : "{\"status\":\"error\", \"message\":\"Lỗi hệ thống!\"}");
                }
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                if (name == null || name.trim().length() < 2 || name.trim().length() > 50) {
                    out.print("{\"status\":\"error\", \"message\":\"Độ dài danh mục từ 2-50 ký tự!\"}");
                } else if (dao.checkCategoryExist(name.trim())) {
                    out.print("{\"status\":\"error\", \"message\":\"Tên danh mục này đã tồn tại!\"}");
                } else {
                    boolean success = dao.updateBlogCategory(id, name.trim());
                    out.print(success ? "{\"status\":\"success\"}" : "{\"status\":\"error\", \"message\":\"Lỗi hệ thống!\"}");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                // Kiểm tra xem có blog nào thuộc category này không
                if (dao.getTotalBlogsByCategory(id) > 0) {
                    out.print("{\"status\":\"error\", \"message\":\"Không thể xóa danh mục đang có bài viết!\"}");
                } else {
                    boolean success = dao.deleteBlogCategory(id);
                    out.print(success ? "{\"status\":\"success\"}" : "{\"status\":\"error\", \"message\":\"Lỗi hệ thống!\"}");
                }
            }
        } catch (Exception e) {
            out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
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
