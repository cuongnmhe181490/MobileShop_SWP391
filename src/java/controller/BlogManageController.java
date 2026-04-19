package controller;

import dao.BlogDAO;
import entity.BlogPost;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.List;
import util.CloudinaryUtil;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 500,           // 500KB
    maxRequestSize = 1024 * 1024 * 2    // 2MB (Tăng lên một chút cho toàn bộ request)
)
@WebServlet(name = "BlogManageController", urlPatterns = {"/admin/blog"})
public class BlogManageController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String service = request.getParameter("service");
        BlogDAO dao = new BlogDAO();
        
        try {
            if (service == null) {
                service = "listAll";
            }
            
            switch (service) {
                case "listAll":
                    List<BlogPost> list = dao.getAllBlogs();
                    request.setAttribute("blogList", list);
                    request.getRequestDispatcher("/admin/blog-manage.jsp").forward(request, response);
                    break;
                    
                case "insertBlog":
                    if ("POST".equals(request.getMethod())) {
                        try {
                            String title = request.getParameter("title");
                            String subTitle = request.getParameter("subTitle");
                            String description = request.getParameter("description");
                            String content = request.getParameter("content");
                            String idSupplier = request.getParameter("idSupplier");
                            
                            Part filePart = request.getPart("image");
                            String imageUrl = CloudinaryUtil.upload(filePart);
                            if (imageUrl == null) imageUrl = "";

                            int userId = 1; 
                            entity.User acc = (entity.User) request.getSession().getAttribute("acc");
                            if(acc != null) userId = acc.getId();

                            BlogPost blog = new BlogPost();
                            blog.setTitle(title);
                            blog.setSubTitle(subTitle);
                            blog.setDescription(description);
                            blog.setContent(content);
                            blog.setImagePath(imageUrl);
                            blog.setIdSupplier(idSupplier);
                            blog.setUserId(userId);
                            
                            if(dao.insertBlog(blog)) {
                                request.getSession().setAttribute("successMessage", "Thêm bài viết mới thành công!");
                            } else {
                                request.getSession().setAttribute("errorMessage", "Thêm bài viết thất bại!");
                            }
                        } catch (Exception e) {
                            e.printStackTrace(); // In lỗi ra Console của NetBeans
                            request.getSession().setAttribute("errorMessage", "Lỗi chi tiết: " + e.getMessage());
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/blog");
                    } else {
                        request.setAttribute("supList", dao.getActiveSuppliers());
                        request.getRequestDispatcher("/admin/addBlog.jsp").forward(request, response);
                    }
                    break;
                    
                case "updateBlog":
                    if ("POST".equals(request.getMethod())) {
                        try {
                            int blogId = Integer.parseInt(request.getParameter("blogId"));
                            String title = request.getParameter("title");
                            String subTitle = request.getParameter("subTitle");
                            String description = request.getParameter("description");
                            String content = request.getParameter("content");
                            String idSupplier = request.getParameter("idSupplier");
                            
                            BlogPost blog = dao.getBlogById(blogId);
                            if (blog != null) {
                                Part filePart = request.getPart("image");
                                if (filePart != null && filePart.getSize() > 0) {
                                    String newImageUrl = CloudinaryUtil.upload(filePart);
                                    if (newImageUrl != null) blog.setImagePath(newImageUrl);
                                }
                                
                                blog.setTitle(title);
                                blog.setSubTitle(subTitle);
                                blog.setDescription(description);
                                blog.setContent(content);
                                blog.setIdSupplier(idSupplier);
                                
                                if(dao.updateBlog(blog)) {
                                    request.getSession().setAttribute("successMessage", "Cập nhật bài viết thành công!");
                                } else {
                                    request.getSession().setAttribute("errorMessage", "Cập nhật thất bại!");
                                }
                            }
                        } catch (Exception e) {
                            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/blog");
                    } else {
                        int blogId = Integer.parseInt(request.getParameter("blogId"));
                        BlogPost blog = dao.getBlogById(blogId);
                        if (blog != null) {
                            request.setAttribute("blog", blog);
                            request.setAttribute("supList", dao.getActiveSuppliers());
                            request.getRequestDispatcher("/admin/editBlog.jsp").forward(request, response);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/admin/blog");
                        }
                    }
                    break;
                    
                case "deleteBlog":
                    try {
                        int blogId = Integer.parseInt(request.getParameter("blogId"));
                        dao.deleteBlog(blogId);
                    } catch (Exception e) {}
                    response.sendRedirect(request.getContextPath() + "/admin/blog");
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/blog");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi hệ thống tại BlogManageController: " + e.getMessage(), e);
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
