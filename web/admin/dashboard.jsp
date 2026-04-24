<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - MobileShop</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); overflow-x: hidden; }

        .dashboard-container { display: flex; min-height: 100vh; }
        
        /* Layout Alignment */
        .main-content { 
            flex: 1; 
            margin-left: 260px; /* Chừa chỗ cho sidebar fixed */
            padding: 40px; 
            transition: 0.3s;
        }

        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .welcome h1 { font-size: 1.5rem; font-weight: 700; color: var(--text-main); margin-top: 4px; }
        
        .user-profile { display: flex; align-items: center; gap: 12px; background: white; padding: 6px 16px; border-radius: 50px; box-shadow: var(--shadow); }
        .avatar { width: 35px; height: 35px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; }

        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 32px; }
        .stat-card { background: var(--bg-card); padding: 24px; border-radius: 20px; box-shadow: var(--shadow); transition: 0.3s; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-label { color: var(--text-muted); font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .stat-value { font-size: 1.8rem; font-weight: 700; color: var(--text-main); }

        /* Content Grid */
        .content-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 24px; }
        .card { background: var(--bg-card); border-radius: 20px; padding: 24px; box-shadow: var(--shadow); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .card-header h3 { font-size: 1.1rem; font-weight: 700; }
        .view-all { color: var(--primary); text-decoration: none; font-size: 0.85rem; font-weight: 700; }

        .order-list, .product-list { display: flex; flex-direction: column; gap: 16px; }
        .order-item, .product-item { display: flex; align-items: center; gap: 16px; padding: 12px; border-radius: 12px; transition: 0.2s; }
        .order-item:hover, .product-item:hover { background: #f8fafc; }
        
        .item-icon, .product-img { width: 48px; height: 48px; background: #f4f7fe; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: var(--primary); }
        .item-info { flex: 1; }
        .item-name { font-weight: 700; font-size: 0.95rem; margin-bottom: 2px; }
        .item-meta { font-size: 0.8rem; color: var(--text-muted); }
        
        .status-pill { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }
        .status-success { background: #e6f9f4; color: var(--success); }
        .status-warning { background: #fff8e6; color: var(--warning); }
        .status-danger { background: #feebeb; color: var(--danger); }

        /* Table Premium Styling */
        .dashboard-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
            margin-top: -12px;
        }
        .dashboard-table th {
            color: var(--text-muted);
            text-transform: uppercase;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 10px 15px;
            text-align: left;
        }
        .dashboard-table td {
            padding: 15px;
            background: #f8fafc;
            vertical-align: middle;
        }
        .dashboard-table tr td:first-child { border-radius: 12px 0 0 12px; }
        .dashboard-table tr td:last-child { border-radius: 0 12px 12px 0; }

        /* Ranking Circles */
        .rank-circle {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 800;
            color: white;
        }
        .rank-1 { background: linear-gradient(135deg, #f59e0b, #d97706); }
        .rank-2 { background: linear-gradient(135deg, #3b82f6, #2563eb); }
        .rank-3 { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }
        .rank-default { background: #64748b; }

        /* Mini Progress Bar under product name */
        .product-progress {
            height: 3px;
            background: #e2e8f0;
            border-radius: 2px;
            margin-top: 6px;
            width: 60px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary), #8b5cf6);
        }

        /* Status Badges */
        .badge-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .status-success-badge { background: #dcfce7; color: #166534; }
        .status-pending-badge { background: #fef3c7; color: #92400e; }
        .status-canceled-badge { background: #fee2e2; color: #991b1b; }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        /* Tùy chỉnh bộ chọn thời gian */
        .header-filter {
            display: flex;
            align-items: center;
            gap: 12px;
            background: white;
            padding: 6px 12px;
            border-radius: 16px;
            box-shadow: var(--shadow);
            margin-right: 15px;
        }

        .date-input-group {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f4f7fe;
            padding: 5px 12px;
            border-radius: 10px;
            border: 1px solid var(--border);
        }

        .date-input-group input {
            border: none;
            background: transparent;
            color: var(--text-main);
            font-size: 0.85rem;
            font-weight: 600;
            outline: none;
            cursor: pointer;
        }

        .btn-refresh-dash {
            background: var(--success);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: 0.2s;
        }

        .btn-refresh-dash:hover { opacity: 0.9; transform: scale(1.02); }
        
        .time-summary {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 8px;
            font-weight: 500;
        }

        /* White Chart Card (Reverted from dark) */
        .card-light-chart {
            background: white;
            color: var(--text-main);
        }
        .card-light-chart h3 {
            color: var(--text-main);
        }

        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>
        <main class="main-content">
            <header class="header">
                <div class="welcome">
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Tổng quan hệ thống</p>
                    <h1>Chào mừng quay trở lại, ${sessionScope.acc != null ? sessionScope.acc.name : "Admin"}</h1>
                    <p class="time-summary">
                        Từ <fmt:formatDate value="${startDate}" pattern="dd/MM/yyyy"/> 
                        → <fmt:formatDate value="${endDate}" pattern="dd/MM/yyyy"/> 
                        (${diffDays} ngày)
                    </p>
                </div>
                <div class="header-actions">


                    <!-- Form lọc thời gian mới -->
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" style="display: flex; align-items: center;">
                        <div class="header-filter">
                            <div class="date-input-group">
                                <input type="date" name="startDate" value="${startDate}">
                                <span style="color: var(--text-muted);">→</span>
                                <input type="date" name="endDate" value="${endDate}">
                            </div>
                            <button type="submit" class="btn-refresh-dash">
                                <i class="fa-solid fa-arrows-rotate"></i> Làm mới
                            </button>
                        </div>
                    </form>

                    <div class="user-profile">
                        <c:set var="adminName" value="${sessionScope.acc != null ? sessionScope.acc.name : 'Admin'}" />
                        <div class="avatar">
                            <c:choose>
                                <c:when test="${not empty adminName}">
                                    ${adminName.substring(0,1).toUpperCase()}
                                </c:when>
                                <c:otherwise>A</c:otherwise>
                            </c:choose>
                        </div>
                        <span style="font-weight: 600;">${adminName}</span>
                    </div>
                </div>
            </header>



            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Sản phẩm ra mắt</div>
                    <div class="stat-value">${totalProducts}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Tổng người dùng</div>
                    <div class="stat-value">${totalUsers}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Đơn hàng đã bán</div>
                    <div class="stat-value">${soldOrders}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Doanh thu tháng</div>
                    <div class="stat-value">${monthlyRevenue}</div>
                </div>
            </div>

            <div class="content-grid">
                <!-- Bảng 1: Top 5 Bán chạy -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fa-solid fa-trophy" style="color: #f59e0b; margin-right: 8px;"></i> Top 5 sản phẩm bán chạy nhất</h3>

                    </div>
                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">#</th>
                                <th>Sản phẩm</th>
                                <th>Đã bán</th>
                                <th>Doanh thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${bestSellers}" var="p" varStatus="loop">
                                <tr>
                                    <td>
                                        <div class="rank-circle rank-${loop.index < 3 ? loop.index + 1 : 'default'}">
                                            ${loop.index + 1}
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 700;">${p.name}</div>
                                        <div class="product-progress"><div class="progress-bar-fill" style="width: ${100 - (loop.index * 15)}%;"></div></div>
                                    </td>
                                    <td style="font-weight: 700;">${p.sold != null ? p.sold : 0}</td>
                                    <td style="color: var(--primary); font-weight: 700;">${p.revenue != null ? p.revenue : '₫0'}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty bestSellers}">
                                <tr><td colspan="4" style="text-align: center; padding: 30px; color: var(--text-muted);">Chưa có dữ liệu bán hàng</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Bảng 2: Đơn hàng mới -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fa-solid fa-bolt" style="color: #3b82f6; margin-right: 8px;"></i> Đơn hàng mới phát sinh</h3>

                    </div>
                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th>Mã ĐH</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentOrders}" var="o" end="4">
                                <tr>
                                    <td style="font-weight: 700; color: var(--primary);">${o.id}</td>
                                    <td style="font-weight: 600;">${o.name}</td>
                                    <td style="font-weight: 700;">${o.price}</td>
                                    <td>
                                        <span class="badge-status ${o.status == 'Đã hoàn thành' ? 'status-success-badge' : (o.status == 'Đang giao hàng' ? 'status-pending-badge' : 'status-canceled-badge')}">
                                            ${o.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr><td colspan="4" style="text-align: center; padding: 30px; color: var(--text-muted);">Chưa có đơn hàng nào</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Hàng mới: Biểu đồ thống kê -->
            <div class="content-grid" style="margin-top: 24px; grid-template-columns: 1.5fr 1fr;">
                <!-- Biểu đồ Doanh thu theo tháng (Bar Chart) - WHITE THEME -->
                <div class="card card-light-chart">
                    <div class="card-header">
                        <h3><i class="fa-solid fa-chart-simple" style="color: var(--primary); margin-right: 8px;"></i> Doanh thu theo tháng</h3>
                    </div>
                    <div style="height: 300px; width: 100%;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                    <div style="margin-top: 15px; display: flex; justify-content: center; align-items: center; gap: 8px; font-size: 0.85rem; color: var(--text-muted);">
                        <span style="width: 12px; height: 12px; background: var(--primary); border-radius: 2px;"></span>
                        Doanh thu (triệu đồng)
                    </div>
                </div>



                <!-- Biểu đồ Trạng thái đơn hàng (Doughnut Chart) -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fa-solid fa-chart-pie" style="color: var(--warning); margin-right: 8px;"></i> Trạng thái đơn hàng</h3>
                        <span style="font-size: 0.8rem; color: var(--text-muted);">Tổng quát</span>
                    </div>
                    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 300px;">
                        <div style="width: 200px; height: 200px; margin-bottom: 20px;">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                        <div style="display: flex; gap: 15px; flex-wrap: wrap; justify-content: center;">
                            <div style="display: flex; align-items: center; gap: 6px; font-size: 0.8rem; font-weight: 600;">
                                <span style="width: 10px; height: 10px; border-radius: 2px; background: #05cd99;"></span>
                                <span>Thành công</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 6px; font-size: 0.8rem; font-weight: 600;">
                                <span style="width: 10px; height: 10px; border-radius: 2px; background: #ee5d50;"></span>
                                <span>Đã hủy</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 6px; font-size: 0.8rem; font-weight: 600;">
                                <span style="width: 10px; height: 10px; border-radius: 2px; background: #ffb81c;"></span>
                                <span>Đang giao hàng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // 1. Biểu đồ Doanh thu theo tháng (Bar Chart)
        const revCtx = document.getElementById('revenueChart').getContext('2d');
        
        const revLabels = [
            <c:forEach items="${monthlyRevenueData}" var="entry" varStatus="loop">
                '${entry.key}'${!loop.last ? ',' : ''}
            </c:forEach>
        ];
        const revData = [
            <c:forEach items="${monthlyRevenueData}" var="entry" varStatus="loop">
                ${(entry.value != null ? entry.value : 0) / 1000000.0}${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        new Chart(revCtx, {
            type: 'bar',
            data: {
                labels: revLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revData,
                    backgroundColor: '#4318ff',
                    hoverBackgroundColor: '#3311cc',
                    borderRadius: 5,
                    borderSkipped: false,
                    barThickness: 25
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1b2559',
                        titleColor: '#fff',
                        footerColor: '#fff',
                        bodyColor: '#fff',
                        padding: 12,
                        cornerRadius: 10,
                        displayColors: false,
                        callbacks: {
                            label: function(context) {
                                let val = context.parsed.y * 1000000;
                                return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val);
                            }
                        }

                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        min: 0,
                        suggestedMax: 1000,
                        grid: { 
                            color: '#f0f0f0',
                            drawBorder: false
                        },
                        ticks: {
                            stepSize: 100,
                            color: '#a3aed0',
                            font: { size: 11, weight: '600' },
                            callback: function(value) {
                                if (value >= 1000) return (value / 1000).toFixed(0) + 'B';
                                if (value === 0) return '0';
                                return value + 'M';
                            }
                        }
                    },

                    x: {
                        grid: { display: false },
                        ticks: {
                            color: '#a3aed0',
                            font: { size: 12, weight: '600' }
                        }
                    }
                }
            }
        });





        // 2. Biểu đồ Trạng thái đơn hàng (Doughnut Chart)
        const orderCtx = document.getElementById('orderStatusChart').getContext('2d');
        new Chart(orderCtx, {
            type: 'doughnut',
            data: {
                labels: ['Thành công', 'Đã hủy', 'Đang giao hàng'],
                datasets: [{
                    data: [
                        ${(not empty orderStats and not empty orderStats['Đã hoàn thành']) ? orderStats['Đã hoàn thành'] : 0},
                        ${(not empty orderStats and not empty orderStats['Đã hủy']) ? orderStats['Đã hủy'] : 0},
                        ${(not empty orderStats and not empty orderStats['Đang giao hàng']) ? orderStats['Đang giao hàng'] : 0}
                    ],
                    backgroundColor: ['#05cd99', '#ee5d50', '#ffb81c'],
                    borderWidth: 0,
                    hoverOffset: 15
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                cutout: '70%'
            }
        });
    </script>
</body>
</html>
