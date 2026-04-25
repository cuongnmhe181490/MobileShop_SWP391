<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý blog - MobileShop Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-body: #f4f7fe;
            --bg-sidebar: #1e293b;
            --bg-card: #ffffff;
            --primary: #4318ff;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border: #e9edf7;
            --sidebar-active: #aff22f;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); }

        .admin-layout { display: flex; min-height: 100vh; }

        /* Sidebar Styling */
        /* ===== SIDEBAR – Version Gold ===== */
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
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active {
            background: rgba(175, 242, 47, 0.1);
            color: #aff22f;
            border-left-color: #aff22f;
            font-weight: 600;
        }
        /* ===== END SIDEBAR ===== */

        .main-content { flex: 1; margin-left: 260px; padding: 40px; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
        .page-title h1 { font-size: 1.8rem; font-weight: 700; margin-bottom: 4px; }
        .page-title p { color: var(--text-muted); font-size: 0.9rem; }
        
        .content-card { background: white; border-radius: 20px; padding: 24px; box-shadow: var(--shadow); }
        .filter-bar { display: flex; gap: 16px; margin-bottom: 24px; }
        .form-input, .form-select { padding: 10px 16px; border: 1px solid var(--border); border-radius: 10px; font-size: 0.9rem; outline: none; }
        
        .btn-primary { background: var(--primary); color: white; border: none; padding: 10px 24px; border-radius: 10px; font-weight: 700; cursor: pointer; }
        .btn-outline { background: transparent; border: 1px solid var(--border); padding: 10px 24px; border-radius: 10px; font-weight: 700; cursor: pointer; }

        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { text-align: left; padding: 12px; color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase; border-bottom: 1px solid var(--border); }
        .admin-table td { padding: 16px 12px; border-bottom: 1px solid var(--border); vertical-align: middle; }
        
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }

        .blog-thumb-sm {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--border);
        }
    </style>
</head>
<body>

    <div class="admin-layout">
        <!-- Sidebar -->
        <!-- Sidebar -->
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <!-- 1. TỔNG QUAN -->
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 2. QUẢN LÝ BÁN HÀNG -->
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/products" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 3. TƯƠNG TÁC & NỘI DUNG -->
            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 4. CẤU HÌNH GIAO DIỆN -->
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 5. HỆ THỐNG -->
            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="page-header">
                <div class="page-title">
                    <h1>Quản lý blog</h1>
                    <p>Quản trị danh sách bài viết và nội dung truyền thông trên cửa hàng.</p>
                </div>
                <!-- Nút thêm blog chính -->
                <a href="${pageContext.request.contextPath}/admin/blog?service=insertBlog" class="btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fas fa-plus"></i> Thêm blog
                </a>
            </header>

            <section class="content-card">
                <!-- Filters -->
                <div class="filter-bar">
                    <div style="position: relative; flex: 1; max-width: 400px;">
                        <i class="fa-solid fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #cbd5e1;"></i>
                        <input type="text" class="form-input" placeholder="Tìm kiếm theo tiêu đề..." style="padding-left: 36px;">
                    </div>
                    <button class="btn-primary" style="background: #4e6af2; padding: 10px 20px;">Lọc</button>
                    <button class="btn-outline">Đặt lại</button>
                </div>

                <!-- Table -->
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 80px;">ID</th>
                            <th style="width: 100px;">Ảnh</th>
                            <th>Tiêu đề bài viết</th>
                            <th style="width: 150px;">Hãng/Tag</th>
                            <th style="width: 130px;">Ngày đăng</th>
                            <th style="width: 180px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${blogList}" var="blog">
                            <tr>
                                <td style="color: var(--text-muted);">#${blog.blogId}</td>
                                <td>
                                    <img src="${not empty blog.imagePath ? blog.imagePath : 'img/no-image.png'}" class="blog-thumb-sm" alt="Thumbnail">
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: var(--text-dark);">${blog.title}</div>
                                    <c:if test="${not empty blog.subTitle}">
                                        <div style="font-size: 0.75rem; color: var(--text-muted);">${blog.subTitle}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="status-badge" style="background: #f1f5f9; color: #475569; font-size: 0.8rem;">
                                        ${not empty blog.idSupplier ? blog.idSupplier : 'N/A'}
                                    </span>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; color: var(--text-muted);">
                                        <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=updateBlog&blogId=${blog.blogId}" class="btn-outline" style="padding: 6px 12px; font-size: 0.8rem; text-decoration: none;">
                                            <i class="fas fa-edit me-1"></i> Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/blog?service=deleteBlog&blogId=${blog.blogId}" class="btn-outline" style="padding: 6px 12px; font-size: 0.8rem; text-decoration: none; color: #ef4444; border-color: #fee2e2;" onclick="return confirm('Bạn có chắc muốn xóa bài viết này?')">
                                            <i class="fas fa-trash me-1"></i> Xóa
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty blogList}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 4rem; color: var(--text-muted);">
                                    <div class="mb-2"><i class="fas fa-folder-open fa-3x" style="opacity: 0.2;"></i></div>
                                    Chưa có bài viết nào trong danh sách.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
        </main>
    </div>
</body>
</html>