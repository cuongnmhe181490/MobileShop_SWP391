<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Homepage Manager</title>
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
        <style>
            :root {
                --page-bg: #f5f7ff;
                --shell-bg: #fbfcff;
                --sidebar-bg: #27315f;
                --sidebar-muted: #c8d0ee;
                --heading: #24345f;
                --text: #64748b;
                --border-color: #e7ecfb;
                --primary-blue: #5b74f1;
                --danger-bg: #fff4f5;
                --danger-border: #ff7b8f;
                --danger-text: #ea4f68;
            }

            html, body {
                height: 100%;
                margin: 0;
                background: var(--page-bg);
                font-family: 'Inter', 'Segoe UI', sans-serif;
                color: var(--heading);
            }

            body {
                padding: 18px;
                overflow: hidden;
            }

            .dashboard-shell {
                height: calc(99vh - 36px);
                background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
                border: 1px solid #eef2ff;
                border-radius: 30px;
                padding: 14px;
                display: flex;
                gap: 16px;
                overflow: hidden;
                box-shadow: 0 14px 34px rgba(110, 124, 180, 0.08);
            }

            .content {
                flex: 1;
                min-width: 0;
                padding: 4px 2px 8px;
                overflow-y: auto;
            }

            .header-section {
                margin-bottom: 18px;
            }

            .header-section h2 {
                margin: 0 0 8px;
                font-size: 18px;
                font-weight: 800;
                color: var(--heading);
            }

            .header-section p {
                margin: 0;
                max-width: 640px;
                color: #7e8eb8;
                font-size: 13px;
                line-height: 1.55;
            }

            .grid-layout {
                display: grid;
                grid-template-columns: repeat(12, minmax(0, 1fr));
                gap: 16px;
            }

            .span-6 {
                grid-column: span 6;
            }

            .span-4 {
                grid-column: span 4;
            }

            .span-12 {
                grid-column: 1 / -1;
            }

            .card-box {
                background: #ffffff;
                border-radius: 24px;
                border: 1px solid var(--border-color);
                padding: 16px 16px 14px;
                display: flex;
                flex-direction: column;
                min-height: 232px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.08);
            }

            .tag {
                display: inline-flex;
                align-items: center;
                width: fit-content;
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 10px;
                font-weight: 700;
                margin-bottom: 12px;
            }

            .card-box h5 {
                margin: 0 0 10px;
                font-size: 16px;
                font-weight: 800;
                color: #1d2d59;
            }

            .card-box p {
                margin: 0 0 16px;
                font-size: 12px;
                line-height: 1.55;
                color: var(--text);
                max-width: 320px;
            }

            .card-visual {
                width: 120px;
                height: 64px;
                border-radius: 14px;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .shape-white,
            .shape-dark {
                width: 28px;
                height: 48px;
                border-radius: 12px;
            }

            .shape-white {
                background: #e0f2fe;
                transform: rotate(8deg);
                box-shadow: 0 6px 14px rgba(255, 255, 255, 0.36);
            }

            .shape-dark {
                background: #253266;
                transform: rotate(-8deg);
            }

            .btn-group-custom {
                display: flex;
                gap: 8px;
                margin-top: auto;
                flex-wrap: wrap;
            }

            .btn-f {
                min-width: 48px;
                padding: 7px 14px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 700;
                line-height: 1;
                text-align: center;
                text-decoration: none;
                border: 1px solid transparent;
                transition: 0.2s ease;
            }

            .btn-edit {
                background: #fff7d6;
                border-color: #f5df8a;
                color: #9a6a00;
            }

            .btn-add {
                background: #eef2ff;
                border-color: #c9d6ff;
                color: #4f46e5;
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-hide {
                background: #fff1f2;
                border-color: #ffb3bf;
                color: #df3754;
            }

            .btn-list {
                background: #f0fdf4;
                border-color: #bbf7d0;
                color: #16a34a;
            }

            /* Colors */
            .bg-hero {
                background: #fff1f2;
            }
            .bg-brand {
                background: #f5f3ff;
            }
            .bg-product {
                background: #fffbeb;
            }
            .bg-promo {
                background: #f0fdf4;
            }

            /* Flash messages */
            .flash {
                border-radius: 16px;
                padding: 12px 18px;
                font-size: 12px;
                font-weight: 600;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .flash-success {
                background: #f0fdf4;
                border: 1px solid #86efac;
                color: #166534;
            }
            .flash-error {
                background: #fff4f5;
                border: 1px solid #ff7b8f;
                color: #ea4f68;
            }
        </style>
    </head>
    <body>

        <div class="dashboard-shell">
          
            <%@ include file="/WEB-INF/jspf/sidebar_config/sidebar_config.jspf" %>

            <div class="content">
                <div class="header-section">
                    <h2>Cấu hình trang chủ</h2>
                </div>

                <%-- Flash messages từ session (sau redirect) --%>
                <%
                    String flashSuccess = (String) session.getAttribute("flashSuccess");
                    String flashError   = (String) session.getAttribute("flashError");
                    session.removeAttribute("flashSuccess");
                    session.removeAttribute("flashError");
                %>
                <% if (flashSuccess != null) { %>
                <div class="flash flash-success">✅ <%= flashSuccess %></div>
                <% } %>
                <% if (flashError != null) { %>
                <div class="flash flash-error">❌ <%= flashError %></div>
                <% } %>

                <div class="grid-layout">
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#fff1f2; color:#e11d48;">Biểu ngữ</span>
                            <h5>Biểu ngữ chính</h5>
                            <div class="card-visual bg-hero">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <a href="${ctx}/HeroEditServlet" class="btn-f btn-edit">Sửa</a>
                                <a href="${ctx}/HeroAddServlet" class="btn-f btn-add">Thêm</a>
                                <a href="${ctx}/HeroListServlet" class="btn-f btn-list">Danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#f5f3ff; color:#7c3aed;">Thương hiệu</span>
                            <h5>Thương hiệu sản phẩm</h5>
                            <div class="card-visual bg-brand">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <%-- Lấy brand mới nhất (id lớn nhất) --%>
                                <c:choose>
                                    <c:when test="${not empty brands}">
                                        <c:set var="latestBrand" value="${brands[brands.size()-1]}" />
                                        <a href="${ctx}/BrandEditServlet?id=${latestBrand.idCat}" class="btn-f btn-edit">Sửa</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/BrandEditServlet" class="btn-f btn-edit">Sửa</a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${ctx}/BrandAddServlet" class="btn-f btn-add">Thêm</a>
                                <a href="${ctx}/BrandListServlet" class="btn-f btn-list">Danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#fffbeb; color:#d97706;">Sản phẩm</span>
                            <h5>Sản phẩm bán chạy</h5>
                            <div class="card-visual bg-product">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <a href="${ctx}/TopProductEditServlet" class="btn-f btn-edit">Sửa</a>
                                <a href="${ctx}/TopProductAddServlet" class="btn-f btn-add">Thêm</a>
                                <a href="${ctx}/TopProductListServlet" class="btn-f btn-list">Danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#f0fdf4; color:#16a34a;">Chương trình</span>
                            <h5>Thu cũ</h5>
                            <div class="card-visual bg-promo">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <a href="${ctx}/TradeInConfigServlet?action=edit" class="btn-f btn-edit">Sửa</a>
                                <a href="${ctx}/TradeInConfigServlet?action=add" class="btn-f btn-add">Thêm</a>
                                <a href="${ctx}/TradeInConfigServlet" class="btn-f btn-list">Danh sách</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>