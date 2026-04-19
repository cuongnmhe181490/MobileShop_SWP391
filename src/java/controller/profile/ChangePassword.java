/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.profile;

import dao.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ChangePassword", urlPatterns={"/changePassword"})
public class ChangePassword extends HttpServlet {
   
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
            out.println("<title>Servlet ChangePassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassword at " + request.getContextPath () + "</h1>");
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("acc") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
 
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("acc");
 
        if (acc == null) {
            response.sendRedirect("login");
            return;
        }
 
        String currentPass  = request.getParameter("currentPass");
        String newPass      = request.getParameter("newPass");
        String confirmPass  = request.getParameter("confirmPass");
 
        // 1. Validate server-side
        if (currentPass == null || currentPass.trim().isEmpty()
                || newPass == null || newPass.length() < 8
                || confirmPass == null || !confirmPass.equals(newPass)) {
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }
 
        // 2. Kiểm tra mật khẩu hiện tại có đúng không
        if (!BCrypt.checkpw(currentPass, acc.getPass())) {
            request.setAttribute("mess", "Mật khẩu hiện tại không chính xác!");
            request.setAttribute("messType", "error");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }
 
        // 3. Không cho đặt trùng mật khẩu cũ
        if (BCrypt.checkpw(newPass, acc.getPass())) {
            request.setAttribute("mess", "Mật khẩu mới không được trùng mật khẩu hiện tại!");
            request.setAttribute("messType", "error");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }
 
        // 4. Hash và lưu mật khẩu mới
        String hashedPass = BCrypt.hashpw(newPass, BCrypt.gensalt());
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.changePassword(acc.getId(), hashedPass);
 
        if (success) {
            // Cập nhật lại session
            acc.setPass(hashedPass);
            session.setAttribute("acc", acc);
 
            request.setAttribute("mess", "Đổi mật khẩu thành công!");
            request.setAttribute("messType", "success");
        } else {
            request.setAttribute("mess", "Đã có lỗi xảy ra, vui lòng thử lại!");
            request.setAttribute("messType", "error");
        }
 
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
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
