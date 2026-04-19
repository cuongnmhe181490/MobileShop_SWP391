package controller;

import dao.ReviewDao;
import entity.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet hiển thị danh sách review (trang admin).
 * GET /ReviewListServlet -> hiển thị danh sách review với phân trang và lọc
 */
@WebServlet(name = "ReviewListServlet", urlPatterns = {"/ReviewListServlet"})
public class ReviewListServlet extends HttpServlet {

    private final ReviewDao dao = new ReviewDao();
    private final int pageSize = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số phân trang
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy tham số lọc theo số sao
        String starFilter = request.getParameter("star");
        Integer star = null;
        if (starFilter != null && !starFilter.isEmpty()) {
            try {
                star = Integer.parseInt(starFilter);
            } catch (NumberFormatException e) {
                // bỏ qua
            }
        }

        // Lấy danh sách review và tổng số
        List<Review> reviews;
        int totalReviews;
        int totalPages;

        if (star != null) {
            reviews = dao.getByStar(star, page, pageSize);
            totalReviews = dao.countByStar(star);
        } else {
            reviews = dao.getAll(page, pageSize);
            totalReviews = dao.count();
        }

        totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        // Đếm số review theo từng sao (cho filter chips)
        Map<Integer, Integer> starCounts = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            starCounts.put(i, dao.countByStar(i));
        }

        // Set attributes cho JSP
        request.setAttribute("reviews", reviews);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("starFilter", star);
        request.setAttribute("starCounts", starCounts);

        request.getRequestDispatcher("/admin-reviews.jsp").forward(request, response);
    }
}