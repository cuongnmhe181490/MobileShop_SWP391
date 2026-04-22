<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - MobileShop Admin</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Admin Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
</head>
<body>

    <div class="admin-layout">
        <!-- Sidebar -->
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
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link active">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/products" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link"><i class="fa-solid fa-newspaper"></i>Blog</a></li>
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
                    <h1>Quản lý đơn hàng</h1>
                    <p>Theo dõi trạng thái đơn hàng và xử lý nhanh từ dashboard.</p>
                </div>
                <button class="btn-primary">Xuất danh sách</button>
            </header>

            <section class="content-card">
                <!-- Filters -->
                <div class="filter-bar">
                    <div style="position: relative; flex: 1; max-width: 400px;">
                        <i class="fa-solid fa-circle-user" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #cbd5e1;"></i>
                        <input type="text" class="form-input" placeholder="Tìm theo tên khách hàng" style="padding-left: 36px;">
                    </div>
                    
                    <select class="form-select">
                        <option>Tất cả trạng thái</option>
                        <option>Chờ xử lý</option>
                        <option>Đang giao</option>
                        <option>Đã hoàn thành</option>
                        <option>Đã hủy</option>
                    </select>
                    
                    <button class="btn-primary" style="background: #4e6af2;">Lọc</button>
                    <button class="btn-outline">Đặt lại</button>
                </div>

                <!-- Table -->
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty orderList}">
                                <c:forEach items="${orderList}" var="order">
                                    <tr>
                                        <td style="font-weight: 500;">${order.customerName}</td>
                                        <td><fmt:formatNumber value="${order.totalPrice}" type="number"/>đ</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><span class="status-badge status--pending">${order.status}</span></td>
                                        <td>
                                            <button class="btn-outline" style="padding: 4px 12px; font-size: 0.8rem;">Chi tiết</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 4rem; color: var(--text-muted);">
                                        <i class="fa-solid fa-cart-shopping" style="font-size: 3rem; margin-bottom: 1rem; display: block; opacity: 0.2;"></i>
                                        Chưa có dữ liệu đơn hàng.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </section>
        </main>
    </div>

</body>
</html>
