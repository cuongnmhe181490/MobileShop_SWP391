<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Hero banner - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        .hero-thumb {
            width: 120px;
            height: 60px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        
        .admin-table th { font-size: 0.8rem; letter-spacing: 0.5px; }
        
        .cta-badge {
            display: inline-block;
            padding: 4px 10px;
            background: #f1f5f9;
            color: #475569;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .action-btns {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }

        .btn-icon {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            transition: 0.2s;
            border: 1px solid var(--border);
            color: var(--text-main);
        }
        .btn-icon:hover { background: #f8fafc; color: var(--primary); transform: translateY(-2px); }
        .btn-icon.delete:hover { color: #dc2626; background: #fff1f2; border-color: #fecaca; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="config_hero" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                <div>
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Cấu hình trang chủ</p>
                    <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0;">Danh sách Banner (Hero)</h2>
                </div>
                <div style="display: flex; gap: 12px;">
                    <form action="${ctx}/HeroListServlet" method="get" style="display: flex; gap: 8px;">
                        <input type="text" name="search" value="${search}" class="form-input" style="max-width: 200px;" placeholder="Tìm tiêu đề...">
                        <button type="submit" class="btn-primary" style="padding: 0 16px;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="${ctx}/HeroAddServlet" class="btn-primary"><i class="fas fa-plus me-2"></i>Thêm banner</a>
                </div>
            </header>

            <div class="content-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th style="width: 140px;">Hình ảnh</th>
                            <th>Nội dung banner</th>
                            <th>Thông tin phụ</th>
                            <th style="text-align: right;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${heroList}">
                            <tr>
                                <td style="font-weight: 700; color: var(--text-muted);">#${h.id}</td>
                                <td>
                                    <img src="${h.imageUrl}" class="hero-thumb" alt="hero">
                                </td>
                                <td>
                                    <div style="font-weight: 800; color: var(--text-main); font-size: 1rem; margin-bottom: 4px;">${h.title}</div>
                                    <div class="cta-badge">CTA: ${h.ctaPrimary}</div>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: var(--text-main); font-size: 0.85rem;">${h.eyebrow}</div>
                                    <div style="color: var(--text-muted); font-size: 0.8rem; margin-top: 2px;">${h.subTitle}</div>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <a href="${ctx}/HeroEditServlet?id=${h.id}" class="btn-icon" title="Chỉnh sửa"><i class="fas fa-pen"></i></a>
                                        <a href="${ctx}/HeroDeleteServlet?id=${h.id}" 
                                           onclick="return confirm('Bạn có chắc muốn xóa banner này?')" 
                                           class="btn-icon delete" title="Xóa"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty heroList}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 60px; color: var(--text-muted);">
                                    <i class="fas fa-image fa-3x mb-3" style="opacity: 0.1;"></i>
                                    <p>Không tìm thấy banner nào.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <%-- Pagination --%>
                <div style="margin-top: 32px; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border); padding-top: 24px;">
                    <div style="font-size: 0.85rem; color: var(--text-muted);">
                        Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong> - 
                        <strong>${currentPage * pageSize > totalItems ? totalItems : currentPage * pageSize}</strong> 
                        trong tổng số <strong>${totalItems}</strong>
                    </div>
                    
                    <div style="display: flex; gap: 8px;">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}&search=${search}" class="btn-outline" style="padding: 8px 16px;">&larr; Trước</a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages == 0 ? 1 : totalPages}" var="i">
                            <a href="?page=${i}&search=${search}" class="product-page-link ${i == currentPage ? 'is-active' : ''}">${i}</a>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}&search=${search}" class="btn-outline" style="padding: 8px 16px;">Sau &rarr;</a>
                        </c:if>
                    </div>
                </div>
            </div>

            <div style="margin-top: 24px;">
                <a href="${ctx}/AdminHomeConfigServlet" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem; font-weight: 600;">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại cấu hình chung
                </a>
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