/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.DAO;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author 84912
 */
@WebServlet(name = "SignupControl", urlPatterns = {"/signup"})
public class SignupControl extends HttpServlet {

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
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("repass");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String birthday = request.getParameter("birthday");
        
        String hashedPassword = BCrypt.hashpw(pass, BCrypt.gensalt());
        
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";

        String phoneRegex = "^0\\d{9}$";

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("mess", "Họ và tên không được để trống!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.matches(emailRegex)) {
            request.setAttribute("mess", "Email không đúng định dạng (VD: email@example.com)!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (phone == null || !phone.matches(phoneRegex)) {
            request.setAttribute("mess", "Số điện thoại không hợp lệ (Phải gồm 10 số và bắt đầu bằng số 0)!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        try {
            java.time.LocalDate parsedDate = java.time.LocalDate.parse(birthday);
            // Tùy chọn: Chặn người dùng chọn ngày sinh ở tương lai
            if (parsedDate.isAfter(java.time.LocalDate.now())) {
                request.setAttribute("mess", "Ngày sinh không thể là ngày trong tương lai!");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("mess", "Ngày sinh không đúng định dạng YYYY-MM-DD hoặc không tồn tại!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }
        if (pass == null || pass.length() < 8) {
            request.setAttribute("mess", "Mật khẩu phải có ít nhất 8 ký tự!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }
        if(!pass.equals(re_pass)){
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }else{
            DAO dao = new DAO();
            User a = dao.checkUserExist(user);

            if (a != null) {
                // 1. Kiểm tra trùng Tên đăng nhập
                request.setAttribute("mess", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            } else if (dao.checkEmailExist(email)) {
                // 2. Kiểm tra trùng Email
                request.setAttribute("mess", "Email này đã được sử dụng!");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            } else if (dao.checkPhoneExist(phone)) {
                // 3. Kiểm tra trùng Số điện thoại
                request.setAttribute("mess", "Số điện thoại này đã được sử dụng!");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            } else {
                // 4. Nếu tất cả đều không trùng thì mới cho đăng ký
                dao.signup(user, gender, hashedPassword, address, email, phone, name, birthday);

                response.sendRedirect("login");
                return;
            }
        }
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
        processRequest(request, response);
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
