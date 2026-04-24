<%@ page import="dao.order.OrderDAO" %>
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

                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                                        <h1>Quản lý đơn hàng (${totalOrders} đơn)</h1>
                                        <p class="admin-shell-subtitle">Theo dõi trạng thái đơn hàng và xử lý yêu cầu từ
                                            khách hàng.</p>
                                    </div>
                                </header>

                                <section class="content-card">
                                    <!-- Filters -->
                                    <form class="filter-bar mb-4" action="${ctx}/admin/orders" method="get"
                                        style="display: flex; gap: 16px; flex-wrap: wrap;">
                                        <div style="position: relative; flex: 1; min-width: 300px;">
                                            <i class="fa-solid fa-search"
                                                style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                                            <input type="text" name="keyword" value="${keyword}"
                                                class="form-input-custom"
                                                placeholder="Tìm theo tên khách hàng hoặc mã đơn..."
                                                style="padding-left: 44px;">
                                        </div>

                                        <select name="status" class="form-input-custom"
                                            style="width: auto; min-width: 200px;">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="Đang giao hàng" ${statusFilter=='Đang giao hàng' ? 'selected'
                                                : '' }>Đang giao hàng</option>
                                            <option value="Đã hoàn thành" ${statusFilter=='Đã hoàn thành' ? 'selected'
                                                : '' }>Đã hoàn thành</option>
                                            <option value="Đã hủy" ${statusFilter=='Đã hủy' ? 'selected' : '' }>Đã hủy
                                            </option>
                                        </select>

                                        <button class="btn-primary" type="submit"
                                            style="padding: 12px 24px;">Lọc</button>
                                        <a href="${ctx}/admin/orders" class="btn-cancel"
                                            style="padding: 12px 24px; text-decoration: none; display: flex; align-items: center;">Đặt
                                            lại</a>
                                    </form>

                                    <!-- Table -->
                                    <div class="table-responsive">
                                        <table class="admin-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 120px;">Mã Đơn</th>
                                                    <th>Khách hàng</th>
                                                    <th>SĐT</th>
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
                                                                <td style="font-weight: 700; color: var(--primary);">
                                                                    #ORD-${order.idOrder}</td>
                                                                <td style="font-weight: 600; color: var(--text-main);">
                                                                    ${order.customerName}</td>
                                                                <td>${order.receiverPhone}</td>
                                                                <td style="font-weight: 700; color: var(--text-main);">
                                                                    <fmt:formatNumber value="${order.totalPrice}"
                                                                        type="number" />đ
                                                                </td>
                                                                <td>
                                                                    <div
                                                                        style="font-size: 0.85rem; color: var(--text-muted);">
                                                                        <fmt:formatDate value="${order.orderDate}"
                                                                            pattern="dd/MM/yyyy" />
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:set var="statusClass" value="" />
                                                                    <c:choose>
                                                                        <c:when test="${order.status == 'Pending'}">
                                                                            <c:set var="statusClass"
                                                                                value="status--pending" />
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${order.status == 'Đang giao hàng'}">
                                                                            <c:set var="statusClass"
                                                                                value="status--delivering" />
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${order.status == 'Đã hoàn thành'}">
                                                                            <c:set var="statusClass"
                                                                                value="status--completed" />
                                                                        </c:when>
                                                                        <c:when test="${order.status == 'Đã hủy'}">
                                                                            <c:set var="statusClass"
                                                                                value="status--canceled" />
                                                                        </c:when>
                                                                    </c:choose>
                                                                    <span
                                                                        class="status-badge ${statusClass}">${order.status}</span>
                                                                </td>
                                                                <td>
                                                                    <div class="action-btns">
                                                                        <a href="${ctx}/admin/orders/detail?id=${order.idOrder}"
                                                                            class="btn-icon btn-edit"
                                                                            title="Chi tiết"><i
                                                                                class="fa-solid fa-eye"></i></a>
                                                                        <c:if
                                                                            test="${order.status == 'Đang giao hàng' || order.status == 'Pending'}">
                                                                            <form action="${ctx}/admin/orders"
                                                                                method="post" style="display:inline;"
                                                                                onsubmit="return confirm('Xác nhận hoàn thành đơn hàng này?')">
                                                                                <input type="hidden" name="id"
                                                                                    value="${order.idOrder}">
                                                                                <input type="hidden" name="action"
                                                                                    value="complete">
                                                                                <button type="submit"
                                                                                    class="btn-icon btn-unlock"
                                                                                    title="Hoàn thành"><i
                                                                                        class="fa-solid fa-check"></i></button>
                                                                            </form>
                                                                            <form action="${ctx}/admin/orders"
                                                                                method="post" style="display:inline;"
                                                                                onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                                                                <input type="hidden" name="id"
                                                                                    value="${order.idOrder}">
                                                                                <input type="hidden" name="action"
                                                                                    value="cancel">
                                                                                <button type="submit"
                                                                                    class="btn-icon btn-lock"
                                                                                    title="Hủy đơn"><i
                                                                                        class="fa-solid fa-xmark"></i></button>
                                                                            </form>
                                                                        </c:if>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="7"
                                                                style="text-align: center; padding: 5rem 0; color: var(--text-muted);">
                                                                <div class="mb-3"><i
                                                                        class="fa-solid fa-cart-shopping fa-4x"
                                                                        style="opacity: 0.1;"></i></div>
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