/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.DAO;
import dao.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author 84912
 */
@WebServlet(name = "LoginControl", urlPatterns = {"/login"})
public class LoginControl extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        login(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        login(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        DAO dao = new DAO();
        UserDAO udao = new UserDAO();
        User loginUser = udao.getAccountByUser(user);
        
        // 3. Kiểm tra User có tồn tại và Mật khẩu có khớp không (Dùng BCrypt)
        // 3. Kiểm tra User có tồn tại và Mật khẩu có khớp không
        boolean isCorrectPassword = false;
        if (loginUser != null) {
            String storedPass = loginUser.getPass();
            // Thử kiểm tra bằng BCrypt trước
            try {
                if (storedPass.startsWith("$2a$") || storedPass.startsWith("$2b$")) {
                    isCorrectPassword = BCrypt.checkpw(pass, storedPass);
                } else {
                    // Nếu không phải hash BCrypt thì so sánh trực tiếp
                    isCorrectPassword = pass.equals(storedPass);
                }
            } catch (Exception e) {
                // Nếu có lỗi khi check BCrypt (vd: data lỗi), quay về so sánh trực tiếp
                isCorrectPassword = pass.equals(storedPass);
            }
        }

        if (loginUser != null && isCorrectPassword) {

            // Đăng nhập thành công -> Lưu nguyên Object User vào Session
            HttpSession session = request.getSession();
            session.setAttribute("acc", loginUser);

            // 4. Đăng nhập xong -> Tất cả đều về trang chủ (Home)
            // Admin sẽ thấy nút "Quản trị" ở Home để tự bấm vào sau
            response.sendRedirect("home"); 
        } else {
            // Đăng nhập thất bại -> Báo lỗi và quay lại trang login
            request.setAttribute("mess", "Email hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
