<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                --brand: #3B6FE8;
                --brand-soft: #EEF3FD;
                --bg: #F8F9FC;
                --white: #FFFFFF;
                --text-main: #0E1D35;
                --text-muted: #6B7491;
                --border: #D8DCE8;
            }

            body {
                background-color: var(--bg);
                font-family: 'Plus Jakarta Sans', sans-serif;
                color: var(--text-main);
            }

            .compare-shell {
                max-width: 1200px;
                margin: 60px auto;
                padding: 0 20px;
            }

            .compare-header {
                text-align: center;
                margin-bottom: 48px;
            }

            .compare-header h1 {
                font-size: 32px;
                font-weight: 800;
                margin-bottom: 12px;
                letter-spacing: -0.5px;
            }

            .compare-grid {
                display: grid;
                grid-template-columns: 200px repeat(auto-fit, minmax(250px, 1fr));
                background: var(--white);
                border-radius: 24px;
                box-shadow: 0 10px 40px rgba(14, 29, 53, 0.05);
                overflow: hidden;
                border: 1px solid var(--border);
            }

            .compare-row {
                display: contents;
            }

            .compare-cell {
                padding: 24px;
                border-bottom: 1px solid #F1F5F9;
                display: flex;
                align-items: center;
            }

            .compare-cell--label {
                background: #F8FAFC;
                font-weight: 700;
                font-size: 14px;
                color: var(--text-muted);
                border-right: 1px solid #F1F5F9;
            }

            .compare-cell--product {
                flex-direction: column;
                text-align: center;
                justify-content: flex-start;
                gap: 16px;
            }

            .product-hero {
                padding: 40px 24px;
                border-bottom: 2px solid var(--brand-soft);
            }

            .product-hero img {
                width: 160px;
                height: 160px;
                object-fit: contain;
                margin-bottom: 20px;
                transition: transform 0.3s ease;
            }

            .product-hero:hover img {
                transform: scale(1.05);
            }

            .product-hero h3 {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 8px;
                line-height: 1.4;
            }

            .product-hero .price {
                font-size: 20px;
                font-weight: 800;
                color: var(--brand);
            }

            .spec-value {
                font-size: 15px;
                font-weight: 600;
                line-height: 1.5;
            }

            .btn-buy {
                display: inline-block;
                padding: 12px 24px;
                background: var(--brand);
                color: white;
                border-radius: 99px;
                text-decoration: none;
                font-weight: 700;
                font-size: 14px;
                margin-top: 12px;
                transition: all 0.3s;
            }

            .btn-buy:hover {
                background: #2D56BF;
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(59, 111, 232, 0.2);
            }

            .empty-slot {
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                color: var(--text-muted);
                gap: 12px;
                opacity: 0.5;
            }

            @media (max-width: 768px) {
                .compare-grid {
                    grid-template-columns: 120px repeat(auto-fit, minmax(200px, 1fr));
                }
                .compare-cell { padding: 16px; }
                .product-hero img { width: 100px; height: 100px; }
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
                        <div class="compare-cell compare-cell--product">
                            <div class="empty-slot">
                                <i class="fa-solid fa-plus-circle fa-2x"></i>
                                <span>Trống</span>
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
                        <div class="compare-cell"><span class="spec-value">${p.OperatingSystem}</span></div>
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

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
