<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý blog - MobileShop Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    <style>
        .blog-thumb-sm {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 99px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .status-visible { background: #ecfdf5; color: #10b981; }
        .status-hidden { background: #fff7ed; color: #f59e0b; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="blog" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header">
                <div class="page-title">
                    <p class="admin-shell-eyebrow">Tương tác & Nội dung</p>
                    <h1>Quản lý Blog</h1>
                    <p class="admin-shell-subtitle">Tổ chức và cập nhật các bài viết tin tức, tư vấn sản phẩm.</p>
                </div>
                <a href="${ctx}/admin/blog?service=insertBlog" class="btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px;">
                    <i class="fas fa-plus"></i> Viết bài mới
                </a>
            </header>

            <section class="content-card">
                <!-- Filters -->
                <form action="${ctx}/admin/blog" method="GET" class="filter-bar mb-4" style="display: flex; gap: 16px; flex-wrap: wrap;">
                    <input type="hidden" name="service" value="listAll">
                    <div style="position: relative; flex: 1; min-width: 300px;">
                        <i class="fa-solid fa-search" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                        <input type="text" name="searchTitle" value="${searchTitle}" class="form-input-custom" placeholder="Tìm kiếm theo tiêu đề..." style="padding-left: 44px;">
                    </div>
                    
                    <select name="filterCat" class="form-input-custom" style="width: auto; min-width: 200px;">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach items="${catList}" var="cat">
                            <option value="${cat.idBlogCat}" ${selectedCat == cat.idBlogCat ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>

                    <button type="submit" class="btn-primary" style="padding: 12px 24px;">Lọc dữ liệu</button>
                    <a href="${ctx}/admin/blog" class="btn-cancel" style="text-decoration: none; padding: 12px 24px; font-size: 0.95rem;">Đặt lại</a>
                </form>

                <!-- Table -->
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 100px;">Ảnh bìa</th>
                                <th>Thông tin bài viết</th>
                                <th>Danh mục</th>
                                <th>Ngày đăng</th>
                                <th>Hiển thị</th>
                                <th style="width: 160px; text-align: center;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${blogList}" var="blog">
                                <tr>
                                    <td style="color: var(--text-muted); font-weight: 600;">#${blog.blogId}</td>
                                    <td>
                                        <img src="${not empty blog.imagePath ? blog.imagePath : 'img/no-image.png'}" class="blog-thumb-sm" alt="Thumbnail">
                                    </td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--text-main); font-size: 0.95rem;">${blog.title}</div>
                                        <c:if test="${not empty blog.subTitle}">
                                            <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">${blog.subTitle}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span style="font-weight: 600; color: var(--text-main); font-size: 0.9rem;">
                                            ${not empty blog.categoryName ? blog.categoryName : 'Chưa phân loại'}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="font-size: 0.85rem; color: var(--text-muted);">
                                            <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </td>
                                    <td>
                                      <c:choose>
                                        <c:when test="${blog.status == 'VISIBLE'}">
                                            <a href="${ctx}/admin/blog?service=toggleStatus&blogId=${blog.blogId}&newStatus=HIDDEN" 
                                               class="status-badge status-visible text-decoration-none">
                                                <i class="fas fa-eye"></i> Hiện
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${ctx}/admin/blog?service=toggleStatus&blogId=${blog.blogId}&newStatus=VISIBLE" 
                                               class="status-badge status-hidden text-decoration-none">
                                                <i class="fas fa-eye-slash"></i> Ẩn
                                            </a>
                                        </c:otherwise>
                                      </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 8px; justify-content: center;">
                                            <a href="${ctx}/admin/blog?service=updateBlog&blogId=${blog.blogId}" class="btn-outline" style="padding: 8px; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 10px; color: var(--primary);" title="Sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${ctx}/admin/blog?service=deleteBlog&blogId=${blog.blogId}" class="btn-outline" style="padding: 8px; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 10px; color: #ef4444; border-color: #fee2e2;" onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty blogList}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 5rem 0; color: var(--text-muted);">
                                        <div class="mb-3"><i class="fas fa-folder-open fa-4x" style="opacity: 0.1;"></i></div>
                                        <p class="fw-bold">Không tìm thấy bài viết nào.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <%-- Phân trang nâng cao (Giống Product) --%>
                <c:if test="${totalPages > 1}">
                    <div class="product-pagination">
                        <c:url var="basePageUrl" value="/admin/blog">
                            <c:param name="service" value="listAll" />
                            <c:param name="searchTitle" value="${searchTitle}" />
                            <c:param name="filterCat" value="${selectedCat}" />
                        </c:url>

                        <c:if test="${currentPage > 1}">
                            <a href="${basePageUrl}&page=1" class="product-page-link">Đầu</a>
                            <a href="${basePageUrl}&page=${prevPage}" class="product-page-link">Trước</a>
                        </c:if>

                        <c:if test="${showFirstPage}">
                            <a href="${basePageUrl}&page=1" class="product-page-link">1</a>
                        </c:if>
                        <c:if test="${showLeadingEllipsis}">
                            <span class="product-page-ellipsis">...</span>
                        </c:if>

                        <c:forEach begin="${startPage}" end="${endPage}" var="pageIndex">
                            <a href="${basePageUrl}&page=${pageIndex}" class="product-page-link ${pageIndex == currentPage ? 'is-active' : ''}">${pageIndex}</a>
                        </c:forEach>

                        <c:if test="${showTrailingEllipsis}">
                            <span class="product-page-ellipsis">...</span>
                        </c:if>
                        <c:if test="${showLastPage}">
                            <a href="${basePageUrl}&page=${totalPages}" class="product-page-link">${totalPages}</a>
                        </c:if>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${basePageUrl}&page=${nextPage}" class="product-page-link">Sau</a>
                            <a href="${basePageUrl}&page=${totalPages}" class="product-page-link">Cuối</a>
                        </c:if>
                    </div>
                </c:if>
            </section>
        </main>
    </div>
</body>
</html>