<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            body {
                background-color: #f8fafc !important; /* Soft background to highlight the center panel */
            }

            .review-shell {
                max-width: 900px;
                margin: 40px auto;
                padding: 40px;
                background: #ffffff;
                border-radius: 24px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.02);
            }

            /* Tiêu đề */
            .rv-title {
                font-size: 28px;
                font-weight: 800;
                margin-bottom: 32px;
                color: #0f172a;
                letter-spacing: -0.5px;
            }

            /* Summary box */
            .rv-summary {
                display: flex;
                gap: 40px;
                align-items: center;
                flex-wrap: wrap;
                margin-bottom: 40px;
                padding: 32px;
                background: linear-gradient(145deg, #ffffff, #f8fafc);
                border-radius: 20px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            }
            .rv-score {
                text-align: center;
                min-width: 140px;
                padding-right: 40px;
                border-right: 1px solid #e2e8f0;
            }
            .rv-score__num {
                font-size: 64px;
                font-weight: 800;
                line-height: 1;
                background: linear-gradient(135deg, #0ea5e9, #3b82f6);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .rv-score__sub {
                font-size: 14px;
                color: #64748b;
                margin-top: 12px;
                font-weight: 500;
            }

            /* Stars */
            .stars {
                display: inline-flex;
                gap: 4px;
                margin-top: 8px;
            }
            .stars__s {
                font-size: 22px;
                color: #e2e8f0;
            }
            .stars__s.on {
                color: #fbbf24;
                text-shadow: 0 0 12px rgba(251, 191, 36, 0.4);
            }
            .stars--sm .stars__s {
                font-size: 14px;
                text-shadow: none;
            }

            /* Filter chips */
            .rv-chips {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                flex: 1;
                align-items: center;
            }
            .chip {
                padding: 10px 20px;
                border-radius: 999px;
                font-size: 14px;
                font-weight: 600;
                border: 2px solid transparent;
                background: #f1f5f9;
                color: #475569;
                text-decoration: none;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }
            .chip:hover {
                transform: translateY(-2px);
                background: #e2e8f0;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }
            .chip.active {
                background: linear-gradient(135deg, #0f172a, #1e293b);
                color: #ffffff;
                box-shadow: 0 4px 15px rgba(15, 23, 42, 0.2);
            }

            /* Write button */
            .btn-write {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 14px 28px;
                border-radius: 999px;
                background: linear-gradient(135deg, #0284c7, #2563eb);
                color: #fff;
                font-size: 15px;
                font-weight: 600;
                text-decoration: none;
                margin-left: auto;
                white-space: nowrap;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
            }
            .btn-write:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
            }

            /* Alert */
            .rv-alert {
                padding: 16px 20px;
                border-radius: 12px;
                font-size: 15px;
                margin-bottom: 24px;
                font-weight: 500;
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
                padding: 32px;
                border-radius: 20px;
                background: #ffffff;
                border: 1px solid #f1f5f9;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }
            .rv-card:hover {
                box-shadow: 0 10px 30px rgba(0,0,0,0.04);
                transform: translateY(-2px);
                border-color: #e2e8f0;
            }
            .rv-card__top {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                gap: 16px;
                margin-bottom: 16px;
            }
            .rv-card__user {
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .rv-card__avatar {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                background: linear-gradient(135deg, #e0f2fe, #bae6fd);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                font-weight: 700;
                color: #0284c7;
            }
            .rv-card__name {
                font-weight: 700;
                font-size: 16px;
                color: #0f172a;
            }
            .rv-card__meta {
                font-size: 13px;
                color: #64748b;
                margin-top: 4px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .rv-card__content {
                font-size: 15px;
                color: #334155;
                line-height: 1.7;
                margin: 16px 0;
            }

            /* Admin reply */
            .rv-reply {
                margin-top: 24px;
                padding: 20px 24px;
                border-radius: 16px;
                background: #f8fafc;
                border-left: 4px solid #0ea5e9;
                position: relative;
            }
            .rv-reply::before {
                content: '';
                position: absolute;
                top: -8px;
                left: 24px;
                border-width: 0 8px 8px 8px;
                border-style: solid;
                border-color: transparent transparent #f8fafc transparent;
            }
            .rv-reply__label {
                font-size: 14px;
                font-weight: 700;
                color: #0ea5e9;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .rv-reply__text  {
                font-size: 15px;
                color: #475569;
                line-height: 1.6;
            }

            /* Review images */
            .rv-imgs {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                margin-top: 16px;
            }
            .rv-imgs img {
                width: 96px;
                height: 96px;
                object-fit: cover;
                border-radius: 12px;
                border: 2px solid transparent;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .rv-imgs img:hover {
                transform: scale(1.05);
                border-color: #0ea5e9;
                box-shadow: 0 8px 20px rgba(14, 165, 233, 0.2);
            }

            /* Edit btn */
            .btn-edit {
                font-size: 13px;
                font-weight: 600;
                padding: 8px 20px;
                border-radius: 999px;
                background: #f1f5f9;
                color: #475569;
                text-decoration: none;
                white-space: nowrap;
                flex-shrink: 0;
                transition: all 0.2s ease;
            }
            .btn-edit:hover {
                background: #e2e8f0;
                color: #0f172a;
            }

            /* Pagination */
            .pagination {
                display: flex;
                gap: 8px;
                justify-content: center;
                padding: 40px 0 20px;
                flex-wrap: wrap;
            }
            .page-btn {
                padding: 10px 18px;
                border-radius: 12px;
                font-size: 14px;
                font-weight: 600;
                border: none;
                background: #ffffff;
                color: #475569;
                text-decoration: none;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(0,0,0,0.02), inset 0 0 0 1px #e2e8f0;
            }
            .page-btn:hover:not(.disabled) {
                background: #f8fafc;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.05), inset 0 0 0 1px #cbd5e1;
            }
            .page-btn.active {
                background: linear-gradient(135deg, #0f172a, #1e293b);
                color: #ffffff;
                box-shadow: 0 4px 15px rgba(15, 23, 42, 0.2);
            }
            .page-btn.disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            /* ─── Toast Notification ─── */
            .toast {
                position: fixed;
                bottom: 32px;
                right: 32px;
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 18px 24px;
                border-radius: 16px;
                font-size: 15px;
                font-weight: 600;
                box-shadow: 0 20px 60px rgba(0,0,0,0.15);
                z-index: 9999;
                transform: translateY(120px);
                opacity: 0;
                transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                pointer-events: none;
                max-width: 400px;
                background: #ffffff;
                color: #0f172a;
            }
            .toast.show {
                transform: translateY(0);
                opacity: 1;
                pointer-events: auto;
            }
            .toast--success {
                border-left: 6px solid #10b981;
            }
            .toast--error {
                border-left: 6px solid #ef4444;
            }
            .toast__icon {
                font-size: 24px;
                flex-shrink: 0;
            }
            .toast--success .toast__icon { color: #10b981; }
            .toast--error .toast__icon { color: #ef4444; }

            .toast__close {
                background: none;
                border: none;
                color: #94a3b8;
                cursor: pointer;
                margin-left: auto;
                font-size: 20px;
                padding: 0 0 0 8px;
            }
            .toast__close:hover { color: #0f172a; }
            .toast__progress {
                position: absolute;
                bottom: 0; left: 0;
                height: 4px;
                border-radius: 0 0 16px 16px;
                animation: toast-progress 4s linear forwards;
            }
            .toast--success .toast__progress { background: #10b981; }
            .toast--error .toast__progress { background: #ef4444; }
            @keyframes toast-progress { from { width: 100%; } to { width: 0%; } }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main>
            <div class="review-shell">

                <%-- Toast: success / error --%>
                <c:if test="${param.success eq 'created' or param.success eq 'updated' or param.error eq 'duplicate'}">
                    <div class="toast toast--${not empty param.success ? 'success' : 'error'}" id="gToast">
                        <span class="toast__icon">${not empty param.success ? '&#10003;' : '&#9888;'}</span>
                        <span id="toastMsg">
                            <c:choose>
                                <c:when test="${param.success eq 'created'}">Cảm ơn! Đánh giá của bạn đã được gửi thành công ✨</c:when>
                                <c:when test="${param.success eq 'updated'}">Cập nhật đánh giá thành công!</c:when>
                                <c:otherwise>Bạn đã đánh giá sản phẩm này rồi.</c:otherwise>
                            </c:choose>
                        </span>
                        <button class="toast__close" onclick="hideToast()">&#x2715;</button>
                        <c:if test="${not empty param.success}">
                            <div class="toast__progress"></div>
                        </c:if>
                    </div>
                </c:if>

                <%-- Tiêu đề --%>
                <h1 class="rv-title">
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
                                    <div class="rv-card__user">
                                        <div class="rv-card__avatar">
                                            ${fn:substring(rv.reviewerName, 0, 1)}
                                        </div>
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
                                    </div>

                                    <%-- Nút Sửa nếu là review của user đang đăng nhập --%>
                                    <c:if test="${sessionScope.acc != null && rv.userId == sessionScope.acc.id}">
                                        <a class="btn-edit" href="${ctx}/review/write?id=${rv.reviewId}">Sửa</a>
                                    </c:if>
                                </div>

                                <p class="rv-card__content">${rv.reviewContent}</p>

                                <%-- Ảnh đính kèm (nếu có) --%>
                                <c:if test="${not empty rv.images}">
                                    <div class="rv-imgs">
                                        <c:forEach items="${rv.images}" var="img">
                                            <img src="${img.imageUrl}" alt="Review image">
                                        </c:forEach>
                                    </div>
                                </c:if>

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

        <script>
            // Tự động hiện toast khi trang load xong
            (function() {
                var toast = document.getElementById('gToast');
                if (!toast) return;

                // Hiện toast với animation
                setTimeout(function() {
                    toast.classList.add('show');
                }, 100);

                // Tự ẩn sau 4 giây
                setTimeout(function() {
                    hideToast();
                }, 4500);
            })();

            function hideToast() {
                var toast = document.getElementById('gToast');
                if (toast) {
                    toast.classList.remove('show');
                }
            }
        </script>
    </body>
</html>
