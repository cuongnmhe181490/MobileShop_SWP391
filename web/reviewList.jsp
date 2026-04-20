<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            .review-shell {
                max-width: 860px;
                margin: 0 auto;
                padding: 40px 20px;
            }

            /* Summary box */
            .rv-summary {
                display: flex;
                gap: 32px;
                align-items: flex-start;
                flex-wrap: wrap;
                margin-bottom: 32px;
            }
            .rv-score {
                text-align: center;
                min-width: 100px;
            }
            .rv-score__num {
                font-size: 52px;
                font-weight: 700;
                line-height: 1;
                color: var(--color-text-primary);
            }
            .rv-score__sub {
                font-size: 13px;
                color: var(--color-text-secondary);
                margin-top: 4px;
            }

            /* Stars */
            .stars {
                display: inline-flex;
                gap: 2px;
            }
            .stars__s {
                font-size: 18px;
                color: #d1d5db;
            }
            .stars__s.on {
                color: #f59e0b;
            }
            .stars--sm .stars__s {
                font-size: 14px;
            }

            /* Filter chips */
            .rv-chips {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                flex: 1;
                align-items: center;
            }
            .chip {
                padding: 6px 14px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 500;
                border: 1px solid var(--color-border-secondary);
                color: var(--color-text-secondary);
                text-decoration: none;
                transition: .15s;
            }
            .chip:hover {
                border-color: var(--color-border-primary);
                color: var(--color-text-primary);
            }
            .chip.active {
                background: var(--color-text-primary);
                color: var(--color-background-primary);
                border-color: transparent;
            }

            /* Write button */
            .btn-write {
                display: inline-block;
                padding: 8px 20px;
                border-radius: 999px;
                background: #0284c7;
                color: #fff;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                margin-left: auto;
                white-space: nowrap;
            }
            .btn-write:hover {
                background: #0369a1;
            }

            /* Alert */
            .rv-alert {
                padding: 12px 16px;
                border-radius: 10px;
                font-size: 14px;
                margin-bottom: 20px;
            }
            .rv-alert--success {
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
            }
            .rv-alert--error   {
                background: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* Review card */
            .rv-card {
                padding: 20px 0;
                border-bottom: 1px solid var(--color-border-tertiary);
            }
            .rv-card:last-child {
                border-bottom: none;
            }
            .rv-card__top {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                gap: 12px;
                margin-bottom: 8px;
            }
            .rv-card__name {
                font-weight: 600;
                font-size: 15px;
                color: var(--color-text-primary);
            }
            .rv-card__meta {
                font-size: 12px;
                color: var(--color-text-secondary);
                margin-top: 2px;
            }
            .rv-card__content {
                font-size: 14px;
                color: var(--color-text-secondary);
                line-height: 1.6;
                margin: 8px 0;
            }

            /* Admin reply */
            .rv-reply {
                margin-top: 12px;
                padding: 12px 16px;
                border-radius: 10px;
                background: #f0fdf4;
                border-left: 3px solid #16a34a;
            }
            .rv-reply__label {
                font-size: 12px;
                font-weight: 700;
                color: #16a34a;
                margin-bottom: 4px;
            }
            .rv-reply__text  {
                font-size: 13px;
                color: #166534;
            }

            /* Review images */
            .rv-imgs {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                margin-top: 10px;
            }
            .rv-imgs img {
                width: 72px;
                height: 72px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid var(--color-border-tertiary);
            }

            /* Edit btn */
            .btn-edit {
                font-size: 12px;
                font-weight: 600;
                padding: 4px 12px;
                border-radius: 999px;
                border: 1px solid #bae6fd;
                background: #f0f9ff;
                color: #0284c7;
                text-decoration: none;
                white-space: nowrap;
                flex-shrink: 0;
            }
            .btn-edit:hover {
                background: #e0f2fe;
            }

            /* Pagination */
            .pagination {
                display: flex;
                gap: 6px;
                justify-content: center;
                padding: 32px 0 8px;
                flex-wrap: wrap;
            }
            .page-btn {
                padding: 6px 14px;
                border-radius: 8px;
                font-size: 13px;
                border: 1px solid var(--color-border-secondary);
                color: var(--color-text-secondary);
                text-decoration: none;
            }
            .page-btn.active {
                background: var(--color-text-primary);
                color: var(--color-background-primary);
                border-color: transparent;
            }
            .page-btn.disabled {
                opacity: .4;
                pointer-events: none;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main>
            <div class="review-shell">

                <%-- Alert thành công / lỗi --%>
                <c:if test="${param.success eq 'created'}">
                    <div class="rv-alert rv-alert--success">Cảm ơn! Đánh giá của bạn đã được gửi.</div>
                </c:if>
                <c:if test="${param.error eq 'duplicate'}">
                    <div class="rv-alert rv-alert--error">Bạn đã đánh giá sản phẩm này rồi.</div>
                </c:if>

                <%-- Tiêu đề --%>
                <h1 style="font-size:22px;font-weight:700;margin-bottom:24px;color:var(--color-text-primary)">
                    Đánh giá sản phẩm
                </h1>

                <%-- Summary: điểm + filter chips + nút viết --%>
                <div class="rv-summary">
                    <div class="rv-score">
                        <div class="rv-score__num">
                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1" minFractionDigits="1"/>
                        </div>
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="stars__s ${s <= averageRating ? 'on' : ''}">★</span>
                            </c:forEach>
                        </div>
                        <div class="rv-score__sub">${reviewCount} đánh giá</div>
                    </div>

                    <div class="rv-chips">
                        <a class="chip ${empty selectedStar ? 'active' : ''}"
                           href="${ctx}/reviews?pid=${pid}">Tất cả · ${reviewCount}</a>
                        <c:forEach items="${reviewCounts}" var="entry">
                            <a class="chip ${selectedStar == entry.key ? 'active' : ''}"
                               href="${ctx}/reviews?pid=${pid}&star=${entry.key}">
                                ${entry.key} sao · ${entry.value}
                            </a>
                        </c:forEach>
                    </div>

                    <%-- Nút viết review (chỉ hiện khi đã đăng nhập) --%>
                    <c:if test="${sessionScope.acc != null}">
                        <a class="btn-write" href="${ctx}/review/write?pid=${pid}">Viết đánh giá</a>
                    </c:if>
                </div>

                <%-- Danh sách review --%>
                <c:choose>
                    <c:when test="${empty reviews}">
                        <p style="color:var(--color-text-secondary);text-align:center;padding:40px 0">
                            Chưa có đánh giá nào${not empty selectedStar ? ' ở mức sao này' : ''}.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${reviews}" var="rv">
                            <article class="rv-card">
                                <div class="rv-card__top">
                                    <div>
                                        <div class="rv-card__name">${rv.reviewerName}</div>
                                        <div class="rv-card__meta">
                                            <span class="stars stars--sm">
                                                <c:forEach begin="1" end="5" var="s">
                                                    <span class="stars__s ${s <= rv.ranking ? 'on' : ''}">★</span>
                                                </c:forEach>
                                            </span>
                                            &nbsp;·&nbsp;
                                            <fmt:formatDate value="${rv.reviewDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>

                                    <%-- Nút Sửa nếu là review của user đang đăng nhập --%>
                                    <c:if test="${sessionScope.acc != null && rv.userId == sessionScope.acc.userId}">
                                        <a class="btn-edit" href="${ctx}/review/write?id=${rv.reviewId}">Sửa</a>
                                    </c:if>
                                </div>

                                <p class="rv-card__content">${rv.reviewContent}</p>

                                <%-- Ảnh đính kèm (nếu có, load riêng) --%>
                                <%-- Để tránh N+1 query, ảnh chỉ hiện ở màn form sửa. --%>
                                <%-- Nếu muốn hiện ở đây, thêm getImages vào ReviewDAO và set vào model --%>

                                <%-- Phản hồi Admin --%>
                                <c:if test="${not empty rv.replyContent}">
                                    <div class="rv-reply">
                                        <div class="rv-reply__label">Phản hồi từ cửa hàng</div>
                                        <div class="rv-reply__text">${rv.replyContent}</div>
                                    </div>
                                </c:if>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <%-- Phân trang --%>
                <c:if test="${totalPages > 1}">
                    <nav class="pagination">
                        <a class="page-btn ${currentPage == 1 ? 'disabled' : ''}"
                           href="${ctx}/reviews?pid=${pid}&star=${selectedStar}&page=${currentPage - 1}">← Trước</a>

                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a class="page-btn ${currentPage == p ? 'active' : ''}"
                               href="${ctx}/reviews?pid=${pid}&star=${selectedStar}&page=${p}">${p}</a>
                        </c:forEach>

                        <a class="page-btn ${currentPage == totalPages ? 'disabled' : ''}"
                           href="${ctx}/reviews?pid=${pid}&star=${selectedStar}&page=${currentPage + 1}">Sau →</a>
                    </nav>
                </c:if>

            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
