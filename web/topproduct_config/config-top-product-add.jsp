<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm nổi bật - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 24px;
        }

        .product-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 16px;
            transition: 0.3s;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        .product-card:hover { transform: translateY(-5px); box-shadow: var(--shadow); }

        .product-img-box {
            width: 100%;
            height: 180px;
            background: #f8fafc;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            overflow: hidden;
            padding: 12px;
        }
        .product-img-box img { max-width: 100%; max-height: 100%; object-fit: contain; }

        .product-name { font-size: 1rem; font-weight: 700; color: var(--text-main); margin-bottom: 8px; line-height: 1.4; height: 2.8em; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .product-price { font-size: 1.1rem; font-weight: 800; color: #16a34a; margin-bottom: 4px; }
        .product-stock { font-size: 0.8rem; color: var(--text-muted); margin-bottom: 16px; }

        .btn-add-top {
            width: 100%;
            padding: 10px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
            margin-top: auto;
        }
        .btn-add-top:hover { background: #3311cc; }
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
                    <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0;">Thêm sản phẩm vào Top</h2>
                </div>
                <a href="${ctx}/TopProductListServlet" class="btn-outline" style="padding: 10px 20px; text-decoration: none; font-weight: 600;">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
            </header>

            <div class="config-overview" style="margin-bottom: 24px;">
                <p style="font-size: 0.9rem; color: var(--text-muted);">Danh sách sản phẩm có thể ghim lên trang chủ (chưa được chọn vào Top):</p>
            </div>

            <c:choose>
                <c:when test="${not empty availableProductList}">
                    <div class="product-grid">
                        <c:forEach var="p" items="${availableProductList}">
                            <div class="product-card">
                                <div class="product-img-box">
                                    <img src="${not empty p.ImagePath ? p.ImagePath : ctx.concat('/img/no-image.png')}" alt="${p.ProductName}">
                                </div>
                                <div class="product-info">
                                    <h4 class="product-name">${p.ProductName}</h4>
                                    <p class="product-price">
                                        <c:choose>
                                            <c:when test="${p.Price > 0}">
                                                ${String.format("%,.0f", p.Price)} ₫
                                            </c:when>
                                            <c:otherwise>Liên hệ</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="product-stock"><i class="fas fa-warehouse me-2"></i>Tồn kho: ${p.CurrentQuantity}</p>
                                    <form action="${ctx}/TopProductAddServlet" method="post">
                                        <input type="hidden" name="productId" value="${p.IdProduct}">
                                        <button type="submit" class="btn-add-top"><i class="fas fa-thumbtack me-2"></i>Ghim lên Top</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 80px; background: white; border-radius: 24px; border: 1px solid var(--border);">
                        <i class="fas fa-box-open fa-3x mb-3" style="opacity: 0.1;"></i>
                        <p style="color: var(--text-muted);">Tất cả sản phẩm hiện có đều đã được ghim vào Top hoặc chưa có sản phẩm nào trong kho.</p>
                    </div>
                </c:otherwise>
            </c:choose>
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