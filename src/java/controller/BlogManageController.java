package controller;

import dao.BlogDAO;
import entity.BlogPost;
import entity.BlogCategory;
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
    fileSizeThreshold = 1024 * 500, 
    maxFileSize = 1024 * 500,           
    maxRequestSize = 1024 * 500
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
                    String filterCatIdStr = request.getParameter("filterCat");
                    String searchTitle = request.getParameter("searchTitle");
                    String pageStr = request.getParameter("page");
                    
                    int pageSizeAdmin = 7; // Hiển thị 7 bài mỗi trang cho Admin theo yêu cầu
                    int pageIndexAdmin = 1;
                    try {
                        if (pageStr != null) pageIndexAdmin = Integer.parseInt(pageStr);
                    } catch (Exception e) { pageIndexAdmin = 1; }
                    
                    Integer filterCatId = null;
                    try {
                        if (filterCatIdStr != null && !filterCatIdStr.isEmpty()) filterCatId = Integer.parseInt(filterCatIdStr);
                    } catch (Exception e) { filterCatId = null; }
                    
                    // Lấy tổng số bài viết để tính số trang
                    int totalBlogsAdmin = dao.getTotalBlogsAdmin(searchTitle, filterCatId);
                    int totalPagesAdmin = (int) Math.ceil((double) totalBlogsAdmin / pageSizeAdmin);
                    if (pageIndexAdmin > totalPagesAdmin && totalPagesAdmin > 0) pageIndexAdmin = totalPagesAdmin;
                    
                    int offset = (pageIndexAdmin - 1) * pageSizeAdmin;
                    List<BlogPost> list = dao.getBlogsWithPaginationAdmin(offset, pageSizeAdmin, searchTitle, filterCatId);
                    
                    request.setAttribute("blogList", list);
                    request.setAttribute("catList", dao.getAllBlogCategories());
                    request.setAttribute("selectedCat", filterCatIdStr);
                    request.setAttribute("searchTitle", searchTitle);
                    request.setAttribute("currentPage", pageIndexAdmin);
                    request.setAttribute("totalPages", totalPagesAdmin);
                    request.getRequestDispatcher("/admin/blog-manage.jsp").forward(request, response);
                    break;
                    
                case "insertBlog":
                    if ("POST".equals(request.getMethod())) {
                        try {
                            String title = request.getParameter("title");
                            String subTitle = request.getParameter("subTitle");
                            String description = request.getParameter("description");
                            String content = request.getParameter("content");
                            int idBlogCat = Integer.parseInt(request.getParameter("idBlogCat"));
                            
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
                            blog.setIdBlogCat(idBlogCat);
                            blog.setUserId(userId);
                            
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
                        request.setAttribute("catList", dao.getAllBlogCategories());
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
                            int idBlogCat = Integer.parseInt(request.getParameter("idBlogCat"));
                                
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
                                    blog.setIdBlogCat(idBlogCat);
                                    String statusFromForm = request.getParameter("status");
                                    if(statusFromForm != null) blog.setStatus(statusFromForm);
                                
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
                            request.setAttribute("catList", dao.getAllBlogCategories());
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
                    
                case "addCategory":
                    String newCatName = request.getParameter("name");
                    if (newCatName != null && !newCatName.trim().isEmpty()) {
                        if (dao.insertBlogCategory(newCatName.trim())) {
                            response.getWriter().write("success");
                        } else {
                            response.getWriter().write("fail");
                        }
                    }
                    return;
                    
                case "deleteCategory":
                    try {
                        int catId = Integer.parseInt(request.getParameter("id"));
                        if (dao.deleteBlogCategory(catId)) {
                            response.getWriter().write("success");
                        } else {
                            response.getWriter().write("fail");
                        }
                    } catch (Exception e) {
                        response.getWriter().write("error");
                    }
                    return;

                case "updateCategory":
                    try {
                        int catId = Integer.parseInt(request.getParameter("id"));
                        String catName = request.getParameter("name");
                        if (catName != null && !catName.trim().isEmpty()) {
                            if (dao.updateBlogCategory(catId, catName.trim())) {
                                response.getWriter().write("success");
                            } else {
                                response.getWriter().write("fail");
                            }
                        }
                    } catch (Exception e) {
                        response.getWriter().write("error");
                    }
                    return;
                    
                case "listCategories":
                    List<BlogCategory> cats = dao.getAllBlogCategories();
                    StringBuilder json = new StringBuilder("[");
                    for (int i = 0; i < cats.size(); i++) {
                        BlogCategory c = cats.get(i);
                        json.append("{\"id\":").append(c.getIdBlogCat())
                            .append(",\"name\":\"").append(c.getCategoryName().replace("\"", "\\\"")).append("\"}");
                        if (i < cats.size() - 1) json.append(",");
                    }
                    json.append("]");
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write(json.toString());
                    return;

                case "toggleStatus":
                    try {
                        String bId = request.getParameter("blogId");
                        String nStatus = request.getParameter("status");
                        if (bId == null || nStatus == null) {
                            response.getWriter().write("error: thieu tham so");
                            return;
                        }
                        int blogId = Integer.parseInt(bId);
                        if (dao.updateBlogStatus(blogId, nStatus)) {
                            response.getWriter().write("success");
                        } else {
                            response.getWriter().write("fail: khong tim thay blog hoac trung trang thai");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        response.getWriter().write("error: " + e.getMessage());
                    }
                    return;
                    
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
