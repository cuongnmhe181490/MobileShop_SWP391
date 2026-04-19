package controller;

import dao.CartDao;
import entity.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet hien thi danh sach Brand (Category).
 * GET /BrandListServlet -> hien thi danh sach brand (có phân trang)
 * POST /BrandListServlet -> xoa brand theo id
 */
@WebServlet(name = "BrandListServlet", urlPatterns = {"/BrandListServlet"})
public class BrandListServlet extends HttpServlet {

    private final CartDao dao = new CartDao();
    private static final int PAGE_SIZE = 10;

    // GET: hien thi danh sach
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy search
        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim();
        }

        // Lấy page từ request, mặc định là 1
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy tổng số bản ghi và tính số trang
        int totalCount = dao.getTotalCount(search);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        // Lấy danh sách phân trang
        List<Category> brands = dao.getAllCategoriesPaging(search, page, PAGE_SIZE);

        // Set attributes cho JSP
        request.setAttribute("search", search);
        request.setAttribute("brands", brands);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalCount);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/brand-list.jsp").forward(request, response);
    }

    // POST: xoa brand
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                dao.deleteCategory(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Sau khi xoa, reload lai danh sach
        response.sendRedirect(request.getContextPath() + "/BrandListServlet");
    }
}