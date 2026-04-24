package controller.admin;

import dao.ContactDAO;
import entity.ContactMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminContactServlet", urlPatterns = {"/admin/contacts"})
public class AdminContactServlet extends HttpServlet {

    private final ContactDAO dao = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (NumberFormatException ignored) {}
        }
        
        String status = request.getParameter("status");
        String topic  = request.getParameter("topic");

        try {
            List<ContactMessage> list = dao.getFiltered(status, topic, page, pageSize);
            int total = dao.countFiltered(status, topic);
            int totalPages = (int) Math.ceil((double) total / pageSize);

            request.setAttribute("contacts", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalMessages", total);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("selectedTopic", topic);
            
            request.getRequestDispatcher("/admin/contact-manage.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action     = request.getParameter("action");
        int contactId     = Integer.parseInt(request.getParameter("id"));
        String status     = request.getParameter("status");
        String adminNotes = request.getParameter("adminNotes");

        try {
            if ("update".equals(action)) {
                dao.updateStatus(contactId, status, adminNotes);
            }
            String page   = request.getParameter("page");
            String fStatus = request.getParameter("fStatus");
            String fTopic  = request.getParameter("fTopic");
            
            StringBuilder redirect = new StringBuilder(request.getContextPath() + "/admin/contacts?page=" + (page != null ? page : "1"));
            if (fStatus != null && !fStatus.isEmpty()) redirect.append("&status=").append(fStatus);
            if (fTopic  != null && !fTopic.isEmpty())  redirect.append("&topic=").append(fTopic);
            
            response.sendRedirect(redirect.toString());
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
