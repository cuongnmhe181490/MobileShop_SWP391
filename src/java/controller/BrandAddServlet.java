package controller;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "BrandAddServlet", urlPatterns = {"/BrandAddServlet"})
public class BrandAddServlet extends HttpServlet {

    // Hiển thị trang form khi nhấn vào menu
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("config-brand-add.jsp").forward(request, response);
    }

    // Xử lý khi nhấn nút "Lưu dữ liệu"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ thẻ input
        String name = trim(request.getParameter("name"));
        String imagePath = trim(request.getParameter("imagePath"));

        // 2. Validation đầy đủ
        StringBuilder errors = new StringBuilder();
        
        if (name == null || name.isEmpty()) {
            errors.append("Tên thương hiệu không được để trống. ");
        } else if (name.length() < 2 || name.length() > 100) {
            errors.append("Tên thương hiệu phải từ 2-100 ký tự. ");
        } else if (!name.matches("^[A-Za-z0-9À-ỹ\\s\\-_]+$")) {
            errors.append("Tên thương hiệu không được chứa ký tự đặc biệt. ");
        }

        if (imagePath == null || imagePath.isEmpty()) {
            errors.append("URL logo không được để trống. ");
        } else if (!imagePath.matches("(?i)^https?://.+\\.(jpg|jpeg|png|gif|svg|webp)(\\?.*)?$")) {
            errors.append("URL logo phải là đường dẫn hình ảnh hợp lệ (jpg, png, gif, svg, webp). ");
        }

        // Nếu có lỗi
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("config-brand-add.jsp").forward(request, response);
            return;
        }

        try {
            // 3. Gọi DAO để chèn vào Database
            CartDao dao = new CartDao();
            dao.insertCategory(name, imagePath);

            // 4. Thành công thì quay về trang danh sách
            response.sendRedirect("AdminHomeConfigServlet"); 
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi lưu dữ liệu!");
            request.getRequestDispatcher("config-brand-add.jsp").forward(request, response);
        }
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}