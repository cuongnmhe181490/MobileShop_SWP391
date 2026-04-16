<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa bài viết - MobileShop</title>
    
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
                <h1 style="font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem;">Chỉnh sửa bài viết</h1>
                <p style="color: var(--text-muted);">Cập nhật thông tin bài viết ID: #${blog.idPost}</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/blog" class="btn-action btn-edit">Quay lại</a>
        </div>

        <div class="info-card" style="max-width: 900px;">
            <!-- Form points to service=updateBlog -->
            <form action="${pageContext.request.contextPath}/admin/blog?service=updateBlog" method="POST" enctype="multipart/form-data">
                <!-- Hidden Field for ID -->
                <input type="hidden" name="idPost" value="${blog.idPost}">

                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-4">
                            <label class="form-label fw-bold">Tiêu đề bài viết</label>
                            <input type="text" name="title" class="form-control" value="${blog.title}" required style="padding: 0.75rem; border-radius: 0.75rem;">
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">Phụ đề (SubTitle)</label>
                            <input type="text" name="subTitle" class="form-control" value="${blog.subTitle}" style="padding: 0.75rem; border-radius: 0.75rem;">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Mô tả ngắn (Summary)</label>
                            <textarea name="summary" class="form-control" rows="3" style="padding: 0.75rem; border-radius: 0.75rem;">${blog.summary}</textarea>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="mb-4">
                            <label class="form-label fw-bold">Nhà cung cấp</label>
                            <select name="idSupplier" class="form-select" required style="padding: 0.75rem; border-radius: 0.75rem;">
                                <c:forEach items="${supList}" var="sup">
                                    <option value="${sup}" ${sup == blog.idSupplier ? 'selected' : ''}>${sup}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Thay đổi ảnh đại diện</label>
                            <div class="mb-2">
                                <img src="${not empty blog.thumbnailPath ? blog.thumbnailPath : 'img/no-image.png'}" class="blog-thumb-sm" style="width: 100px; height: 75px;">
                            </div>
                            <input type="file" name="thumbnail" class="form-control" accept="image/*" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div class="form-text mt-2">Để trống nếu không muốn thay đổi ảnh.</div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Nội dung chi tiết</label>
                    <textarea name="content" class="form-control" rows="12" required style="padding: 1rem; border-radius: 1rem;">${blog.content}</textarea>
                </div>

                <hr style="margin: 2rem 0; opacity: 0.1;">

                <div class="d-flex justify-content-end gap-3">
                    <a href="${pageContext.request.contextPath}/admin/blog" class="btn-action btn-edit">Hủy bỏ</a>
                    <button type="submit" class="btn-action">Cập nhật bài viết</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
