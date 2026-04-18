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
        <!-- Sidebar -->
        <aside class="sidebar">
            <a href="#" class="sidebar-brand">MobileShop</a>
            <ul class="sidebar-menu">
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                        <span class="menu-dot"></span>
                        Dashboard
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link">
                        <span class="menu-dot"></span>
                        Quản lý tài khoản
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                        <span class="menu-dot"></span>
                        Quản lý đơn hàng
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link">
                        <span class="menu-dot"></span>
                        Quản lý sản phẩm
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active">
                        <span class="menu-dot"></span>
                        Quản lý blog
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/home" class="menu-link">
                        <span class="menu-dot"></span>
                        Về trang chủ
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                        <span class="menu-dot"></span>
                        Đăng xuất
                    </a>
                </li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="page-header">
                <div class="page-title">
                    <h1>Quản lý blog</h1>
                    <p>Quản trị danh sách bài viết và nội dung truyền thông trên cửa hàng.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/blog?service=insertBlog" class="btn-primary" style="text-decoration: none;">Thêm blog</a>
            </header>

            <section class="content-card">
                <!-- Filters -->
                <div class="filter-bar">
                    <div style="position: relative; flex: 1; max-width: 400px;">
                        <i class="fa-solid fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #cbd5e1;"></i>
                        <input type="text" class="form-input" placeholder="Tìm kiếm theo tiêu đề..." style="padding-left: 36px;">
                    </div>
                    <button class="btn-primary" style="background: #4e6af2;">Lọc</button>
                    <button class="btn-outline">Đặt lại</button>
                </div>

                <!-- Table -->
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 80px;">ID</th>
                            <th style="width: 100px;">Ảnh</th>
                            <th>Tiêu đề</th>
                            <th style="width: 150px;">Hãng/Tag</th>
                            <th style="width: 120px;">Ngày đăng</th>
                            <th style="width: 150px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${blogList}" var="blog">
                            <tr>
                                <td style="color: var(--text-muted);">#${blog.idPost}</td>
                                <td>
                                    <img src="${not empty blog.thumbnailPath ? blog.thumbnailPath : 'img/no-image.png'}" class="blog-thumb-sm" alt="">
                                </td>
                                <td>
                                    <div style="font-weight: 600;">${blog.title}</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">${blog.subTitle}</div>
                                </td>
                                <td><span class="status-badge" style="background: #f1f5f9; color: #475569;">${blog.idSupplier}</span></td>
                                <td><div style="font-size: 0.85rem; color: var(--text-muted);"><fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/></div></td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=updateBlog&idPost=${blog.idPost}" class="btn-outline" style="padding: 4px 10px; font-size: 0.75rem; text-decoration: none;">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=deleteBlog&idPost=${blog.idPost}" class="btn-outline" style="padding: 4px 10px; font-size: 0.75rem; text-decoration: none; color: #ef4444; border-color: #fee2e2;" onclick="return confirm('Xóa bài viết này?')">Xóa</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty blogList}">
                            <tr><td colspan="6" style="text-align: center; padding: 3rem; color: var(--text-muted);">Chưa có bài viết nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
        </main>
    </div>

</body>
</html>
