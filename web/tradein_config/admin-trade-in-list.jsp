<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Cấu hình Trade-in - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        :root {
            --bg-body: #f4f7fe;
            --bg-card: #ffffff;
            --primary: #4318ff;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border: #e9edf7;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
        }

        .config-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 32px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-bottom: 32px;
        }

        .config-section { margin-bottom: 32px; }
        .config-section:last-child { margin-bottom: 0; }
        
        .config-section h4 { 
            font-size: 0.85rem; 
            font-weight: 800; 
            color: var(--primary); 
            margin-bottom: 16px; 
            padding-bottom: 8px; 
            border-bottom: 1px solid var(--border);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .note-card {
            background: #f8fafc;
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 20px;
            margin-top: 12px;
        }
        .note-card p { font-size: 0.95rem; color: #475569; margin: 0; line-height: 1.6; }

        .btn-edit {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            background: var(--primary);
            color: white;
            border-radius: 12px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 700;
            transition: 0.2s;
            border: none;
        }
        .btn-edit:hover { background: #3311cc; transform: translateY(-2px); color: white; }

        .empty-state { text-align: center; padding: 60px; color: var(--text-muted); }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="config_tradein" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                <div>
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Cấu hình trang chủ</p>
                    <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0;">Quản lý Trade-in</h2>
                </div>
                <a href="${ctx}/TradeInConfigServlet?action=edit" class="btn-edit">
                    <i class="fas fa-pen-to-square"></i> Chỉnh sửa cấu hình
                </a>
            </header>

            <div class="config-card">
                <c:choose>
                    <c:when test="${not empty tradeInConfig}">
                        <%-- Thông tin chính --%>
                        <div class="config-section">
                            <h4>📌 Thông tin hiển thị chính</h4>
                            <h3 style="font-size: 1.5rem; font-weight: 800; margin: 0 0 12px; color: var(--text-main);">${tradeInConfig.Title}</h3>
                            <p style="font-size: 1rem; color: #475569; margin: 0; line-height: 1.6;">${tradeInConfig.Description}</p>
                        </div>
    
                        <%-- Note 1 --%>
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note1_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note1_Desc}</p>
                            </div>
                        </div>
    
                        <%-- Note 2 --%>
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note2_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note2_Desc}</p>
                            </div>
                        </div>
    
                        <%-- Note 3 --%>
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note3_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note3_Desc}</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-arrows-rotate fa-4x mb-4" style="opacity: 0.2;"></i>
                            <p>Chưa có cấu hình Trade-in nào được tạo.</p>
                            <a href="${ctx}/TradeInConfigServlet?action=edit" class="btn-edit mt-3">Tạo mới ngay</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

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