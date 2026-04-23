<%@ page import="dao.order.OrderDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (request.getAttribute("orderList") == null) {
        final int pageSize = 8;
        OrderDAO orderDao = new OrderDAO();
        String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword").trim();
        String status = request.getParameter("status") == null ? "" : request.getParameter("status").trim();
        int currentPage = 1;
        try { currentPage = Math.max(1, Integer.parseInt(request.getParameter("page"))); } catch (Exception ignored) {}
        int totalOrders = orderDao.countAdminOrders(keyword, status);
        int totalPages = Math.max(1, (int) Math.ceil(totalOrders / (double) pageSize));
        if (currentPage > totalPages) currentPage = totalPages;
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("orderList", orderDao.getAdminOrders(keyword, status, currentPage, pageSize));
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{--bg-body:#f4f7fe;--bg-sidebar:#1e293b;--primary:#4318ff;--text-main:#1b2559;--text-muted:#a3aed0;--border:#e9edf7;--sidebar-active:#aff22f;--shadow:14px 17px 40px 4px rgba(112,144,176,.08)}
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Inter',sans-serif}body{background:var(--bg-body);color:var(--text-main)}.admin-layout{display:flex;min-height:100vh}
        .sidebar{width:260px;background:var(--bg-sidebar);padding:24px 0;display:flex;flex-direction:column;position:fixed;inset:0 auto 0 0;z-index:100;color:#fff;overflow-y:auto}.brand{padding:0 24px;margin-bottom:40px;text-decoration:none;color:#fff;display:block}.brand h2{font-size:1.5rem;margin:0}.brand p{font-size:.75rem;color:#94a3b8;margin-top:4px}.nav-section{margin-bottom:32px}.nav-label{font-size:.7rem;text-transform:uppercase;color:#64748b;letter-spacing:1px;margin-bottom:12px;display:block;padding:0 24px}.sidebar-menu{list-style:none}.menu-link{display:flex;align-items:center;gap:12px;padding:12px 24px;color:#94a3b8;text-decoration:none;font-weight:500;font-size:.95rem;border-left:4px solid transparent;transition:.3s}.menu-link i{width:20px;text-align:center}.menu-link:hover{background:rgba(255,255,255,.05);color:#fff}.menu-link.active{background:rgba(175,242,47,.1);color:var(--sidebar-active);border-left-color:var(--sidebar-active);font-weight:600}
        .main-content{flex:1;margin-left:260px;padding:40px}.page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px}.page-title h1{font-size:1.8rem;font-weight:700;margin-bottom:4px}.page-title p{color:var(--text-muted);font-size:.9rem}.content-card{background:#fff;border-radius:20px;padding:24px;box-shadow:var(--shadow);margin-bottom:24px}.filter-bar{display:flex;gap:16px;margin-bottom:24px;flex-wrap:wrap;align-items:center}.form-input,.form-select{padding:10px 16px;border:1px solid var(--border);border-radius:10px;font-size:.9rem;outline:none;min-height:42px}.search-wrap{position:relative;width:320px}.search-wrap i{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:#cbd5e1}.search-wrap .form-input{width:100%;padding-left:36px}.btn-primary,.btn-outline{min-height:42px;padding:10px 16px;border-radius:10px;font-weight:700;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;justify-content:center}.btn-primary{background:var(--primary);color:#fff;border:0}.btn-outline{background:#fff;border:1px solid var(--border);color:var(--text-main)}
        .admin-table{width:100%;border-collapse:collapse}.admin-table th{text-align:left;padding:12px;color:var(--text-muted);font-size:.75rem;text-transform:uppercase;border-bottom:1px solid var(--border)}.admin-table td{padding:16px 12px;border-bottom:1px solid var(--border);vertical-align:middle}.status-badge{padding:5px 12px;border-radius:20px;font-size:.75rem;font-weight:700;white-space:nowrap}.is-delivering{background:#fff7ed;color:#c2410c}.is-completed{background:#ecfdf5;color:#047857}.is-canceled{background:#fef2f2;color:#dc2626}.action-row{display:flex;gap:8px;align-items:center;flex-wrap:wrap}.action-row form{margin:0}.admin-pagination{display:flex;align-items:center;justify-content:center;gap:8px;margin-top:24px}.page-link{min-width:40px;min-height:40px;padding:0 12px;border-radius:12px;border:1px solid var(--border);color:var(--text-main);text-decoration:none;display:inline-flex;align-items:center;justify-content:center;font-weight:700}.page-link.active{background:var(--primary);color:#fff;border-color:var(--primary)}.page-link.disabled{opacity:.45;pointer-events:none}
    </style>
</head>
<body>
<div class="admin-layout">
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand"><h2>MobileShop</h2><p>Quản trị hệ thống</p></a>
        <div class="nav-section"><span class="nav-label">Tổng quan</span><ul class="sidebar-menu"><li><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li></ul></div>
        <div class="nav-section"><span class="nav-label">Quản lý bán hàng</span><ul class="sidebar-menu"><li><a href="${pageContext.request.contextPath}/admin/orders" class="menu-link active"><i class="fa-solid fa-receipt"></i>Đơn hàng</a></li><li><a href="${pageContext.request.contextPath}/admin/products" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li><li><a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li></ul></div>
        <div class="nav-section"><span class="nav-label">Tương tác & nội dung</span><ul class="sidebar-menu"><li><a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link"><i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn</a></li><li><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li><li><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link"><i class="fa-solid fa-newspaper"></i>Blog / Tin tức</a></li></ul></div>
        <div class="nav-section"><span class="nav-label">Cấu hình giao diện</span><ul class="sidebar-menu"><li><a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link"><i class="fa-solid fa-house-chimney-window"></i>Trang chủ</a></li></ul></div>
        <div style="margin-top:auto;padding-bottom:24px"><ul class="sidebar-menu"><li><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-globe"></i>Xem Website</a></li><li><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-power-off"></i>Đăng xuất</a></li></ul></div>
    </aside>
    <main class="main-content">
        <header class="page-header"><div class="page-title"><h1>Quản lý đơn hàng</h1><p>Theo dõi đơn hàng mới nhất, hủy đơn hoặc xác nhận hoàn thành.</p></div></header>
        <section class="content-card">
            <form class="filter-bar" action="${pageContext.request.contextPath}/admin/orders" method="get">
                <div class="search-wrap"><i class="fa-solid fa-magnifying-glass"></i><input type="text" name="keyword" class="form-input" value="${keyword}" placeholder="Mã đơn / khách hàng / SĐT"></div>
                <select name="status" class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Đang giao hàng" ${statusFilter == 'Đang giao hàng' ? 'selected' : ''}>Đang giao hàng</option>
                    <option value="Đã hoàn thành" ${statusFilter == 'Đã hoàn thành' ? 'selected' : ''}>Đã hoàn thành</option>
                    <option value="Đã hủy" ${statusFilter == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                </select>
                <button class="btn-primary" type="submit">Lọc</button><a class="btn-outline" href="${pageContext.request.contextPath}/admin/orders">Đặt lại</a>
            </form>
            <table class="admin-table">
                <thead><tr><th>Mã đơn</th><th>Khách hàng</th><th>SĐT</th><th>Số SP</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày tạo</th><th>Hành động</th></tr></thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty orderList}">
                        <c:forEach items="${orderList}" var="order">
                            <c:set var="statusClass" value="is-delivering" /><c:if test="${order.status == 'Đã hoàn thành'}"><c:set var="statusClass" value="is-completed" /></c:if><c:if test="${order.status == 'Đã hủy'}"><c:set var="statusClass" value="is-canceled" /></c:if>
                            <tr>
                                <td>#ORD-${order.idOrder}</td><td style="font-weight:600">${order.customerName}</td><td>${order.receiverPhone}</td><td>${order.itemCount}</td><td><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0" /> đ</td><td><span class="status-badge ${statusClass}">${order.status}</span></td><td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></td>
                                <td><div class="action-row"><a class="btn-outline" href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.idOrder}">Xem</a><c:if test="${order.status == 'Đang giao hàng'}"><form action="${pageContext.request.contextPath}/admin/orders" method="post"><input type="hidden" name="id" value="${order.idOrder}"><input type="hidden" name="action" value="cancel"><button class="btn-outline" type="submit">Hủy đơn</button></form><form action="${pageContext.request.contextPath}/admin/orders" method="post"><input type="hidden" name="id" value="${order.idOrder}"><input type="hidden" name="action" value="complete"><button class="btn-primary" type="submit">Xác nhận hoàn thành</button></form></c:if></div></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><tr><td colspan="8" style="text-align:center;padding:4rem;color:var(--text-muted)">Chưa có dữ liệu đơn hàng.</td></tr></c:otherwise>
                </c:choose>
                </tbody>
            </table>
            <div class="admin-pagination">
                <c:url var="prevUrl" value="/admin/orders"><c:param name="page" value="${currentPage - 1}" /><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if><c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}" /></c:if></c:url>
                <a class="page-link ${currentPage <= 1 ? 'disabled' : ''}" href="${prevUrl}">Trước</a>
                <c:forEach begin="1" end="${totalPages}" var="p"><c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}"><c:url var="pageUrl" value="/admin/orders"><c:param name="page" value="${p}" /><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if><c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}" /></c:if></c:url><a class="page-link ${p == currentPage ? 'active' : ''}" href="${pageUrl}">${p}</a></c:if></c:forEach>
                <c:url var="nextUrl" value="/admin/orders"><c:param name="page" value="${currentPage + 1}" /><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if><c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}" /></c:if></c:url>
                <a class="page-link ${currentPage >= totalPages ? 'disabled' : ''}" href="${nextUrl}">Sau</a>
            </div>
        </section>
    </main>
</div>
</body>
</html>
