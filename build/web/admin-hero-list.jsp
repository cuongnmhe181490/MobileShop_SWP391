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
            --sidebar-bg: #27315f;
            --sidebar-muted: #c8d0ee;
            --heading: #24345f;
            --text: #64748b;
            --border-color: #e7ecfb;
            --primary-blue: #5b74f1;
        }

        html, body { height: 100%; margin: 0; background: var(--page-bg); font-family: 'Inter', 'Segoe UI', sans-serif; color: var(--heading); }
        body { padding: 18px; overflow: hidden; }

        .dashboard-shell {
            height: calc(99vh - 36px);
            background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
            border: 1px solid #eef2ff;
            border-radius: 30px;
            padding: 14px;
            display: flex;
            gap: 16px;
            overflow: hidden;
            box-shadow: 0 14px 34px rgba(110, 124, 180, 0.08);
        }

        /* Sidebar giữ nguyên style của bạn */
        .sidebar { width: 140px; flex: 0 0 140px; background: var(--sidebar-bg); color: white; border-radius: 24px; padding: 14px 10px; display: flex; flex-direction: column; margin-top: 50px; height: calc(80% - 10px); }
        .sidebar h4 { margin: 0 0 8px; font-size: 20px; font-weight: 800; }
        .nav-list { display: flex; flex-direction: column; gap: 8px; }
        .sidebar a { display: block; color: var(--sidebar-muted); padding: 8px 12px; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 12px; transition: 0.2s ease; }
        .sidebar a.active { background: #ffffff; color: #1f2a56; box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16); }

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
        .sidebar-footer { margin-top: 26px; background: #ffffff; color: #1e2b57; padding: 14px 12px; border-radius: 18px; }
        .sidebar-footer strong { display: block; font-size: 12px; line-height: 1.2; }
        .sidebar-footer span { display: block; font-size: 10px; color: #7381a8; }
    </style>
</head>

<body>
    <div class="dashboard-shell">
        <div class="sidebar">
            <h4>MobileShop</h4>
            <div class="nav-list">
                <a href="${ctx}/HeroListServlet" class="active">Biểu ngữ chính</a>
                <a href="${ctx}/BrandListServlet">Thương hiệu</a>
                <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
            </div>
        </div>

        <div class="content">
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
</body>

</html>