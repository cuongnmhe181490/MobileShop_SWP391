<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Danh sách Brand Logo</title>
        <link rel="stylesheet" href="/css/bootstrap.min.css" type="text/css">
        <style>
            :root {
                --page-bg: #f5f7ff;
                --heading: #24345f;
                --text: #64748b;
                --border-color: #e7ecfb;
                --primary-blue: #5b74f1;
                --danger-bg: #fff4f5;
                --danger-text: #ea4f68;
                --success-bg: #ecfdf5;
                --success-text: #059669;
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
                height: calc(100vh - 36px);
                background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
                border: 1px solid #eef2ff;
                border-radius: 30px;
                padding: 14px;
                display: flex;
                gap: 16px;
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

            .content { flex: 1; padding: 10px; overflow-y: auto; }

            .header-section { 
                display: flex; 
                justify-content: space-between; 
                align-items: center;
                margin-bottom: 24px; 
            }

            .header-section h2 { 
                font-size: 22px; 
                font-weight: 800; 
                color: var(--heading); 
                margin: 0; 
            }

            .header-section p { 
                color: var(--text); 
                font-size: 13px; 
                margin: 4px 0 0 0;
            }

            .btn-add {
                background: var(--primary-blue);
                color: white;
                padding: 10px 20px;
                border-radius: 999px;
                text-decoration: none;
                font-weight: 700;
                font-size: 13px;
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-add:hover { opacity: 0.9; }

            .table-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 20px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.05);
            }

            .brand-table {
                width: 100%;
                border-collapse: collapse;
            }

            .brand-table th {
                text-align: left;
                padding: 12px 16px;
                font-size: 11px;
                font-weight: 800;
                color: #7e8eb8;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 1px solid #eef2ff;
            }

            .brand-table td {
                padding: 16px;
                font-size: 14px;
                color: var(--heading);
                border-bottom: 1px solid #f1f5f9;
            }

            .brand-table tr:last-child td { border-bottom: none; }

            .brand-table tr:hover { background: #f8fafc; }

            .brand-logo {
                width: 60px;
                height: 60px;
                object-fit: contain;
                border-radius: 12px;
                background: #f8fafc;
                padding: 8px;
            }

            .action-btns {
                display: flex;
                gap: 8px;
            }

            .btn-action {
                padding: 6px 14px;
                border-radius: 999px;
                font-size: 11px;
                font-weight: 700;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-edit {
                background: #f0f9ff;
                color: #0284c7;
                border-color: #bae6fd;
            }

            .btn-edit:hover { background: #e0f2fe; }

            .btn-delete {
                background: var(--danger-bg);
                color: var(--danger-text);
                border-color: #ffccd2;
            }

            .btn-delete:hover { background: #ffe4e6; }

            .empty-state {
                text-align: center;
                padding: 40px;
                color: var(--text);
            }

            .empty-state p { margin: 0; font-size: 14px; }

            @media (max-width: 991px) {
                body { padding: 12px; }
                .dashboard-shell { flex-direction: column; }
                .header-section { flex-direction: column; align-items: flex-start; gap: 12px; }
                .brand-table { display: block; overflow-x: auto; }
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
                    <div>
                        <h2>Danh sách Thương hiệu sản phẩm</h2>
                        <p>Quản lý các đối tác thương hiệu hiển thị trên hệ thống.</p>
                    </div>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <form action="${ctx}/BrandListServlet" method="get" style="display: flex; gap: 5px; margin: 0;">
                            <input type="text" name="search" value="${search}" placeholder="Tìm kiếm theo tên..." style="padding: 8px 12px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 12px; outline: none; width: 200px;">
                            <button type="submit" class="btn-add" style="padding: 8px 16px; border: none; cursor: pointer;">Tìm</button>
                        </form>
                        <a href="${ctx}/BrandAddServlet" class="btn-add" style="text-decoration: none; display: inline-block;">+ Thêm thương hiệu</a>
                    </div>
                </div>

                <div class="table-card">
                    <c:choose>
                        <c:when test="${not empty brands}">
                            <table class="brand-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Logo</th>
                                        <th>Tên Thương Hiệu</th>
                                        <th>Email / SĐT</th>
                                        <th>Địa chỉ</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="brand" items="${brands}">
                                        <tr>
                                            <td style="font-size: 11px; font-weight: 700; color: #94a3b8;">${brand.idSupplier}</td>
                                            <td>
                                                <img src="${brand.logoPath}" alt="${brand.name}" class="brand-logo">
                                            </td>
                                            <td>
                                                <div style="font-weight: 800; color: var(--heading);">${brand.name}</div>
                                            </td>
                                            <td>
                                                <div style="font-size: 12px; color: var(--heading); font-weight: 600;">${brand.email}</div>
                                                <div style="font-size: 11px; color: #7e8eb8;">${brand.phoneNumber}</div>
                                            </td>
                                            <td style="font-size: 12px; color: #7e8eb8; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                                ${brand.address}
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${ctx}/BrandEditServlet?id=${brand.idSupplier}" class="btn-action btn-edit">Sửa</a>
                                                    <form method="post" action="${ctx}/BrandListServlet" style="display:inline;">
                                                        <input type="hidden" name="id" value="${brand.idSupplier}">
                                                        <button type="submit" class="btn-action btn-delete" onclick="return confirm('Bạn muốn xoá thương hiệu này?')">Xoá</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <p>Chưa có thương hiệu nào. <a href="${ctx}/BrandAddServlet">Thêm ngay</a></p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Pagination --%>
                <div class="pagination-wrapper" style="margin-top: 20px; display: flex; justify-content: space-between; align-items: center;">
                    <div class="page-info" style="font-size: 12px; color: #7e8eb8;">
                        <c:choose>
                            <c:when test="${totalItems == 0}">
                                Không có bản ghi nào
                            </c:when>
                            <c:otherwise>
                                Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong> - 
                                <strong>${currentPage * pageSize > totalItems ? totalItems : currentPage * pageSize}</strong> 
                                của <strong>${totalItems}</strong> bản ghi
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="pagination" style="display: flex; gap: 4px; align-items: center; flex-wrap: nowrap;">
                        <c:set var="tPages" value="${totalPages == 0 ? 1 : totalPages}" />
                        <c:set var="startPage" value="${currentPage - 2}" />
                        <c:set var="endPage" value="${currentPage + 2}" />
                        <c:if test="${startPage < 1}">
                            <c:set var="endPage" value="${endPage + (1 - startPage)}" />
                            <c:set var="startPage" value="1" />
                        </c:if>
                        <c:if test="${endPage > tPages}">
                            <c:set var="startPage" value="${startPage - (endPage - tPages)}" />
                            <c:if test="${startPage < 1}">
                                <c:set var="startPage" value="1" />
                            </c:if>
                            <c:set var="endPage" value="${tPages}" />
                        </c:if>
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&search=${search}" class="page-btn" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; text-decoration: none; color: #64748b; font-size: 12px; font-weight: 600; white-space: nowrap;">&larr; Trước</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; color: #cbd5e1; font-size: 12px; font-weight: 600; cursor: not-allowed; white-space: nowrap;">&larr; Trước</span>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${startPage > 1}">
                            <a href="?page=1&search=${search}" class="page-btn" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; text-decoration: none; color: #64748b; font-size: 12px; font-weight: 600;">1</a>
                        </c:if>
                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="page-btn active" style="padding: 6px 12px; background: #5b74f1; color: white; border-radius: 8px; font-size: 12px; font-weight: 600;">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${i}&search=${search}" class="page-btn" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; text-decoration: none; color: #64748b; font-size: 12px; font-weight: 600;">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${endPage < tPages}">
                            <a href="?page=${tPages}&search=${search}" class="page-btn" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; text-decoration: none; color: #64748b; font-size: 12px; font-weight: 600;">${tPages}</a>
                        </c:if>
                        <c:choose>
                            <c:when test="${currentPage < tPages}">
                                <a href="?page=${currentPage + 1}&search=${search}" class="page-btn" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; text-decoration: none; color: #64748b; font-size: 12px; font-weight: 600; white-space: nowrap;">Sau &rarr;</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled" style="padding: 6px 12px; border: 1px solid #e7ecfb; border-radius: 8px; color: #cbd5e1; font-size: 12px; font-weight: 600; cursor: not-allowed; white-space: nowrap;">Sau &rarr;</span>
                            </c:otherwise>
                        </c:choose>
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