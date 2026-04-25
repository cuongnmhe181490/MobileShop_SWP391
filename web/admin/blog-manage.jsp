<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Blog - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <style>
        :root {
            --bg-body: #f4f7fe;
            --sidebar-bg: #1e293b;
            --primary: #4318ff;
            --accent: #aff22f;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border-color: #e9edf7;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg-body); margin: 0; color: var(--text-main); }

        /* Sidebar Styles */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
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
        .sidebar .brand { padding: 0 24px; margin-bottom: 40px; text-decoration: none; color: white; display: block; }
        .sidebar .brand h2 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        
        .nav-section { margin-bottom: 32px; }
        .nav-label { font-size: 0.7rem; text-transform: uppercase; color: #64748b; letter-spacing: 1px; margin-bottom: 12px; display: block; padding: 0 24px; }
        
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link { display: flex; align-items: center; gap: 12px; padding: 12px 24px; color: #94a3b8; text-decoration: none; font-weight: 500; font-size: 0.95rem; border-left: 4px solid transparent; transition: 0.3s; }
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active { 
            background: rgba(175, 242, 47, 0.1); 
            color: var(--accent); 
            border-left-color: var(--accent); 
            font-weight: 600; 
        }

        /* Main Content */
        .main-content { margin-left: 260px; padding: 2.5rem; width: calc(100% - 260px); }

        .page-header { margin-bottom: 2.5rem; display: flex; justify-content: space-between; align-items: center; }
        .eyebrow { font-size: 0.75rem; font-weight: 700; color: var(--text-sub); text-transform: uppercase; letter-spacing: 1px; }
        .page-header h1 { font-size: 2.1rem; font-weight: 800; color: var(--text-main); margin: 5px 0; }
        .page-header p { color: var(--text-sub); font-size: 0.95rem; margin: 0; }

        .btn-add { background: var(--primary); color: white; border: none; padding: 0.8rem 1.8rem; border-radius: 10px; font-weight: 700; display: flex; align-items: center; gap: 10px; text-decoration: none; transition: 0.2s; }
        .btn-add:hover { background: #3311cc; color: white; transform: translateY(-1px); }

        /* Filter Area */
        .filter-card { background: white; border-radius: 12px; padding: 1.5rem; border: 1px solid var(--border); margin-bottom: 2rem; display: flex; gap: 1rem; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .search-box { position: relative; flex: 1; }
        .search-box i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
        .search-box input { width: 100%; padding: 0.75rem 1rem 0.75rem 2.8rem; border-radius: 10px; border: 1.5px solid var(--border); background: #f8fafc; font-size: 0.95rem; outline: none; transition: 0.2s; }
        .search-box input:focus { border-color: var(--accent); background: white; }

        .select-premium { padding: 0.75rem 1.5rem; border-radius: 10px; border: 1.5px solid var(--border); background: #f8fafc; font-size: 0.95rem; outline: none; min-width: 180px; }
        .btn-filter { background: var(--primary); color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 10px; font-weight: 700; cursor: pointer; transition: 0.2s; }
        .btn-filter:hover { background: #3311cc; }
        .btn-reset { background: #f1f5f9; color: #475569; border: none; padding: 0.75rem 1.5rem; border-radius: 10px; font-weight: 700; cursor: pointer; transition: 0.2s; text-decoration: none; }

        /* Table Styles */
        .table-card { background: white; border-radius: 12px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { background: #f8fafc; padding: 1rem 1.5rem; text-align: left; font-size: 0.75rem; font-weight: 700; color: var(--text-sub); text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid var(--border); }
        .admin-table td { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); vertical-align: middle; }
        
        .id-cell { font-weight: 600; color: var(--text-sub); }
        .blog-thumb { width: 48px; height: 48px; border-radius: 10px; object-fit: cover; border: 1px solid var(--border); }
        
        .blog-info-title { font-weight: 700; color: var(--text-main); font-size: 0.95rem; display: block; margin-bottom: 4px; }
        .blog-info-sub { font-size: 0.85rem; color: var(--text-sub); line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
        
        .cat-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; background: #f1f5f9; color: #475569; }
        .date-text { font-size: 0.85rem; color: var(--text-sub); font-weight: 500; }
        
        .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 30px; font-size: 0.8rem; font-weight: 700; cursor: pointer; border: none; transition: 0.2s; }
        .status-pill:hover { transform: scale(1.05); }
        .status-active { background: #dcfce7; color: #15803d; }
        .status-hidden { background: #fee2e2; color: #b91c1c; }

        .actions-flex { display: flex; gap: 8px; }
        .btn-action { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border); transition: 0.2s; text-decoration: none; }
        .btn-edit { color: #6366f1; background: #eef2ff; }
        .btn-edit:hover { background: #6366f1; color: white; }
        .btn-delete { color: #ef4444; background: #fef2f2; }
        .btn-delete:hover { background: #ef4444; color: white; }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link"><i class="fa-solid fa-receipt"></i>Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/products" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link"><i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active"><i class="fa-solid fa-newspaper"></i>Blog / Tin tức</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link"><i class="fa-solid fa-house-chimney-window"></i>Trang chủ</a></li>
                </ul>
            </div>

            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-globe"></i>Xem Website</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-power-off"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <header class="page-header">
                <div>
                    <span class="eyebrow">TƯƠNG TÁC & NỘI DUNG</span>
                    <h1>Quản lý Blog</h1>
                    <p>Tổ chức và cập nhật các bài viết tin tức, tư vấn sản phẩm.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/blog?service=insertBlog" class="btn-add">
                    <i class="fas fa-plus"></i> Viết bài mới
                </a>
            </header>

            <form action="${pageContext.request.contextPath}/admin/blog" method="GET" class="filter-card">
                <input type="hidden" name="service" value="listAll">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="searchTitle" value="${searchTitle}" placeholder="Tìm kiếm theo tiêu đề...">
                </div>
                <select name="filterCat" class="select-premium">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach items="${catList}" var="cat">
                        <option value="${cat.idBlogCat}" ${cat.idBlogCat == selectedCat ? 'selected' : ''}>${cat.categoryName}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn-filter">Lọc dữ liệu</button>
                <a href="${pageContext.request.contextPath}/admin/blog" class="btn-reset">Đặt lại</a>
            </form>

            <div class="table-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 70px;">ID</th>
                            <th style="width: 80px;">Ảnh bìa</th>
                            <th>Thông tin bài viết</th>
                            <th style="width: 150px;">Danh mục</th>
                            <th style="width: 120px;">Ngày đăng</th>
                            <th style="width: 130px;">Hiển thị</th>
                            <th style="width: 110px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${blogList}" var="blog">
                            <tr>
                                <td class="id-cell">#${blog.blogId}</td>
                                <td>
                                    <img src="${not empty blog.imagePath ? blog.imagePath : 'img/no-image.png'}" class="blog-thumb" alt="Thumb">
                                </td>
                                <td>
                                    <span class="blog-info-title">${blog.title}</span>
                                    <span class="blog-info-sub">${blog.subTitle}</span>
                                </td>
                                <td>
                                    <span class="cat-badge">${not empty blog.categoryName ? blog.categoryName : 'N/A'}</span>
                                </td>
                                <td>
                                    <span class="date-text"><fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/></span>
                                </td>
                                <td>
                                    <c:set var="isVis" value="${blog.status eq 'VISIBLE'}" />
                                    <button class="status-pill ${isVis ? 'status-active' : 'status-hidden'}" 
                                            onclick="toggleStatus(${blog.blogId}, '${blog.status}', this)">
                                        <i class="fa-solid ${isVis ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                        <span>${isVis ? 'Hiện' : 'Ẩn'}</span>
                                    </button>
                                </td>
                                <td>
                                    <div class="actions-flex">
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=updateBlog&blogId=${blog.blogId}" class="btn-action btn-edit" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=deleteBlog&blogId=${blog.blogId}" class="btn-action btn-delete" title="Xóa" onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination-container" style="margin-top: 2rem; display: flex; justify-content: center; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/admin/blog?service=listAll&page=${currentPage - 1}&searchTitle=${searchTitle}&filterCat=${selectedCat}" 
                       class="btn-action ${currentPage == 1 ? 'disabled' : ''}" style="width: auto; padding: 0 15px; pointer-events: ${currentPage == 1 ? 'none' : 'auto'}; opacity: ${currentPage == 1 ? '0.5' : '1'}">
                        <i class="fa-solid fa-angle-left"></i>
                    </a>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="${pageContext.request.contextPath}/admin/blog?service=listAll&page=${i}&searchTitle=${searchTitle}&filterCat=${selectedCat}" 
                           class="btn-action ${currentPage == i ? 'active-page' : ''}" 
                           style="width: 40px; height: 40px; font-weight: 700; ${currentPage == i ? 'background: var(--accent); color: white;' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <a href="${pageContext.request.contextPath}/admin/blog?service=listAll&page=${currentPage + 1}&searchTitle=${searchTitle}&filterCat=${selectedCat}" 
                       class="btn-action ${currentPage == totalPages ? 'disabled' : ''}" style="width: auto; padding: 0 15px; pointer-events: ${currentPage == totalPages ? 'none' : 'auto'}; opacity: ${currentPage == totalPages ? '0.5' : '1'}">
                        <i class="fa-solid fa-angle-right"></i>
                    </a>
                </div>
            </c:if>
        </main>
    </div>

    <script>
        function toggleStatus(blogId, currentStatus, btnElement) {
            // Chuẩn hóa chuỗi để tránh lỗi so sánh do khoảng trắng hoặc hoa thường
            const cur = currentStatus.trim().toUpperCase();
            const newStatus = (cur === 'VISIBLE') ? 'HIDDEN' : 'VISIBLE';
            
            // Sử dụng pathname hiện tại (ví dụ: /MobileShop/admin/blog) 
            // để đảm bảo request luôn gửi về đúng Servlet đang xử lý
            const url = window.location.pathname + '?service=toggleStatus&blogId=' + blogId + '&status=' + newStatus;
            
            fetch(url)
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === 'success') {
                        // Tự động cập nhật giao diện nút mà không cần load lại trang
                        const isVis = (newStatus === 'VISIBLE');
                        
                        // Cập nhật class CSS bằng nối chuỗi truyền thống
                        btnElement.className = 'status-pill ' + (isVis ? 'status-active' : 'status-hidden');
                        
                        // Cập nhật nội dung bên trong (icon + text)
                        btnElement.innerHTML = '<i class="fa-solid ' + (isVis ? 'fa-eye' : 'fa-eye-slash') + '"></i> ' +
                                             '<span>' + (isVis ? 'Hiện' : 'Ẩn') + '</span>';
                        
                        // Cập nhật lại thuộc tính onclick để lần nhấn sau hoạt động đúng
                        btnElement.onclick = function() { toggleStatus(blogId, newStatus, this); };
                    } else {
                        // In ra lỗi cụ thể từ server nếu có
                        alert('Thất bại! Server trả về: ' + data.trim());
                    }
                })
                .catch(err => {
                    alert('Lỗi kết nối: ' + err.message);
                });
        }
    </script>
</body>
</html>