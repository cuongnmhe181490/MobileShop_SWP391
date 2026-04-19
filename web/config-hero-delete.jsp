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
            body { padding: 18px; overflow: hidden; }
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
            .sidebar {
                width: 140px;
                flex: 0 0 140px;
                background: var(--sidebar-bg);
                color: white;
                border-radius: 24px;
                padding: 14px 10px;
                display: flex;
                flex-direction: column;
                margin-top: 50px;
                height: calc(80% - 10px);
                overflow-y: auto;
                overflow-x: hidden;
            }
            .sidebar h4 { margin: 0 0 8px; font-size: 20px; line-height: 1.15; font-weight: 800; }
            .brand-subtitle { font-size: 11px; color: var(--sidebar-muted); margin-bottom: 18px; }
            .nav-list { display: flex; flex-direction: column; gap: 8px; }
            .sidebar a {
                display: block;
                color: #f8faff;
                padding: 8px 12px;
                text-decoration: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 12px;
                transition: 0.2s ease;
                white-space: nowrap;
            }
            .sidebar a:not(.active) { color: var(--sidebar-muted); }
            .sidebar a.active {
                background: #ffffff;
                color: #1f2a56;
                box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16);
            }
            .sidebar-footer {
                margin-top: 26px;
                background: #ffffff;
                color: #1e2b57;
                padding: 14px 12px;
                border-radius: 18px;
            }
            .sidebar-footer strong { display: block; font-size: 12px; margin-bottom: 2px; line-height: 1.2; }
            .sidebar-footer span { display: block; font-size: 10px; color: #7381a8; }
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
                .sidebar { width: 100%; flex-basis: auto; height: auto; margin-top: 0; }
                .actions { justify-content: center; }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <div class="sidebar">
                <h4>MobileShop</h4>
                <div style="font-size: 10px; color: #94a3b8; margin-bottom: 16px; padding-left: 8px;">Admin Panel</div>
                <div class="nav-list">
                    <a href="${ctx}/HeroListServlet" class="active">Biểu ngữ chính</a>
                    <a href="${ctx}/BrandListServlet">Thương hiệu</a>
                    <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                    <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
                </div>
                <div class="sidebar-footer">
                    <strong>Xin chào admin</strong>
                    <span>Xóa hero banner</span>
                </div>
                <a href="#" class="logout-link">Đăng xuất</a>
            </div>

            <div class="content">
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

