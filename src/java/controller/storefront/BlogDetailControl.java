package controller.storefront;

import dao.BlogDAO;
import entity.BlogPost;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BlogDetailControl", urlPatterns = {"/blog-detail"})
public class BlogDetailControl extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String bidStr = request.getParameter("bid");
        if (bidStr != null) {
            try {
                int bid = Integer.parseInt(bidStr);
                BlogDAO dao = new BlogDAO();
                BlogPost blog = dao.getBlogById(bid);
                
                if (blog != null) {
                    // Tự động định dạng nội dung: To, đậm đầu mục và xử lý khoảng trắng
                    String rawContent = blog.getContent();
                    if (rawContent != null) {
                        // 1. Chia nhỏ từng dòng, xóa khoảng trắng thừa ở đầu/cuối mỗi dòng
                        String[] lines = rawContent.split("\\R");
                        StringBuilder sb = new StringBuilder();
                        for (String line : lines) {
                            String trimmed = line.trim();
                            if (trimmed.isEmpty()) {
                                sb.append("<br>");
                            } else {
                                // 2. Tự động nhận diện tiêu đề (1., 2., 3. hoặc Kết luận:)
                                if (trimmed.matches("^\\d+\\..*") || trimmed.startsWith("Kết luận:")) {
                                    sb.append("<h2>").append(trimmed).append("</h2>");
                                } else {
                                    sb.append("<p>").append(trimmed).append("</p>");
                                }
                            }
                        }
                        blog.setContent(sb.toString());
                    }
                    
                    request.setAttribute("blog", blog);
                    request.setAttribute("activePage", "blog");
                    request.getRequestDispatcher("blog-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("home");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("home");
            }
        } else {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
