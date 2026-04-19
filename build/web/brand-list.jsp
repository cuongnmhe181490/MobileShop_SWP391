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
                --sidebar-bg: #27315f;
                --sidebar-muted: #c8d0ee;
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

            body { padding: 18px; overflow: hidden; }

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

            .sidebar-footer {
                margin-top: 26px;
                background: #ffffff;
                color: #1e2b57;
                padding: 14px 12px;
                border-radius: 18px;
            }

            .sidebar-footer strong {
                display: block;
                font-size: 12px;
                margin-bottom: 2px;
                line-height: 1.2;
            }

            .sidebar-footer span {
                display: block;
                font-size: 10px;
                color: #7381a8;
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
                .sidebar { width: 100%; flex-basis: auto; }
                .header-section { flex-direction: column; align-items: flex-start; gap: 12px; }
                .brand-table { display: block; overflow-x: auto; }
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
                                        <th>Đường dẫn Logo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="brand" items="${brands}">
                                        <tr>
                                            <td>${brand.idCat}</td>
                                            <td>
                                                <img src="${brand.imagePath}" alt="${brand.name}" class="brand-logo">
                                            </td>
                                            <td><strong>${brand.name}</strong></td>
                                            <td style="color: #94a3b8; font-size: 12px;">${brand.imagePath}</td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${ctx}/BrandEditServlet?id=${brand.idCat}" class="btn-action btn-edit">Sửa</a>
                                                    <form method="post" action="${ctx}/BrandListServlet" style="display:inline;">
                                                        <input type="hidden" name="id" value="${brand.idCat}">
                                                        <button type="submit" class="btn-action btn-delete" onclick="return confirm('Bạn muốn xoá brand này?')">Xoá</button>
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
                                <p>Chưa có brand nào. <a href="${ctx}/BrandAddServlet">Thêm brand đầu tiên</a></p>
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
            </div>
        </div>
    </body>
</html>