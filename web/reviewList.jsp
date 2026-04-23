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
                border: none;
                cursor: pointer;
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

            :root {
                --color-primary: #0284c7;
                --color-primary-hover: #0369a1;
                --color-bg: #f8fafc;
                --color-surface: #ffffff;
                --color-text-main: #0f172a;
                --color-text-secondary: #64748b;
                --color-border: #e2e8f0;
                --color-red: #d70018; /* Cellphones red */
                --font-main: 'Inter', sans-serif;
            }

            /* ─── TABS ─── */
            .rv-tabs {
                display: flex;
                gap: 30px;
                border-bottom: 2px solid var(--color-border);
                margin-bottom: 24px;
            }
            .rv-tab {
                font-size: 16px;
                font-weight: 700;
                color: var(--color-text-secondary);
                padding: 12px 0;
                cursor: pointer;
                position: relative;
                transition: color 0.3s;
            }
            .rv-tab.active {
                color: var(--color-primary);
            }
            .rv-tab::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 100%;
                height: 2px;
                background: var(--color-primary);
                transform: scaleX(0);
                transition: transform 0.3s;
            }
            .rv-tab.active::after {
                transform: scaleX(1);
            }
            .tab-content {
                display: none;
            }
            .tab-content.active {
                display: block;
                animation: fadeIn 0.4s ease forwards;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }

            /* ─── Q&A FORM (CellphoneS Style) ─── */
            .qa-box {
                background: #ffffff;
                border-radius: 12px;
                border: 1px solid var(--color-border);
                padding: 24px;
                display: flex;
                gap: 24px;
                align-items: flex-start;
                margin-bottom: 30px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            }
            .qa-box__mascot {
                width: 80px;
                flex-shrink: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--color-primary);
                background: #e0f2fe;
                border-radius: 50%;
                height: 80px;
                font-size: 32px;
            }
            .qa-box__main {
                flex: 1;
            }
            .qa-box__title {
                font-size: 16px;
                font-weight: 700;
                color: var(--color-text-main);
                margin-bottom: 8px;
            }
            .qa-box__desc {
                font-size: 13px;
                color: var(--color-text-secondary);
                line-height: 1.5;
                margin-bottom: 16px;
            }
            .qa-box__input-group {
                display: flex;
                gap: 12px;
            }
            .qa-box__input {
                flex: 1;
                border: 1px solid var(--color-border);
                border-radius: 8px;
                padding: 12px 16px;
                font-size: 14px;
                outline: none;
                transition: border-color 0.2s;
            }
            .qa-box__input:focus {
                border-color: var(--color-primary);
                box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.1);
            }
            .qa-box__btn {
                background: var(--color-primary);
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 0 24px;
                font-weight: 700;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .qa-box__btn:hover {
                background: var(--color-primary-hover);
                transform: translateY(-1px);
            }
            
            /* Disabled writing button */
            .btn-write.disabled {
                background: #e2e8f0;
                color: #94a3b8;
                border-color: #cbd5e1;
                cursor: not-allowed;
                box-shadow: none;
            }
            .btn-write.disabled:hover {
                transform: none;
            }

            /* ─── Custom Modal & Toast ─── */
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

            /* ─── Login Modal ─── */
            .login-modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.5);
                backdrop-filter: blur(4px);
                z-index: 1000;
                align-items: center;
                justify-content: center;
            }
            .login-modal-overlay.active {
                display: flex;
            }
            .login-modal {
                background: #ffffff;
                border-radius: 24px;
                padding: 40px 36px;
                max-width: 380px;
                width: 90%;
                text-align: center;
                position: relative;
                box-shadow: 0 25px 60px rgba(0,0,0,0.15);
                animation: modalIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            }
            @keyframes modalIn {
                from { opacity: 0; transform: scale(0.92) translateY(16px); }
                to   { opacity: 1; transform: scale(1)    translateY(0);     }
            }
            .login-modal__close {
                position: absolute;
                top: 16px; right: 20px;
                background: none;
                border: none;
                font-size: 22px;
                color: #94a3b8;
                cursor: pointer;
                line-height: 1;
                padding: 4px;
                border-radius: 6px;
                transition: color 0.2s, background 0.2s;
            }
            .login-modal__close:hover {
                color: #0f172a;
                background: #f1f5f9;
            }
            .login-modal__icon {
                font-size: 48px;
                margin-bottom: 16px;
                display: block;
            }
            .login-modal__title {
                font-size: 20px;
                font-weight: 800;
                color: #0f172a;
                margin: 0 0 10px;
            }
            .login-modal__desc {
                font-size: 14px;
                color: #64748b;
                line-height: 1.6;
                margin: 0 0 28px;
            }
            .login-modal__actions {
                display: flex;
                gap: 10px;
                justify-content: center;
            }
            .login-modal__btn-primary {
                padding: 12px 28px;
                border-radius: 999px;
                background: linear-gradient(135deg, #0284c7, #2563eb);
                color: #fff;
                font-size: 14px;
                font-weight: 700;
                text-decoration: none;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
            }
            .login-modal__btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
            }
            .login-modal__btn-secondary {
                padding: 12px 24px;
                border-radius: 999px;
                background: #f1f5f9;
                color: #475569;
                font-size: 14px;
                font-weight: 600;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .login-modal__btn-secondary:hover {
                background: #e2e8f0;
                color: #0f172a;
            }
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

                <%-- Tabs Header --%>
                <div class="rv-tabs">
                    <div class="rv-tab ${empty param.success or param.success ne 'asked' ? 'active' : ''}" onclick="switchTab('reviews')">Đánh giá sản phẩm</div>
                    <div class="rv-tab ${param.success eq 'asked' ? 'active' : ''}" onclick="switchTab('qa')">Hỏi và đáp</div>
                </div>

                <div id="tab-reviews" class="tab-content ${empty param.success or param.success ne 'asked' ? 'active' : ''}">
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

                        <%-- Nút viết review: Nếu chưa login -> modal. Nếu đã login, kiểm tra mua hàng --%>
                        <c:choose>
                            <c:when test="${!loggedIn}">
                                <button class="btn-write" onclick="openLoginModal()">✦ Viết đánh giá</button>
                            </c:when>
                            <c:when test="${hasPurchased}">
                                <a class="btn-write" href="${ctx}/review/write?pid=${pid}">✦ Viết đánh giá</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-write disabled" onclick="alert('Bạn cần mua và nhận sản phẩm này thành công để có thể viết đánh giá.')">✦ Viết đánh giá</button>
                            </c:otherwise>
                        </c:choose>
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

                </div> <!-- End tab-reviews -->

                <div id="tab-qa" class="tab-content ${param.success eq 'asked' ? 'active' : ''}">
                    <%-- Q&A Form MobileShop Style --%>
                    <div class="qa-box">
                        <div class="qa-box__mascot">
                            <i class="fa-solid fa-comments"></i>
                        </div>
                        <div class="qa-box__main">
                            <div class="qa-box__title">Hãy đặt câu hỏi cho chúng tôi</div>
                            <div class="qa-box__desc">
                                Chúng tôi sẽ phản hồi trong vòng 1 giờ. Thông tin có thể thay đổi theo thời gian, vui lòng đặt câu hỏi để nhận được cập nhật mới nhất!
                            </div>
                            <c:choose>
                                <c:when test="${loggedIn}">
                                    <form action="${ctx}/reviews" method="POST" class="qa-box__input-group">
                                        <input type="hidden" name="pid" value="${pid}">
                                        <input type="text" name="questionContent" class="qa-box__input" placeholder="Viết câu hỏi của bạn tại đây" required maxlength="500">
                                        <button type="submit" class="qa-box__btn">Gửi câu hỏi <i class="fa-regular fa-paper-plane"></i></button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="qa-box__input-group">
                                        <input type="text" class="qa-box__input" placeholder="Đăng nhập để đặt câu hỏi..." onclick="openLoginModal()" readonly style="cursor: pointer;">
                                        <button type="button" class="qa-box__btn" onclick="openLoginModal()">Gửi câu hỏi <i class="fa-regular fa-paper-plane"></i></button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- Danh sách Hỏi đáp --%>
                    <c:choose>
                        <c:when test="${empty questions}">
                            <p style="color:var(--color-text-secondary);text-align:center;padding:40px 0">
                                Chưa có câu hỏi nào. Hãy là người đầu tiên đặt câu hỏi!
                            </p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${questions}" var="q">
                                <article class="rv-card">
                                    <div class="rv-card__top">
                                        <div class="rv-card__user">
                                            <div class="rv-card__avatar">
                                                ${fn:substring(q.reviewerName, 0, 1)}
                                            </div>
                                            <div>
                                                <div class="rv-card__name">${q.reviewerName}</div>
                                                <div class="rv-card__meta">
                                                    <span style="color:#0284c7; font-weight: 600; font-size: 11px; background: #e0f2fe; padding: 2px 6px; border-radius: 4px;">Câu hỏi</span>
                                                    &nbsp;·&nbsp;
                                                    <fmt:formatDate value="${q.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <p class="rv-card__content" style="font-weight: 600; font-size: 16px;">${q.reviewContent}</p>

                                    <%-- Phản hồi Admin cho câu hỏi --%>
                                    <c:if test="${not empty q.replyContent}">
                                        <div class="rv-reply">
                                            <div class="rv-reply__label">
                                                <i class="fa-solid fa-headset"></i> Phản hồi từ Admin
                                            </div>
                                            <div class="rv-reply__text">
                                                ${q.replyContent}
                                            </div>
                                        </div>
                                    </c:if>
                                </article>
                            </c:forEach>
                            
                            <%-- Phân trang cho câu hỏi --%>
                            <c:if test="${totalQPages > 1}">
                                <div class="rv-pagination pagination">
                                    <c:forEach begin="1" end="${totalQPages}" var="p">
                                        <c:choose>
                                            <c:when test="${p == currentQPage}">
                                                <span class="page-btn active">${p}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-btn" href="?pid=${pid}&qpage=${p}#qa-tab">${p}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div> <!-- End tab-qa -->

            </div>
        </main>

        <%-- ─── Modal yêu cầu đăng nhập ─── --%>
        <div class="login-modal-overlay" id="loginModalOverlay" onclick="handleOverlayClick(event)">
            <div class="login-modal">
                <button class="login-modal__close" onclick="closeLoginModal()">&#x2715;</button>
                <span class="login-modal__icon">⭐</span>
                <h3 class="login-modal__title">Vui lòng đăng nhập</h3>
                <p class="login-modal__desc">
                    Bạn cần đăng nhập để có thể viết đánh giá cho sản phẩm này.
                </p>
                <div class="login-modal__actions">
                    <a class="login-modal__btn-primary"
                       href="${ctx}/login.jsp?redirect=${ctx}/review/write?pid=${pid}">
                        Đăng nhập
                    </a>
                    <button class="login-modal__btn-secondary" onclick="closeLoginModal()">
                        Để sau
                    </button>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <script>
            // ── Toast ──
            (function() {
                var toast = document.getElementById('gToast');
                if (!toast) return;
                setTimeout(function() { toast.classList.add('show'); }, 100);
                setTimeout(function() { hideToast(); }, 4500);
            })();

            function hideToast() {
                var toast = document.getElementById('gToast');
                if (toast) toast.classList.remove('show');
            }

            // ── Login Modal ──
            function openLoginModal() {
                document.getElementById('loginModalOverlay').classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeLoginModal() {
                document.getElementById('loginModalOverlay').classList.remove('active');
                document.body.style.overflow = '';
            }

            // Đóng khi click ra vùng tối bên ngoài modal
            function handleOverlayClick(e) {
                if (e.target === document.getElementById('loginModalOverlay')) {
                    closeLoginModal();
                }
            }

            // Đóng khi bấm Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') closeLoginModal();
            });

            // ── Tabs Switcher ──
            function switchTab(tabId) {
                // Update tab buttons
                document.querySelectorAll('.rv-tab').forEach(t => t.classList.remove('active'));
                if(tabId === 'reviews') {
                    document.querySelector('.rv-tab:nth-child(1)').classList.add('active');
                } else if (tabId === 'qa') {
                    document.querySelector('.rv-tab:nth-child(2)').classList.add('active');
                }

                // Update tab contents
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
                document.getElementById('tab-' + tabId).classList.add('active');
            }

            // Auto-switch based on hash URL or param success
            window.addEventListener('DOMContentLoaded', () => {
                if (window.location.hash === '#qa-tab') {
                    switchTab('qa');
                }
            });
        </script>
    </body>
</html>
