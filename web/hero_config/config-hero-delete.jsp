<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Xoá Hero banner</title>
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <style>
            :root {
                --page-bg: #f5f7ff;
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
            body { padding: 18px; overflow: auto; }
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
            .logout-link {
                margin-top: 8px;
                padding: 0 12px;
                text-decoration: none;
                color: #f8faff;
                font-weight: 800;
                font-size: 12px;
                white-space: nowrap;
            }
            .content {
                flex: 1;
                min-width: 0;
                padding: 4px 2px 8px;
                overflow-y: auto;
            }
            .header-section { margin-bottom: 18px; padding-left: 6px; }
            .header-section h2 { margin: 0 0 8px; font-size: 18px; font-weight: 800; color: var(--heading); }
            .header-section p { margin: 0; max-width: 760px; color: #7e8eb8; font-size: 13px; line-height: 1.55; }
            .confirm-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 18px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
            }
            .confirm-title {
                font-size: 14px;
                font-weight: 900;
                color: #1d2d59;
                margin-bottom: 8px;
            }
            .confirm-text {
                font-size: 12px;
                line-height: 1.6;
                color: var(--text);
                margin-bottom: 16px;
                max-width: 760px;
            }
            .actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 10px; }
            .btn-f {
                padding: 8px 18px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 800;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
            }
            .btn-delete {
                background: var(--danger-bg);
                border-color: var(--danger-border);
                color: var(--danger-text);
            }
            .btn-cancel {
                background: #ffffff;
                border-color: #e2e8f0;
                color: #1f2a56;
            }
            @media (max-width: 991px) {
                body { padding: 12px; }
                .dashboard-shell { flex-direction: column; }
                .actions { justify-content: center; }
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
                    <li><a href="${pageContext.request.contextPath}/AdminHomeConfigServlet" class="menu-link"><i class="fa-solid fa-sliders"></i>Trang chủ</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH TRANG CHỦ</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/HeroListServlet" class="menu-link active"><i class="fa-solid fa-image"></i>Biểu ngữ chính</a></li>
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
                    <h2>Xoá Hero banner</h2>
                    <p>Xác nhận thao tác xoá. Sau khi xoá, phần Hero trên homepage sẽ không hiển thị.</p>
                </div>

                <div class="confirm-card">
                    <div class="confirm-title">Bạn có chắc chắn muốn xoá Hero banner?</div>
                    <div class="confirm-text">
                        Thao tác này sẽ xoá cấu hình hiện tại của Hero (eyebrow, tiêu đề, mô tả, CTA, ảnh và chỉ số).
                        Nếu bạn chỉ muốn ẩn hero, hãy dùng tính năng chỉnh sửa thay vì xoá.
                    </div>

                    <form action="#" method="post">
                        <div class="actions">
                            <button type="submit" class="btn-f btn-delete">Xoá</button>
                            <a href="${ctx}/admin-home-config.jsp" class="btn-f btn-cancel">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>

