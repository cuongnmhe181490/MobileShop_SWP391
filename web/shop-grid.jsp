<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Cửa hàng" />
<c:set var="activePage" value="catalog" />
<c:set var="catalogProducts" value="${product}" />
<c:set var="catalogPriceLabels" value="${requestScope.catalogPriceLabels}" />
<c:set var="catalogDisplayStockMap" value="${requestScope.catalogDisplayStockMap}" />
<c:set var="brandLabels" value="${requestScope.brandLabels}" />
<c:set var="priceBounds" value="${requestScope.catalogPriceBounds}" />
<c:url var="loginNoticeUrl" value="/login">
    <c:param name="notice" value="Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng." />
</c:url>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <!-- Css Styles -->
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/owl.carousel.min.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/style.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/custom.css" type="text/css">
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <div class="catalog-layout">
                    <aside class="catalog-sidebar">
                        <div class="catalog-sidebar__stack">
                            <div>
                                <span class="section-eyebrow">Bộ lọc</span>
                                <h2 class="catalog-sidebar__title">Chọn nhanh theo hãng, RAM, năm và giá</h2>
                            </div>

                            <form id="catalogFilterForm" action="${ctx}/product" method="get" class="catalog-filter-form">
                                <div class="filter-group">
                                    <h3>Tìm kiếm</h3>
                                    <input id="catalogSearchInput" class="catalog-search" type="text" name="txt" value="${fn:escapeXml(searchQuery)}" placeholder="Tìm sản phẩm như iPhone 17 Pro Max">
                                    <p class="catalog-filter-note">Hệ thống tự bỏ khác biệt hoa/thường và khoảng trắng khi tìm kiếm.</p>
                                </div>

                                <div class="filter-group">
                                    <h3>Thương hiệu</h3>
                                    <label class="catalog-filter-select-wrap">
                                        <span class="sr-only">Chọn thương hiệu</span>
                                        <select name="brand" class="catalog-filter-select">
                                            <option value="" ${empty selectedBrand ? 'selected' : ''}>Tất cả thương hiệu</option>
                                            <c:forEach items="${brandOptions}" var="brandOption">
                                                <option value="${brandOption}" ${selectedBrand == brandOption ? 'selected' : ''}>${empty brandLabels[brandOption] ? brandOption : brandLabels[brandOption]}</option>
                                            </c:forEach>
                                        </select>
                                    </label>
                                </div>

                                <div class="filter-group">
                                    <h3>RAM</h3>
                                    <label class="catalog-filter-select-wrap">
                                        <span class="sr-only">Chọn RAM</span>
                                        <select name="storage" class="catalog-filter-select">
                                            <option value="" ${empty selectedStorage ? 'selected' : ''}>Tất cả RAM</option>
                                            <c:forEach items="${ramOptions}" var="ramOption">
                                                <c:set var="ramLabel" value="${ramOption}GB" />
                                                <option value="${ramLabel}" ${selectedStorage == ramLabel ? 'selected' : ''}>${ramLabel}</option>
                                            </c:forEach>
                                        </select>
                                    </label>
                                </div>

                                <div class="filter-group">
                                    <h3>Theo năm</h3>
                                    <div class="filter-chip-row">
                                        <label class="filter-chip ${empty selectedYear ? 'is-active' : ''}">
                                            <input type="radio" name="year" value="" ${empty selectedYear ? 'checked' : ''}>
                                            Tất cả
                                        </label>
                                        <c:forEach items="${recentYears}" var="yearOption">
                                            <label class="filter-chip ${selectedYear == yearOption.toString() ? 'is-active' : ''}">
                                                <input type="radio" name="year" value="${yearOption}" ${selectedYear == yearOption.toString() ? 'checked' : ''}>
                                                ${yearOption}
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="filter-group">
                                    <h3>Khoảng giá</h3>
                                    <div class="catalog-price-filter">
                                        <div class="catalog-price-inputs">
                                            <label>
                                                <span>Từ</span>
                                                <input id="minPriceInput" type="number" name="minPrice" min="0" step="1000" value="${selectedMinPrice}" placeholder="0">
                                            </label>
                                            <label>
                                                <span>Đến</span>
                                                <input id="maxPriceInput" type="number" name="maxPrice" min="0" step="1000" value="${selectedMaxPrice}" placeholder="<fmt:formatNumber value='${priceBounds.max}' type='number' maxFractionDigits='0' />">
                                            </label>
                                        </div>
                                        <div class="catalog-price-slider">
                                            <input id="minPriceSlider" type="range" min="0" max="${priceBounds.max > 0 ? priceBounds.max : 100000000}" step="100000" value="${empty selectedMinPrice ? 0 : selectedMinPrice}">
                                            <input id="maxPriceSlider" type="range" min="0" max="${priceBounds.max > 0 ? priceBounds.max : 100000000}" step="100000" value="${empty selectedMaxPrice ? (priceBounds.max > 0 ? priceBounds.max : 100000000) : selectedMaxPrice}">
                                        </div>
                                        <p id="priceRangePreview" class="catalog-filter-note"></p>
                                    </div>
                                </div>

                                <input type="hidden" name="sort" value="${selectedSort}">

                                <div class="catalog-filter-actions">
                                    <button class="pill-button pill-button--primary" type="submit">Áp dụng</button>
                                    <a class="pill-link" href="${ctx}/product">Xóa lọc</a>
                                </div>
                            </form>
                        </div>
                    </aside>

                    <section class="catalog-stage">
                        <div class="banner-card banner-card--compact">
                            <div>
                                <span class="section-eyebrow">Cửa hàng</span>
                                <h1>Tìm điện thoại đúng nhu cầu.</h1>
                                <p>Lọc nhanh theo thương hiệu, RAM, năm ra mắt và khoảng giá để chọn máy phù hợp hơn.</p>
                            </div>
                        </div>

                        <div class="catalog-toolbar">
                            <span>Hiển thị ${empty catalogProducts ? 0 : fn:length(catalogProducts)} / ${totalCatalogProducts} sản phẩm</span>
                            <div class="catalog-toolbar__actions">
                                <form class="catalog-sort-form" action="${ctx}/product" method="get">
                                    <input type="hidden" name="txt" value="${fn:escapeXml(searchQuery)}">
                                    <input type="hidden" name="brand" value="${selectedBrand}">
                                    <input type="hidden" name="storage" value="${selectedStorage}">
                                    <input type="hidden" name="year" value="${selectedYear}">
                                    <input type="hidden" name="minPrice" value="${selectedMinPrice}">
                                    <input type="hidden" name="maxPrice" value="${selectedMaxPrice}">
                                    <input type="hidden" name="page" value="${currentPage}">
                                    <label for="catalog-sort" class="catalog-sort-form__label">Sắp xếp</label>
                                    <select id="catalog-sort" name="sort" class="catalog-sort-form__select" onchange="this.form.submit()">
                                        <option value="" ${empty selectedSort ? 'selected' : ''}>Mặc định</option>
                                        <option value="year-desc" ${selectedSort == 'year-desc' ? 'selected' : ''}>Năm mới nhất</option>
                                        <option value="year-asc" ${selectedSort == 'year-asc' ? 'selected' : ''}>Năm cũ hơn</option>
                                        <option value="price-desc" ${selectedSort == 'price-desc' ? 'selected' : ''}>Giá cao trước</option>
                                        <option value="price-asc" ${selectedSort == 'price-asc' ? 'selected' : ''}>Giá thấp trước</option>
                                    </select>
                                </form>
                            </div>
                        </div>

                        <c:if test="${empty catalogProducts}">
                            <div class="order-empty">
                                <p>Chưa có sản phẩm phù hợp với bộ lọc hiện tại. Hãy thử nới điều kiện tìm kiếm hoặc quay lại danh sách chung.</p>
                                <a class="pill-link pill-link--primary" href="${ctx}/product">Xem tất cả sản phẩm</a>
                            </div>
                        </c:if>

                        <div class="catalog-grid">
                            <c:forEach items="${catalogProducts}" var="item">
                                <c:set var="displayStock" value="${catalogDisplayStockMap[item.idProduct]}" />
                                <c:url var="fallbackImageUrl" value="/product-image">
                                    <c:param name="brand" value="${item.idSupplier}" />
                                    <c:param name="name" value="${item.productName}" />
                                </c:url>
                                <article class="product-card">
                                    <a class="product-card__media" href="${ctx}/detail?pid=${item.idProduct}">
                                        <img src="${item.imagePath}" alt="${item.productName}" onerror="this.onerror=null;this.src='${fallbackImageUrl}';">
                                    </a>
                                    <div class="product-card__body">
                                        <h3><a href="${ctx}/detail?pid=${item.idProduct}">${item.productName}</a></h3>
                                        <div class="product-card__row">
                                            <div class="product-price">${catalogPriceLabels[item.idProduct]}</div>
                                        </div>
                                        <div class="product-card__stock">
                                            <c:choose>
                                                <c:when test="${item.quantity == 0}">
                                                    Sản phẩm hiện đã hết hàng
                                                </c:when>
                                                <c:otherwise>
                                                    Còn ${displayStock} sản phẩm khả dụng
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="product-card__actions">
                                            <c:choose>
                                                <c:when test="${displayStock <= 0}">
                                                    <button class="pill-button pill-button--primary" type="button" disabled>Hết hàng</button>
                                                </c:when>
                                                <c:when test="${sessionScope.acc == null}">
                                                    <a class="pill-link pill-link--primary" href="${loginNoticeUrl}">Thêm giỏ hàng</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${ctx}/cart/add" method="post">
                                                        <input type="hidden" name="idProduct" value="${item.idProduct}">
                                                        <input type="hidden" name="quantity" value="1">
                                                        <button class="pill-button pill-button--primary" type="submit">Thêm giỏ hàng</button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                            <a class="pill-link pill-link--dark" href="${ctx}/detail?pid=${item.idProduct}">Xem chi tiết</a>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="product-pagination">
                                <c:url var="catalogPageUrl" value="/product">
                                    <c:param name="txt" value="${searchQuery}" />
                                    <c:param name="brand" value="${selectedBrand}" />
                                    <c:param name="storage" value="${selectedStorage}" />
                                    <c:param name="year" value="${selectedYear}" />
                                    <c:param name="sort" value="${selectedSort}" />
                                    <c:param name="minPrice" value="${selectedMinPrice}" />
                                    <c:param name="maxPrice" value="${selectedMaxPrice}" />
                                </c:url>

                                <c:if test="${currentPage > 1}">
                                    <a href="${catalogPageUrl}&page=1" class="product-page-link">Đầu</a>
                                    <a href="${catalogPageUrl}&page=${prevPage}" class="product-page-link">Trước</a>
                                </c:if>

                                <c:if test="${showFirstPage}">
                                    <a href="${catalogPageUrl}&page=1" class="product-page-link">1</a>
                                </c:if>
                                <c:if test="${showLeadingEllipsis}">
                                    <span class="product-page-ellipsis">...</span>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="pageIndex">
                                    <a href="${catalogPageUrl}&page=${pageIndex}" class="product-page-link ${pageIndex == currentPage ? 'is-active' : ''}">${pageIndex}</a>
                                </c:forEach>

                                <c:if test="${showTrailingEllipsis}">
                                    <span class="product-page-ellipsis">...</span>
                                </c:if>
                                <c:if test="${showLastPage}">
                                    <a href="${catalogPageUrl}&page=${totalPages}" class="product-page-link">${totalPages}</a>
                                </c:if>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="${catalogPageUrl}&page=${nextPage}" class="product-page-link">Sau</a>
                                    <a href="${catalogPageUrl}&page=${totalPages}" class="product-page-link">Cuối</a>
                                </c:if>
                            </div>
                        </c:if>
                    </section>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
        <script>
            (function () {
                const filterForm = document.getElementById('catalogFilterForm');
                const searchInput = document.getElementById('catalogSearchInput');
                const minInput = document.getElementById('minPriceInput');
                const maxInput = document.getElementById('maxPriceInput');
                const minSlider = document.getElementById('minPriceSlider');
                const maxSlider = document.getElementById('maxPriceSlider');
                const preview = document.getElementById('priceRangePreview');

                function toNumber(value, fallback) {
                    const parsed = parseInt(String(value || '').replace(/[^\d]/g, ''), 10);
                    return Number.isFinite(parsed) ? parsed : fallback;
                }

                function formatVnd(value) {
                    return new Intl.NumberFormat('vi-VN').format(Math.max(0, value)) + ' đ';
                }

                function syncPreview() {
                    const minValue = Math.max(0, toNumber(minInput.value, 0));
                    const maxValue = Math.max(minValue, toNumber(maxInput.value, toNumber(maxSlider.value, minValue)));
                    preview.textContent = 'Khoảng giá đang chọn: ' + formatVnd(minValue) + ' - ' + formatVnd(maxValue);
                }

                function syncFromInputs() {
                    let minValue = Math.max(0, toNumber(minInput.value, 0));
                    let maxValue = Math.max(0, toNumber(maxInput.value, toNumber(maxSlider.value, minValue)));
                    if (minValue > maxValue) {
                        maxValue = minValue;
                        maxInput.value = maxValue;
                    }
                    minSlider.value = minValue;
                    maxSlider.value = maxValue;
                    syncPreview();
                }

                function syncFromSliders() {
                    let minValue = toNumber(minSlider.value, 0);
                    let maxValue = toNumber(maxSlider.value, minValue);
                    if (minValue > maxValue) {
                        const temp = minValue;
                        minValue = maxValue;
                        maxValue = temp;
                    }
                    minInput.value = minValue;
                    maxInput.value = maxValue;
                    minSlider.value = minValue;
                    maxSlider.value = maxValue;
                    syncPreview();
                }

                if (minInput && maxInput && minSlider && maxSlider && preview) {
                    minInput.addEventListener('input', syncFromInputs);
                    maxInput.addEventListener('input', syncFromInputs);
                    minSlider.addEventListener('input', syncFromSliders);
                    maxSlider.addEventListener('input', syncFromSliders);
                    syncFromInputs();
                }

                if (filterForm && searchInput) {
                    filterForm.querySelectorAll('input[type="radio"], select[name="brand"], select[name="storage"], select[name="year"]').forEach(function (control) {
                        control.addEventListener('change', function () {
                            filterForm.requestSubmit();
                        });
                    });

                    filterForm.addEventListener('submit', function (event) {
                        searchInput.value = searchInput.value.trim().replace(/\s+/g, ' ');
                        if (searchInput.value.length === 0) {
                            searchInput.value = '';
                        }
                        if (minInput && maxInput) {
                            const minValue = Math.max(0, toNumber(minInput.value, 0));
                            const maxValue = Math.max(0, toNumber(maxInput.value, 0));
                            if (minInput.value && maxInput.value && minValue > maxValue) {
                                event.preventDefault();
                                alert('Khoảng giá không hợp lệ: giá từ phải nhỏ hơn hoặc bằng giá đến.');
                                return;
                            }
                            minInput.value = minInput.value ? minValue : '';
                            maxInput.value = maxInput.value ? Math.max(minValue, maxValue) : '';
                        }
                    });
                }
            })();
        </script>
    </body>
</html>
