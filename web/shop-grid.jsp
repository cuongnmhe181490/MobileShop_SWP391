<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Cửa hàng" />
<c:set var="activePage" value="catalog" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <div class="section-heading section-heading--compact">
                    <div>
                        <span class="section-eyebrow">Danh mục sản phẩm</span>
                        <h2>Lọc điện thoại theo đúng nhu cầu của bạn</h2>
                        <p>Giữ baseline từ main, chỉ thêm search, filter, sort và màn hình chi tiết cho luồng product.</p>
                    </div>
                </div>

                <div class="catalog-layout">
                    <aside class="catalog-sidebar">
                        <div class="catalog-sidebar__stack">
                            <div>
                                <h3 class="catalog-sidebar__title">Tìm kiếm</h3>
                                <form action="${ctx}/product" method="get" class="catalog-filter-form">
                                    <input class="form-input catalog-search" type="text" name="txt" value="${fn:escapeXml(searchQuery)}" placeholder="Tên máy, dòng máy...">

                                    <div>
                                        <h3>Thương hiệu</h3>
                                        <div class="filter-group">
                                            <label class="filter-chip ${empty selectedBrand ? 'is-active' : ''}">
                                                <input type="radio" name="brand" value="" ${empty selectedBrand ? 'checked' : ''}>
                                                Tất cả
                                            </label>
                                            <c:forEach items="${brandOptions}" var="brand">
                                                <label class="filter-chip ${selectedBrand == brand ? 'is-active' : ''}">
                                                    <input type="radio" name="brand" value="${brand}" ${selectedBrand == brand ? 'checked' : ''}>
                                                    ${brand}
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div>
                                        <h3>RAM</h3>
                                        <div class="filter-group">
                                            <label class="filter-chip ${empty selectedStorage ? 'is-active' : ''}">
                                                <input type="radio" name="storage" value="" ${empty selectedStorage ? 'checked' : ''}>
                                                Tất cả
                                            </label>
                                            <c:forEach items="${ramOptions}" var="ramOption">
                                                <label class="filter-chip ${selectedStorage == ramOption.toString() ? 'is-active' : ''}">
                                                    <input type="radio" name="storage" value="${ramOption}" ${selectedStorage == ramOption.toString() ? 'checked' : ''}>
                                                    ${ramOption} GB
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div>
                                        <h3>Năm ra mắt</h3>
                                        <div class="filter-group">
                                            <label class="filter-chip ${empty selectedYear ? 'is-active' : ''}">
                                                <input type="radio" name="year" value="" ${empty selectedYear ? 'checked' : ''}>
                                                Tất cả
                                            </label>
                                            <c:forEach items="${recentYears}" var="releaseYear">
                                                <label class="filter-chip ${selectedYear == releaseYear.toString() ? 'is-active' : ''}">
                                                    <input type="radio" name="year" value="${releaseYear}" ${selectedYear == releaseYear.toString() ? 'checked' : ''}>
                                                    ${releaseYear}
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div>
                                        <h3>Sắp xếp</h3>
                                        <select class="catalog-sort-form__select" name="sort">
                                            <option value="" ${empty selectedSort ? 'selected' : ''}>Mới nhất</option>
                                            <option value="price-asc" ${selectedSort == 'price-asc' ? 'selected' : ''}>Giá tăng dần</option>
                                            <option value="price-desc" ${selectedSort == 'price-desc' ? 'selected' : ''}>Giá giảm dần</option>
                                            <option value="year-desc" ${selectedSort == 'year-desc' ? 'selected' : ''}>Năm mới nhất</option>
                                            <option value="year-asc" ${selectedSort == 'year-asc' ? 'selected' : ''}>Năm cũ hơn</option>
                                        </select>
                                    </div>

                                    <div class="catalog-price-inputs">
                                        <label>
                                            Giá từ
                                            <input type="text" inputmode="numeric" name="minPrice" value="${fn:escapeXml(selectedMinPrice)}" placeholder="0">
                                        </label>
                                        <label>
                                            Giá đến
                                            <input type="text" inputmode="numeric" name="maxPrice" value="${fn:escapeXml(selectedMaxPrice)}" placeholder="50000000">
                                        </label>
                                    </div>

                                    <div class="catalog-filter-actions">
                                        <button class="pill-button pill-button--primary" type="submit">Áp dụng</button>
                                        <a class="pill-link" href="${ctx}/product">Đặt lại</a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </aside>

                    <section class="catalog-stage">
                        <div class="catalog-toolbar">
                            <div>
                                <strong>${empty product ? 0 : fn:length(product)} sản phẩm</strong>
                            </div>
                        </div>

                        <c:if test="${not empty productDataError}">
                            <div class="surface-card" style="padding: 24px; margin-bottom: 16px; border: 1px solid #f1c27d; background: #fff7ed;">
                                <h3>Khong the tai du lieu san pham</h3>
                                <p>${productDataError}</p>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty product}">
                                <div class="catalog-grid">
                                    <c:forEach items="${product}" var="item">
                                        <c:url var="fallbackImageUrl" value="/product-image">
                                            <c:param name="brand" value="${item.idSupplier}" />
                                            <c:param name="name" value="${item.productName}" />
                                        </c:url>
                                        <article class="product-card">
                                            <a class="product-card__media" href="${ctx}/detail?pid=${item.idProduct}">
                                                <img src="${not empty item.imagePath ? item.imagePath : fallbackImageUrl}"
                                                     alt="${item.productName}"
                                                     onerror="this.onerror=null;this.src='${fallbackImageUrl}';">
                                            </a>
                                            <div class="product-card__body">
                                                <h3><a href="${ctx}/detail?pid=${item.idProduct}">${item.productName}</a></h3>
                                                <div class="product-card__meta">
                                                    ${item.idSupplier}
                                                    <c:if test="${not empty item.releaseDate}">
                                                        • ${item.releaseDate}
                                                    </c:if>
                                                </div>
                                                <div class="product-card__row">
                                                    <strong>${catalogPriceLabels[item.idProduct]}</strong>
                                                </div>
                                                <div class="product-card__actions">
                                                    <a class="pill-link pill-link--dark" href="${ctx}/detail?pid=${item.idProduct}">Xem chi tiết</a>
                                                </div>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="surface-card" style="padding: 32px;">
                                    <h3>Chưa có sản phẩm phù hợp</h3>
                                    <p>Hãy nới điều kiện lọc hoặc quay lại danh mục đầy đủ để xem thêm sản phẩm.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
