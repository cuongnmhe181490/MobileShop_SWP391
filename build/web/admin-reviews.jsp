<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Quản lý Reviews</title>
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
                width: 160px;
                flex: 0 0 160px;
                background: var(--sidebar-bg);
                color: white;
                border-radius: 24px;
                padding: 20px 12px;
                display: flex;
                flex-direction: column;
            }

            .sidebar h4 { margin: 0 0 20px; font-size: 18px; font-weight: 800; text-align: center; }

            .nav-list { display: flex; flex-direction: column; gap: 8px; }

            .sidebar a {
                display: block;
                color: var(--sidebar-muted);
                padding: 10px 14px;
                text-decoration: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 12px;
                transition: 0.2s;
            }

            .sidebar a:hover { color: white; background: rgba(255,255,255,0.05); }

            .sidebar a.active {
                background: #ffffff;
                color: #1f2a56;
                box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16);
            }

            .sidebar-footer {
                margin-top: auto;
                padding-top: 20px;
            }

            .sidebar-footer strong { display: block; font-size: 12px; margin-bottom: 2px; }
            .sidebar-footer span { display: block; font-size: 10px; color: #7381a8; }

            .logout-link {
                margin-top: 8px;
                padding: 0 12px;
                text-decoration: none;
                color: #f8faff;
                font-weight: 800;
                font-size: 12px;
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

            /* Flash messages */
            .flash {
                border-radius: 16px;
                padding: 12px 18px;
                font-size: 12px;
                font-weight: 600;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .flash-success {
                background: var(--success-bg);
                border: 1px solid var(--success-text);
                color: var(--success-text);
            }
            .flash-error {
                background: var(--danger-bg);
                border: 1px solid var(--danger-text);
                color: var(--danger-text);
            }

            /* Filter chips */
            .filter-bar {
                display: flex;
                gap: 8px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }

            .filter-chip {
                padding: 8px 16px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
                background: #ffffff;
                color: var(--text);
                border: 1px solid var(--border-color);
                transition: 0.2s;
            }

            .filter-chip:hover { border-color: var(--primary-blue); color: var(--primary-blue); }

            .filter-chip.is-active {
                background: var(--primary-blue);
                color: white;
                border-color: var(--primary-blue);
            }

            .table-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 20px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.05);
            }

            .review-table {
                width: 100%;
                border-collapse: collapse;
            }

            .review-table th {
                text-align: left;
                padding: 12px 16px;
                font-size: 11px;
                font-weight: 800;
                color: #7e8eb8;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 1px solid #eef2ff;
            }

            .review-table td {
                padding: 16px;
                font-size: 14px;
                color: var(--heading);
                border-bottom: 1px solid #f1f5f9;
                vertical-align: top;
            }

            .review-table tr:last-child td { border-bottom: none; }
            .review-table tr:hover { background: #f8fafc; }

            .reviewer-name { font-weight: 700; }
            .review-content { 
                max-width: 300px; 
                color: var(--text);
                font-size: 13px;
                line-height: 1.5;
            }

            .stars {
                color: #fbbf24;
                font-size: 14px;
            }

            .verified-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 999px;
                font-size: 10px;
                font-weight: 700;
                background: #ecfdf5;
                color: #059669;
            }

            .unverified-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 999px;
                font-size: 10px;
                font-weight: 700;
                background: #fff4f5;
                color: #ea4f68;
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

            /* Pagination */
            .pagination-bar {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-top: 20px;
            }

            .page-pill {
                padding: 8px 14px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
                background: #ffffff;
                color: var(--text);
                border: 1px solid var(--border-color);
            }

            .page-pill:hover { border-color: var(--primary-blue); color: var(--primary-blue); }

            .page-pill.is-active {
                background: var(--primary-blue);
                color: white;
                border-color: var(--primary-blue);
            }

            .page-pill.is-disabled {
                opacity: 0.5;
                pointer-events: none;
            }

            @media (max-width: 991px) {
                body { padding: 12px; }
                .dashboard-shell { flex-direction: column; }
                .sidebar { width: 100%; flex-basis: auto; }
                .header-section { flex-direction: column; align-items: flex-start; gap: 12px; }
                .review-table { display: block; overflow-x: auto; }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <div class="sidebar">
                <h4>MobileShop</h4>
                <div class="nav-list">
                    <a href="${ctx}/HeroListServlet">Biểu ngữ chính</a>
                    <a href="${ctx}/BrandListServlet">Thương hiệu</a>
                    <a href="${ctx}/ReviewListServlet" class="active">Đánh giá</a>
                    <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                    <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
                </div>

                <div class="sidebar-footer">
                    <strong>Xin chào admin</strong>
                    <span>Quản lý đánh giá</span>
                </div>
                <a href="#" class="logout-link">Đăng xuất</a>
            </div>

            <div class="content">
                <div class="header-section">
                    <div>
                        <h2>Quản lý Reviews</h2>
                        <p>Quản lý đánh giá sản phẩm từ khách hàng.</p>
                    </div>
                    <a href="${ctx}/ReviewAddServlet" class="btn-add">+ Thêm Review</a>
                </div>

                <%-- Flash messages --%>
                <c:if test="${not empty sessionScope.flashSuccess}">
                    <div class="flash flash-success">✅ ${sessionScope.flashSuccess}</div>
                    <c:remove var="flashSuccess" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.flashError}">
                    <div class="flash flash-error">❌ ${sessionScope.flashError}</div>
                    <c:remove var="flashError" scope="session"/>
                </c:if>

                <%-- Filter chips --%>
                <div class="filter-bar">
                    <a href="${ctx}/ReviewListServlet" class="filter-chip ${empty starFilter ? 'is-active' : ''}">
                        Tất cả (${totalReviews})
                    </a>
                    <c:forEach begin="1" end="5" var="star">
                        <a href="${ctx}/ReviewListServlet?star=${star}" class="filter-chip ${starFilter == star ? 'is-active' : ''}">
                            ${star} sao (${starCounts[star]})
                        </a>
                    </c:forEach>
                </div>

                <div class="table-card">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <table class="review-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Người đánh giá</th>
                                        <th>Sao</th>
                                        <th>Nội dung</th>
                                        <th>Phản hồi</th>
                                        <th>Ngày</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="review" items="${reviews}">
                                        <tr>
                                            <td>${review.idReview}</td>
                                            <td class="reviewer-name">${review.reviewerName}</td>
                                            <td>
                                                <span class="stars">
                                                    <c:forEach begin="1" end="5" var="s">
                                                        <c:choose>
                                                            <c:when test="${s <= review.ranking}">★</c:when>
                                                            <c:otherwise>☆</c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </span>
                                            </td>
                                            <td class="review-content">${review.review}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty review.replyContent}">
                                                        <span style="color: var(--primary-blue); font-size: 12px;">✓ Đã phản hồi</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8; font-size: 12px;">- Chưa phản hồi</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${review.verified}">
                                                        <span class="verified-badge">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="unverified-badge">Chưa xác nhận</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${ctx}/ReviewReplyServlet?id=${review.idReview}" class="btn-action btn-edit">Phản hồi</a>
                                                    <form method="post" action="${ctx}/ReviewDeleteServlet" style="display:inline;">
                                                        <input type="hidden" name="id" value="${review.idReview}">
                                                        <button type="submit" class="btn-action btn-delete" onclick="return confirm('Bạn muốn xóa review này?')">Xóa</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <%-- Pagination: Luôn hiển thị --%>
                            <div class="pagination-bar">
                                <c:if test="${totalPages > 1}">
                                    <a href="${ctx}/ReviewListServlet?page=${currentPage - 1}${not empty starFilter ? '&star='.concat(starFilter) : ''}" 
                                       class="page-pill ${currentPage == 1 ? 'is-disabled' : ''}">Trước</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                    <a href="${ctx}/ReviewListServlet?page=${pageNumber}${not empty starFilter ? '&star='.concat(starFilter) : ''}" 
                                       class="page-pill ${currentPage == pageNumber ? 'is-active' : ''}">${pageNumber}</a>
                                </c:forEach>
                                <c:if test="${totalPages > 1}">
                                    <a href="${ctx}/ReviewListServlet?page=${currentPage + 1}${not empty starFilter ? '&star='.concat(starFilter) : ''}" 
                                       class="page-pill ${currentPage == totalPages ? 'is-disabled' : ''}">Sau</a>
                                </c:if>
                                <c:if test="${totalPages == 1}">
                                    <span class="page-pill" style="background: #5b74f1; color: white;">Trang 1 / 1</span>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <p>Chưa có review nào.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </body>
</html>