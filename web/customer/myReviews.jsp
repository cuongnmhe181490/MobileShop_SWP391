<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            .my-shell {
                max-width: 800px;
                margin: 0 auto;
                padding: 40px 20px;
            }
            .my-shell h1 {
                font-size: 22px;
                font-weight: 700;
                margin-bottom: 6px;
                color: var(--color-text-primary);
            }
            .my-shell .sub {
                font-size: 14px;
                color: var(--color-text-secondary);
                margin-bottom: 28px;
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

            /* Card */
            .rv-card {
                display: flex;
                gap: 16px;
                padding: 20px;
                background: var(--color-background-secondary);
                border-radius: 14px;
                border: 1px solid var(--color-border-tertiary);
                margin-bottom: 14px;
            }
            .rv-card__thumb {
                width: 72px;
                height: 72px;
                object-fit: cover;
                border-radius: 10px;
                flex-shrink: 0;
            }
            .rv-card__thumb-placeholder {
                width: 72px;
                height: 72px;
                border-radius: 10px;
                background: var(--color-background-tertiary);
                flex-shrink: 0;
            }
            .rv-card__body {
                flex: 1;
                min-width: 0;
            }
            .rv-card__product {
                font-weight: 600;
                font-size: 15px;
                color: var(--color-text-primary);
                margin-bottom: 4px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .rv-card__meta {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 12px;
                color: var(--color-text-secondary);
                flex-wrap: wrap;
            }
            .rv-card__content {
                font-size: 13px;
                color: var(--color-text-secondary);
                margin-top: 8px;
                line-height: 1.6;
            }

            /* Stars */
            .stars {
                display: inline-flex;
                gap: 1px;
            }
            .stars span {
                font-size: 13px;
                color: #d1d5db;
            }
            .stars span.on {
                color: #f59e0b;
            }

            /* Status badge */
            .badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 999px;
                font-size: 11px;
                font-weight: 700;
            }
            .badge--visible {
                background: #dcfce7;
                color: #166534;
            }
            .badge--hidden  {
                background: #fee2e2;
                color: #991b1b;
            }

            /* Tag badge */
            .tag-badge {
                display: inline-block;
                padding: 1px 10px;
                background: #EEF3FD; 
                color: #3B6FE8;
                border-radius: 4px;
                font-size: 10px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.03em;
                margin-right: 8px;
            }
            .tag-badge--qa {
                background: #FFF7ED;
                color: #EA580C;
            }

            /* Admin reply */
            .rv-reply {
                margin-top: 10px;
                padding: 10px 14px;
                border-radius: 10px;
                background: #f0fdf4;
                border-left: 3px solid #16a34a;
            }
            .rv-reply__label {
                font-size: 11px;
                font-weight: 700;
                color: #16a34a;
                margin-bottom: 3px;
            }
            .rv-reply__text  {
                font-size: 13px;
                color: #166534;
            }

            /* Actions */
            .rv-card__actions {
                display: flex;
                flex-direction: column;
                gap: 8px;
                flex-shrink: 0;
                align-items: flex-end;
            }
            .btn-edit {
                padding: 6px 16px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
                background: #f0f9ff;
                color: #0284c7;
                border: 1px solid #bae6fd;
                text-decoration: none;
                white-space: nowrap;
            }
            .btn-edit:hover {
                background: #e0f2fe;
            }
            .btn-delete {
                padding: 6px 16px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fecaca;
                cursor: pointer;
                white-space: nowrap;
            }
            .btn-delete:hover {
                background: #fee2e2;
            }

            /* Empty */
            .empty-state {
                text-align: center;
                padding: 60px 0;
            }
            .empty-state p {
                color: var(--color-text-secondary);
                font-size: 14px;
                margin-bottom: 16px;
            }
            .btn-browse {
                display: inline-block;
                padding: 10px 24px;
                border-radius: 999px;
                background: #0284c7;
                color: #fff;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
            }

            /* Tabs */
            .my-tabs {
                display: flex;
                gap: 32px;
                margin-bottom: 24px;
                border-bottom: 1px solid var(--line);
                padding-bottom: 1px;
            }
            .tab-btn {
                background: none;
                border: none;
                padding: 12px 0;
                font-size: 14px;
                font-weight: 700;
                color: var(--muted);
                cursor: pointer;
                position: relative;
                transition: 0.3s;
            }
            .tab-btn:hover { color: var(--text); }
            .tab-btn.active { color: var(--accent); }
            .tab-btn.active::after {
                content: '';
                position: absolute;
                bottom: -1px;
                left: 0;
                right: 0;
                height: 2px;
                background: var(--accent);
            }
            .tab-pane {
                display: none;
            }
            .tab-pane.active {
                display: block;
                animation: fadeIn 0.3s ease;
            }
            @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

            /* Confirm modal */
            .modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.4);
                backdrop-filter: blur(4px);
                z-index: 1000;
                align-items: center;
                justify-content: center;
            }
            .modal-overlay.open {
                display: flex;
            }
            .modal-box {
                background: #ffffff;
                border-radius: 20px;
                padding: 32px;
                max-width: 380px;
                width: 90%;
                text-align: center;
                box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            }
            .modal-box h2 {
                font-size: 18px;
                font-weight: 800;
                margin-bottom: 10px;
                color: #0f172a;
            }
            .modal-box p  {
                font-size: 14px;
                color: #64748b;
                margin-bottom: 24px;
                line-height: 1.6;
            }
            .modal-actions {
                display: flex;
                gap: 12px;
                justify-content: center;
            }
            .btn-confirm-del {
                padding: 10px 24px;
                border-radius: 999px;
                background: #ef4444;
                color: #fff;
                font-size: 14px;
                font-weight: 700;
                border: none;
                cursor: pointer;
                transition: 0.2s;
            }
            .btn-confirm-del:hover { background: #dc2626; }
            .btn-confirm-cancel {
                padding: 10px 24px;
                border-radius: 999px;
                font-size: 14px;
                font-weight: 600;
                border: 1px solid #e2e8f0;
                color: #64748b;
                background: #f8fafc;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main>
            <div class="my-shell">
                <h1>Đánh giá của tôi</h1>
                <p class="sub">Danh sách các sản phẩm bạn đã đánh giá</p>

                <c:if test="${successMsg eq 'updated'}">
                    <div class="rv-alert rv-alert--success">Đánh giá đã được cập nhật thành công.</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="empty-state">
                            <p>Bạn chưa có đánh giá nào.</p>
                            <a class="btn-browse" href="${ctx}/product">Khám phá sản phẩm</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="my-tabs">
                            <button class="tab-btn active" onclick="switchTab('product', this)">Đánh giá Sản phẩm</button>
                            <button class="tab-btn" onclick="switchTab('service', this)">Đánh giá Dịch vụ</button>
                        </div>

                        <!-- TAB: Sản phẩm -->
                        <div id="tab-product" class="tab-pane active">
                            <c:set var="hasProduct" value="false" />
                            <c:forEach items="${reviews}" var="rv">
                                <c:if test="${rv.reviewType eq 'PRODUCT'}">
                                    <c:set var="hasProduct" value="true" />
                                    <div class="rv-card">
                                        <%-- Ảnh sản phẩm --%>
                                        <c:choose>
                                            <c:when test="${not empty rv.productImage}">
                                                <img class="rv-card__thumb" src="${rv.productImage}" alt="${rv.productName}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rv-card__thumb-placeholder"></div>
                                            </c:otherwise>
                                        </c:choose>

                                        <%-- Nội dung --%>
                                        <div class="rv-card__body">
                                            <div style="display: flex; align-items: center; margin-bottom: 2px;">
                                                <span class="tag-badge ${rv.reviewContent.contains('?') ? 'tag-badge--qa' : ''}">
                                                    ${rv.reviewContent.contains('?') ? 'Hỏi đáp' : 'Sản phẩm'}
                                                </span>
                                                <div class="rv-card__product" style="margin: 0;">${rv.productName}</div>
                                            </div>
                                    <div class="rv-card__meta">
                                        <span class="stars">
                                            <c:forEach begin="1" end="5" var="s">
                                                <span class="${s <= rv.ranking ? 'on' : ''}">★</span>
                                            </c:forEach>
                                        </span>
                                        <span>·</span>
                                        <fmt:formatDate value="${rv.reviewDate}" pattern="dd/MM/yyyy"/>
                                        <span>·</span>
                                        <span class="badge badge--${rv.status eq 'VISIBLE' ? 'visible' : 'hidden'}">
                                            ${rv.status eq 'VISIBLE' ? 'Đang hiển thị' : 'Đang ẩn'}
                                        </span>
                                    </div>
                                    <p class="rv-card__content">${rv.reviewContent}</p>

                                    <%-- Ảnh review --%>
                                    <c:if test="${not empty rv.images}">
                                        <div class="rv-card__images" style="display: flex; gap: 8px; margin-top: 12px; flex-wrap: wrap;">
                                            <c:forEach items="${rv.images}" var="img">
                                                <img src="${img.imageUrl}" 
                                                     style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid var(--color-border-primary);"
                                                     alt="Review image">
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
                                </div>

                                <%-- Nút Sửa / Xóa --%>
                                <div class="rv-card__actions">
                                    <a class="btn-edit" href="${ctx}/review/write?id=${rv.reviewId}">Sửa</a>
                                    <button class="btn-delete" onclick="confirmDelete(${rv.reviewId}, '${rv.productName}')">Xóa</button>
                                </div>
                            </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasProduct}">
                                <div class="empty-state">
                                    <p>Bạn chưa có đánh giá nào cho riêng thẻ Sản phẩm.</p>
                                </div>
                            </c:if>
                        </div>

                        <!-- TAB: Dịch vụ -->
                        <div id="tab-service" class="tab-pane">
                            <c:set var="hasService" value="false" />
                            <c:forEach items="${reviews}" var="rv">
                                <c:if test="${rv.reviewType eq 'SERVICE'}">
                                    <c:set var="hasService" value="true" />
                                    <div class="rv-card">
                                        <div class="rv-card__thumb-placeholder" style="display:flex; align-items:center; justify-content:center; font-size:24px; color:#d1d5db; background:#f8fafc; border:1px solid #e2e8f0;">⭐</div>
                                        <div class="rv-card__body">
                                            <div style="display: flex; align-items: center; margin-bottom: 2px;">
                                                <span class="tag-badge">Dịch vụ</span>
                                                <div class="rv-card__product" style="margin: 0;">Chất lượng dịch vụ</div>
                                            </div>
                                            <div class="rv-card__meta">
                                                <span class="stars">
                                                    <c:forEach begin="1" end="5" var="s">
                                                        <span class="${s <= rv.ranking ? 'on' : ''}">★</span>
                                                    </c:forEach>
                                                </span>
                                                <span>·</span>
                                                <fmt:formatDate value="${rv.reviewDate}" pattern="dd/MM/yyyy"/>
                                                <span>·</span>
                                                <span class="badge badge--${rv.status eq 'VISIBLE' ? 'visible' : 'hidden'}">
                                                    ${rv.status eq 'VISIBLE' ? 'Đang hiển thị' : 'Đang ẩn'}
                                                </span>
                                            </div>
                                            <p class="rv-card__content" style="font-weight:600; color:#334155; margin-bottom:4px;">${rv.reviewTopic}</p>
                                            <p class="rv-card__content" style="margin-top:0;">${rv.reviewContent}</p>

                                            <%-- Ảnh review --%>
                                            <c:if test="${not empty rv.images}">
                                                <div class="rv-card__images" style="display: flex; gap: 8px; margin-top: 12px; flex-wrap: wrap;">
                                                    <c:forEach items="${rv.images}" var="img">
                                                        <img src="${img.imageUrl}" style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid var(--color-border-primary);" alt="Review image">
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
                                        </div>

                                        <%-- Nút Sửa / Xóa --%>
                                        <div class="rv-card__actions">
                                            <a class="btn-edit" href="${ctx}/review/write?id=${rv.reviewId}">Sửa</a>
                                            <button class="btn-delete" onclick="confirmDelete(${rv.reviewId}, 'Đánh giá dịch vụ')">Xóa</button>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasService}">
                                <div class="empty-state">
                                    <p>Bạn chưa có đánh giá dịch vụ nào.</p>
                                    <a class="btn-browse" href="${ctx}/contact">Đánh giá dịch vụ ngay</a>
                                </div>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <%-- Modal xác nhận xóa --%>
        <div class="modal-overlay" id="deleteModal">
            <div class="modal-box">
                <h2>Xóa đánh giá?</h2>
                <p id="modalDesc">Bạn có chắc muốn xóa đánh giá này không?</p>
                <div class="modal-actions">
                    <form method="post" action="${ctx}/review/mine" id="deleteForm">
                        <input type="hidden" name="action"   value="delete"/>
                        <input type="hidden" name="reviewId" id="deleteReviewId" value=""/>
                        <div class="modal-actions">
                            <button type="button" class="btn-confirm-cancel"
                                    onclick="closeModal()">Hủy</button>
                            <button type="submit" class="btn-confirm-del">Xóa</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <script>
            function switchTab(tabId, btnElement) {
                // Remove active classes
                document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
                document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
                // Add active to current
                btnElement.classList.add('active');
                document.getElementById('tab-' + tabId).classList.add('active');
            }

            function confirmDelete(reviewId, productName) {
                document.getElementById('deleteReviewId').value = reviewId;
                document.getElementById('modalDesc').textContent =
                        'Bạn có chắc muốn xóa "' + productName + '"?';
                document.getElementById('deleteModal').classList.add('open');
            }
            function closeModal() {
                document.getElementById('deleteModal').classList.remove('open');
            }
            document.getElementById('deleteModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeModal();
            });

            // Auto-hide success alert
            window.addEventListener('DOMContentLoaded', () => {
                const alert = document.querySelector('.rv-alert--success');
                if (alert) {
                    setTimeout(() => {
                        alert.style.transition = '0.5s opacity';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.style.display = 'none', 500);
                    }, 3000);
                }
            });
        </script>
    </body>
</html>
