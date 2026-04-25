<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    <style>
        .order-filter-bar {
            display: grid;
            grid-template-columns: minmax(260px, 1fr) minmax(160px, 190px) 76px 96px;
            gap: 14px;
            align-items: center;
            width: 100%;
            margin-bottom: 24px;
        }

        .order-search-wrap,
        .order-filter-select {
            min-width: 0;
            width: 100%;
        }

        .order-search-wrap i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #cbd5e1;
            font-size: 16px;
            pointer-events: none;
        }

        .order-search-input,
        .order-filter-select select {
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .order-search-input {
            padding-left: 40px;
        }

        .order-status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.35rem 0.85rem;
            border-radius: 999px;
            font-size: 0.82rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .order-status-badge--delivering {
            background: #fef3c7;
            color: #b45309;
        }

        .order-status-badge--completed {
            background: #dcfce7;
            color: #15803d;
        }

        .order-status-badge--cancelled {
            background: #fee2e2;
            color: #b91c1c;
        }

        .order-action-group {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: nowrap;
            justify-content: flex-start;
            min-width: 0;
        }

        .order-action-group form {
            margin: 0;
            display: inline-flex;
            min-width: 0;
        }

        .order-action-btn {
            height: 34px;
            padding: 0 10px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            white-space: nowrap;
            box-sizing: border-box;
            text-decoration: none;
            transition: background 0.15s, border-color 0.15s;
        }

        .order-action-btn--view {
            min-width: 82px;
        }

        .order-action-btn--complete {
            min-width: 112px;
        }

        .order-action-btn--cancel {
            min-width: 68px;
        }

        .product-action-btn--danger {
            color: #ef4444;
            border-color: #fecdd3;
        }

        .product-action-btn--danger:hover {
            background: #fff1f2;
        }

        .order-empty-state {
            text-align: center;
            padding: 56px 24px;
            color: var(--text-muted);
        }

        .order-empty-state i {
            font-size: 3rem;
            opacity: 0.18;
            margin-bottom: 12px;
            display: block;
        }

        .admin-table td {
            white-space: nowrap;
        }
        .admin-table td.wrap-ok {
            white-space: normal;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- ===== SIDEBAR (đồng bộ từ dashboard.jsp) ===== -->
        <aside class="sidebar">
            <a href="${ctx}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin/dashboard" class="menu-link">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin/orders" class="menu-link active">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/products" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/accounts" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/blog" class="menu-link">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin-home-config.jsp" class="menu-link">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <header class="header">
                <div class="welcome">
                    <p class="admin-shell-eyebrow">QUẢN LÝ ĐƠN HÀNG</p>
                    <h1>Quản lý đơn hàng</h1>
                    <p class="admin-shell-subtitle">Theo dõi đơn mới nhất, lọc theo khách hàng hoặc trạng thái và cập nhật xử lý ngay tại đây.</p>
                </div>
            </header>

            <section class="content-card">
                <form class="order-filter-bar" action="${ctx}/admin/orders" method="get">
                    <div class="order-search-wrap">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" class="form-input order-search-input" name="keyword" value="${keyword}" placeholder="Tìm theo mã đơn, tên khách hoặc SĐT">
                    </div>

                    <select class="form-select order-filter-select" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Đang giao hàng" ${statusFilter == 'Đang giao hàng' ? 'selected' : ''}>Đang giao hàng</option>
                        <option value="Đã hoàn thành" ${statusFilter == 'Đã hoàn thành' ? 'selected' : ''}>Đã hoàn thành</option>
                        <option value="Đã hủy" ${statusFilter == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                    </select>

                    <button type="submit" class="btn-primary">Lọc</button>
                    <a href="${ctx}/admin/orders" class="btn-outline" style="text-decoration:none;">Đặt lại</a>
                </form>

                <c:choose>
                    <c:when test="${not empty orderList}">
                        <div class="table-wrap" style="width: 100%; overflow-x: auto;">
                        <table class="admin-table order-admin-table" style="table-layout: fixed; width: 100%;">
                            <thead>
                                <tr>
                                    <th style="width: 90px;">Mã đơn</th>
                                    <th style="width: 150px;">Khách hàng</th>
                                    <th style="width: 60px;">SL</th>
                                    <th style="width: 120px;">Tổng tiền</th>
                                    <th style="width: 100px;">Ngày đặt</th>
                                    <th style="width: 130px;">Trạng thái</th>
                                    <th style="width: 280px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderList}" var="order">
                                    <c:url var="detailUrl" value="/admin/orders/detail">
                                        <c:param name="id" value="${order.idOrder}" />
                                    </c:url>
                                    <tr>
                                        <td>#ORD-${order.idOrder}</td>
                                        <td class="wrap-ok">
                                            <div style="font-weight:600">${order.customerName}</div>
                                            <div style="color:var(--text-muted);font-size:0.82rem">${order.receiverPhone}</div>
                                        </td>
                                        <td>${order.itemCount}</td>
                                        <td><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0" /> đ</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></td>
                                        <td>
                                            <span class="order-status-badge ${order.status == 'Đang giao hàng' ? 'order-status-badge--delivering' : (order.status == 'Đã hoàn thành' ? 'order-status-badge--completed' : 'order-status-badge--cancelled')}">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="order-action-group">
                                                <a class="btn-outline order-action-btn order-action-btn--view" href="${detailUrl}" title="Xem chi tiết">Xem</a>
                                                <c:if test="${order.status == 'Đang giao hàng'}">
                                                    <form action="${ctx}/admin/orders" method="post">
                                                        <input type="hidden" name="id" value="${order.idOrder}">
                                                        <input type="hidden" name="action" value="complete">
                                                        <button type="submit" class="btn-outline order-action-btn order-action-btn--complete" title="Xác nhận hoàn thành">Hoàn thành</button>
                                                    </form>
                                                    <form action="${ctx}/admin/orders" method="post">
                                                        <input type="hidden" name="id" value="${order.idOrder}">
                                                        <input type="hidden" name="action" value="cancel">
                                                        <button type="submit" class="btn-outline order-action-btn product-action-btn--danger order-action-btn--cancel" onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">Hủy đơn</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="product-pagination">
                                <c:url var="basePageUrl" value="/admin/orders">
                                    <c:param name="keyword" value="${keyword}" />
                                    <c:param name="status" value="${statusFilter}" />
                                </c:url>
                                <c:if test="${currentPage > 1}">
                                    <a href="${basePageUrl}&page=1" class="product-page-link">Đầu</a>
                                    <a href="${basePageUrl}&page=${currentPage - 1}" class="product-page-link">Trước</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="pageIndex">
                                    <a href="${basePageUrl}&page=${pageIndex}" class="product-page-link ${pageIndex == currentPage ? 'is-active' : ''}">${pageIndex}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="${basePageUrl}&page=${currentPage + 1}" class="product-page-link">Sau</a>
                                    <a href="${basePageUrl}&page=${totalPages}" class="product-page-link">Cuối</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="order-empty-state">
                            <i class="fa-solid fa-cart-shopping"></i>
                            <h3>Chưa có dữ liệu đơn hàng</h3>
                            <p>Không có đơn hàng nào khớp với bộ lọc hiện tại.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </div>
</body>
</html>
