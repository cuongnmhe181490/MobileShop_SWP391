<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <title>So sánh sản phẩm - MobileShop</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --brand: #2563EB; /* Xanh hiện đại hơn */
                --brand-hover: #1D4ED8;
                --brand-soft: #EFF6FF;
                --bg: #F8F9FC;
                --white: #FFFFFF;
                --text-main: #0E1D35;
                --text-muted: #64748B;
                --border: #E2E8F0;
                --border-strong: #94A3B8;
            }

            body {
                background-color: var(--bg);
                font-family: 'Plus Jakarta Sans', sans-serif;
                color: var(--text-main);
                margin: 0;
            }

            .compare-shell {
                max-width: 1300px;
                margin: 60px auto 100px;
                padding: 0 24px;
            }

            .compare-header {
                text-align: center;
                margin-bottom: 64px;
            }

            .compare-header h1 {
                font-size: 40px;
                font-weight: 800;
                margin-bottom: 16px;
                letter-spacing: -1px;
                background: linear-gradient(135deg, #0F172A 0%, #2563EB 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .compare-header p {
                color: var(--text-muted);
                font-size: 18px;
                font-weight: 500;
            }

            .compare-grid {
                display: grid;
                grid-template-columns: 240px repeat(auto-fit, minmax(300px, 1fr));
                background: var(--white);
                border-radius: 24px;
                box-shadow: 0 25px 60px rgba(14, 29, 53, 0.12);
                overflow: hidden;
                border: 2px solid var(--border-strong);
            }

            .compare-row {
                display: contents;
            }

            .compare-cell {
                padding: 28px 32px;
                border-bottom: 1px solid var(--border);
                border-right: 1px solid var(--border);
                display: flex;
                align-items: center;
                background: var(--white);
            }
            
            /* Make internal grid lines consistent */
            .compare-cell--label {
                background: #F8FAFC;
                font-weight: 800;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.1em;
                color: var(--text-main);
                justify-content: flex-start;
            }

            .compare-cell--product {
                flex-direction: column;
                text-align: center;
                justify-content: flex-start;
                gap: 12px;
                padding: 40px 32px;
                background: var(--white);
            }

            .product-hero img {
                width: 200px;
                height: 200px;
                object-fit: contain;
                margin-bottom: 20px;
                filter: drop-shadow(0 15px 25px rgba(0,0,0,0.06));
                transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            }

            .product-hero:hover img {
                transform: scale(1.08) translateY(-5px);
            }

            .product-hero h3 {
                font-size: 20px;
                font-weight: 800;
                margin: 0 0 4px 0;
                line-height: 1.4;
                color: var(--text-main);
                min-height: 56px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .product-hero .price {
                font-size: 24px;
                font-weight: 800;
                color: var(--brand);
                margin-bottom: 20px;
            }

            .spec-value {
                font-size: 15px;
                font-weight: 600;
                color: #334155;
                line-height: 1.6;
            }

            /* OS Chips */
            .os-chip {
                display: inline-flex;
                align-items: center;
                padding: 6px 16px;
                border-radius: 99px;
                font-size: 13px;
                font-weight: 700;
            }

            .os-chip--ios, .os-chip--blue {
                background: #EFF6FF;
                color: #2563EB;
                border: 1px solid #DBEAFE;
            }

            .os-chip--android {
                background: #FFFBEB;
                color: #D97706;
                border: 1px solid #FEF3C7;
            }

            .os-chip--green {
                background: #F0FDF4;
                color: #16A34A;
                border: 1px solid #DCFCE7;
            }

            .btn-buy {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                padding: 14px 24px;
                background: var(--brand);
                color: white;
                border-radius: 12px;
                text-decoration: none;
                font-weight: 700;
                font-size: 15px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
            }

            .btn-buy:hover {
                background: var(--brand-hover);
                transform: translateY(-2px);
                box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
            }

            .empty-slot {
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                color: #94A3B8;
                gap: 16px;
                padding: 40px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .empty-slot:hover {
                background: #F8FAFC;
                color: var(--brand);
            }

            .empty-slot i {
                font-size: 32px;
                opacity: 0.5;
                transition: transform 0.3s;
            }

            .empty-slot:hover i {
                transform: scale(1.2);
                opacity: 1;
            }

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
                box-shadow: 0 25px 50px rgba(0,0,0,0.2);
            }
            .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
            .search-input {
                width: 100%;
                padding: 14px 20px;
                border: 2px solid var(--border);
                border-radius: 12px;
                font-size: 15px;
                outline: none;
                transition: border-color 0.2s;
            }
            .search-input:focus { border-color: var(--brand); }
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
                background: var(--brand-soft);
                color: var(--brand);
                border-radius: 8px;
                font-size: 12px;
                font-weight: 700;
            }

            @media (max-width: 1024px) {
                .compare-grid {
                    grid-template-columns: 140px repeat(auto-fit, minmax(240px, 1fr));
                }
                .compare-cell { padding: 16px; }
                .product-hero img { width: 140px; height: 140px; }
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="compare-shell">
            <div class="compare-header">
                <h1>So sánh sản phẩm</h1>
                <p>Đối chiếu cấu hình chi tiết để chọn ra thiết bị phù hợp nhất.</p>
            </div>

            <div class="compare-grid">
                <%-- Product Info --%>
                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">Sản phẩm</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <div class="compare-cell compare-cell--product product-hero">
                            <img src="${p.ImagePath}" alt="${p.ProductName}">
                            <h3>${p.ProductName}</h3>
                            <span class="price"><fmt:formatNumber value="${p.Price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            <a href="${ctx}/detail?pid=${p.IdProduct}" class="btn-buy">Xem chi tiết</a>
                        </div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2">
                        <div class="compare-cell compare-cell--product" onclick="openModal()">
                            <div class="empty-slot">
                                <i class="fa-solid fa-plus-circle"></i>
                                <span>Thêm sản phẩm</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- Specs --%>
                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">Màn hình</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <div class="compare-cell"><span class="spec-value">${p.Screen}</span></div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2"><div class="compare-cell"></div></c:forEach>
                </div>

                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">Hệ điều hành</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <c:set var="os" value="${p.OperatingSystem}" />
                        <c:set var="isAndroid" value="${fn:containsIgnoreCase(os, 'Android')}" />
                        <c:set var="isIOS" value="${fn:containsIgnoreCase(os, 'iOS')}" />
                        <div class="compare-cell">
                            <span class="os-chip ${isAndroid ? 'os-chip--android' : (isIOS ? 'os-chip--ios' : 'os-chip--blue')}">
                                ${os}
                            </span>
                        </div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2"><div class="compare-cell"></div></c:forEach>
                </div>

                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">Chip (CPU)</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <div class="compare-cell"><span class="spec-value">${p.CPU}</span></div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2"><div class="compare-cell"></div></c:forEach>
                </div>

                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">RAM</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <div class="compare-cell"><span class="spec-value">${p.RAM} GB</span></div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2"><div class="compare-cell"></div></c:forEach>
                </div>

                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">Camera</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <div class="compare-cell"><span class="spec-value">${p.Camera}</span></div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2"><div class="compare-cell"></div></c:forEach>
                </div>

                <div class="compare-row">
                    <div class="compare-cell compare-cell--label">Pin</div>
                    <c:forEach items="${compareProducts}" var="p">
                        <div class="compare-cell"><span class="spec-value">${p.Battery}</span></div>
                    </c:forEach>
                    <c:forEach begin="${compareProducts.size()}" end="2"><div class="compare-cell"></div></c:forEach>
                </div>
            </div>
        </main>

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

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <script>
            function openModal() {
                document.getElementById('compareModal').classList.add('show');
                document.getElementById('pSearch').focus();
            }

            function closeModal() {
                document.getElementById('compareModal').classList.remove('show');
            }

            async function fetchProducts() {
                const query = document.getElementById('pSearch').value;
                if (query.length < 2) {
                    document.getElementById('pList').innerHTML = '';
                    return;
                }

                try {
                    const res = await fetch(`${ctx}/compare/api/list?q=` + encodeURIComponent(query));
                    const data = await res.json();
                    renderSearchResults(data);
                } catch (err) {
                    console.error('Search failed:', err);
                }
            }

            function renderSearchResults(products) {
                const list = document.getElementById('pList');
                list.innerHTML = '';
                
                products.forEach(p => {
                    const div = document.createElement('div');
                    div.className = 'list-item';
                    div.onclick = () => selectForCompare(p);
                    div.innerHTML = `
                        <img src="${ctx}/\${p.image}" alt="\${p.name}">
                        <div class="list-item-info">
                            <div class="list-item-name">\${p.name}</div>
                            <div class="list-item-price">\${new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.price)}</div>
                        </div>
                        <div class="btn-select">Chọn</div>
                    `;
                    list.appendChild(div);
                });
            }

            function selectForCompare(p) {
                // Get current pids from URL
                const urlParams = new URLSearchParams(window.location.search);
                const pids = [];
                if (urlParams.get('pid1')) pids.push(urlParams.get('pid1'));
                if (urlParams.get('pid2')) pids.push(urlParams.get('pid2'));
                if (urlParams.get('pid3')) pids.push(urlParams.get('pid3'));

                // Check if already in comparison
                if (pids.includes(p.id)) {
                    alert('Sản phẩm này đã có trong danh sách so sánh.');
                    return;
                }

                if (pids.length >= 3) {
                    alert('Chỉ có thể so sánh tối đa 3 sản phẩm.');
                    return;
                }

                // Add new pid
                pids.push(p.id);

                // Build new URL
                let newUrl = '${ctx}/compare?';
                pids.forEach((id, idx) => {
                    newUrl += (idx === 0 ? '' : '&') + 'pid' + (idx + 1) + '=' + id;
                });
                window.location.href = newUrl;
            }
        </script>
    </body>
</html>
