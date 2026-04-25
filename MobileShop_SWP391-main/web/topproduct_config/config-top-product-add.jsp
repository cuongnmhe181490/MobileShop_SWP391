<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

    <head>
        <title>Thêm Top Product</title>
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

            html,
            body {
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

            .header-section {
                margin-bottom: 18px;
                padding-left: 6px;
            }

            .header-section h2 {
                margin: 0 0 8px;
                font-size: 18px;
                font-weight: 800;
                color: var(--heading);
            }

            .header-section p {
                margin: 0;
                max-width: 760px;
                color: #7e8eb8;
                font-size: 13px;
                line-height: 1.55;
            }

            .form-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 18px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
            }

            .form-grid-3 {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
            }

            .form-grid-1 {
                display: grid;
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .field label {
                display: block;
                font-size: 10px;
                font-weight: 800;
                color: #7e8eb8;
                margin-bottom: 8px;
            }

            .input,
            .textarea {
                width: 100%;
                border: 1px solid #eaf0ff;
                background: #ffffff;
                border-radius: 14px;
                padding: 10px 12px;
                font-size: 12px;
                outline: none;
            }

            .input:focus,
            .textarea:focus {
                border-color: #c9d6ff;
                box-shadow: 0 0 0 3px rgba(91, 116, 241, 0.12);
            }

            .textarea {
                resize: vertical;
                min-height: 44px;
            }

            /* Read-only live stats */
            .input-readonly {
                width: 100%;
                border: 1px dashed #c9d6ff;
                background: #f0f4ff;
                border-radius: 14px;
                padding: 10px 12px;
                font-size: 12px;
                color: #3b5bdb;
                font-weight: 700;
                cursor: not-allowed;
            }

            .auto-badge {
                display: inline-block;
                margin-top: 5px;
                font-size: 9px;
                font-weight: 700;
                color: #6366f1;
                background: #eef2ff;
                border-radius: 999px;
                padding: 2px 8px;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
                margin-top: 2px;
            }

            .actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 18px;
            }

            .btn-f {
                padding: 8px 18px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 800;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
            }

            .btn-save {
                background: var(--primary-blue);
                border-color: var(--primary-blue);
                color: #ffffff;
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-cancel {
                background: #ffffff;
                border-color: #e2e8f0;
                color: #1f2a56;
            }

            /* Flash error */
            .flash-error {
                background: var(--danger-bg);
                border: 1px solid var(--danger-border);
                color: var(--danger-text);
                border-radius: 14px;
                padding: 10px 14px;
                font-size: 12px;
                font-weight: 600;
                margin-bottom: 14px;
            }

            /* Product Grid Styles */
            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 16px;
            }

            .product-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 16px;
                padding: 12px;
                transition: 0.2s ease;
            }

            .product-card:hover {
                box-shadow: 0 8px 20px rgba(110, 124, 180, 0.12);
                transform: translateY(-2px);
            }

            .product-image {
                width: 100%;
                height: 140px;
                border-radius: 12px;
                overflow: auto;
                background: #f8faff;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 10px;
            }

            .product-image img {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
            }

            .product-image .no-image {
                color: #94a3b8;
                font-size: 11px;
            }

            .product-info .product-name {
                font-size: 13px;
                font-weight: 700;
                color: var(--heading);
                margin: 0 0 6px;
                line-height: 1.3;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: auto;
            }

            .product-info .product-price {
                font-size: 14px;
                font-weight: 800;
                color: #059669;
                margin: 0 0 4px;
            }

            .product-info .product-stock {
                font-size: 11px;
                color: #7e8eb8;
                margin: 0 0 8px;
            }

            .empty-state {
                text-align: center;
                padding: 40px;
                color: #94a3b8;
            }

            @media (max-width: 991px) {
                body {
                    padding: 12px;
                }

                .dashboard-shell {
                    flex-direction: column;
                }

                .form-grid-3 {
                    grid-template-columns: 1fr;
                }

                .stats-row {
                    grid-template-columns: 1fr;
                }

                .actions {
                    justify-content: center;
                }
            }

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
                    <h2>Thêm sản phẩm vào Top</h2>
                    <a href="${ctx}/TopProductListServlet" class="btn-f btn-cancel" style="padding: 8px 16px; font-size: 12px;">← Quay lại</a>
                </div>

                <div class="form-card">
                    <%-- Danh sách sản phẩm có thể thêm vào Top (IsFeatured = 0) --%>
                    <p style="font-size: 12px; color: #7e8eb8; margin-bottom: 16px;">
                        Chọn sản phẩm từ kho để ghim lên trang chủ:
                    </p>

                    <c:choose>
                        <c:when test="${not empty availableProductList}">
                            <div class="product-grid">
                                <c:forEach var="p" items="${availableProductList}">
                                    <div class="product-card">
                                        <div class="product-image">
                                            <c:choose>
                                                <c:when test="${not empty p.ImagePath}">
                                                    <img src="${p.ImagePath}" alt="${p.ProductName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-image">No img</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="product-info">
                                            <h4 class="product-name">${p.ProductName}</h4>
                                            <p class="product-price">
                                                <c:choose>
                                                    <c:when test="${p.Price > 0}">
                                                        ${String.format("%,.0f", p.Price)} ₫
                                                    </c:when>
                                                    <c:otherwise>
                                                        Liên hệ
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p class="product-stock">Tồn kho: ${p.CurrentQuantity}</p>
                                            <form action="${ctx}/TopProductAddServlet" method="post" style="margin-top: 8px;">
                                                <input type="hidden" name="productId" value="${p.IdProduct}">
                                                <button type="submit" class="btn-f btn-save" style="width: 100%;">Ghim lên Top</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <p>Không có sản phẩm nào có thể thêm vào Top.</p>
                                <p style="font-size: 11px; color: #94a3b8;">Tất cả sản phẩm đã được ghim hoặc chưa có sản phẩm trong kho.</p>
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
                <c:if test="${not empty error}">
                    showToast('${error}', 'error');
                </c:if>
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