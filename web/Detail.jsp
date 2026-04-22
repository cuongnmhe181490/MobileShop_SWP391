<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="${detail.productName}" />
<c:set var="activePage" value="catalog" />
<c:set var="detailDescription" value="Mẫu ${detail.productName} thuộc dòng ${detail.idSupplier}, dùng màn hình ${detail.screen}, chip ${detail.cpu}, RAM ${detail.ram}GB, camera ${detail.camera} và pin ${detail.battery}." />
<c:url var="loginNoticeUrl" value="/login">
    <c:param name="notice" value="Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng." />
</c:url>
<c:url var="detailFallbackImageUrl" value="/product-image">
    <c:param name="brand" value="${detail.idSupplier}" />
    <c:param name="name" value="${detail.productName}" />
</c:url>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <div class="detail-layout">
                    <section class="detail-media">
                        <div class="detail-breadcrumb">
                            <a href="${ctx}/product">Cửa hàng</a>
                            <span>/</span>
                            <span>${detail.productName}</span>
                        </div>
                        <div class="detail-media__hero">
                            <img src="${detail.imagePath}" alt="${detail.productName}" onerror="this.onerror=null;this.src='${detailFallbackImageUrl}';">
                        </div>
                    </section>

                    <section class="detail-summary">
                        <span class="section-eyebrow">${detail.idSupplier}</span>
                        <h1>${detail.productName}</h1>
                        <p class="detail-summary__subtitle">${detailDescription}</p>

                        <div class="detail-summary__price">
                            <strong>${detailPriceLabel}</strong>
                            <span class="status-chip status-chip--blue">${detail.ram}GB RAM</span>
                        </div>

                        <div class="detail-summary__stock">
                            <span class="status-chip ${detailDisplayStock > 0 ? 'status-chip--green' : 'status-chip--pink'}">${detail.quantity == 0 ? 'Hết hàng' : detailDisplayStock > 0 ? 'Còn hàng' : 'Tạm hết hàng'}</span>
                            <span>
                                <c:choose>
                                    <c:when test="${detail.quantity == 0}">
                                        Sản phẩm hiện đã hết hàng
                                    </c:when>
                                    <c:otherwise>
                                        Còn ${detailDisplayStock} sản phẩm khả dụng
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="detail-summary__group">
                            <h3>Điểm nổi bật</h3>
                            <ul class="detail-bullets">
                                <li>Màn hình: ${detail.screen}</li>
                                <li>Chip xử lý: ${detail.cpu}</li>
                                <li>Camera: ${detail.camera}</li>
                                <li>Pin: ${detail.battery}</li>
                            </ul>
                        </div>

                        <div class="detail-summary__actions">
                            <div class="detail-summary__primary-actions">
                                <c:choose>
                                    <c:when test="${detailDisplayStock <= 0}">
                                        <button class="pill-button pill-button--primary" type="button" disabled>Hết hàng</button>
                                    </c:when>
                                    <c:when test="${sessionScope.acc == null}">
                                        <a class="pill-link pill-link--primary" href="${loginNoticeUrl}">Thêm giỏ hàng</a>
                                    </c:when>
                                    <c:otherwise>
                                        <form class="detail-add-cart" action="${ctx}/cart/add" method="post">
                                            <input type="hidden" name="idProduct" value="${detail.idProduct}">
                                            <label class="detail-add-cart__qty">
                                                <span>Số lượng</span>
                                                <input type="number" name="quantity" min="1" max="${detailDisplayStock}" value="1" step="1" required>
                                            </label>
                                            <button class="pill-button pill-button--primary" type="submit">Thêm giỏ hàng</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                                <a class="pill-link pill-link--primary detail-review-link" href="${ctx}/reviews?pid=${detail.idProduct}">Xem đánh giá</a>
                            </div>
                            <a class="pill-link detail-back-link" href="${ctx}/product">Quay lại cửa hàng</a>
                        </div>

                        <section class="review-summary-card">
                            <div class="review-summary-card__head">
                                <div class="review-summary-card__rating">
                                    <strong><fmt:formatNumber value="${averageRating}" maxFractionDigits="1" minFractionDigits="1"/></strong>
                                    <div class="review-stars">
                                        <c:forEach begin="1" end="5" var="star">
                                            <span class="review-stars__star ${star <= averageRating ? 'is-filled' : ''}">★</span>
                                        </c:forEach>
                                    </div>
                                    <span>${reviewCount} đánh giá</span>
                                </div>
                                <a class="review-summary-card__link" href="${ctx}/reviews?pid=${detail.idProduct}">Xem chi tiết</a>
                            </div>
                            <p>Người mua có thể xem chi tiết theo từng mức sao và toàn bộ nhận xét ở màn đánh giá riêng.</p>
                        </section>
                    </section>
                </div>

                <section class="spec-grid">
                    <article class="spec-card">
                        <span>Màn hình</span>
                        <strong>${detail.screen}</strong>
                        <p>Tập trung vào trải nghiệm nhìn, độ sáng và độ mượt khi dùng lâu dài.</p>
                    </article>
                    <article class="spec-card">
                        <span>Hệ điều hành</span>
                        <strong>${detail.operatingSystem}</strong>
                        <p>Phù hợp cho người dùng muốn hệ sinh thái ổn định và dễ làm quen.</p>
                    </article>
                    <article class="spec-card">
                        <span>Hiệu năng</span>
                        <strong>${detail.cpu}</strong>
                        <p>Cấu hình phục vụ tốt công việc, giải trí và chụp ảnh di động.</p>
                    </article>
                    <article class="spec-card">
                        <span>Pin & camera</span>
                        <strong>${detail.battery}</strong>
                        <p>${detail.camera}</p>
                    </article>
                </section>

                <section class="review-preview">
                    <div class="section-heading">
                        <div>
                            <span class="section-eyebrow">Đánh giá gần đây</span>
                            <h2>Người mua nói gì về mẫu máy này.</h2>
                        </div>
                        <a class="pill-link" href="${ctx}/reviews?pid=${detail.idProduct}">Xem tất cả đánh giá</a>
                    </div>

                    <div class="review-list">
                        <c:forEach items="${reviewPreview}" var="review">
                            <article class="review-card">
                                <div class="review-card__head">
                                    <div>
                                        <h3>${review.reviewerName}</h3>
                                        <div class="review-stars review-stars--small">
                                            <c:forEach begin="1" end="5" var="star">
                                                <span class="review-stars__star ${star <= review.ranking ? 'is-filled' : ''}">★</span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <span>${review.reviewDate}</span>
                                </div>
                                <p>${review.review}</p>
                            </article>
                        </c:forEach>
                    </div>
                </section>

                <section>
                    <div class="section-heading">
                        <div>
                            <span class="section-eyebrow">Gợi ý thêm</span>
                            <h2>Cùng thương hiệu, cùng nhóm trải nghiệm.</h2>
                        </div>
                    </div>

                    <div class="catalog-grid">
                        <c:forEach items="${relatedProducts}" var="item">
                            <c:set var="relatedDisplayStock" value="${relatedDisplayStockMap[item.idProduct]}" />
                            <c:url var="relatedFallbackImageUrl" value="/product-image">
                                <c:param name="brand" value="${item.idSupplier}" />
                                <c:param name="name" value="${item.productName}" />
                            </c:url>
                            <article class="product-card">
                                <a class="product-card__media" href="${ctx}/detail?pid=${item.idProduct}">
                                    <img src="${item.imagePath}" alt="${item.productName}" onerror="this.onerror=null;this.src='${relatedFallbackImageUrl}';">
                                </a>
                                <div class="product-card__body">
                                    <h3><a href="${ctx}/detail?pid=${item.idProduct}">${item.productName}</a></h3>
                                    <div class="product-card__row">
                                        <div class="product-price">${relatedPriceLabels[item.idProduct]}</div>
                                        <span class="status-chip ${relatedDisplayStock > 0 ? 'status-chip--green' : 'status-chip--pink'}">${item.quantity == 0 ? 'Hết hàng' : relatedDisplayStock > 0 ? 'Còn hàng' : 'Tạm hết hàng'}</span>
                                    </div>
                                    <div class="product-card__stock">
                                        <c:choose>
                                            <c:when test="${item.quantity == 0}">
                                                Sản phẩm hiện đã hết hàng
                                            </c:when>
                                            <c:otherwise>
                                                Còn ${relatedDisplayStock} sản phẩm khả dụng
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="product-card__actions">
                                        <c:choose>
                                            <c:when test="${relatedDisplayStock <= 0}">
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
                </section>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
