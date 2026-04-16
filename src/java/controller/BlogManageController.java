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
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
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
                            String summary = request.getParameter("summary");
                            String content = request.getParameter("content");
                            String idSupplier = request.getParameter("idSupplier");
                            
                            // XỬ LÝ CLOUDINARY: Nhận file từ Part "thumbnail"
                            Part filePart = request.getPart("thumbnail");
                            String imageUrl = CloudinaryUtil.upload(filePart);
                            
                            if (imageUrl == null) {
                                imageUrl = ""; 
                            }

                            int userId = 1; 
                            entity.User acc = (entity.User) request.getSession().getAttribute("acc");
                            if(acc != null) {
                                userId = acc.getId();
                            }

                            BlogPost blog = new BlogPost();
                            blog.setTitle(title);
                            blog.setSubTitle(subTitle);
                            blog.setSummary(summary);
                            blog.setContent(content);
                            blog.setThumbnailPath(imageUrl);
                            blog.setUserId(userId);
                            blog.setIdSupplier(idSupplier);
                            
                            if(dao.insertBlog(blog)) {
                                request.getSession().setAttribute("successMessage", "Thêm bài viết mới thành công!");
                            } else {
                                request.getSession().setAttribute("errorMessage", "Thêm bài viết thất bại!");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/blog");
                    } else {
                        List<String> listSup = dao.getActiveSuppliers();
                        request.setAttribute("supList", listSup);
                        request.getRequestDispatcher("/admin/addBlog.jsp").forward(request, response);
                    }
                    break;
                    
                case "updateBlog":
                    if ("POST".equals(request.getMethod())) {
                        try {
                            int idPost = Integer.parseInt(request.getParameter("idPost"));
                            String title = request.getParameter("title");
                            String subTitle = request.getParameter("subTitle");
                            String summary = request.getParameter("summary");
                            String content = request.getParameter("content");
                            String idSupplier = request.getParameter("idSupplier");
                            
                            BlogPost blog = dao.getBlogById(idPost);
                            if (blog != null) {
                                // Xử lý upload ảnh mới
                                Part filePart = request.getPart("thumbnail");
                                if (filePart != null && filePart.getSize() > 0) {
                                    String newImageUrl = CloudinaryUtil.upload(filePart);
                                    if (newImageUrl != null) {
                                        blog.setThumbnailPath(newImageUrl);
                                    }
                                }
                                
                                blog.setTitle(title);
                                blog.setSubTitle(subTitle);
                                blog.setSummary(summary);
                                blog.setContent(content);
                                blog.setIdSupplier(idSupplier);
                                
                                if(dao.updateBlog(blog)) {
                                    request.getSession().setAttribute("successMessage", "Cập nhật bài viết thành công!");
                                } else {
                                    request.getSession().setAttribute("errorMessage", "Cập nhật thất bại!");
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/blog");
                    } else {
                        int idPost = Integer.parseInt(request.getParameter("idPost"));
                        BlogPost blog = dao.getBlogById(idPost);
                        if (blog != null) {
                            List<String> listSup = dao.getActiveSuppliers();
                            request.setAttribute("supList", listSup);
                            request.setAttribute("blog", blog);
                            request.getRequestDispatcher("/admin/editBlog.jsp").forward(request, response);
                        } else {
                            request.getSession().setAttribute("errorMessage", "Không tìm thấy bài viết!");
                            response.sendRedirect(request.getContextPath() + "/admin/blog");
                        }
                    }
                    break;
                    
                case "deleteBlog":
                    try {
                        int idPost = Integer.parseInt(request.getParameter("idPost"));
                        if(dao.deleteBlog(idPost)) {
                            request.getSession().setAttribute("successMessage", "Xóa bài viết thành công!");
                        } else {
                            request.getSession().setAttribute("errorMessage", "Xóa bài viết thất bại!");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/blog");
                    break;
                    
            
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/blog");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/blog");
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
