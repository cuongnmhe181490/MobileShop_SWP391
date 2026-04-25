<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Lịch sử đơn hàng" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${ctx}/css/style.css" type="text/css">
    <link rel="stylesheet" href="${ctx}/css/mobileshop.css" type="text/css">
    <style>
        .order-history-card{background:#fff;border:1px solid var(--line);border-radius:28px;padding:24px;margin-bottom:18px;box-shadow:0 24px 60px rgba(22,33,63,.04)}.order-history-head{display:flex;justify-content:space-between;gap:16px;align-items:center;margin-bottom:14px}.order-history-meta{color:var(--muted);font-size:14px}.order-history-actions{display:flex;gap:10px;align-items:center;flex-wrap:wrap}.order-status-chip,.order-toggle-button{min-height:44px;min-width:140px;padding:0 18px;border-radius:999px;display:inline-flex;align-items:center;justify-content:center;font-weight:800;border:1px solid transparent;line-height:1}.order-status-chip{cursor:default}.order-status-chip.is-delivering{background:#fff7ed;color:#c2410c;border-color:#fed7aa}.order-status-chip.is-completed{background:#ecfdf5;color:#047857;border-color:#a7f3d0}.order-status-chip.is-canceled{background:#fef2f2;color:#dc2626;border-color:#fecaca}.order-toggle-button{background:#14264b;color:#fff;cursor:pointer}.order-detail-panel{display:none;margin-top:18px;border-top:1px solid var(--line);padding-top:18px}.order-detail-panel.is-open{display:block}.order-detail-table{width:100%;border-collapse:collapse;margin-top:16px}.order-detail-table th,.order-detail-table td{padding:12px;border-bottom:1px solid var(--line);text-align:left}.order-detail-table img{width:54px;height:54px;object-fit:contain;border:1px solid var(--line);border-radius:12px;background:#fff}.order-receiver-box{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;margin-top:12px}.order-receiver-box div{background:#f8fbff;border:1px solid var(--line);border-radius:18px;padding:12px 14px}.order-receiver-box span{color:var(--muted);display:block;font-size:12px;font-weight:800;text-transform:uppercase;margin-bottom:4px}.order-pagination{display:flex;justify-content:center;align-items:center;gap:8px;margin-top:26px}.order-page-link{min-width:42px;min-height:42px;padding:0 14px;border-radius:14px;border:1px solid var(--line);color:#14264b;text-decoration:none;display:inline-flex;align-items:center;justify-content:center;font-weight:800;background:#fff}.order-page-link.active{background:#14264b;color:#fff;border-color:#14264b}.order-page-link.disabled{opacity:.45;pointer-events:none}@media(max-width:768px){.order-history-head,.summary-row{flex-direction:column;align-items:flex-start}.order-receiver-box{grid-template-columns:1fr}}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>
<main class="page-section">
    <div class="mobile-shell">
        <div class="cart-title"><span class="section-eyebrow">Tài khoản</span><h1>Lịch sử đơn hàng</h1><p>Theo dõi các đơn hàng đã đặt bằng tài khoản hiện tại.</p></div>
        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach items="${orders}" var="order">
                    <c:set var="statusClass" value="is-delivering" /><c:if test="${order.status == 'Đã hoàn thành'}"><c:set var="statusClass" value="is-completed" /></c:if><c:if test="${order.status == 'Đã hủy'}"><c:set var="statusClass" value="is-canceled" /></c:if>
                    <section class="order-history-card">
                        <div class="order-history-head">
                            <div><h2 style="margin:0 0 6px">#ORD-${order.idOrder}</h2><div class="order-history-meta">Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /> · ${order.itemCount} sản phẩm</div></div>
                            <div class="order-history-actions"><button type="button" class="order-status-chip ${statusClass}" disabled>${order.status}</button><button type="button" class="order-toggle-button" data-toggle-order="${order.idOrder}">Xem chi tiết</button></div>
                        </div>
                        <div class="summary-row" style="border:0;padding:0">
                            <span>Người nhận: ${order.receiverName} · ${order.receiverPhone}</span>
                            <strong>Tổng tiền: <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0" /> đ</strong>
                        </div>
                        <div id="order-detail-${order.idOrder}" class="order-detail-panel">
                            <div class="order-receiver-box"><div><span>Người nhận</span><strong>${order.receiverName}</strong></div><div><span>Số điện thoại</span><strong>${order.receiverPhone}</strong></div><div><span>Địa chỉ</span><strong>${order.receiverAddress}</strong></div></div>
                            <table class="order-detail-table"><thead><tr><th>Sản phẩm</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr></thead><tbody>
                                <c:forEach items="${detailsByOrder[order.idOrder]}" var="item"><tr><td><div style="display:flex;gap:12px;align-items:center"><img src="${item.imagePath}" alt="${item.productName}"><span>${item.productName}</span></div></td><td><fmt:formatNumber value="${item.unitPrice}" type="number" maxFractionDigits="0" /> đ</td><td>${item.quantity}</td><td><fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0" /> đ</td></tr></c:forEach>
                            </tbody></table>
                            <div class="summary-row"><span>Tổng tiền đơn hàng</span><strong><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0" /> đ</strong></div>
                        </div>
                    </section>
                </c:forEach>
                <div class="order-pagination">
                    <c:url var="prevUrl" value="/my-orders"><c:param name="page" value="${currentPage - 1}" /></c:url><a class="order-page-link ${currentPage <= 1 ? 'disabled' : ''}" href="${prevUrl}">Trước</a>
                    <c:forEach begin="1" end="${totalPages}" var="p"><c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}"><c:url var="pageUrl" value="/my-orders"><c:param name="page" value="${p}" /></c:url><a class="order-page-link ${p == currentPage ? 'active' : ''}" href="${pageUrl}">${p}</a></c:if></c:forEach>
                    <c:url var="nextUrl" value="/my-orders"><c:param name="page" value="${currentPage + 1}" /></c:url><a class="order-page-link ${currentPage >= totalPages ? 'disabled' : ''}" href="${nextUrl}">Sau</a>
                </div>
            </c:when>
            <c:otherwise><section class="order-history-card" style="text-align:center;padding:48px"><h2>Chưa có đơn hàng</h2><p class="order-history-meta">Bạn chưa đặt đơn hàng nào bằng tài khoản này.</p><a class="pill-link pill-link--primary" href="${ctx}/product">Mua sắm ngay</a></section></c:otherwise>
        </c:choose>
    </div>
</main>
<%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
<script>
    document.querySelectorAll('[data-toggle-order]').forEach(function(button){button.addEventListener('click',function(){var panel=document.getElementById('order-detail-'+button.dataset.toggleOrder);if(!panel)return;var opened=panel.classList.toggle('is-open');button.textContent=opened?'Ẩn chi tiết':'Xem chi tiết';});});
</script>
</body>
</html>
