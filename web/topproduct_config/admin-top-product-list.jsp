<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm bán chạy - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        .product-thumb {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border-radius: 12px;
            background: #f8fafc;
            border: 1px solid var(--border);
            padding: 4px;
        }
        
        .price-text { font-weight: 700; color: #16a34a; }
        .sold-text { font-weight: 700; color: var(--primary); }
        
        .btn-remove-top {
            padding: 6px 14px;
            background: #fff1f2;
            color: #e11d48;
            border: 1px solid #fecaca;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 700;
            text-decoration: none;
            transition: 0.2s;
        }
        .btn-remove-top:hover { background: #fee2e2; color: #be123c; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="config_top" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                <div>
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Cấu hình trang chủ</p>
                    <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0;">Sản phẩm nổi bật (Top)</h2>
                </div>
                <div style="display: flex; gap: 12px;">
                    <form action="${ctx}/TopProductListServlet" method="get" style="display: flex; gap: 8px;">
                        <input type="text" name="search" value="${search}" class="form-input" style="max-width: 200px;" placeholder="Tìm tên sản phẩm...">
                        <button type="submit" class="btn-primary" style="padding: 0 16px;"><i class="fas fa-search"></i></button>
                    </form>
                    <a href="${ctx}/TopProductAddServlet" class="btn-primary"><i class="fas fa-plus me-2"></i>Thêm sản phẩm</a>
                </div>
            </header>

            <div class="content-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Mã SP</th>
                            <th style="width: 100px;">Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá bán</th>
                            <th>Đã bán</th>
                            <th>Tồn kho</th>
                            <th style="text-align: right;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty featuredProductList}">
                                <c:forEach var="p" items="${featuredProductList}">
                                    <tr>
                                        <td style="font-weight: 700; color: var(--text-muted); font-size: 0.8rem;">#${p.IdProduct}</td>
                                        <td>
                                            <img src="${not empty p.ImagePath ? p.ImagePath : ctx.concat('/img/no-image.png')}" alt="${p.ProductName}" class="product-thumb">
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: var(--text-main);">${p.ProductName}</div>
                                        </td>
                                        <td>
                                            <div class="price-text">
                                                <c:choose>
                                                    <c:when test="${p.Price > 0}">
                                                        ${String.format("%,.0f", p.Price)} ₫
                                                    </c:when>
                                                    <c:otherwise>Liên hệ</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td><div class="sold-text">${p.SoldQuantity > 0 ? p.SoldQuantity : 0}</div></td>
                                        <td style="font-weight: 600;">${p.CurrentQuantity}</td>
                                        <td style="text-align: right;">
                                            <a href="${ctx}/TopProductToggleServlet?productId=${p.IdProduct}&status=0" 
                                               class="btn-remove-top"
                                               onclick="return confirm('Gỡ sản phẩm này khỏi danh sách nổi bật?');">
                                                <i class="fas fa-trash-can me-2"></i>Gỡ khỏi Top
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 60px; color: var(--text-muted);">
                                        <i class="fas fa-star fa-3x mb-3" style="opacity: 0.1;"></i>
                                        <p>Chưa có sản phẩm nào được chọn vào Top.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
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