<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MobileShop</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .stat-card .label { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 0.5rem; }
        .stat-card .value { font-size: 1.75rem; font-weight: 700; color: var(--text-main); }
    </style>
</head>
<body>

    <div class="admin-layout">
        <!-- Sidebar -->
        <aside class="sidebar">
            <a href="#" class="sidebar-brand">MobileShop</a>
            <ul class="sidebar-menu">
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link active">
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
                    <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link">
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
                    <h1>Tổng quan hệ thống</h1>
                    <p>Chào mừng quay trở lại, ${sessionScope.acc != null ? sessionScope.acc.name : "Admin"}.</p>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="label">Tổng sản phẩm</div>
                    <div class="value">${totalProducts != null ? totalProducts : "0"}</div>
                </div>
                <div class="stat-card">
                    <div class="label">Tổng người dùng</div>
                    <div class="value">${totalUsers != null ? totalUsers : "0"}</div>
                </div>
                <div class="stat-card">
                    <div class="label">Tổng bài viết</div>
                    <div class="value">${totalBlogs != null ? totalBlogs : "0"}</div>
                </div>
            </div>

            <section class="content-card">
                <h3>Các thao tác nhanh</h3>
                <p>Chọn chức năng bạn muốn quản lý từ Sidebar bên trái để bắt đầu.</p>
            </section>
        </main>
    </div>

</body>
</html>
