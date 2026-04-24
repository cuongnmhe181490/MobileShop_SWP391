package filter;

import dao.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/*"}) // Bạn có thể chỉnh lại "/cart", "/checkout" cho phù hợp
public class BanCheckFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("acc") != null) {
            User sessionUser = (User) session.getAttribute("acc");
            User dbUser = new UserDAO().getAccountByUser(sessionUser.getUser());
            
            if (dbUser != null && "Không hoạt động".equals(dbUser.getStatus())) {
                session.invalidate(); // Hủy session ngay lập tức
                req.getSession(true).setAttribute("errorMsg", "Tài khoản của bạn đã bị ngừng hoạt động. Lý do: " + dbUser.getLockReason());
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}