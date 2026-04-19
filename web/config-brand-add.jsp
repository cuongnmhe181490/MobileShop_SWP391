<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Thêm Brand Logo | Admin Panel</title>
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
                --danger-text: #ea4f68;
                --success-bg: #ecfdf5;
                --success-border: #a7f3d0;
                --success-text: #059669;
            }

            html, body {
                height: 100%;
                margin: 0;
                background: var(--page-bg);
                font-family: 'Inter', 'Segoe UI', sans-serif;
                color: var(--heading);
                overflow: hidden;
            }

            body {
                padding: 18px;
            }

            .dashboard-shell {
                height: calc(100vh - 36px);
                background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
                border: 1px solid #eef2ff;
                border-radius: 30px;
                padding: 14px;
                display: flex;
                gap: 16px;
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

            .sidebar h4 {
                margin: 0 0 8px;
                font-size: 20px;
                line-height: 1.15;
                font-weight: 800;
            }

            .brand-title {
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 6px;
            }

            .brand-subtitle {
                font-size: 11px;
                color: var(--sidebar-muted);
                margin-bottom: 18px;
            }

            .nav-list {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

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

            .sidebar a:not(.active) {
                color: var(--sidebar-muted);
            }

            .sidebar a.active {
                background: #ffffff;
                color: #1f2a56;
                box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16);
            }
            /* Content Area */
            .content {
                flex: 1;
                padding: 10px;
                overflow-y: auto;
            }

            .header-section {
                margin-bottom: 24px;
            }
            .header-section h2 {
                font-size: 22px;
                font-weight: 800;
                color: var(--heading);
                margin-bottom: 4px;
            }
            .header-section p {
                color: var(--text);
                font-size: 13px;
            }

            /* Form Card */
            .form-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 30px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.05);
                max-width: 900px;
            }

            .field {
                margin-bottom: 20px;
            }
            .field label {
                display: block;
                font-size: 11px;
                font-weight: 800;
                color: #7e8eb8;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .input {
                width: 100%;
                border: 1px solid #eaf0ff;
                border-radius: 14px;
                padding: 12px 16px;
                font-size: 14px;
                outline: none;
                transition: all 0.2s;
                background: #fcfdff;
            }

            .input:focus {
                border-color: var(--primary-blue);
                background: #fff;
                box-shadow: 0 0 0 4px rgba(91, 116, 241, 0.1);
            }

            /* Group inputs in one row */
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            /* Action Buttons */
            .actions {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 12px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #f1f5f9;
            }

            .btn-f {
                padding: 10px 24px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-save {
                background: var(--primary-blue);
                color: white;
            }
            .btn-save:hover {
                opacity: 0.9;
                transform: translateY(-1px);
            }

            .btn-list {
                background: var(--success-bg);
                color: var(--success-text);
                border-color: var(--success-border);
            }
            .btn-list:hover {
                background: var(--success-border);
            }

            .btn-cancel {
                background: #f8fafc;
                color: #64748b;
                border-color: #e2e8f0;
            }
            .btn-cancel:hover {
                background: #f1f5f9;
            }

            /* Error message */
            .error-msg {
                background: var(--danger-bg);
                color: var(--danger-text);
                padding: 12px;
                border-radius: 12px;
                font-size: 13px;
                margin-bottom: 20px;
                border: 1px solid #ffccd2;
            }
        </style>
    </head>

    <body>
        <div class="dashboard-shell">
            <div class="sidebar">
            <h4>MobileShop</h4>
            <div class="nav-list">
                <a href="${ctx}/HeroListServlet">Biểu ngữ chính</a>
                <a href="${ctx}/BrandListServlet" class="active">Thương hiệu</a>
                <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
            </div>
        </div>

            <div class="content">
                <div class="header-section">
                    <h2>Thêm Logo Thương Hiệu</h2>
                    <p>Quản lý các đối tác thương hiệu (Category) hiển thị trên hệ thống.</p>
                </div>

                <div class="form-card">
                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <form action="${ctx}/BrandAddServlet" method="post" id="brandForm">
                        <div class="form-row">
                            <div class="field">
                                <label>Tên Thương Hiệu <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="name" 
                                       placeholder="Ví dụ: Apple, Samsung, Xiaomi..."
                                       required minlength="2" maxlength="100"
                                       pattern="[A-Za-z0-9À-ỹ\s\-_]{2,100}"
                                       title="Tên thương hiệu từ 2-100 ký tự, không chứa ký tự đặc biệt">
                            </div>

                            <div class="field">
                                <label>Đường dẫn Logo (URL) <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="url" name="imagePath" 
                                       placeholder="https://example.com/logo.png"
                                       required pattern="https?://.*\.(jpg|jpeg|png|gif|svg|webp)"
                                       title="Nhập URL hợp lệ (jpg, png, gif, svg, webp)">
                            </div>
                        </div>

                        <div class="actions">
                            <a href="${ctx}/BrandListServlet" class="btn-f btn-list">Xem danh sách</a>

                            <a href="${ctx}/AdminHomeConfigServlet" class="btn-f btn-cancel">Hủy</a>

                            <button type="submit" class="btn-f btn-save">Lưu dữ liệu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>