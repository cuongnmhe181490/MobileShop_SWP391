<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - MobileShop</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --bg-body: #f4f7fe;
            --sidebar-bg: #1e293b;
            --primary: #4318ff;
            --accent: #aff22f;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border-color: #e9edf7;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--bg-body); color: var(--text-main); font-family: 'Plus Jakarta Sans', sans-serif; overflow-x: hidden; }

        .dashboard-container { display: flex; min-height: 100vh; }

        /* ===== SIDEBAR - EXACTLY AS REQUESTED ===== */
        .sidebar {
            width: 260px; background: #1e293b; padding: 24px 0; display: flex;
            flex-direction: column; position: fixed; top: 0; left: 0; height: 100vh;
            z-index: 100; color: white; overflow-y: auto;
        }
        .sidebar .brand { padding: 0 24px; margin-bottom: 40px; text-decoration: none; color: white; display: block; }
        .sidebar .brand h2 { font-size: 1.6rem; font-weight: 800; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        
        .nav-section { margin-bottom: 32px; }
        .nav-label { font-size: 0.7rem; text-transform: uppercase; color: #64748b; letter-spacing: 1px; margin-bottom: 12px; display: block; padding: 0 24px; }
        
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link {
            display: flex; align-items: center; gap: 12px; padding: 12px 24px; color: #94a3b8;
            text-decoration: none; font-weight: 500; font-size: 0.95rem; border-left: 4px solid transparent; transition: 0.3s;
        }
        .menu-link i { width: 20px; text-align: center; }
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active { background: rgba(175, 242, 47, 0.1); color: #aff22f; border-left-color: #aff22f; font-weight: 600; }

        /* ===== MAIN CONTENT ===== */
        .main-content { flex: 1; margin-left: 260px; padding: 40px; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .welcome-msg h1 { font-size: 1.6rem; font-weight: 800; color: var(--text-main); }
        .welcome-msg p { color: var(--text-muted); font-size: 0.8rem; font-weight: 700; text-transform: uppercase; }
        
        .header-tools { display: flex; align-items: center; gap: 15px; }
        
        /* DATE RANGE FORM */
        .filter-form { display: flex; align-items: center; gap: 10px; background: white; padding: 8px 15px; border-radius: 12px; box-shadow: var(--shadow); border: 1px solid #e9edf7; }
        .filter-form input[type="date"] { border: none; font-family: inherit; font-weight: 700; color: var(--text-main); outline: none; font-size: 0.85rem; }
        .btn-filter { background: #4318ff; color: white; border: none; padding: 8px 15px; border-radius: 8px; font-weight: 800; cursor: pointer; font-size: 0.8rem; transition: 0.2s; font-family: inherit; }
        .btn-filter:hover { background: #3311cc; }
        
        .btn-refresh { background: #05cd99; color: white; border: none; padding: 10px 20px; border-radius: 12px; font-weight: 800; cursor: pointer; transition: 0.2s; font-family: inherit; }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 25px; border-radius: 20px; box-shadow: var(--shadow); transition: 0.3s; }
        .stat-card .label { font-size: 0.75rem; font-weight: 800; color: var(--text-muted); text-transform: uppercase; margin-bottom: 10px; }
        .stat-card .value { font-size: 2rem; font-weight: 800; }

        .content-grid { display: grid; grid-template-columns: 1.6fr 1fr; gap: 30px; margin-bottom: 30px; }
        .glass-card { background: white; padding: 30px; border-radius: 24px; box-shadow: var(--shadow); }
        .card-header { display: flex; align-items: center; gap: 12px; margin-bottom: 25px; font-size: 1.1rem; font-weight: 800; }

        .custom-table { width: 100%; border-collapse: collapse; }
        .custom-table th { text-align: left; font-size: 0.7rem; text-transform: uppercase; color: var(--text-muted); font-weight: 800; padding-bottom: 15px; }
        .custom-table td { padding: 15px 0; border-bottom: 1px solid #f4f7fe; font-size: 0.9rem; }
        .rank-badge { width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 0.75rem; }
        .rank-1 { background: #ff9900; }
        .rank-2 { background: #4318ff; }
        .rank-3 { background: #05cd99; }

        .order-row { display: flex; align-items: center; justify-content: space-between; padding: 15px 0; border-bottom: 1px solid #f4f7fe; }
        .order-id { font-weight: 800; color: var(--primary); font-size: 0.85rem; width: 80px; }
        .order-user { font-weight: 700; flex: 1; font-size: 0.85rem; }
        .order-status { padding: 5px 12px; border-radius: 8px; font-size: 0.65rem; font-weight: 800; text-transform: uppercase; }
        .st-done { background: #e6fcf5; color: #087f5b; }
        .st-warning { background: #fff9db; color: #e67700; }
        .st-danger { background: #fff5f5; color: #c92a2a; }

        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .content-grid { grid-template-columns: 1fr; }
            .main-content { margin-left: 0; padding: 20px; }
            .sidebar { display: none; }
        }
    </style>
</head>
<body>

    <div class="dashboard-container">
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

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

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="menu-link">
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

        <main class="main-content">
            <header class="page-header">
                <div class="welcome-msg">
                    <p>Tổng quan hệ thống</p>
                    <h1>Chào mừng quay trở lại, ${sessionScope.acc != null ? sessionScope.acc.name : "admin"}</h1>
                </div>
                <div class="header-tools">
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="filter-form">
                        <i class="fa-regular fa-calendar"></i>
                        <input type="date" name="startDate" value="${startDate}" required>
                        <span>&rarr;</span>
                        <input type="date" name="endDate" value="${endDate}" required>
                        <button type="submit" class="btn-filter">Lọc</button>
                    </form>
                    <button class="btn-refresh" onclick="location.href='${pageContext.request.contextPath}/admin/dashboard'">Làm mới</button>
                    <div class="user-pill">
                        <div class="avatar-circle">${sessionScope.acc != null ? sessionScope.acc.name.substring(0,1).toUpperCase() : "A"}</div>
                        <span>${sessionScope.acc != null ? sessionScope.acc.name : "admin"}</span>
                    </div>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card"><div class="label">Sản phẩm mới</div><div class="value">${totalProducts}</div></div>
                <div class="stat-card"><div class="label">Người dùng mới</div><div class="value">${totalUsers}</div></div>
                <div class="stat-card"><div class="label">Đơn hàng trong kỳ</div><div class="value">${orderStats['Đã hoàn thành'] + orderStats['Chờ xử lý'] + orderStats['Đã hủy']}</div></div>
                <div class="stat-card"><div class="label">Doanh thu kỳ này</div><div class="value" style="color: var(--primary);">${monthlyRevenue}</div></div>
            </div>

            <div class="content-grid">
                <div class="glass-card">
                    <div class="card-header"><i class="fa-solid fa-trophy" style="color:#ffcc00;"></i> Top 5 sản phẩm bán chạy</div>
                    <table class="custom-table">
                        <thead><tr><th>#</th><th>Sản phẩm</th><th style="text-align:center;">Đã bán</th><th style="text-align:right;">Doanh thu</th></tr></thead>
                        <tbody>
                            <c:forEach items="${bestSellers}" var="p" varStatus="st">
                                <tr>
                                    <td><div class="rank-badge rank-${st.count}">${st.count}</div></td>
                                    <td><div style="font-weight:700;">${p.name}</div><div style="font-size:0.75rem; color:var(--text-muted);">${p.brand}</div></td>
                                    <td style="text-align:center; font-weight:800;">${p.sold}</td>
                                    <td style="text-align:right; font-weight:800;">${p.revenue}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="glass-card">
                    <div class="card-header"><i class="fa-solid fa-bolt" style="color:var(--primary);"></i> Đơn hàng phát sinh</div>
                    <div class="order-list">
                        <c:forEach items="${recentOrders}" var="o">
                            <div class="order-row">
                                <span class="order-id">${o.id}</span>
                                <span class="order-user">${o.name}</span>
                                <span class="order-status ${o.status == 'Hoàn thành' ? 'st-done' : o.status == 'Đang giao' ? 'st-warning' : 'st-danger'}">${o.status}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="content-grid">
                <div class="glass-card">
                    <div class="card-header"><i class="fa-solid fa-chart-column" style="color:var(--primary);"></i> Doanh thu (Biểu đồ cột)</div>
                    <div style="height:300px;"><canvas id="barChart"></canvas></div>
                </div>
                <div class="glass-card">
                    <div class="card-header"><i class="fa-solid fa-chart-pie" style="color:#ff9900;"></i> Trạng thái đơn hàng</div>
                    <div style="height:300px;"><canvas id="pieChart"></canvas></div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Bar Chart for Revenue (Dynamic 12 Months)
        new Chart(document.getElementById('barChart').getContext('2d'), {
            type: 'bar',
            data: {
                labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                datasets: [{
                    label: 'Doanh thu (M)',
                    data: [
                        <c:forEach items="${monthlyRevenueArray}" var="val" varStatus="st">
                            ${val}${!st.last ? ',' : ''}
                        </c:forEach>
                    ],
                    backgroundColor: '#4318ff',
                    borderRadius: 8,
                    hoverBackgroundColor: '#aff22f'
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false, 
                plugins: { 
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + context.raw + 'M';
                            }
                        }
                    }
                }, 
                scales: { 
                    y: { 
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return value + 'M'; }
                        }
                    }, 
                    x: { grid: { display: false } } 
                } 
            }
        });

        // Pie Chart for Status
        new Chart(document.getElementById('pieChart').getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Thành công', 'Chờ xử lý', 'Đã hủy'],
                datasets: [{
                    data: [${orderStats['Đã hoàn thành']}, ${orderStats['Chờ xử lý']}, ${orderStats['Đã hủy']}],
                    backgroundColor: ['#05cd99', '#ffb81c', '#ee5d50'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, maintainAspectRatio: false, cutout: '75%', plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20, font: { weight: '700' } } } } }
        });
    </script>
</body>
</html>
