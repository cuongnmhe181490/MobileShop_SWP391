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
    <title>${blog.title} - MobileShop Cẩm nang</title>
    <style>
        .blog-hero {
            padding: 80px 0 40px;
            background: #fff;
            text-align: center;
        }
        .blog-tag {
            display: inline-block;
            padding: 6px 16px;
            background: #f1f5f9;
            color: #64748b;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 24px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .blog-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
            color: #0f172a;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
        }
        .blog-subtitle {
            font-size: 1.25rem;
            color: #64748b;
            max-width: 700px;
            margin: 0 auto 40px;
            line-height: 1.6;
        }
        .blog-meta {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            color: #94a3b8;
            font-size: 0.95rem;
        }
        .blog-featured-image {
            width: 100%;
            max-width: 1000px;
            aspect-ratio: 16/9;
            object-fit: cover;
            border-radius: 32px;
            margin: 60px auto;
            display: block;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
        }
        .blog-content-wrapper {
            max-width: 800px;
            margin: 0 auto 100px;
            font-size: 1.15rem;
            line-height: 1.8;
            color: #334155;
            text-align: left !important;
        }
        .blog-content-wrapper p {
            margin-bottom: 20px;
            text-align: justify !important;
            display: block;
        }
        .blog-content-wrapper h2 {
            font-size: 1.85rem;
            font-weight: 800;
            margin: 40px 0 20px;
            color: #0f172a;
            line-height: 1.2;
            text-align: left !important;
        }
        .blog-content-wrapper h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin: 32px 0 16px;
            color: #1e293b;
            display: block;
        }
        .summary-box {
            background: #f8fafc;
            border-left: 4px solid #3b82f6;
            padding: 32px;
            border-radius: 0 16px 16px 0;
            margin-bottom: 48px;
            font-style: italic;
            color: #475569;
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="blog" />
    <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

    <main>
        <div class="mobile-shell">
            <header class="blog-hero">
                <span class="blog-tag">${blog.idSupplier}</span>
                <h1 class="blog-title">${blog.title}</h1>
                <p class="blog-subtitle">${blog.subTitle}</p>
                <div class="blog-meta">
                    <span><i class="fa-regular fa-calendar me-2"></i> <fmt:formatDate value="${blog.createdDate}" pattern="dd 'tháng' MM, yyyy"/></span>
                    <span>•</span>
                    <span>Tác giả: Admin</span>
                </div>
            </header>

            <img src="${not empty blog.thumbnailPath ? blog.thumbnailPath : 'img/no-image.png'}" class="blog-featured-image" alt="${blog.title}">

            <div class="blog-content-wrapper">
                <div class="summary-box">
                    ${blog.summary}
                </div>
                
                <div class="main-body-text">
                    ${blog.content}
                </div>
                
                <hr style="margin: 60px 0; opacity: 0.1;">
                
                <div class="d-flex justify-content-between align-items-center">
                    <a href="${ctx}/home" class="pill-link pill-link--dark"> Quay lại trang chủ</a>
                    <div class="share-links d-flex gap-3">
                        <span style="color: #94a3b8; font-size: 0.9rem;">Chia sẻ bài viết:</span>
                        <a href="#" style="color: #64748b;"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#" style="color: #64748b;"><i class="fa-brands fa-twitter"></i></a>
                    </div>
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
