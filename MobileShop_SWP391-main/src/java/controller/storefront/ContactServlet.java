package controller.storefront;

import dao.ContactDAO;
import entity.ContactMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    private final ContactDAO dao = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "contact");
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String nameStr  = request.getParameter("name");
        String emailStr = request.getParameter("email");
        String phoneStr = request.getParameter("phone");
        String message  = request.getParameter("message");
        
        ContactMessage m = new ContactMessage();
        m.setFullName(nameStr);
        m.setEmail(emailStr);
        m.setPhoneNumber(phoneStr);
        m.setSubject("Yêu cầu hỗ trợ từ Contact Page");
        m.setMessageContent(message);
        
        try {
            boolean success = dao.insertMessage(m);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/contact?success=true");
            } else {
                request.setAttribute("error", "Không thể gửi tin nhắn lúc này.");
                doGet(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
