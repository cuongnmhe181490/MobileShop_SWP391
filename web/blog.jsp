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
        .blog-header {
            padding: 60px 0 40px;
            background: #fff;
            border-bottom: 1px solid #f1f5f9;
        }
        .blog-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 40px;
            padding: 40px 0 100px;
        }

        /* Sidebar Styles */
        .blog-sidebar {
            position: sticky;
            top: 20px;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
            background: #fff;
            border-radius: 16px;
            border: 1px solid #f1f5f9;
            overflow: hidden;
        }
        .sidebar-item {
            border-bottom: 1px solid #f1f5f9;
        }
        .sidebar-item:last-child {
            border-bottom: none;
        }
        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            color: #475569;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .sidebar-link:hover {
            background: #f8fafc;
            color: #3b82f6;
        }
        .sidebar-link.is-active {
            background: #eff6ff;
            color: #3b82f6;
            font-weight: 700;
        }
        .sidebar-icon {
            width: 32px;
            font-size: 1.25rem;
            margin-right: 12px;
            text-align: center;
            opacity: 0.7;
        }
        .sidebar-chevron {
            margin-left: auto;
            font-size: 0.8rem;
            opacity: 0.3;
        }

        /* Blog Grid Styles */
        .blog-list-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
        }
        .editorial-card {
            border-radius: 20px;
            overflow: hidden;
            background: #fff;
            transition: all 0.4s ease;
            border: 1px solid #f1f5f9;
        }
        .editorial-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px -10px rgba(0,0,0,0.08);
        }
        .editorial-card__image {
            aspect-ratio: 16/9;
            overflow: hidden;
            display: block;
        }
        .editorial-card__image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .editorial-card__body {
            padding: 20px;
        }
        .editorial-card__tag {
            color: #3b82f6;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 10px;
            display: block;
        }
        .editorial-card h3 {
            font-size: 1.15rem;
            font-weight: 700;
            line-height: 1.4;
            margin-bottom: 10px;
            color: #0f172a;
        }
        .editorial-card p {
            color: #64748b;
            font-size: 0.9rem;
            line-height: 1.6;
            margin-bottom: 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        @media (max-width: 1024px) {
            .blog-layout { grid-template-columns: 1fr; }
            .blog-sidebar { position: static; margin-bottom: 40px; }
            .sidebar-menu { display: flex; overflow-x: auto; white-space: nowrap; border-radius: 50px; padding: 5px; }
            .sidebar-item { border-bottom: none; border-right: 1px solid #f1f5f9; }
            .sidebar-link { padding: 10px 20px; }
            .sidebar-chevron { display: none; }
        }
        @media (max-width: 640px) {
            .blog-list-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="blog" />
    <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

    <header class="blog-header">
        <div class="mobile-shell">
            <h1 style="font-size: 2.5rem; font-weight: 800; color: #0f172a; margin-bottom: 8px;">Cẩm nang MobileShop.</h1>
            <p style="font-size: 1.1rem; color: #64748b;">Khám phá tin tức mới nhất từ các thương hiệu hàng đầu.</p>
        </div>
    </header>

    <main class="mobile-shell">
        <div class="blog-layout">
            <!-- Sidebar: Brand Categories -->
            <aside class="blog-sidebar">
                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${ctx}/blog" class="sidebar-link ${empty selectedBrand ? 'is-active' : ''}">
                            <i class="fa-solid fa-newspaper sidebar-icon"></i>
                            <span>Tất cả bài viết</span>
                            <i class="fa-solid fa-chevron-right sidebar-chevron"></i>
                        </a>
                    </li>
                    <c:forEach items="${supList}" var="sup">
                        <li class="sidebar-item">
                            <a href="${ctx}/blog?brand=${sup}" class="sidebar-link ${selectedBrand == sup ? 'is-active' : ''}">
                                <c:choose>
                                    <c:when test="${sup == 'Apple'}"><i class="fa-brands fa-apple sidebar-icon"></i></c:when>
                                    <c:when test="${sup == 'Samsung'}"><i class="fa-solid fa-mobile-screen sidebar-icon"></i></c:when>
                                    <c:when test="${sup == 'Google'}"><i class="fa-brands fa-google sidebar-icon"></i></c:when>
                                    <c:otherwise><i class="fa-solid fa-tags sidebar-icon"></i></c:otherwise>
                                </c:choose>
                                <span>${sup}</span>
                                <i class="fa-solid fa-chevron-right sidebar-chevron"></i>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </aside>

            <!-- Blog List Area -->
            <div class="blog-main">
                <c:if test="${not empty selectedBrand}">
                    <div style="margin-bottom: 24px; padding: 12px 20px; background: #f8fafc; border-radius: 12px; display: flex; align-items: center; justify-content: space-between;">
                        <span style="font-weight: 500; color: #64748b;">Đang hiển thị tin tức của: <strong style="color: #0f172a;">${selectedBrand}</strong></span>
                        <a href="${ctx}/blog" style="font-size: 0.85rem; color: #3b82f6; text-decoration: none;">Xóa bộ lọc</a>
                    </div>
                </c:if>

                <div class="blog-list-grid">
                    <c:choose>
                        <c:when test="${not empty blogPosts}">
                            <c:forEach items="${blogPosts}" var="post">
                                <article class="editorial-card">
                                    <a href="${ctx}/blog-detail?bid=${post.idPost}" class="editorial-card__image">
                                        <img src="${not empty post.thumbnailPath ? post.thumbnailPath : 'img/no-image.png'}" alt="${post.title}">
                                    </a>
                                    <div class="editorial-card__body">
                                        <span class="editorial-card__tag">${post.idSupplier}</span>
                                        <h3><a href="${ctx}/blog-detail?bid=${post.idPost}" style="color: inherit; text-decoration: none;">${post.title}</a></h3>
                                        <p>${post.summary}</p>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="grid-column: 1 / -1; text-align: center; padding: 60px 0; background: #fff; border-radius: 20px; border: 1px dashed #e2e8f0;">
                                <i class="fa-solid fa-newspaper" style="font-size: 3.5rem; color: #f1f5f9; margin-bottom: 20px;"></i>
                                <p style="color: #94a3b8;">Chưa có bài viết nào cho thương hiệu này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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
