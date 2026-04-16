<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý blog - MobileShop</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    
    <!-- Custom Admin Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">MobileShop</div>
        <nav>
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-house"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/accounts">
                        <i class="fa-solid fa-users"></i>
                        <span>Quản lý tài khoản</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/products">
                        <i class="fa-solid fa-box-archive"></i>
                        <span>Quản lý sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/blog" class="active">
                        <i class="fa-solid fa-newspaper"></i>
                        <span>Quản lý blog</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Về trang chủ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        <span>Đăng xuất</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="user-info">
            <h4>Xin chào ${sessionScope.acc != null ? sessionScope.acc.name : "admin"}</h4>
            <p>Quản lý dữ liệu hệ thống</p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header-flex">
            <div>
                <h1 style="font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem;">Quản lý blog</h1>
                <p style="color: var(--text-muted);">Quản trị danh sách bài viết theo cấu trúc database mới.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/blog?service=insertBlog" class="btn-action">Thêm blog</a>
        </div>
        
        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 1rem; margin-bottom: 2rem;">
                <i class="fa-solid fa-check-circle me-2"></i> ${sessionScope.successMessage}
                <c:remove var="successMessage" scope="session"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 1rem; margin-bottom: 2rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMessage}
                <c:remove var="errorMessage" scope="session"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="table-container">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th style="width: 100px;">Ảnh</th>
                        <th>Tiêu đề</th>
                        <th style="width: 150px;">Nhà cung cấp</th>
                        <th style="width: 150px;">Ngày đăng</th>
                        <th style="width: 180px;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty blogList}">
                            <c:forEach items="${blogList}" var="blog">
                                <tr>
                                    <td style="color: var(--text-muted); font-weight: 500;">#${blog.idPost}</td>
                                    <td>
                                        <img src="${not empty blog.thumbnailPath ? blog.thumbnailPath : 'img/no-image.png'}" class="blog-thumb-sm" alt="Blog Thumb">
                                    </td>
                                    <td>
                                        <div style="font-weight: 600; color: var(--text-main); line-height: 1.4;">
                                            ${blog.title}
                                            <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 0.2rem;">${blog.subTitle}</div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge-status badge-info">${blog.idSupplier}</span>
                                    </td>
                                    <td>
                                        <div style="color: var(--text-muted); font-size: 0.85rem;">
                                            <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=updateBlog&idPost=${blog.idPost}" class="btn-action btn-sm-action btn-edit">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=deleteBlog&idPost=${blog.idPost}" class="btn-action btn-sm-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 4rem; color: var(--text-muted);">
                                    <i class="fa-solid fa-folder-open" style="font-size: 3rem; margin-bottom: 1rem; display: block; opacity: 0.2;"></i>
                                    Chưa có dữ liệu bài viết .
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
