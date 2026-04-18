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
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="resetPassword", urlPatterns={"/resetPassword"})
public class resetPassword extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet resetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet resetPassword at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // Khi khách hàng bấm vào Link trong Email
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        DAO dao = new DAO();
        
        // Kiểm tra mã có hợp lệ/còn hạn không
        User user = dao.getUserByResetToken(token);
        
        if (user == null) {
            request.setAttribute("mess", "Đường dẫn đổi mật khẩu không hợp lệ hoặc đã hết hạn.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Hợp lệ -> Cho hiện form đổi pass. Truyền token và email sang form.
        request.setAttribute("token", token);
        request.setAttribute("email", user.getEmail());
        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   // Khi khách hàng điền pass mới và bấm "Lưu thay đổi"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token"); // Lấy từ thẻ <input type="hidden">
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        
        
        DAO dao = new DAO();
        
        // 1. Validate mật khẩu khớp
        if (!password.equals(confirmPassword)) {
            request.setAttribute("mess", "Mật khẩu xác nhận không trùng khớp!");
            request.setAttribute("token", token);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }
        
        // 2. Xác thực lại Token để chống thao tác form giả mạo
        User user = dao.getUserByResetToken(token);
        if (user != null) {
            // 3. Băm mật khẩu (Bảo mật tuyệt đối)
            String hashedPass = BCrypt.hashpw(password, BCrypt.gensalt());
            
            // 4. Lưu và vô hiệu hóa link
            dao.updatePasswordAndClearToken(user.getEmail(), hashedPass);
            
            request.setAttribute("mess", "Đổi mật khẩu thành công! Vui lòng đăng nhập bằng mật khẩu mới.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("mess", "Đã có lỗi xảy ra hoặc mã xác thực đã hết hạn.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
