<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đánh giá - MobileShop</title>
        
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <style>
            :root {
                --bg-body: #f4f7fe;
                --bg-sidebar: #1e293b;
                --bg-card: #ffffff;
                --primary: #4318ff;
                --primary-light: #e9e3ff;
                --text-main: #1b2559;
                --text-muted: #a3aed0;
                --border: #e9edf7;
                --danger: #ee5d50;
                --success: #05cd99;
                --warning: #ffb81c;
                --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
                --sidebar-active: #aff22f;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Plus Jakarta Sans', 'Inter', sans-serif;
            }

            body {
                background-color: var(--bg-body);
                color: var(--text-main);
                overflow-x: hidden;
            }

            .dashboard-container {
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar */
            .sidebar {
                width: 260px;
                background: var(--bg-sidebar);
                padding: 24px 0;
                display: flex;
                flex-direction: column;
                position: fixed;
                height: 100vh;
                z-index: 100;
                color: white;
            }

            .brand {
                padding: 0 24px;
                margin-bottom: 40px;
                text-decoration: none;
                color: white;
            }
            .brand h2 { font-size: 1.5rem; font-weight: 700; }
            .brand p { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }

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

            .menu-link {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 24px;
                color: #94a3b8;
                text-decoration: none;
                transition: 0.3s;
                font-weight: 500;
                font-size: 0.95rem;
                border-left: 4px solid transparent;
            }
            .menu-link.active {
                background: rgba(175, 242, 47, 0.1);
                color: var(--sidebar-active);
                border-left-color: var(--sidebar-active);
                font-weight: 600;
            }
            .menu-link:hover { color: white; background: rgba(255,255,255,0.05); }

            /* Main Content */
            .main-content {
                flex: 1;
                margin-left: 260px;
                padding: 40px;
            }

            .page-header {
                margin-bottom: 32px;
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
            }
            .page-header h1 { font-size: 1.8rem; font-weight: 800; color: var(--text-main); }
            .page-header p { color: var(--text-muted); font-size: 0.9rem; margin-top: 4px; }

            /* Filters */
            .filter-tabs {
                display: flex;
                gap: 12px;
                margin-bottom: 32px;
                background: white;
                padding: 6px;
                border-radius: 12px;
                width: fit-content;
                box-shadow: var(--shadow);
            }
            .tab {
                padding: 8px 20px;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 700;
                text-decoration: none;
                transition: 0.3s;
                color: var(--text-muted);
            }
            .tab.active {
                background: var(--primary);
                color: white;
            }

            /* Review Card */
            .rv-card {
                background: var(--bg-card);
                border-radius: 20px;
                padding: 24px;
                margin-bottom: 24px;
                box-shadow: var(--shadow);
                border: 1px solid transparent;
                transition: 0.3s;
            }
            .rv-card:hover { transform: translateY(-5px); border-color: var(--primary-light); }

            .rv-card__top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }
            .rv-product-name { font-size: 1.1rem; font-weight: 700; color: var(--text-main); }
            .rv-user-info { font-size: 0.85rem; color: var(--text-muted); display: flex; align-items: center; gap: 8px; }

            .stars { color: #ffb81c; font-size: 0.9rem; }
            .stars .off { color: #e9edf7; }

            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 700;
            }
            .status-visible { background: #e6f9f4; color: var(--success); }
            .status-hidden { background: #feebeb; color: var(--danger); }

            .rv-content {
                font-size: 0.95rem;
                line-height: 1.6;
                color: #475569;
                margin-bottom: 24px;
            }

            /* Reply Section */
            .reply-box {
                background: #f8fafc;
                border-radius: 16px;
                padding: 16px;
                border: 1px solid var(--border);
            }
            .reply-existing {
                padding-bottom: 16px;
                margin-bottom: 16px;
                border-bottom: 1px dashed var(--border);
                font-size: 0.9rem;
            }
            .reply-existing strong { color: var(--primary); display: block; margin-bottom: 4px; font-size: 0.75rem; text-transform: uppercase; }

            .reply-form { display: flex; gap: 12px; }
            .reply-input {
                flex: 1;
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 12px;
                font-size: 0.9rem;
                resize: none;
                height: 80px;
                transition: 0.3s;
            }
            .reply-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-light); }

            .btn-action {
                padding: 10px 24px;
                border-radius: 12px;
                font-weight: 700;
                font-size: 0.85rem;
                cursor: pointer;
                border: none;
                transition: 0.3s;
            }
            .btn-primary { background: var(--primary); color: white; }
            .btn-primary:hover { background: #3311cc; }
            .btn-toggle { background: white; border: 1px solid var(--border); color: var(--text-main); }
            .btn-toggle:hover { background: #f1f5f9; }

            /* Pagination */
            .pagination {
                display: flex;
                gap: 8px;
                justify-content: center;
                margin-top: 40px;
            }
            .page-link {
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: white;
                border-radius: 10px;
                text-decoration: none;
                color: var(--text-main);
                font-weight: 700;
                box-shadow: var(--shadow);
                transition: 0.3s;
            }
            .page-link.active { background: var(--primary); color: white; }
            .page-link:hover:not(.active) { background: var(--primary-light); color: var(--primary); }

            .empty-state {
                text-align: center;
                padding: 80px;
                background: white;
                border-radius: 30px;
                box-shadow: var(--shadow);
            }
        </style>
    </head>
    <body>

    <div class="dashboard-container">
        <!-- Sidebar -->
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
                    <li><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link active"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/AdminHomeConfigServlet" class="menu-link"><i class="fa-solid fa-home"></i>Trang chủ</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">HỆ THỐNG</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-house"></i>Về trang chủ</a></li>
                </ul>
            </div>

            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-arrow-right-from-bracket"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="page-header">
                <div>
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Hệ thống phản hồi</p>
                    <h1>Quản lý đánh giá</h1>
                </div>
                <div style="text-align: right;">
                    <span style="font-weight: 700; color: var(--primary); font-size: 1.2rem;">${totalReviews}</span>
                    <span style="color: var(--text-muted); font-size: 0.85rem; display: block;">Tổng số đánh giá</span>
                </div>
            </header>

            <%-- Filter tabs --%>
            <div class="filter-tabs">
                <a class="tab ${empty statusFilter ? 'active' : ''}" href="${ctx}/admin/reviews">Tất cả</a>
                <a class="tab ${'VISIBLE' eq statusFilter ? 'active' : ''}" href="${ctx}/admin/reviews?status=VISIBLE">Đang hiện</a>
                <a class="tab ${'HIDDEN' eq statusFilter ? 'active' : ''}" href="${ctx}/admin/reviews?status=HIDDEN">Đang ẩn</a>
            </div>

            <%-- Danh sách --%>
            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="empty-state">
                        <i class="fa-solid fa-comment-slash" style="font-size: 3rem; color: #e2e8f0; margin-bottom: 16px;"></i>
                        <p>Không tìm thấy đánh giá nào trong hệ thống.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${reviews}" var="rv">
                        <div class="rv-card">
                            <div class="rv-card__top">
                                <div>
                                    <h3 class="rv-product-name">${rv.productName}</h3>
                                    <div class="rv-user-info">
                                        <span style="font-weight: 700; color: var(--text-main);">${rv.reviewerName}</span>
                                        <span>&bull;</span>
                                        <fmt:formatDate value="${rv.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        <span>&bull;</span>
                                        <span class="stars">
                                            <c:forEach begin="1" end="5" var="s">
                                                <i class="fa-solid fa-star ${s <= rv.ranking ? '' : 'off'}"></i>
                                            </c:forEach>
                                        </span>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 12px; align-items: center;">
                                    <span class="status-badge ${rv.status eq 'VISIBLE' ? 'status-visible' : 'status-hidden'}">
                                        <i class="fa-solid ${rv.status eq 'VISIBLE' ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                        ${rv.status eq 'VISIBLE' ? 'Công khai' : 'Đã ẩn'}
                                    </span>
                                    <form method="post" action="${ctx}/admin/reviews">
                                        <input type="hidden" name="action" value="toggle"/>
                                        <input type="hidden" name="reviewId" value="${rv.reviewId}"/>
                                        <input type="hidden" name="page" value="${currentPage}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <button type="submit" class="btn-action btn-toggle">
                                            ${rv.status eq 'VISIBLE' ? 'Ẩn đi' : 'Hiện lại'}
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <div class="rv-content">${rv.reviewContent}</div>

                            <%-- Phản hồi --%>
                            <div class="reply-box">
                                <c:if test="${not empty rv.replyContent}">
                                    <div class="reply-existing">
                                        <strong>Phản hồi từ Admin &bull; <fmt:formatDate value="${rv.replyDate}" pattern="dd/MM/yyyy"/></strong>
                                        ${rv.replyContent}
                                    </div>
                                </c:if>
                                <form method="post" action="${ctx}/admin/reviews" class="reply-form">
                                    <input type="hidden" name="action" value="reply"/>
                                    <input type="hidden" name="reviewId" value="${rv.reviewId}"/>
                                    <input type="hidden" name="page" value="${currentPage}"/>
                                    <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                    <textarea name="replyContent" class="reply-input"
                                              placeholder="${not empty rv.replyContent ? 'Sửa lại phản hồi...' : 'Gửi lời phản hồi tới khách hàng...'}"
                                              >${rv.replyContent}</textarea>
                                    <button type="submit" class="btn-action btn-primary">${not empty rv.replyContent ? 'Cập nhật' : 'Gửi đi'}</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <%-- Phân trang --%>
            <c:if test="${totalPages > 1}">
                <nav class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="${ctx}/admin/reviews?page=${currentPage-1}&status=${statusFilter}"><i class="fa-solid fa-chevron-left"></i></a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <a class="page-link ${currentPage == p ? 'active' : ''}"
                           href="${ctx}/admin/reviews?page=${p}&status=${statusFilter}">${p}</a>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="${ctx}/admin/reviews?page=${currentPage+1}&status=${statusFilter}"><i class="fa-solid fa-chevron-right"></i></a>
                    </c:if>
                </nav>
            </c:if>
        </main>
    </div>
    </body>
</html>
