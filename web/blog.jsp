<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <!-- Css Styles -->
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="css/style.css" type="text/css">
        <link rel="stylesheet" href="css/mobileshop.css" type="text/css">
        <title>Cẩm nang công nghệ - MobileShop</title>
        <style>
            :root {
                --primary-blue: #3b82f6;
                --soft-blue: #f0f7ff;
                --text-main: #0f172a;
                --text-sub: #475569;
                --border-color: #e2e8f0;
            }

            body {
                background-color: #ffffff;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }

            /* --- New Light Blog Header --- */
            .blog-hero {
                background: #fff;
                padding: 100px 0 80px;
                border-bottom: 1px solid var(--border-color);
                position: relative;
                display: flex;
                justify-content: center;
                align-items: center;
                text-align: center;
            }
            .blog-hero .mobile-shell {
                width: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .blog-hero h1 {
                font-family: 'Lexend', sans-serif;
                font-size: 4rem;
                font-weight: 800;
                color: var(--text-main);
                margin-bottom: 20px;
                letter-spacing: -0.05em;
                line-height: 1.1;
            }
            .blog-hero h1 span {
                color: var(--primary-blue);
                position: relative;
                display: inline-block;
            }
            .blog-hero h1 span::after {
                content: '';
                position: absolute;
                bottom: 12px;
                left: 5%;
                width: 90%;
                height: 14px;
                background: rgba(59, 130, 246, 0.08);
                z-index: -1;
                border-radius: 4px;
            }
            .blog-hero p {
                font-family: 'Lexend', sans-serif;
                font-size: 1.25rem;
                color: var(--text-sub);
                max-width: 800px;
                line-height: 1.6;
                font-weight: 300;
                margin: 0 auto;
            }

            .blog-layout {
                display: grid;
                grid-template-columns: 280px 1fr;
                gap: 40px;
                padding: 20px 0 100px;
            }

            /* --- Redesigned Sidebar --- */
            .blog-sidebar {
                position: sticky;
                top: 100px;
            }
            .sidebar-title {
                font-family: 'Outfit', sans-serif;
                font-size: 0.85rem;
                text-transform: uppercase;
                font-weight: 700;
                color: var(--text-sub);
                letter-spacing: 0.1em;
                margin-bottom: 20px;
                padding-left: 10px;
            }
            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
                background: #fff;
                border-radius: 20px;
                border: 1px solid var(--border-color);
                padding: 10px;
            }
            .sidebar-link {
                display: flex;
                align-items: center;
                padding: 14px 18px;
                color: var(--text-main);
                text-decoration: none !important;
                font-weight: 600;
                border-radius: 12px;
                transition: all 0.25s ease;
                margin-bottom: 4px;
            }
            .sidebar-link:hover {
                background: var(--soft-blue);
                color: var(--primary-blue);
            }
            .sidebar-link.is-active {
                background: var(--primary-blue);
                color: #fff;
            }
            .sidebar-icon {
                width: 32px;
                font-size: 1.1rem;
                margin-right: 8px;
                display: flex;
                justify-content: center;
                opacity: 0.8;
            }

            /* --- Editorial Cards Upgrade --- */
            .blog-list-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 32px;
            }
            .editorial-card {
                border-radius: 24px;
                background: #fff;
                border: 1px solid var(--border-color);
                transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
                position: relative;
                overflow: hidden;
            }
            .editorial-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 20px 40px -12px rgba(59, 130, 246, 0.12);
                border-color: var(--primary-blue);
            }
            .editorial-card__image {
                width: 100%;
                aspect-ratio: 16 / 10;
                overflow: hidden;
                display: block;
                background: #f8fafc; /* Màu nền dự phòng */
            }
            .editorial-card__image img {
                width: 100% !important;
                height: 100% !important;
                object-fit: cover;
                transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
                display: block;
            }
            .editorial-card:hover img {
                transform: scale(1.05);
            }
            .editorial-card__body {
                padding: 24px;
            }
            .editorial-card__tag {
                background: var(--soft-blue);
                color: var(--primary-blue);
                font-size: 0.7rem;
                font-weight: 800;
                padding: 4px 10px;
                border-radius: 6px;
                display: inline-block;
                margin-bottom: 12px;
                text-transform: uppercase;
            }
            .editorial-card h3 {
                font-family: 'Outfit', sans-serif;
                font-size: 1.35rem;
                font-weight: 700;
                line-height: 1.4;
                margin-bottom: 12px;
                color: var(--text-main);
            }
            .editorial-card p {
                color: var(--text-sub);
                font-size: 0.95rem;
                line-height: 1.6;
                margin-bottom: 0;
            }

            /* --- Empty State Upgrade --- */
            .empty-state {
                grid-column: 1 / -1;
                background: #fff;
                border-radius: 32px;
                padding: 80px 40px;
                text-align: center;
                border: 1px dashed #e2e8f0;
            }
            .empty-state__icon {
                width: 80px;
                height: 80px;
                background: #f8fafc;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 24px;
                font-size: 2rem;
                color: #94a3b8;
            }
            .empty-state h2 {
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 10px;
            }
            .empty-state p {
                color: #64748b;
                font-size: 1.1rem;
            }

            @media (max-width: 1024px) {
                .blog-layout {
                    grid-template-columns: 1fr;
                }
                .blog-sidebar {
                    position: static;
                    margin-bottom: 40px;
                }
            }
            @media (max-width: 768px) {
                .blog-list-grid {
                    grid-template-columns: 1fr;
                }
                .blog-hero h1 {
                    font-size: 2rem;
                }
            }

            /* --- Pagination Styles --- */
            .pagination-container {
                margin-top: 50px;
                display: flex;
                justify-content: center;
                gap: 12px;
            }
            .page-btn {
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 16px;
                border: 1px solid #eef2f6;
                background: #fff;
                color: #2d3748;
                font-weight: 700;
                font-size: 1.1rem;
                text-decoration: none !important;
                transition: all 0.2s ease;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
            }
            .page-btn:hover {
                background: #f8fafc;
                border-color: #cbd5e1;
                transform: translateY(-2px);
            }
            .page-btn.active {
                background: #4f6cf6;
                border-color: #4f6cf6;
                color: #fff;
                box-shadow: 0 10px 15px -3px rgba(79, 108, 246, 0.3);
            }
            .page-btn.disabled {
                opacity: 0.2;
                pointer-events: none;
                background: #f8fafc;
            }
            .page-btn i {
                font-size: 1rem;
                color: #4a5568;
                font-weight: 900;
            }
            .page-btn.active i {
                color: #fff;
            }
        </style>
    </head>
    <body>
        <c:set var="activePage" value="blog" />
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <header class="blog-hero">
            <div class="mobile-shell">
                <h1>Cẩm nang <span>MobileShop.</span></h1>
                <p>Tuyển tập những bài viết đánh giá chi tiết, mẹo vặt hữu ích từ các chuyên gia hàng đầu về điện thoại.</p>
            </div>
        </header>

        <main class="mobile-shell">
            <div class="blog-layout">
                <aside class="blog-sidebar">
                    <div class="sidebar-title">Khám phá</div>
                    <ul class="sidebar-menu mb-4">
                        <li>
                            <a href="${ctx}/blog" class="sidebar-link ${empty selectedCat ? 'is-active' : ''}">
                                <span class="sidebar-icon"><i class="fa-solid fa-rectangle-list"></i></span>
                                <span>Tất cả bài viết</span>
                            </a>
                        </li>
                    </ul>

                    <div class="sidebar-title">Danh mục</div>
                    <ul class="sidebar-menu">
                        <c:forEach items="${catList}" var="cat">
                            <li>
                                <a href="${ctx}/blog?cat=${cat.idBlogCat}" class="sidebar-link ${selectedCat == cat.idBlogCat ? 'is-active' : ''}">
                                    <span class="sidebar-icon"><i class="fa-solid fa-folder"></i></span>
                                    <span>${cat.categoryName}</span>
                                </a>
                            </li>
                        </c:forEach>
                        <c:if test="${empty catList}">
                            <li class="p-3 text-muted small">Chưa có danh mục</li>
                        </c:if>
                    </ul>
                </aside>

                <!-- Blog List Area -->
                <div class="blog-main">
                    <c:if test="${not empty selectedCat}">
                        <div style="margin-bottom: 30px; display: flex; align-items: center; justify-content: space-between;">
                            <h2 style="font-size: 1.5rem; font-weight: 700; color: #1e293b;">
                                Danh mục: 
                                <c:forEach items="${catList}" var="cat">
                                    <c:if test="${cat.idBlogCat == selectedCat}">${cat.categoryName}</c:if>
                                </c:forEach>
                            </h2>
                            <a href="${ctx}/blog" style="font-size: 0.9rem; color: #1e293b; font-weight: 600; text-underline-offset: 4px;">Xóa bộ lọc</a>
                        </div>
                    </c:if>

                    <div class="blog-list-grid">
                        <c:choose>
                            <c:when test="${not empty blogPosts}">
                                <c:forEach items="${blogPosts}" var="post">
                                    <article class="editorial-card">
                                        <a href="${ctx}/blog-detail?bid=${post.blogId}" class="editorial-card__image">
                                            <img src="${not empty post.imagePath ? post.imagePath : 'img/no-image.png'}" alt="${post.title}">
                                        </a>
                                        <div class="editorial-card__body">
                                            <span class="editorial-card__tag">${post.categoryName}</span>
                                            <h3><a href="${ctx}/blog-detail?bid=${post.blogId}" style="color: inherit; text-decoration: none;">${post.title}</a></h3>
                                            <p>${post.description}</p>
                                        </div>
                                    </article>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state__icon">
                                        <i class="fa-solid fa-folder-open"></i>
                                    </div>
                                    <h2 style="color: #475569">Chưa có bài viết nào!</h2>
                                    <p>Rất tiếc, hiện tại chưa có bài đánh giá nào thuộc danh mục này.</p>
                                    <a href="${ctx}/blog" class="btn mt-4" style="background: #0f172a; color: #fff; border-radius: 12px; padding: 12px 30px; font-weight: 600;">Xem tất cả bài viết</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <a href="${ctx}/blog?cat=${selectedCat}&page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                                <i class="fa-solid fa-angle-left"></i>
                            </a>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${ctx}/blog?cat=${selectedCat}&page=${i}" class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                            </c:forEach>

                            <a href="${ctx}/blog?cat=${selectedCat}&page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                                <i class="fa-solid fa-angle-right"></i>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <!-- Scripts -->
        <script src="${ctx}/js/jquery-3.3.1.min.js"></script>
        <script src="${ctx}/js/bootstrap.min.js"></script>
        <script src="${ctx}/js/main.js"></script>
    </body>
</html>
