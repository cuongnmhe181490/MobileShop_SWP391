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
                overflow: auto;
            }

            .dashboard-shell {
                height: calc(99vh - 36px);
                background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
                border: 1px solid #eef2ff;
                border-radius: 30px;
                padding: 14px;
                display: flex;
                gap: 16px;
                overflow: auto;
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

        /* ===== SIDEBAR – Dashboard Design ===== */
        .sidebar {
            width: 260px;
            background: #1e293b;
            padding: 24px 0;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            z-index: 100;
            color: white;
            overflow-y: auto;
        }
        .sidebar .brand {
            padding: 0 24px;
            margin-bottom: 40px;
            text-decoration: none;
            color: white;
            display: block;
        }
        .sidebar .brand h2 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        .nav-section { margin-bottom: 32px; }
        .nav-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            color: #64748b;
            letter-spacing: 1px;
            margin-bottom: 12px;
            display: block;
            padding: 0 24px;
        }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 24px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            border-left: 4px solid transparent;
            transition: 0.3s;
        }
        .menu-link i { width: 20px; text-align: center; }
        .menu-link:hover { background: rgba(175,242,47,0.05); color: #cbd5e1; }
        .menu-link.active {
            background: rgba(175,242,47,0.1);
            color: #aff22f;
            border-left-color: #aff22f;
            font-weight: 600;
        }
        .sidebar-logout { margin-top: auto; }
        /* ===== END SIDEBAR ===== */

        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
    <body>

        <div class="dashboard-shell">
          
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-table-columns"></i>Dashboard</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ</span>
                <ul class="sidebar-menu">
                    <li><a href="#" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link"><i class="fa-solid fa-receipt"></i>Đơn hàng</a></li>
                    <li><a href="#" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link"><i class="fa-solid fa-newspaper"></i>Blog</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/AdminHomeConfigServlet" class="menu-link active"><i class="fa-solid fa-sliders"></i>Trang chủ</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH TRANG CHỦ</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/HeroListServlet" class="menu-link"><i class="fa-solid fa-image"></i>Biểu ngữ chính</a></li>
                    <li><a href="${pageContext.request.contextPath}/BrandListServlet" class="menu-link"><i class="fa-solid fa-tags"></i>Thương hiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/TopProductListServlet" class="menu-link"><i class="fa-solid fa-star"></i>Sản phẩm nổi bật</a></li>
                    <li><a href="${pageContext.request.contextPath}/TradeInConfigServlet" class="menu-link"><i class="fa-solid fa-arrows-rotate"></i>Cấu hình Trade-in</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">HỆ THỐNG</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-house"></i>Về trang chủ</a></li>
                </ul>
            </div>
            <div class="sidebar-logout">
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-arrow-right-from-bracket"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

            <div class="content" style="margin-left:260px;padding:32px 40px;min-height:100vh;box-sizing:border-box;">
                <div class="header-section">
                    <h2>Cấu hình trang chủ</h2>
                </div>

                <div class="grid-layout">

                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#fff1f2; color:#e11d48;">Biểu ngữ</span>
                            <h5>Biểu ngữ chính</h5>
                            <div class="card-visual bg-hero">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <%-- Lấy id từ active banner hoặc mặc định --%>
                                <c:choose>
                                    <c:when test="${not empty activeHero}">
                                        <a href="${ctx}/HeroEditServlet?id=${activeHero.id}" class="btn-f btn-edit">Sửa</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/HeroListServlet" class="btn-f btn-edit">Sửa</a>
                                    </c:otherwise>
                                </c:choose>
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
                                <c:choose>
                                    <c:when test="${not empty latestSupplier}">
                                        <a href="${ctx}/BrandEditServlet?id=${latestSupplier.idSupplier}" class="btn-f btn-edit">Sửa</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/BrandListServlet" class="btn-f btn-edit">Sửa</a>
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
                            <h5>Sản phẩm nổi bật</h5>
                            <div class="card-visual bg-product">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <a href="${ctx}/TopProductListServlet" class="btn-f btn-edit">Quản lý</a>
                                <a href="${ctx}/TopProductAddServlet" class="btn-f btn-add">Thêm</a>
                                <a href="${ctx}/TopProductListServlet" class="btn-f btn-list">Danh sách</a>
                            </div>
                        </div>
                    </div>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#f0fdf4; color:#16a34a;">Chương trình</span>
                            <h5>Cấu hình Trade-in</h5>
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

        <!-- Toast Notifications System -->
        <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>

        <script>
            function showToast(message, type = 'success') {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                toast.style.cssText = `
                    min-width: 280px;
                    padding: 16px 20px;
                    margin-bottom: 12px;
                    border-radius: 12px;
                    background: \${type === 'success' ? '#4caf50' : '#f44336'};
                    color: white;
                    font-size: 13px;
                    font-weight: 600;
                    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
                    opacity: 0;
                    transform: translateX(50px);
                    transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                    display: flex;
                    align-items: center;
                    gap: 12px;
                `;
                
                const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';
                toast.innerHTML = `<i class="fa-solid \${icon}"></i> <span>\${message}</span>`;
                
                container.appendChild(toast);
                
                setTimeout(() => {
                    toast.style.opacity = '1';
                    toast.style.transform = 'translateX(0)';
                }, 10);
                
                setTimeout(() => {
                    toast.style.opacity = '0';
                    toast.style.transform = 'translateX(50px)';
                    setTimeout(() => toast.remove(), 400);
                }, 4000);
            }

            window.onload = function() {
                <c:if test="${not empty sessionScope.flashSuccess}">
                    showToast('${sessionScope.flashSuccess}', 'success');
                    <% session.removeAttribute("flashSuccess"); %>
                </c:if>
                <c:if test="${not empty sessionScope.flashError}">
                    showToast('${sessionScope.flashError}', 'error');
                    <% session.removeAttribute("flashError"); %>
                </c:if>
            };
        </script>
    </body>
</html>