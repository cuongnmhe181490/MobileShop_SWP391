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
import dao.UserDAO;
import entity.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="EditUserServlet", urlPatterns={"/admin/edit-user"})
public class EditUserServlet extends HttpServlet {
   
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
            out.println("<title>Servlet EditUserServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditUserServlet at " + request.getContextPath () + "</h1>");
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
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();
            User u = dao.getUserById(id);
            
            if (u != null) {
                request.setAttribute("editUser", u);
                request.getRequestDispatcher("/admin/edit-user.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("errorMsg", "Không tìm thấy người dùng!");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
        }
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
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String birthday = request.getParameter("birthday");
            int roleId = Integer.parseInt(request.getParameter("roleId")); 

            // Chặn không cho Admin tự tước quyền của chính mình
            User sessionAdmin = (User) request.getSession().getAttribute("acc");
            
            if (sessionAdmin == null) {
                request.getSession().setAttribute("errorMsg", "Phiên đăng nhập đã hết hạn!");
                response.sendRedirect(request.getContextPath() + "/login.jsp"); // Đổi link login tùy hệ thống của bạn
                return;
            }
            
            if (sessionAdmin.getId() == id) {
                if (roleId != 1) {
                    request.getSession().setAttribute("errorMsg", "Bạn không thể tự hạ quyền của chính mình!");
                    response.sendRedirect(request.getContextPath() + "/admin/accounts");
                    return;
                }
                // Chốt chặn cuối cùng: Ép cứng giá trị RoleId luôn là 1 (Admin) 
                // khi Admin tự Edit chính mình, mặc kệ F12 hay request ảo gửi lên cái gì
                roleId = 1; 
            }

            UserDAO dao = new UserDAO();
            if (dao.updateUserByAdmin(id, fullName, phone, address, gender, birthday, roleId)) {
                request.getSession().setAttribute("successMsg", "Đã cập nhật thông tin và phân quyền thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Cập nhật thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Có lỗi xảy ra: " + e.getMessage());
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