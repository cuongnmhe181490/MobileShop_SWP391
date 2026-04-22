<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Quản lý Cấu hình Trade-in</title>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
    <style>
        :root {
            --page-bg: #f5f7ff;
            --heading: #24345f;
            --text: #64748b;
            --border-color: #e7ecfb;
            --primary-blue: #5b74f1;
            --success-color: #059669;
        }

        html, body { height: 100%; margin: 0; background: var(--page-bg); font-family: 'Inter', 'Segoe UI', sans-serif; color: var(--heading); }
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

        .content { flex: 1; min-width: 0; padding: 4px 2px 8px; overflow-y: auto; }
        .header-section { margin-bottom: 18px; padding-left: 6px; display: flex; justify-content: space-between; align-items: center; }
        .header-section h2 { margin: 0; font-size: 18px; font-weight: 800; color: var(--heading); }

        .config-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 20px;
            box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
        }

        .config-section { margin-bottom: 24px; }
        .config-section h4 { font-size: 14px; font-weight: 800; color: var(--primary-blue); margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid var(--border-color); }
        
        .note-card {
            background: #f8faff;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 16px;
            margin-bottom: 12px;
        }
        .note-card h5 { font-size: 13px; font-weight: 800; color: var(--heading); margin: 0 0 8px; }
        .note-card p { font-size: 12px; color: var(--text); margin: 0; }

        .btn-edit {
            display: inline-block;
            padding: 8px 20px;
            background: var(--primary-blue);
            color: white;
            border-radius: 999px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s;
        }
        .btn-edit:hover { background: #4a63d9; }

        .empty-state { text-align: center; padding: 40px; color: #94a3b8; }
        .empty-state a { color: #5b74f1; font-weight: 600; }

        /* ===== SIDEBAR – Version Gold ===== */
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
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active {
            background: rgba(175, 242, 47, 0.1);
            color: #aff22f;
            border-left-color: #aff22f;
            font-weight: 600;
        }
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

            <!-- 1. TỔNG QUAN -->
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 2. QUẢN LÝ BÁN HÀNG -->
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 3. TƯƠNG TÁC & NỘI DUNG -->
            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 4. CẤU HÌNH GIAO DIỆN -->
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link active">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 5. HỆ THỐNG -->
            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <div class="content" style="margin-left:260px;padding:32px 40px;min-height:100vh;box-sizing:border-box;">
            <div class="header-section">
                <div>
                    <h2>Danh sách Cấu hình Trade-in</h2>
                    <p style="font-size: 12px; color: #7e8eb8; margin: 0;">Quản lý nội dung hiển thị section Trade-in trên trang chủ.</p>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <a href="${ctx}/TradeInConfigServlet?action=edit" class="btn-edit" style="margin: 0;">✏️ Chỉnh sửa</a>
                </div>
            </div>
    
            <div class="config-card">
                <c:choose>
                    <c:when test="${not empty tradeInConfig}">
                        <!-- Title & Description -->
                        <div class="config-section">
                            <h4>📌 Thông tin chính</h4>
                            <h3 style="font-size: 20px; font-weight: 800; margin: 0 0 8px; color: var(--heading);">${tradeInConfig.Title}</h3>
                            <p style="font-size: 14px; color: var(--text); margin: 0;">${tradeInConfig.Description}</p>
                        </div>
    
                        <!-- Note 1 -->
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note1_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note1_Desc}</p>
                            </div>
                        </div>
    
                        <!-- Note 2 -->
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note2_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note2_Desc}</p>
                            </div>
                        </div>
    
                        <!-- Note 3 -->
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note3_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note3_Desc}</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>Chưa có cấu hình Trade-in.</p>
                            <a href="${ctx}/TradeInConfigServlet?action=edit">Tạo mới</a>
                        </div>
                    </c:otherwise>
                </c:choose>
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