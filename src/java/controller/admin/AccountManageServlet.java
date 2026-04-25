/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import controller.auth.SendGridEmailService;
import dao.UserDAO;
import entity.User;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="AccountManageServlet", urlPatterns={"/admin/accounts"})
public class AccountManageServlet extends HttpServlet {
   
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
            out.println("<title>Servlet AccountManageServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AccountManageServlet at " + request.getContextPath () + "</h1>");
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
        
        String searchQuery = request.getParameter("search");
        if (searchQuery != null) searchQuery = searchQuery.trim();
        
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (Exception e) {
                page = 1;
            }
        }
        
        int pageSize = 6;
        UserDAO dao = new UserDAO();
        
        int totalUsers = dao.getTotalUsersCount(searchQuery);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<User> list = dao.getUsersWithPagination(searchQuery, page, pageSize);
        request.setAttribute("userList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery); // Giữ lại từ khóa tìm kiếm
        
        request.getRequestDispatcher("/admin/account-manage.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User currentAdmin = (User) request.getSession().getAttribute("acc");
            
            if (currentAdmin != null && currentAdmin.getId() == userId && "lock".equals(action)) {
                request.getSession().setAttribute("errorMsg", "Bạn không thể tự khóa tài khoản của chính mình!");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            if ("lock".equals(action)) {
                String reason = request.getParameter("reason");
                String email = request.getParameter("email");
                String name = request.getParameter("name");

                if (dao.lockUser(userId, reason)) {
                    // Chỉ gửi mail khi DB đã cập nhật thành công
                    new controller.auth.SendGridEmailService().sendBanNotificationEmail(email, name, reason);
                    request.getSession().setAttribute("successMsg", "Đã khóa tài khoản của " + name + " và gửi mail thông báo.");
                } else {
                    request.getSession().setAttribute("errorMsg", "Lỗi: Không thể cập nhật trạng thái trong Database!");
                }
            } else if ("unlock".equals(action)) {
                if (dao.unlockUser(userId)) {
                    request.getSession().setAttribute("successMsg", "Đã mở khóa tài khoản thành công!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/accounts");
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
