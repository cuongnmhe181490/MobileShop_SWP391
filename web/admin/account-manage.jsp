<%-- 
    Document   : account-manage
    Created on : Apr 20, 2026, 11:01:31 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - Admin Panel</title>
    
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
            /* Đưa về đúng font Inter giống y hệt file Dashboard */
            font-family: 'Inter', sans-serif;
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

        /* --- SIDEBAR --- */
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
            display: block;
        }

        .brand h2 { font-size: 1.5rem; font-weight: 700; margin-bottom: 4px;}
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

        .sidebar-menu { list-style: none; }

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

        .menu-link i { width: 20px; text-align: center; }

        .menu-link:hover { color: white; }

        .menu-link.active {
            background: rgba(175, 242, 47, 0.1);
            color: var(--sidebar-active);
            border-left-color: var(--sidebar-active);
            font-weight: 600;
        }

        /* --- MAIN CONTENT --- */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 40px;
        }

        .page-header {
            margin-bottom: 32px;
        }

        /* Khớp font size với class .welcome h1 và p của Dashboard */
        .page-header h1 {
            font-size: 1.5rem; 
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 4px;
        }

        .page-header p {
            color: var(--text-muted);
            font-size: 0.9rem; 
        }

        /* --- BẢNG DỮ LIỆU --- */
        .card {
            background: var(--bg-card);
            border-radius: 20px; /* Khớp với dashboard (20px hoặc 24px) */
            padding: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .admin-table th {
            background-color: #eef2f8;
            color: #64748b;
            font-weight: 600;
            font-size: 0.85rem; /* Cỡ chữ tiêu đề bảng khớp Dashboard */
            padding: 18px 24px;
            white-space: nowrap;
        }
        
        .admin-table th:first-child {
            border-top-left-radius: 12px;
            border-bottom-left-radius: 12px;
        }

        /* Bo góc phải của ô header cuối cùng */
        .admin-table th:last-child {
            border-top-right-radius: 12px;
            border-bottom-right-radius: 12px;
        }

        .admin-table td {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
            font-size: 0.95rem; /* Cỡ chữ nội dung bảng khớp .item-name */
            vertical-align: middle;
        }

        .admin-table tr:last-child td { border-bottom: none; }
        .font-bold { font-weight: 700; }
        .text-muted { color: #a3aed0; font-size: 0.85rem; }

        .status-active {
            background: #e6f9f4;
            color: var(--success);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem; /* Khớp .status-pill */
            font-weight: 700;
            display: inline-block;
        }

        .status-locked {
            background: #feebeb;
            color: var(--danger);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem; /* Khớp .status-pill */
            font-weight: 700;
            display: inline-block;
        }

        .btn-delete {
            background: transparent;
            border: 1px solid var(--danger);
            color: var(--danger);
            padding: 4px 16px;
            border-radius: 20px;
            cursor: pointer;
            transition: 0.3s;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }
    </style>
</head>
<body>

    <div class="dashboard-container">
        
        <aside class="sidebar">
            <a href="#" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="#" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item"><a href="#" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link"><i class="fa-solid fa-newspaper"></i>Blog</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/banned-words" class="menu-link">
                            <i class="fa-solid fa-comment-slash"></i>Từ nhạy cảm
                        </a>
                    </li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link"><i class="fa-solid fa-home"></i>Trang chủ</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">HỆ THỐNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-house"></i>Về trang chủ</a></li>
                </ul>
            </div>

            <div style="margin-top: auto;">
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-arrow-right-from-bracket"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="page-header">
                <h1>Quản lý tài khoản</h1>
            </div>

            <div class="card">
                <div class="table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Bạn sẽ bọc c:forEach ở đây --%>
                            
                            <tr>
                                <td class="font-bold">U001</td>
                                <td class="font-bold">Nguyễn Mạnh Cường</td>
                                <td class="text-muted">cuong@example.com</td>
                                <td>0385 842 752</td>
                                <td>Admin</td>
                                <td><span class="status-active">Hoạt động</span></td>
                                <td>14/04/2026</td>
                                <td><button class="btn-delete">Xóa</button></td>
                            </tr>

                            <tr>
                                <td class="font-bold">U002</td>
                                <td class="font-bold">Trần Minh K</td>
                                <td class="text-muted">minhk@example.com</td>
                                <td>0912 334 455</td>
                                <td>User</td>
                                <td><span class="status-active">Hoạt động</span></td>
                                <td>12/04/2026</td>
                                <td><button class="btn-delete">Xóa</button></td>
                            </tr>

                            <tr>
                                <td class="font-bold">U003</td>
                                <td class="font-bold">Lê Thị H</td>
                                <td class="text-muted">lethi@example.com</td>
                                <td>0908 712 221</td>
                                <td>User</td>
                                <td><span class="status-locked">Tạm khóa</span></td>
                                <td>09/04/2026</td>
                                <td><button class="btn-delete">Xóa</button></td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

</body>
</html>