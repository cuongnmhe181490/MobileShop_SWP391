<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MobileShop</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Bootstrap CSS (Optional but useful for grid) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    
    <!-- Custom Admin Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">
            MobileShop
        </div>
        
        <nav>
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
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
                    <a href="${pageContext.request.contextPath}/admin/blog">
                        <i class="fa-solid fa-newspaper"></i>
                        <span>Quản lý blog</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/index.jsp">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Về trang chủ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/auth/logout">
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
        <div class="header-section">
            <h1>Admin Dashboard</h1>
            <p>Theo dõi nhanh số liệu chính và truy cập các thao tác quản trị thường dùng.</p>
        </div>
        
        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="label">Tổng tài khoản</div>
                <div class="value">${totalUsers != null ? totalUsers : "1.284"}</div>
                <div class="description">Người dùng đang hoạt động</div>
            </div>
            
            <div class="stat-card">
                <div class="label">Tổng sản phẩm</div>
                <div class="value">${totalProducts != null ? totalProducts : "72"}</div>
                <div class="description">Sản phẩm hiển thị trên storefront</div>
            </div>
            
            <div class="stat-card">
                <div class="label">Tổng blog</div>
                <div class="value">${totalBlogs != null ? totalBlogs : "18"}</div>
                <div class="description">Bài viết đã xuất bản</div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions-section">
            <h2>Quick actions</h2>
            <div class="actions-grid">
                <div class="action-card">
                    <h3>Thêm sản phẩm</h3>
                    <p>Tạo nhanh sản phẩm mới và cập nhật tồn kho.</p>
                    <a href="${pageContext.request.contextPath}/admin/products?service=addProduct" class="btn-action">Thêm sản phẩm</a>
                </div>
                
                <div class="action-card">
                    <h3>Thêm blog</h3>
                    <p>Viết bài mới theo hệ thống nội dung hiện tại.</p>
                    <a href="${pageContext.request.contextPath}/admin/blog?service=insertBlog" class="btn-action btn-outline">Thêm blog</a>
                </div>
                
                <div class="action-card">
                    <h3>Quản lý tài khoản</h3>
                    <p>Kiểm tra trạng thái user và dọn tài khoản không hợp lệ.</p>
                    <a href="${pageContext.request.contextPath}/admin/accounts" class="btn-action btn-outline">Quản lý tài khoản</a>
                </div>
            </div>
        </div>
        
        <!-- Overview Section -->
        <div class="info-card">
            <h3>Tổng quan hôm nay</h3>
            <p>Giữ phần quản trị theo đúng logic JSP + Bootstrap: các card số liệu ở trên, các thao tác nhanh ở giữa, và các bảng dữ liệu chi tiết sẽ được phát triển ở các trang chức năng riêng biệt.</p>
        </div>
    </div>

</body>
</html>
