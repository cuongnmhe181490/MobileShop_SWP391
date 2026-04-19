<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Chi tiết đánh giá" />
<<<<<<< HEAD
<c:set var="activePage" value="catalog" %>
=======
<c:set var="activePage" value="catalog" />
>>>>>>> 29e16c36384973902b60704acd8229c07109ec73
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
<<<<<<< HEAD
        <style>
            .btn-edit-review {
                padding: 6px 14px;
                border-radius: 999px;
                font-size: 11px;
                font-weight: 700;
                text-decoration: none;
                background: #f0f9ff;
                color: #0284c7;
                border: 1px solid #bae6fd;
                transition: 0.2s;
            }
            .btn-edit-review:hover { background: #e0f2fe; }
            .admin-reply {
                margin-top: 12px;
                padding: 12px;
                background: #f0fdf4;
                border-radius: 12px;
                border-left: 3px solid #16a34a;
                font-size: 13px;
                color: #166534;
            }
            .admin-reply strong { color: #16a34a; }
        </style>
=======
>>>>>>> 29e16c36384973902b60704acd8229c07109ec73
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <section class="review-page-shell">
                    <div class="section-heading section-heading--compact">
                        <div>
                            <span class="section-eyebrow">Chi tiết đánh giá sản phẩm</span>
                            <h1>${detailProduct.productName}</h1>
                        </div>
                    </div>

                    <div class="review-page-summary">
                        <div class="review-page-summary__score">
                            <strong><fmt:formatNumber value="${averageRating}" maxFractionDigits="1" minFractionDigits="1"/></strong>
                            <div class="review-stars">
                                <c:forEach begin="1" end="5" var="star">
                                    <span class="review-stars__star ${star <= averageRating ? 'is-filled' : ''}">★</span>
                                </c:forEach>
                            </div>
                            <span>${reviewCount} đánh giá</span>
                        </div>

                        <div class="review-page-filters">
                            <a class="filter-chip ${empty selectedStar ? 'is-active' : ''}" href="${ctx}/reviews?pid=${detailProduct.idProduct}">Tất cả · ${reviewCount}</a>
                            <c:forEach items="${reviewCounts}" var="entry">
                                <a class="filter-chip ${selectedStar == entry.key ? 'is-active' : ''}" href="${ctx}/reviews?pid=${detailProduct.idProduct}&star=${entry.key}">${entry.key} sao · ${entry.value}</a>
                            </c:forEach>
                        </div>

                        <c:if test="${sessionScope.acc == null}">
                            <div class="review-page-summary__login">
                                <p>Người dùng phải đăng nhập mới có thể gửi đánh giá.</p>
                                <a class="pill-link pill-link--primary" href="${ctx}/login.jsp">Đăng nhập để đánh giá</a>
                            </div>
                        </c:if>
                        <c:if test="${sessionScope.acc != null}">
                            <div class="review-page-summary__login">
                                <p>Bạn đã đăng nhập. Phần gửi đánh giá sẽ được nối ở bước backend tiếp theo.</p>
                            </div>
                        </c:if>
                    </div>

                    <div class="review-list review-list--page">
                        <c:forEach items="${reviews}" var="review">
                            <article class="review-card">
                                <div class="review-card__head review-card__head--row">
                                    <div>
                                        <h3>${review.reviewerName}</h3>
                                        <div class="review-card__meta">
                                            <div class="review-stars review-stars--small">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <span class="review-stars__star ${star <= review.ranking ? 'is-filled' : ''}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span>Đã mua ${detailProduct.productName} · ${review.reviewDate}</span>
                                        </div>
                                    </div>
<<<<<<< HEAD
                                    <%-- Hiển thị nút sửa nếu review thuộc về user đang đăng nhập --%>
                                    <c:if test="${sessionScope.acc != null && review.idAccount == sessionScope.acc.id}">
                                        <a href="${ctx}/UserReviewEditServlet?id=${review.idReview}" class="btn-edit-review">Sửa</a>
                                    </c:if>
                                </div>
                                <p>${review.review}</p>
                                <%-- Hiển thị phản hồi của admin nếu có --%>
                                <c:if test="${not empty review.replyContent}">
                                    <div class="admin-reply">
                                        <strong>Phản hồi:</strong> ${review.replyContent}
                                    </div>
                                </c:if>
=======
                                </div>
                                <p>${review.review}</p>
>>>>>>> 29e16c36384973902b60704acd8229c07109ec73
                            </article>
                        </c:forEach>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination-bar">
                            <a class="page-pill ${currentPage == 1 ? 'is-disabled' : ''}" href="${ctx}/reviews?pid=${detailProduct.idProduct}&star=${selectedStar}&page=${currentPage - 1}">Trước</a>
                            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                <a class="page-pill ${currentPage == pageNumber ? 'is-active' : ''}" href="${ctx}/reviews?pid=${detailProduct.idProduct}&star=${selectedStar}&page=${pageNumber}">${pageNumber}</a>
                            </c:forEach>
                            <a class="page-pill ${currentPage == totalPages ? 'is-disabled' : ''}" href="${ctx}/reviews?pid=${detailProduct.idProduct}&star=${selectedStar}&page=${currentPage + 1}">Sau</a>
                        </div>
                    </c:if>
                </section>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
