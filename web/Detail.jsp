<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="${detail.productName}" />
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
                <c:url var="detailFallbackImageUrl" value="/product-image">
                    <c:param name="brand" value="${detail.idSupplier}" />
                    <c:param name="name" value="${detail.productName}" />
                </c:url>

                <div class="catalog-layout" style="grid-template-columns: minmax(0, 1fr);">
                    <div class="detail-media surface-card" style="padding: 24px;">
                        <div class="detail-media__hero">
                            <img src="${not empty detail.imagePath ? detail.imagePath : detailFallbackImageUrl}"
                                 alt="${detail.productName}"
                                 onerror="this.onerror=null;this.src='${detailFallbackImageUrl}';">
                        </div>
                    </div>

                    <div class="detail-summary surface-card" style="padding: 28px;">
                        <div class="detail-summary__breadcrumb">
                            <a href="${ctx}/home">Trang chủ</a>
                            <span>/</span>
                            <a href="${ctx}/product">Cửa hàng</a>
                            <span>/</span>
                            <span>${detail.idSupplier}</span>
                        </div>

                        <h1>${detail.productName}</h1>
                        <p class="detail-summary__subtitle">${detail.idSupplier}</p>

                        <div class="detail-summary__price">
                            <strong>${detailPriceLabel}</strong>
                        </div>

                        <div class="detail-summary__group">
                            <h3>Thông số nổi bật</h3>
                            <ul>
                                <c:if test="${not empty detail.screen}"><li>Màn hình: ${detail.screen}</li></c:if>
                                <c:if test="${not empty detail.operatingSystem}"><li>Hệ điều hành: ${detail.operatingSystem}</li></c:if>
                                <c:if test="${not empty detail.cpu}"><li>CPU: ${detail.cpu}</li></c:if>
                                <c:if test="${not empty detail.ram}"><li>RAM: ${detail.ram} GB</li></c:if>
                                <c:if test="${not empty detail.camera}"><li>Camera: ${detail.camera}</li></c:if>
                                <c:if test="${not empty detail.battery}"><li>Pin: ${detail.battery}</li></c:if>
                                <c:if test="${not empty detail.releaseDate}"><li>Ra mắt: ${detail.releaseDate}</li></c:if>
                                <li>Số lượng hiện tại: ${detail.quantity}</li>
                            </ul>
                        </div>

                        <c:if test="${not empty detail.description}">
                            <div class="detail-summary__group">
                                <h3>Mô tả</h3>
                                <p>${detail.description}</p>
                            </div>
                        </c:if>

                        <div class="detail-summary__actions">
                            <a class="pill-link pill-link--primary" href="${ctx}/product">Quay lại danh mục</a>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty relatedProducts}">
                    <section style="margin-top: 32px;">
                        <div class="section-heading section-heading--compact">
                            <div>
                                <span class="section-eyebrow">Liên quan</span>
                                <h2>Sản phẩm cùng thương hiệu</h2>
                            </div>
                        </div>
                        <div class="catalog-grid">
                            <c:forEach items="${relatedProducts}" var="item">
                                <c:url var="relatedFallbackImageUrl" value="/product-image">
                                    <c:param name="brand" value="${item.idSupplier}" />
                                    <c:param name="name" value="${item.productName}" />
                                </c:url>
                                <article class="product-card">
                                    <a class="product-card__media" href="${ctx}/detail?pid=${item.idProduct}">
                                        <img src="${not empty item.imagePath ? item.imagePath : relatedFallbackImageUrl}"
                                             alt="${item.productName}"
                                             onerror="this.onerror=null;this.src='${relatedFallbackImageUrl}';">
                                    </a>
                                    <div class="product-card__body">
                                        <h3><a href="${ctx}/detail?pid=${item.idProduct}">${item.productName}</a></h3>
                                        <div class="product-card__meta">${item.idSupplier}</div>
                                        <div class="product-card__row">
                                            <strong>${relatedPriceLabels[item.idProduct]}</strong>
                                        </div>
                                        <div class="product-card__actions">
                                            <a class="pill-link pill-link--dark" href="${ctx}/detail?pid=${item.idProduct}">Xem chi tiết</a>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </section>
                </c:if>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
