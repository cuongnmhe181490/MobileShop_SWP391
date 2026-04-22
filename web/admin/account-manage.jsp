<%-- 
    Document   : account-manage
    Created on : Apr 20, 2026, 11:01:31 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        /* --- SIDEBAR CHUẨN DASHBOARD --- */
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
        .menu-link:hover { color: white; background: rgba(255,255,255,0.05); }

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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-header h1 {
            font-size: 1.5rem;
            color: var(--text-main);
            font-weight: 700;
        }

        .btn-add { 
            background: var(--primary); 
            color: white; 
            padding: 10px 20px; 
            border-radius: 10px; 
            text-decoration: none; 
            font-weight: 600; 
            font-size: 0.9rem; 
            transition: 0.3s; 
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }
        .btn-add:hover { background: #3208ff; color: white;}

        /* --- BẢNG DỮ LIỆU --- */
        .card {
            background: var(--bg-card);
            border-radius: 20px; 
            padding: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table-container { width: 100%; overflow-x: auto; }
        .admin-table { width: 100%; border-collapse: collapse; text-align: left; }
        .admin-table th {
            background-color: #eef2f8;
            color: #64748b;
            font-weight: 600;
            font-size: 0.85rem; 
            padding: 18px 15px;
            white-space: nowrap;
        }
        .admin-table th:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .admin-table th:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }

        .admin-table td {
            padding: 18px 15px;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
            font-size: 0.9rem; 
            vertical-align: middle;
        }
        .admin-table tr:last-child td { border-bottom: none; }
        .font-bold { font-weight: 700; }
        .text-muted { color: #a3aed0; font-size: 0.85rem; }

        .status-active { background: #e6f9f4; color: var(--success); padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; display: inline-block; }
        .status-locked { background: #feebeb; color: var(--danger); padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; display: inline-block; }

        /* NÚT THAO TÁC (ACTION BUTTONS) */
        .action-btns { display: flex; gap: 8px; justify-content: center; align-items: center; }
        .btn-icon { width: 32px; height: 32px; border-radius: 8px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; color: white; transition: 0.3s; text-decoration: none; font-size: 0.8rem;}
        .btn-view { background: #4318ff; } 
        .btn-edit { background: #ffb81c; } 
        .btn-lock { background: #ee5d50; } 
        .btn-unlock { background: #05cd99; } 
        .btn-promote { background: #1b2559; }
        .btn-icon:hover { opacity: 0.8; }
        
        .alert { padding: 15px; border-radius: 10px; margin-bottom: 20px; font-weight: 500; font-size: 0.9rem;}
        .alert-success { background: #e6f9f4; color: #05cd99; border: 1px solid #bbf2e3; }
        .alert-error { background: #feebeb; color: #ee5d50; border: 1px solid #f5b7b1; }
        
        .search-bar { display: flex; gap: 10px; margin-bottom: 24px; align-items: center; }
        .search-input { flex: 1; max-width: 350px; padding: 10px 16px; border: 1px solid var(--border); border-radius: 10px; font-size: 0.95rem; outline: none; transition: 0.3s; }
        .search-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(67, 24, 255, 0.1); }
        .btn-search { background: var(--bg-sidebar); color: white; padding: 10px 20px; border: none; border-radius: 10px; cursor: pointer; font-weight: 600; transition: 0.3s; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .btn-search:hover { background: #0f172a; color: white; }
        .btn-clear { background: #f4f7fe; color: var(--text-main); border: 1px solid var(--border); }
        .btn-clear:hover { background: #e9edf7; color: var(--text-main); }
    </style>
</head>
<body>

    <div class="dashboard-container">
        
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
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link active">
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
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link">
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

        <main class="main-content">
            <div class="page-header">
                <h1>Quản lý tài khoản</h1>
                <a href="${pageContext.request.contextPath}/admin/add-user.jsp" class="btn-add"><i class="fa-solid fa-user-plus"></i> Thêm người dùng mới</a>
            </div>

            <div class="card">
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success"><i class="fa-solid fa-check-circle"></i> ${sessionScope.successMsg}</div>
                    <c:remove var="successMsg" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.errorMsg}</div>
                    <c:remove var="errorMsg" scope="session"/>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/admin/accounts" method="GET" class="search-bar">
                    <input type="text" name="search" class="search-input" placeholder="Tìm theo tên, email, SĐT..." value="${searchQuery}">
                    <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
                    
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="btn-search btn-clear"><i class="fa-solid fa-xmark"></i> Hủy lọc</a>
                    </c:if>
                </form>    

                <div class="table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th style="text-align: center; width: 15%;">Hành động</th> </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="u">
                                <tr>
                                    <td class="font-bold">
                                        ${u.name}
                                        <c:if test="${not empty sessionScope.acc and u.id == sessionScope.acc.id}">
                                            <span style="font-style: italic; color: var(--primary); font-size: 0.8rem;">(Bạn)</span>
                                        </c:if>
                                    </td>
                                    <td class="text-muted">${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td class="font-bold">${u.role.roleName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'Hoạt động'}">
                                                <span class="status-active">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-locked" title="Lý do khóa: ${u.lockReason}">Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${u.createdDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <div class="action-btns">
                                            <a href="${pageContext.request.contextPath}/admin/edit-user?id=${u.id}" class="btn-icon btn-edit" title="Sửa thông tin"><i class="fa-solid fa-pen"></i></a>

                                            <c:choose>
                                                <c:when test="${not empty sessionScope.acc and u.id == sessionScope.acc.id}">
                                                    <button type="button" class="btn-icon" style="background: #ccc; cursor: not-allowed;" disabled><i class="fa-solid fa-lock"></i></button>
                                                </c:when>
                                                <c:otherwise>
                                                    <form id="form-action-${u.id}" action="${pageContext.request.contextPath}/admin/accounts" method="POST" style="margin:0;">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <input type="hidden" name="email" value="${u.email}">
                                                        <input type="hidden" name="name" value="${u.name}">
                                                        <input type="hidden" name="action" id="action-${u.id}">
                                                        <input type="hidden" name="reason" id="reason-${u.id}">
                                                    </form>

                                                    <c:choose>
                                                        <c:when test="${u.status == 'Hoạt động'}">
                                                            <button type="button" onclick="confirmLock(${u.id}, '${u.name}')" class="btn-icon btn-lock" title="Khóa tài khoản"><i class="fa-solid fa-lock"></i></button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" onclick="submitForm(${u.id}, 'unlock')" class="btn-icon btn-unlock" style="background: #05cd99;" title="Mở khóa"><i class="fa-solid fa-unlock"></i></button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty userList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        <i class="fa-solid fa-users" style="font-size: 2rem; margin-bottom: 10px; display: block;"></i>
                                        Chưa có dữ liệu người dùng.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script>
        function submitForm(id, actionStr) {
            document.getElementById('action-' + id).value = actionStr;
            document.getElementById('form-action-' + id).submit();
        }

        function confirmLock(id, name) {
            let reason = prompt("Nhập lý do khóa tài khoản của " + name + ":\n(Lý do sẽ được gửi qua email cho người dùng)");
            if (reason !== null && reason.trim() !== "") {
                document.getElementById('action-' + id).value = 'lock';
                document.getElementById('reason-' + id).value = reason;
                document.getElementById('form-action-' + id).submit();
            } else if (reason !== null) {
                alert("Bạn phải nhập lý do để khóa tài khoản!");
            }
        }
    </script>
</body>
</html>