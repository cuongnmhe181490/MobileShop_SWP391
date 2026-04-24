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
        <style>
            /* Comparison Toolbar */
            .detail-toolbar {
                display: flex;
                gap: 20px;
                margin: 20px 0;
                padding: 12px 0;
                border-bottom: 1px solid #F1F5F9;
            }
            .tool-item {
                display: flex;
                align-items: center;
                gap: 8px;
                color: var(--brand);
                font-weight: 700;
                font-size: 14px;
                text-decoration: none;
                cursor: pointer;
                transition: opacity 0.2s;
            }
            .tool-item:hover { opacity: 0.7; }
            .tool-item i { font-size: 18px; }

            /* Floating Compare Bar */
            .compare-bar {
                position: fixed;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%) translateY(110%);
                width: 95%;
                max-width: 1000px;
                background: #FFF;
                box-shadow: 0 -10px 40px rgba(14, 29, 53, 0.15);
                border-radius: 20px 20px 0 0;
                padding: 20px 32px;
                z-index: 1000;
                display: flex;
                align-items: center;
                gap: 24px;
                transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                visibility: hidden;
            }
            .compare-bar.show { 
                transform: translateX(-50%) translateY(0); 
                visibility: visible;
            }
            .compare-slots {
                display: flex;
                gap: 16px;
                flex: 1;
            }
            .compare-slot {
                width: 140px;
                height: 100px;
                border: 2px dashed #D8DCE8;
                border-radius: 12px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                position: relative;
                overflow: hidden;
                background: #F8F9FC;
                transition: all 0.2s;
            }
            .compare-slot:hover { border-color: var(--brand); background: #FFF; }
            .compare-slot img { width: 60px; height: 60px; object-fit: contain; }
            .compare-slot span { font-size: 10px; text-align: center; color: var(--text-muted); padding: 0 4px; }
            .compare-slot .remove-btn {
                position: absolute;
                top: 4px; right: 4px;
                background: rgba(220, 38, 38, 0.8);
                color: #FFF;
                width: 18px; height: 18px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                z-index: 2;
            }

            .compare-actions { text-align: right; min-width: 200px; }
            .compare-count { font-size: 13px; font-weight: 700; margin-bottom: 8px; display: block; }
            .btn-compare-start {
                background: var(--brand);
                color: #FFF;
                border: none;
                padding: 10px 24px;
                border-radius: 99px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s;
                width: 100%;
            }
            .btn-compare-start:disabled { background: #D8DCE8; cursor: not-allowed; }

            /* Modal */
            .compare-modal {
                position: fixed;
                inset: 0;
                background: rgba(14, 29, 53, 0.6);
                backdrop-filter: blur(4px);
                z-index: 1001;
                display: none;
                align-items: center;
                justify-content: center;
            }
            .compare-modal.show { display: flex; }
            .modal-content {
                background: #FFF;
                width: 90%;
                max-width: 600px;
                border-radius: 24px;
                padding: 32px;
                max-height: 80vh;
                display: flex;
                flex-direction: column;
            }
            .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
            .search-input {
                width: 100%;
                padding: 14px 20px;
                border: 1px solid #D8DCE8;
                border-radius: 12px;
                font-size: 15px;
                outline: none;
            }
            .search-input:focus { border-color: var(--brand); box-shadow: 0 0 0 4px var(--brand-soft); }
            .product-list { overflow-y: auto; margin-top: 16px; }
            .list-item {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 12px;
                border-radius: 12px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .list-item:hover { background: #F1F5F9; }
            .list-item img { width: 50px; height: 50px; object-fit: contain; }
            .list-item-info { flex: 1; }
            .list-item-name { font-weight: 700; font-size: 14px; }
            .list-item-price { font-size: 13px; color: var(--brand); font-weight: 800; }
            .btn-select {
                padding: 6px 16px;
                border-radius: 99px;
                border: 1px solid var(--brand);
                color: var(--brand);
                font-weight: 700;
                font-size: 12px;
                background: #FFF;
            }

            .btn-collapse {
                background: #F1F5F9;
                border: none;
                padding: 10px 20px;
                border-radius: 99px;
                font-weight: 600;
                margin-right: 8px;
                cursor: pointer;
            }
        </style>
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
                        <input type="hidden" id="currentProductName" value="<c:out value='${detail.productName}' />">
                        <input type="hidden" id="currentProductImage" value="${detail.imagePath}">
                        <div class="detail-toolbar">
                            <a class="tool-item" href="${ctx}/reviews?pid=${detail.idProduct}"><i class="fa-regular fa-comment-dots"></i> Hỏi đáp</a>
                            <a class="tool-item" onclick="initCompare()"><i class="fa-solid fa-circle-plus"></i> So sánh</a>
                        </div>
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

        <%-- Comparison Bar --%>
        <div id="compareBar" class="compare-bar">
            <div class="compare-slots" id="compareSlots">
                <!-- Slots will be injected here -->
            </div>
            <div class="compare-actions">
                <span class="compare-count" id="compareCountLabel">Đã chọn 1 sản phẩm</span>
                <div style="display: flex;">
                    <button class="btn-collapse" onclick="toggleCompareBar(false)">Thu gọn</button>
                    <button id="btnCompareGo" class="btn-compare-start" onclick="goCompare()">So sánh</button>
                </div>
            </div>
        </div>

        <%-- Selection Modal --%>
        <div id="compareModal" class="compare-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 style="font-weight: 800; margin: 0;">Chọn sản phẩm so sánh</h3>
                    <button style="border:none;background:none;font-size:24px;cursor:pointer;" onclick="closeModal()">×</button>
                </div>
                <input type="text" class="search-input" id="pSearch" placeholder="Tìm tên sản phẩm..." oninput="fetchProducts()">
                <div class="product-list" id="pList">
                    <!-- Products injected here -->
                </div>
            </div>
        </div>

        <script>
            let currentCompare = JSON.parse(localStorage.getItem('mobileShopCompare') || '[]');
            const currentPid = '${detail.idProduct}';

            function initCompare() {
                // Start fresh for this product session
                currentCompare = [];
                
                const pName = document.getElementById('currentProductName').value;
                const pImage = document.getElementById('currentProductImage').value;

                // Add current product
                currentCompare.push({
                    id: currentPid,
                    name: pName,
                    image: pImage
                });
                
                saveCompare();
                renderCompareBar();
                toggleCompareBar(true);
            }

            function saveCompare() {
                localStorage.setItem('mobileShopCompare', JSON.stringify(currentCompare));
            }

            function renderCompareBar() {
                const container = document.getElementById('compareSlots');
                container.innerHTML = '';
                
                for (let i = 0; i < 3; i++) {
                    const p = currentCompare[i];
                    const slot = document.createElement('div');
                    slot.className = 'compare-slot';
                    
                    if (p) {
                        slot.innerHTML = `
                            <div class="remove-btn" onclick="removeFromCompare('\${p.id}', event)">×</div>
                            <img src="\${p.image}">
                            <span>\${p.name}</span>
                        `;
                    } else {
                        slot.innerHTML = `
                            <i class="fa-solid fa-plus-circle" style="color: #D8DCE8; font-size: 24px;"></i>
                            <span style="margin-top: 8px;">Chọn sản phẩm so sánh</span>
                        `;
                        slot.onclick = openModal;
                    }
                    container.appendChild(slot);
                }
                
                document.getElementById('compareCountLabel').innerText = `Đã chọn ${currentCompare.length} sản phẩm`;
                document.getElementById('btnCompareGo').disabled = currentCompare.length < 2;
            }

            function removeFromCompare(id, e) {
                if (e) e.stopPropagation();
                // Sync first
                currentCompare = JSON.parse(localStorage.getItem('mobileShopCompare') || '[]');
                currentCompare = currentCompare.filter(p => p.id != id);
                saveCompare();
                renderCompareBar();
                if (currentCompare.length === 0) toggleCompareBar(false);
            }

            function toggleCompareBar(show) {
                document.getElementById('compareBar').classList.toggle('show', show);
            }

            function openModal() {
                document.getElementById('compareModal').classList.add('show');
                fetchProducts();
            }

            function closeModal() {
                document.getElementById('compareModal').classList.remove('show');
            }

            function fetchProducts() {
                const q = document.getElementById('pSearch').value;
                fetch(`${ctx}/compare/api/list?q=` + encodeURIComponent(q))
                    .then(r => r.json())
                    .then(data => {
                        const list = document.getElementById('pList');
                        list.innerHTML = '';
                        data.forEach(p => {
                            // Don't show if already in compare
                            if (currentCompare.find(cp => cp.id === p.id)) return;
                            
                            const div = document.createElement('div');
                            div.className = 'list-item';
                            div.onclick = () => selectForCompare(p);
                            div.innerHTML = `
                                <img src="\${p.image}">
                                <div class="list-item-info">
                                    <div class="list-item-name">\${p.name}</div>
                                    <div class="list-item-price">\${new Intl.NumberFormat('vi-VN').format(p.price)}đ</div>
                                </div>
                                <button class="btn-select">Chọn</button>
                            `;
                            list.appendChild(div);
                        });
                    });
            }

            function selectForCompare(p) {
                // Sync first
                currentCompare = JSON.parse(localStorage.getItem('mobileShopCompare') || '[]');
                
                if (currentCompare.length >= 3) {
                    alert('Chỉ có thể so sánh tối đa 3 sản phẩm.');
                    return;
                }
                currentCompare.push(p);
                saveCompare();
                renderCompareBar();
                closeModal();
                toggleCompareBar(true);
            }

            function goCompare() {
                let url = '${ctx}/compare?';
                currentCompare.forEach((p, idx) => {
                    url += (idx === 0 ? '' : '&') + 'pid' + (idx + 1) + '=' + p.id;
                });
                window.location.href = url;
            }

            // Reset comparison list on load for a fresh start on each product
            window.addEventListener('load', () => {
                localStorage.removeItem('mobileShopCompare');
                currentCompare = [];
                renderCompareBar();
                // Ensure hidden by default on load
                toggleCompareBar(false);
            });
        </script>
    </body>
</html>
