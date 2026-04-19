<%-- 
    Document   : profile
    Created on : Apr 18, 2026, 2:36:17 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="css/owl.carousel.min.css" type="text/css">
    <link rel="stylesheet" href="css/style.css" type="text/css">
    <link rel="stylesheet" href="css/mobileshop.css" type="text/css">
    <link rel="stylesheet" href="css/custom.css" type="text/css">
    <meta charset="UTF-8">
    <title>Hồ sơ của tôi - MobileShop</title>
    <style>
        /* Đặt lại font chữ và màu nền cơ bản */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* Container chính bọc toàn bộ nội dung */
        .profile-container {
            max-width: 1200px;
            margin: 40px auto;
            display: flex;
            gap: 24px;
            padding: 0 20px;
        }

        /* ================= CỘT TRÁI (SIDEBAR) ================= */
        .sidebar {
            width: 280px;
            background-color: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            height: fit-content;
        }

        .user-avatar-section {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 30px;
        }

        .avatar-circle {
            width: 50px;
            height: 50px;
            background-color: #dbeaff; /* Màu xanh nhạt giống Figma */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #1e3a8a;
        }

        .user-name {
            font-weight: 600;
            font-size: 18px;
            color: #111827;
        }

        .nav-menu {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .nav-item {
            padding: 12px 20px;
            border-radius: 24px;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            text-align: center;
            border: 1px solid #e5e7eb;
            color: #4b5563;
            transition: all 0.2s ease;
        }

        /* Trạng thái đang chọn (Active) - Nền xanh đậm */
        .nav-item.active {
            background-color: #1a2b4c;
            color: #ffffff;
            border-color: #1a2b4c;
        }

        .nav-item:hover:not(.active) { 
            background-color: #e5e7eb;  /* Xám đậm hơn */
            color: #111827;              /* Chữ đậm rõ */
        }

        /* ================= CỘT PHẢI (MAIN CONTENT) ================= */
        .main-content {
            flex: 1;
            background-color: #ffffff;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 16px;
        }

        .content-title {
            font-size: 24px;
            font-weight: 700;
            color: #111827;
            margin: 0;
        }

        .btn-edit {
            background-color: #eef2ff;
            color: #4f46e5;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-edit:hover {
            background-color: #e0e7ff;
        }

        /* Danh sách thông tin */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .info-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .info-label {
            font-size: 14px;
            color: #6b7280;
            font-weight: 500;
        }

        .info-value {
            font-size: 16px;
            color: #111827;
            font-weight: 500;
            padding: 12px;
            background-color: #f9fafb;
            border-radius: 8px;
            border: 1px solid #f3f4f6;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>
    <div class="profile-container">
        <div class="sidebar">
            
            <div class="user-avatar-section">
                <div class="avatar-circle">
                    ${sessionScope.acc.name.substring(0, 1).toUpperCase()}
                </div>
                <div class="user-name">
                    ${sessionScope.acc.name}
                </div>
            </div>

            <div class="nav-menu">
                <a href="profile" class="nav-item active">Tài khoản</a>
                <a href="myOrders" class="nav-item">Đơn hàng</a>
                <a href="changePassword" class="nav-item">Đổi mật khẩu</a>
            </div>
        </div>

        <div class="main-content">
            <div class="content-header">
                <h2 class="content-title">Thông tin tài khoản</h2>
                <a href="editProfile" class="btn-edit">Chỉnh sửa thông tin</a>
            </div>

            <div class="info-grid">
                <div class="info-group">
                    <span class="info-label">Họ và tên</span>
                    <div class="info-value">${sessionScope.acc.name}</div>
                </div>

                <div class="info-group">
                    <span class="info-label">Tên đăng nhập</span>
                    <div class="info-value">${sessionScope.acc.user}</div>
                </div>

                <div class="info-group">
                    <span class="info-label">Email</span>
                    <div class="info-value">${sessionScope.acc.email}</div>
                </div>

                <div class="info-group">
                    <span class="info-label">Số điện thoại</span>
                    <div class="info-value">${sessionScope.acc.phone}</div>
                </div>

                <div class="info-group" style="grid-column: span 2;">
                    <span class="info-label">Địa chỉ</span>
                    <div class="info-value">${sessionScope.acc.address}</div>
                </div>
                
                <div class="info-group">
                    <span class="info-label">Giới tính</span>
                    <div class="info-value">${sessionScope.acc.gender}</div>
                </div>

                <div class="info-group">
                    <span class="info-label">Ngày sinh</span>
                    <div class="info-value">${sessionScope.acc.birthday}</div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
