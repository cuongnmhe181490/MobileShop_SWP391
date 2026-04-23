<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - MobileShop Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="orders" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header">
                <div class="page-title">
                    <p class="admin-shell-eyebrow">Quản lý bán hàng</p>
                    <h1>Quản lý đơn hàng</h1>
                    <p class="admin-shell-subtitle">Theo dõi trạng thái đơn hàng và xử lý yêu cầu từ khách hàng.</p>
                </div>
                <button class="btn-primary" style="padding: 12px 24px;">
                    <i class="fas fa-file-export me-2"></i> Xuất danh sách
                </button>
            </header>

            <section class="content-card">
                <!-- Filters -->
                <div class="filter-bar mb-4" style="display: flex; gap: 16px; flex-wrap: wrap;">
                    <div style="position: relative; flex: 1; min-width: 300px;">
                        <i class="fa-solid fa-search" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                        <input type="text" class="form-input-custom" placeholder="Tìm theo tên khách hàng hoặc mã đơn..." style="padding-left: 44px;">
                    </div>
                    
                    <select class="form-input-custom" style="width: auto; min-width: 200px;">
                        <option>Tất cả trạng thái</option>
                        <option>Chờ xử lý</option>
                        <option>Đang giao</option>
                        <option>Đã hoàn thành</option>
                        <option>Đã hủy</option>
                    </select>
                    
                    <button class="btn-primary" style="padding: 12px 24px;">Lọc</button>
                    <button class="btn-cancel" style="padding: 12px 24px; text-decoration: none;">Đặt lại</button>
                </div>

                <!-- Table -->
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width: 120px;">Mã Đơn</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Ngày đặt</th>
                                <th>Trạng thái</th>
                                <th style="width: 140px; text-align: center;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty orderList}">
                                    <c:forEach items="${orderList}" var="order">
                                        <tr>
                                            <td style="font-weight: 700; color: var(--primary);">#ORD-${order.orderId}</td>
                                            <td style="font-weight: 600; color: var(--text-main);">${order.customerName}</td>
                                            <td style="font-weight: 700; color: var(--text-main);"><fmt:formatNumber value="${order.totalPrice}" type="number"/>đ</td>
                                            <td>
                                                <div style="font-size: 0.85rem; color: var(--text-muted);">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-badge" style="background: #eef2ff; color: #4338ca;">${order.status}</span>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 8px; justify-content: center;">
                                                    <button class="btn-outline" style="padding: 6px 16px; font-size: 0.8rem; border-radius: 8px;">Chi tiết</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 5rem 0; color: var(--text-muted);">
                                            <div class="mb-3"><i class="fa-solid fa-cart-shopping fa-4x" style="opacity: 0.1;"></i></div>
                                            <p class="fw-bold">Chưa có dữ liệu đơn hàng.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
