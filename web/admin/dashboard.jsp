<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%
    // Dữ liệu động được cung cấp bởi AdminDashboardController
    // Bao gồm: totalProducts, totalUsers, totalBlogs, pendingOrders, monthlyRevenue, recentOrders, bestSellers
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - MobileShop</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-body: #f4f7fe;
            --bg-sidebar: #1e293b;
            --bg-card: #ffffff;
            --primary: #4318ff;
            --primary-light: #e9e3ff;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border: #e9edf7;
            --danger: #ee5d50;
            --success: #05cd99;
            --warning: #ffb81c;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
            --sidebar-active: #aff22f;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            overflow-x: hidden;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* ===== SIDEBAR – Version Gold ===== */
        .sidebar {
            width: 260px;
            background: #1e293b;
            padding: 24px 0;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            z-index: 100;
            color: white;
            overflow-y: auto;
        }
        .sidebar .brand {
            padding: 0 24px;
            margin-bottom: 40px;
            text-decoration: none;
            color: white;
            display: block;
        }
        .sidebar .brand h2 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        
        .nav-section { margin-bottom: 32px; }
        .nav-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            color: #64748b;
            letter-spacing: 1px;
            margin-bottom: 12px;
            display: block;
            padding: 0 24px;
        }
        
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 24px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            border-left: 4px solid transparent;
            transition: 0.3s;
        }
        .menu-link i { width: 20px; text-align: center; }
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active {
            background: rgba(175, 242, 47, 0.1);
            color: #aff22f;
            border-left-color: #aff22f;
            font-weight: 600;
        }
        /* ===== END SIDEBAR ===== */

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .welcome h1 { font-size: 1.5rem; color: var(--text-main); font-weight: 700; margin-bottom: 4px; }
        .welcome p { color: var(--text-muted); font-size: 0.9rem; }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .notification {
            position: relative;
            cursor: pointer;
            color: var(--text-muted);
            font-size: 1.2rem;
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow);
        }

        .notification .n-dot {
            position: absolute;
            top: 10px;
            right: 12px;
            width: 8px;
            height: 8px;
            background: var(--danger);
            border-radius: 50%;
            border: 2px solid white;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            background: white;
            padding: 4px 12px 4px 4px;
            border-radius: 30px;
            box-shadow: var(--shadow);
        }

        .avatar {
            width: 36px;
            height: 36px;
            background: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-weight: 700;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: var(--bg-card);
            padding: 24px;
            border-radius: 20px;
            border: 1px solid transparent;
            box-shadow: var(--shadow);
            transition: 0.3s;
        }

        .stat-card:hover { transform: translateY(-5px); border-color: var(--primary-light); }

        .stat-label { font-size: 0.85rem; color: var(--text-muted); font-weight: 600; margin-bottom: 8px; }
        .stat-value { font-size: 1.5rem; font-weight: 700; color: var(--text-main); margin-bottom: 8px; }
        
        .stat-trend { font-size: 0.8rem; display: flex; align-items: center; gap: 4px; font-weight: 700; }
        .trend-up { color: var(--success); }
        .trend-down { color: var(--danger); }
        .trend-neutral { color: var(--warning); }

        .progress-container {
            width: 100%;
            height: 6px;
            background: #f4f7fe;
            border-radius: 10px;
            margin-top: 16px;
            overflow: hidden;
        }

        .progress-bar { height: 100%; border-radius: 10px; }

        /* Tables Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
            gap: 24px;
        }

        .card {
            background: var(--bg-card);
            border-radius: 24px;
            padding: 24px;
            box-shadow: var(--shadow);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .card-header h3 { font-size: 1.1rem; color: var(--text-main); font-weight: 700; }
        .view-all { color: var(--primary); text-decoration: none; font-size: 0.85rem; font-weight: 700; }

        /* Order List */
        .order-item {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f4f7fe;
        }

        .order-item:last-child { border-bottom: none; }

        .item-icon {
            width: 44px;
            height: 44px;
            background: var(--bg-body);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 16px;
        }

        .item-icon i { color: var(--primary); }

        .item-info { flex: 1; }
        .item-name { font-weight: 700; font-size: 0.95rem; color: var(--text-main); margin-bottom: 4px; }
        .item-meta { font-size: 0.8rem; color: var(--text-muted); font-weight: 500; }

        .item-value { text-align: right; }
        .item-price { font-weight: 700; color: var(--text-main); margin-bottom: 4px; }
        
        .status-pill {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .status-success { background: #e6f9f4; color: var(--success); }
        .status-warning { background: #fff8e6; color: var(--warning); }
        .status-danger { background: #feebeb; color: var(--danger); }

        /* Product List */
        .product-item {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
        }

        .product-img {
            width: 48px;
            height: 48px;
            background: var(--bg-body);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-img i { color: var(--primary); font-size: 1.2rem; }

        .product-info h4 { font-size: 0.9rem; font-weight: 700; color: var(--text-main); margin-bottom: 2px; }
        .product-info p { font-size: 0.75rem; color: var(--text-muted); font-weight: 600; }

        /* Responsive */
        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .content-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <!-- 1. TỔNG QUAN -->
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link active">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 2. QUẢN LÝ BÁN HÀNG -->
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/products" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 3. TƯƠNG TÁC & NỘI DUNG -->
            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 4. CẤU HÌNH GIAO DIỆN -->
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 5. HỆ THỐNG -->
            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="header">
                <div class="welcome">
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Tổng quan hệ thống</p>
                    <h1>Chào mừng quay trở lại, ${sessionScope.acc != null ? sessionScope.acc.name : "Thân Hải Phúc"} &bull; Hôm nay: ${currentDate}</h1>
                </div>
                <div class="header-actions">
                    <div class="notification"><i class="fa-regular fa-bell"></i></div>
                    <div class="user-profile">
                        <div class="avatar">${sessionScope.acc != null ? sessionScope.acc.name.substring(0,1).toUpperCase() : "A"}</div>
                        <span style="font-weight: 600;">${sessionScope.acc != null ? sessionScope.acc.name : "Admin"}</span>
                    </div>
                </div>
            </header>

            <div style="margin-bottom: 24px;">
                <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--text-main);">THỐNG KÊ TỔNG QUAN</h3>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Tổng sản phẩm</div>
                    <div class="stat-value">${totalProducts}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Tổng người dùng</div>
                    <div class="stat-value">${totalUsers}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Đơn hàng chờ</div>
                    <div class="stat-value">${pendingOrders}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Doanh thu tháng</div>
                    <div class="stat-value">${monthlyRevenue}</div>
                </div>
            </div>

            <div class="content-grid">
                <!-- Recent Orders -->
                <div class="card">
                    <div class="card-header">
                        <h3>Đơn hàng gần đây</h3>
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="view-all">Xem tất cả <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                    <div class="order-list">
                        <c:forEach items="${recentOrders}" var="order">
                            <div class="order-item">
                                <div class="item-icon">
                                    <i class="fa-solid fa-box-open"></i>
                                </div>
                                <div class="item-info">
                                    <div class="item-name">${order.name}</div>
                                    <div class="item-meta">${order.time} &bull; ${order.id}</div>
                                </div>
                                <div class="item-value">
                                    <div class="item-price">${order.price}</div>
                                    <span class="status-pill 
                                        ${order.status == 'Hoàn thành' ? 'status-success' : 
                                          order.status == 'Đang giao' ? 'status-warning' : 'status-danger'}">
                                        ${order.status}
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty recentOrders}">
                            <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                                <i class="fa-solid fa-receipt" style="font-size: 2rem; margin-bottom: 12px; display: block; opacity: 0.3;"></i>
                                <p>Chưa có đơn hàng nào</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Best Sellers -->
                <div class="card">
                    <div class="card-header">
                        <h3>Sản phẩm bán chạy</h3>
                        <i class="fa-solid fa-ellipsis-vertical" style="color: var(--text-muted); cursor: pointer;"></i>
                    </div>
                    <div class="product-list">
                        <c:forEach items="${bestSellers}" var="product">
                            <div class="product-item">
                                <div class="product-img">
                                    <i class="fa-solid fa-laptop-code" style="color: var(--primary);"></i>
                                </div>
                                <div class="product-info">
                                    <h4>${product.name}</h4>
                                    <p>${product.brand} &bull; ${product.stock}</p>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty bestSellers}">
                            <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                                <i class="fa-solid fa-box-archive" style="font-size: 2rem; margin-bottom: 12px; display: block; opacity: 0.3;"></i>
                                <p>Chưa có dữ liệu bán hàng</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>

</body>
</html>
