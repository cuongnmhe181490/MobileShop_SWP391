package controller.brand;

import dao.SupplierDAO;
import entity.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


/**
 * Servlet hiển thị danh sách Brand (Supplier).
 */
@WebServlet(name = "BrandListServlet", urlPatterns = {"/BrandListServlet"})
public class BrandListServlet extends HttpServlet {

    private final SupplierDAO dao = new SupplierDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim();
        }

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

        int totalCount = dao.getTotalCount(search);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Supplier> brands = dao.getAllSuppliersPaging(search, page, PAGE_SIZE);

        request.setAttribute("search", search);
        request.setAttribute("brands", brands);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalCount);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("brand_config/brand-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        jakarta.servlet.http.HttpSession session = request.getSession();
        String id = request.getParameter("id");

        if (id != null && !id.isEmpty()) {
            try {
                boolean success = dao.deleteSupplier(id);
                if (success) {
                    session.setAttribute("flashSuccess", "Đã xoá thương hiệu " + id + " thành công!");
                } else {
                    session.setAttribute("flashError", "Xoá thương hiệu thất bại.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashError", "Lỗi: " + e.getMessage());
            }
        } else {
            session.setAttribute("flashError", "Không tìm thấy ID thương hiệu cần xoá.");
        }

        response.sendRedirect(request.getContextPath() + "/BrandListServlet");
    }

}
