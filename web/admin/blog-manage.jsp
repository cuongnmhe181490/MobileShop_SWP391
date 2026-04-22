<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý blog - MobileShop Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
    <style>
        .blog-thumb-sm {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--border);
        }
    </style>
</head>
<body>

    <div class="admin-layout">
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-table-columns"></i>Dashboard</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="#" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/products" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active"><i class="fa-solid fa-newspaper"></i>Blog</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/AdminHomeConfigServlet" class="menu-link"><i class="fa-solid fa-home"></i>Trang chủ</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">HỆ THỐNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-house"></i>Về trang chủ</a></li>
                </ul>
            </div>

            <div style="margin-top: auto;">
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-arrow-right-from-bracket"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="page-header">
                <div class="page-title">
                    <h1>Quản lý blog</h1>
                    <p>Quản trị danh sách bài viết và nội dung truyền thông trên cửa hàng.</p>
                </div>
                <!-- Nút thêm blog chính -->
                <a href="${pageContext.request.contextPath}/admin/blog?service=insertBlog" class="btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fas fa-plus"></i> Thêm blog
                </a>
            </header>

            <section class="content-card">
                <!-- Filters -->
                <form action="${pageContext.request.contextPath}/admin/blog" method="GET" class="filter-bar">
                    <input type="hidden" name="service" value="listAll">
                    
                    <div style="position: relative; flex: 1; max-width: 300px;">
                        <i class="fa-solid fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #cbd5e1;"></i>
                        <input type="text" name="searchTitle" class="form-input" placeholder="Tìm kiếm theo tiêu đề..." value="${param.searchTitle}" style="padding-left: 36px;">
                    </div>

                    <select name="filterCat" class="form-select" style="max-width: 200px; padding: 8px 12px; border-radius: 8px; border: 1px solid #e2e8f0;">
                        <option value="">-- Tất cả danh mục --</option>
                        <c:forEach items="${catList}" var="cat">
                            <option value="${cat.idBlogCat}" ${cat.idBlogCat == selectedCat ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>

                    <button type="submit" class="btn-primary" style="background: #4e6af2; padding: 10px 20px;">Lọc</button>
                    <a href="${pageContext.request.contextPath}/admin/blog?service=listAll" class="btn-outline" style="text-decoration: none; padding: 10px 20px;">Đặt lại</a>
                </form>

                <!-- Table -->
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 80px;">ID</th>
                            <th style="width: 100px;">Ảnh</th>
                            <th>Tiêu đề bài viết</th>
                            <th style="width: 150px;">Danh mục</th>
                            <th style="width: 130px;">Ngày đăng</th>
                            <th style="width: 130px;">Trạng Thái</th>
                            <th style="width: 180px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${blogList}" var="blog">
                            <tr>
                                <td style="color: var(--text-muted);">#${blog.blogId}</td>
                                <td>
                                    <img src="${not empty blog.imagePath ? blog.imagePath : 'img/no-image.png'}" class="blog-thumb-sm" alt="Thumbnail">
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: var(--text-dark);">${blog.title}</div>
                                    <c:if test="${not empty blog.subTitle}">
                                        <div style="font-size: 0.75rem; color: var(--text-muted);">${blog.subTitle}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="status-badge" style="background: #f1f5f9; color: #475569; font-size: 0.8rem;">
                                        ${not empty blog.categoryName ? blog.categoryName : 'N/A'}
                                    </span>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; color: var(--text-muted);">
                                        <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </td>
                                <td>
                                  <c:choose>
                                    <c:when test="${blog.status == 'VISIBLE'}">
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=toggleStatus&blogId=${blog.blogId}&newStatus=HIDDEN" 
                                           class="btn-outline" style="padding: 6px 12px; font-size: 0.8rem; text-decoration: none; color: #10b981; border-color: #d1fae5; background: #ecfdf5;">
                                            <i class="fas fa-eye"></i> Hiện
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=toggleStatus&blogId=${blog.blogId}&newStatus=VISIBLE" 
                                           class="btn-outline" style="padding: 6px 12px; font-size: 0.8rem; text-decoration: none; color: #f59e0b; border-color: #fef3c7; background: #fffbeb;">
                                            <i class="fas fa-eye-slash"></i> Ẩn
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=updateBlog&blogId=${blog.blogId}" class="btn-outline" style="padding: 6px 12px; font-size: 0.8rem; text-decoration: none;">
                                            <i class="fas fa-edit me-1"></i> Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=deleteBlog&blogId=${blog.blogId}" class="btn-outline" style="padding: 6px 12px; font-size: 0.8rem; text-decoration: none; color: #ef4444; border-color: #fee2e2;" onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')">
                                            <i class="fas fa-trash me-1"></i> Xóa
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty blogList}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 4rem; color: var(--text-muted);">
                                    <div class="mb-2"><i class="fas fa-folder-open fa-3x" style="opacity: 0.2;"></i></div>
                                    Chưa có bài viết nào trong danh sách.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <!-- Pagination for Admin -->
                <c:if test="${totalPages > 1}">
                    <div style="margin-top: 24px; display: flex; justify-content: center; gap: 8px;">
                        <a href="${pageContext.request.contextPath}/admin/blog?service=listAll&filterCat=${selectedCat}&searchTitle=${param.searchTitle}&page=${currentPage - 1}" 
                           class="btn-outline ${currentPage == 1 ? 'disabled' : ''}" 
                           style="width: 40px; height: 40px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 8px; ${currentPage == 1 ? 'pointer-events: none; opacity: 0.5;' : ''}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/admin/blog?service=listAll&filterCat=${selectedCat}&searchTitle=${param.searchTitle}&page=${i}" 
                               style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 8px; text-decoration: none; font-weight: 600; 
                                      ${currentPage == i ? 'background: #4e6af2; color: white; border: none;' : 'background: white; border: 1px solid #e5e7eb; color: #374151;'}"
                               class="${currentPage == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>

                        <a href="${pageContext.request.contextPath}/admin/blog?service=listAll&filterCat=${selectedCat}&searchTitle=${param.searchTitle}&page=${currentPage + 1}" 
                           class="btn-outline ${currentPage == totalPages ? 'disabled' : ''}" 
                           style="width: 40px; height: 40px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 8px; ${currentPage == totalPages ? 'pointer-events: none; opacity: 0.5;' : ''}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </div>
                </c:if>
            </section>
        </main>
    </div>
</body>
</html>
