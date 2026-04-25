<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - MobileShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
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
                        <a href="${ctx}/admin/orders" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/products" class="menu-link active">
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
                    <p class="admin-shell-eyebrow">QUẢN LÝ SẢN PHẨM</p>
                    <h1>Quản lý sản phẩm</h1>
                    <p class="admin-shell-subtitle">Quản trị danh sách sản phẩm và thao tác nhanh trong đúng shell dashboard hiện tại.</p>
                </div>
                <div class="header-actions">
                    <a href="${ctx}/admin/products?service=addProduct" class="btn-primary" style="text-decoration: none;">Thêm sản phẩm</a>
                    <div class="user-profile">
                        <div class="avatar">${sessionScope.acc != null ? sessionScope.acc.name.substring(0,1).toUpperCase() : "A"}</div>
                        <span style="font-weight: 600;">${sessionScope.acc != null ? sessionScope.acc.name : "Admin"}</span>
                    </div>
                </div>
            </header>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="admin-flash admin-flash--success" role="alert">
                    <i class="fa-solid fa-check-circle"></i>
                    <span>${sessionScope.successMessage}</span>
                    <c:remove var="successMessage" scope="session"/>
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="admin-flash admin-flash--danger" role="alert">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>${sessionScope.errorMessage}</span>
                    <c:remove var="errorMessage" scope="session"/>
                </div>
            </c:if>

            <c:if test="${not empty productDataError}">
                <div class="admin-flash admin-flash--danger" role="alert">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>${productDataError}</span>
                </div>
            </c:if>

            <section class="content-card product-content-card">
                <form class="filter-bar product-filter-bar" action="${ctx}/admin/products" method="GET">
                    <input type="hidden" name="service" value="listAll">
                    <div class="product-search-wrap">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" class="form-input product-search-input" name="keyword" value="${keyword}" placeholder="Tìm theo tên sản phẩm">
                    </div>

                    <select class="form-select product-filter-select" name="supplier">
                        <option value="">Tất cả supplier</option>
                        <c:forEach items="${supplierIds}" var="supplierId">
                            <option value="${supplierId}" ${supplierFilter == supplierId ? 'selected' : ''}>${supplierId}</option>
                        </c:forEach>
                    </select>

                    <select class="form-select product-filter-select" name="sort">
                        <option value="">Sắp xếp mặc định</option>
                        <option value="priceAsc" ${sortBy == 'priceAsc' ? 'selected' : ''}>Giá tăng dần</option>
                        <option value="priceDesc" ${sortBy == 'priceDesc' ? 'selected' : ''}>Giá giảm dần</option>
                        <option value="quantityAsc" ${sortBy == 'quantityAsc' ? 'selected' : ''}>Số lượng tăng dần</option>
                        <option value="quantityDesc" ${sortBy == 'quantityDesc' ? 'selected' : ''}>Số lượng giảm dần</option>
                    </select>

                    <button type="submit" class="btn-primary">Lọc</button>
                    <a href="${ctx}/admin/products" class="btn-outline" style="text-decoration: none;">Đặt lại</a>
                </form>

                <c:choose>
                    <c:when test="${not empty productList}">
                        <div class="table-wrap" style="width: 100%; overflow-x: auto;">
                        <table class="admin-table product-admin-table" style="table-layout: fixed; width: 100%;">
                            <thead>
                                <tr>
                                    <th style="width: 68px;">Ảnh</th>
                                    <th style="width: 210px;">Tên sản phẩm</th>
                                    <th style="width: 110px;">Giá</th>
                                    <th style="width: 58px;">SL</th>
                                    <th style="width: 108px;">Ngày ra mắt</th>
                                    <th style="width: 115px;">NCC</th>
                                    <th style="width: 220px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${productList}" var="product">
                                    <c:set var="resolvedImage" value="${product.imagePath}" />
                                    <c:if test="${not empty resolvedImage and fn:startsWith(resolvedImage, '/uploads/')}">
                                        <c:set var="resolvedImage" value="${ctx}${resolvedImage}" />
                                    </c:if>
                                    <tr>
                                        <td>
                                            <div class="product-thumb-wrap" style="width:56px;height:56px;border-radius:12px;">
                                                <img
                                                    src="${not empty resolvedImage ? resolvedImage : ctx.concat('/img/categories/cat-1.jpg')}"
                                                    class="product-thumb"
                                                    alt="${product.productName}"
                                                    onerror="this.onerror=null;this.src='${ctx}/img/categories/cat-1.jpg';">
                                            </div>
                                        </td>
                                        <td style="white-space:normal;">
                                            <div class="product-name-text">${product.productName}</div>
                                        </td>
                                        <td style="white-space:nowrap;"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                                        <td>${product.quantity}</td>
                                        <td style="white-space:nowrap;">${product.releaseDate}</td>
                                        <td>${product.idSupplier}</td>
                                        <td>
                                            <div class="product-action-group">
                                                <a href="${ctx}/admin/products?service=viewProduct&id=${product.idProduct}" class="btn-outline product-action-btn">Xem</a>
                                                <a href="${ctx}/admin/products?service=editProduct&id=${product.idProduct}" class="btn-outline product-action-btn">Sửa</a>
                                                <a href="${ctx}/admin/products?service=deleteProduct&id=${product.idProduct}" class="btn-outline product-action-btn product-action-btn--danger" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">Xóa</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="product-pagination">
                                <c:url var="basePageUrl" value="/admin/products">
                                    <c:param name="keyword" value="${keyword}" />
                                    <c:param name="supplier" value="${supplierFilter}" />
                                    <c:param name="sort" value="${sortBy}" />
                                </c:url>

                                <c:if test="${currentPage > 1}">
                                    <a href="${basePageUrl}&page=1" class="product-page-link">Đầu</a>
                                    <a href="${basePageUrl}&page=${prevPage}" class="product-page-link">Trước</a>
                                </c:if>

                                <c:if test="${showFirstPage}">
                                    <a href="${basePageUrl}&page=1" class="product-page-link">1</a>
                                </c:if>
                                <c:if test="${showLeadingEllipsis}">
                                    <span class="product-page-ellipsis">...</span>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="pageIndex">
                                    <a href="${basePageUrl}&page=${pageIndex}" class="product-page-link ${pageIndex == currentPage ? 'is-active' : ''}">${pageIndex}</a>
                                </c:forEach>

                                <c:if test="${showTrailingEllipsis}">
                                    <span class="product-page-ellipsis">...</span>
                                </c:if>
                                <c:if test="${showLastPage}">
                                    <a href="${basePageUrl}&page=${totalPages}" class="product-page-link">${totalPages}</a>
                                </c:if>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="${basePageUrl}&page=${nextPage}" class="product-page-link">Sau</a>
                                    <a href="${basePageUrl}&page=${totalPages}" class="product-page-link">Cuối</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="product-empty-state">
                            <i class="fa-solid fa-box-open"></i>
                            <h3>Không có sản phẩm phù hợp</h3>
                            <p>Danh sách hiện đang trống hoặc chưa có kết quả khớp với bộ lọc hiện tại.</p>
                            <a href="${ctx}/admin/products?service=addProduct" class="btn-primary" style="text-decoration: none;">Thêm sản phẩm</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </div>
</body>
</html>
