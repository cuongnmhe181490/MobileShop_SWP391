package controller.hero;

import dao.HeroBannerDAO;
import entity.HeroBanner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HeroListServlet", urlPatterns = {"/HeroListServlet"})
public class HeroListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HeroBannerDAO dao = new HeroBannerDAO();

        try {
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
            List<HeroBanner> list = dao.getAllPaging(search, page, PAGE_SIZE);

            // Set attributes cho JSP
            request.setAttribute("heroList", list);
            request.setAttribute("search", search);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalCount);
            request.setAttribute("pageSize", PAGE_SIZE);

            request.getRequestDispatcher("hero_config/admin-hero-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải danh sách");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}