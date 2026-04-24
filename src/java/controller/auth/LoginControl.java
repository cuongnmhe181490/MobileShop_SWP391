/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.DAO;
import dao.UserDAO;
import dao.order.UserCartDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import util.CartSupport;

/**
 *
 * @author 84912
 */
@WebServlet(name = "LoginControl", urlPatterns = {"/login"})
public class LoginControl extends HttpServlet {

    private static final String INVALID_LOGIN_MESSAGE = "Email hoặc mật khẩu không chính xác!";

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
        
        if (loginUser != null) {
            // Kiểm tra trạng thái tài khoản
            if ("Bị khóa".equals(loginUser.getStatus())) {
                request.setAttribute("errorMsg", "Tài khoản của bạn đã bị khóa!<br>Lý do: " + loginUser.getLockReason());
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu (BCrypt)
            boolean isCorrectPassword = false;
            String storedPass = loginUser.getPass();
            try {
                if (storedPass.startsWith("$2a$") || storedPass.startsWith("$2b$")) {
                    isCorrectPassword = BCrypt.checkpw(pass, storedPass);
                } else {
                    isCorrectPassword = pass.equals(storedPass);
                }
            } catch (Exception e) {
                isCorrectPassword = pass.equals(storedPass);
            }

            if (isCorrectPassword) {

                HttpSession session = request.getSession();
                session.setAttribute("acc", loginUser);
                new UserCartDAO().releaseExpiredReservations();
                CartSupport.syncCartSize(session);
                response.sendRedirect("home"); 
            } else {
                request.setAttribute("mess", INVALID_LOGIN_MESSAGE);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("mess", INVALID_LOGIN_MESSAGE);
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
