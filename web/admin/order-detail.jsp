<%@ page import="dao.order.OrderDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{--bg-body:#f4f7fe;--bg-sidebar:#1e293b;--primary:#4318ff;--text-main:#1b2559;--text-muted:#a3aed0;--border:#e9edf7;--sidebar-active:#aff22f;--shadow:14px 17px 40px 4px rgba(112,144,176,.08)}
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Inter',sans-serif}body{background:var(--bg-body);color:var(--text-main)}.admin-layout{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-sidebar);padding:24px 0;display:flex;flex-direction:column;position:fixed;inset:0 auto 0 0;color:#fff;overflow-y:auto}.brand{padding:0 24px;margin-bottom:40px;text-decoration:none;color:#fff;display:block}.brand h2{font-size:1.5rem}.brand p{font-size:.75rem;color:#94a3b8;margin-top:4px}.nav-section{margin-bottom:32px}.nav-label{font-size:.7rem;text-transform:uppercase;color:#64748b;letter-spacing:1px;margin-bottom:12px;display:block;padding:0 24px}.sidebar-menu{list-style:none}.menu-link{display:flex;align-items:center;gap:12px;padding:12px 24px;color:#94a3b8;text-decoration:none;font-weight:500;font-size:.95rem;border-left:4px solid transparent}.menu-link i{width:20px;text-align:center}.menu-link:hover{background:rgba(255,255,255,.05);color:#fff}.menu-link.active{background:rgba(175,242,47,.1);color:var(--sidebar-active);border-left-color:var(--sidebar-active);font-weight:600}
        .main-content{flex:1;margin-left:260px;padding:40px}.page-header{display:flex;justify-content:space-between;align-items:flex-start;gap:20px;margin-bottom:32px}.page-title h1{font-size:1.8rem;font-weight:700;margin-bottom:4px}.page-title p{color:var(--text-muted);font-size:.9rem}.content-card{background:#fff;border-radius:20px;padding:24px;box-shadow:var(--shadow);margin-bottom:24px}.btn-outline{background:#fff;border:1px solid var(--border);padding:10px 16px;border-radius:10px;font-weight:700;text-decoration:none;color:var(--text-main);display:inline-flex;align-items:center;justify-content:center;min-height:42px}.detail-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}.detail-item{border:1px solid var(--border);border-radius:16px;padding:14px 16px}.detail-item span{display:block;color:var(--text-muted);font-size:.78rem;text-transform:uppercase;font-weight:700;margin-bottom:6px}.admin-table{width:100%;border-collapse:collapse}.admin-table th{text-align:left;padding:12px;color:var(--text-muted);font-size:.75rem;text-transform:uppercase;border-bottom:1px solid var(--border)}.admin-table td{padding:16px 12px;border-bottom:1px solid var(--border);vertical-align:middle}.admin-table img{width:56px;height:56px;object-fit:contain;border:1px solid var(--border);border-radius:12px;background:#fff}.status-badge{padding:6px 12px;border-radius:20px;font-size:.8rem;font-weight:700;background:#eef2ff;color:var(--primary);white-space:nowrap}.total-row{display:flex;justify-content:flex-end;align-items:center;gap:20px;font-size:1.1rem;font-weight:700;margin-top:18px}
    </style>
</head>
<body>
<div class="admin-layout">
    <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>
    <main class="main-content">
        <c:choose>
            <c:when test="${not empty order}">
                <header class="page-header"><div class="page-title"><h1>Chi tiết đơn #ORD-${order.idOrder}</h1><p>Thông tin người nhận, trạng thái và danh sách sản phẩm trong đơn.</p></div><a class="btn-outline" href="${pageContext.request.contextPath}/admin/orders">Quay lại</a></header>
                <section class="content-card"><div class="detail-grid">
                    <div class="detail-item"><span>Mã đơn</span><strong>#ORD-${order.idOrder}</strong></div>
                    <div class="detail-item"><span>Trạng thái</span><strong><span class="status-badge">${order.status}</span></strong></div>
                    <div class="detail-item"><span>Khách hàng</span><strong>${order.customerName}</strong></div>
                    <div class="detail-item"><span>SĐT</span><strong>${order.receiverPhone}</strong></div>
                    <div class="detail-item"><span>Địa chỉ</span><strong>${order.receiverAddress}</strong></div>
                    <div class="detail-item"><span>Ngày đặt</span><strong><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></strong></div>
                    <div class="detail-item"><span>Tổng tiền</span><strong><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0" /> đ</strong></div>
                </div></section>
                <section class="content-card"><table class="admin-table"><thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr></thead><tbody>
                    <c:forEach items="${orderDetails}" var="item"><tr><td><div style="display:flex;gap:12px;align-items:center"><img src="${item.imagePath}" alt="${item.productName}"><span>${item.productName}</span></div></td><td><fmt:formatNumber value="${item.unitPrice}" type="number" maxFractionDigits="0" /> đ</td><td>${item.quantity}</td><td><fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0" /> đ</td></tr></c:forEach>
                </tbody></table><div class="total-row"><span>Tổng thanh toán</span><span><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0" /> đ</span></div></section>
            </c:when>
            <c:otherwise><header class="page-header"><div class="page-title"><h1>Không tìm thấy đơn hàng</h1><p>Đơn hàng không tồn tại hoặc đã bị xóa.</p></div><a class="btn-outline" href="${pageContext.request.contextPath}/admin/orders">Quay lại</a></header></c:otherwise>
        </c:choose>
    </main>
</div>
</body>
</html>
