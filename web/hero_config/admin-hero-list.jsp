<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Danh sách Hero banner</title>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
    <style>
        :root {
            --page-bg: #f5f7ff;
            --heading: #24345f;
            --text: #64748b;
            --border-color: #e7ecfb;
            --primary-blue: #5b74f1;
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

        /* Sidebar giữ nguyên style của bạn */

        .content { flex: 1; min-width: 0; padding: 4px 2px 8px; overflow-y: auto; }
        .header-section { margin-bottom: 18px; padding-left: 6px; display: flex; justify-content: space-between; align-items: center; }
        .header-section h2 { margin: 0; font-size: 18px; font-weight: 800; color: var(--heading); }

        /* Table Card Style */
        .table-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 10px;
            box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
        }

        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; font-size: 12px; }
        .custom-table th { background: #f8faff; color: #7e8eb8; font-weight: 800; text-transform: uppercase; padding: 12px; border-bottom: 1px solid var(--border-color); }
        .custom-table td { padding: 12px; border-bottom: 1px solid #f1f5ff; vertical-align: middle; }
        .custom-table tr:last-child td { border-bottom: none; }

        /* Nút thao tác */
        .btn-action { padding: 4px 12px; border-radius: 999px; font-size: 11px; font-weight: 700; text-decoration: none; display: inline-block; margin-right: 4px; }
        .btn-edit { background: #eef2ff; color: #5b74f1; }
        .btn-delete { background: #fff4f5; color: #ea4f68; }
        
        .img-preview { width: 80px; height: 45px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
        
        /* Sidebar Footer */

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
                <div>
                    <h2>Danh sách Hero banner</h2>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <form action="${ctx}/HeroListServlet" method="get" style="display: flex; gap: 5px; margin: 0;">
                        <input type="text" name="search" value="${search}" placeholder="Tìm kiếm theo tiêu đề..." style="padding: 8px 12px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 12px; outline: none; width: 220px;">
                        <button type="submit" class="btn btn-primary" style="border-radius: 8px; font-size: 12px; font-weight: 600; padding: 8px 16px; border: none; background: var(--primary-blue); color: white; cursor: pointer;">Tìm</button>
                    </form>
                    <a href="${ctx}/HeroAddServlet" class="btn btn-primary" style="border-radius: 999px; font-size: 12px; font-weight: 800; padding: 8px 20px; text-decoration: none; display: inline-block;">+ Thêm mới</a>
                </div>
            </div>

            <div class="table-card">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th style="width: 100px;">Hình ảnh</th>
                            <th>Tiêu đề chính</th>
                            <th>Nhãn phụ</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${heroList}">
                            <tr>
                                <td><strong>#${h.id}</strong></td>
                                <td>
                                    <img src="${h.imageUrl}" class="img-preview" alt="hero">
                                </td>
                                <td>
                                    <div style="font-weight: 700; color: var(--heading);">${h.title}</div>
                                    <div style="color: #94a3b8; font-size: 10px;">CTA: ${h.ctaPrimary}</div>
                                </td>
                                <td><span style="color: #64748b;">${h.eyebrow}</span></td>
                                <td style="text-align: center;">
                                    <a href="${ctx}/HeroEditServlet?id=${h.id}" class="btn-action btn-edit">Sửa</a>
                                    <a href="${ctx}/HeroDeleteServlet?id=${h.id}" 
                                       onclick="return confirm('Bạn có chắc muốn xóa banner này?')" 
                                       class="btn-action btn-delete">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty heroList}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 40px; color: #94a3b8;">
                                    Chưa có dữ liệu banner nào được tạo.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <%-- Pagination Info: Luôn hiển thị số lượng bản ghi và số trang --%>
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
                        <c:if test="${startPage > 2}">
                            <span style="padding: 6px 4px; color: #94a3b8; font-weight: 600;">...</span>
                        </c:if>
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
                        <c:if test="${endPage < tPages - 1}">
                            <span style="padding: 6px 4px; color: #94a3b8; font-weight: 600;">...</span>
                        </c:if>
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
            
            <div style="margin-top: 15px;">
                <a href="${ctx}/AdminHomeConfigServlet" style="font-size: 12px; color: #7e8eb8; text-decoration: none;">&larr; Quay lại cấu hình chung</a>
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