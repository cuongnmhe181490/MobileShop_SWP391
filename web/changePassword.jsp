<%-- 
    Document   : changePassword
    Created on : Apr 19, 2026, 2:30:17 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    <link rel="stylesheet" href="css/mobileshop.css" type="text/css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Đổi mật khẩu - MobileShop</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; color: #333; }
        .profile-container { max-width: 1200px; margin: 40px auto; display: flex; gap: 24px; padding: 0 20px; }
        .sidebar { width: 280px; background-color: #ffffff; border-radius: 16px; padding: 24px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: fit-content; }
        .user-avatar-section { display: flex; align-items: center; gap: 16px; margin-bottom: 30px; }
        .avatar-circle { width: 50px; height: 50px; background-color: #dbeaff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: 700; color: #1e3a8a; }
        .user-name { font-weight: 600; font-size: 18px; color: #111827; }
        .nav-menu { display: flex; flex-direction: column; gap: 12px; }
        .nav-item { padding: 12px 20px; border-radius: 24px; text-decoration: none; font-weight: 500; font-size: 15px; text-align: center; border: 1px solid #e5e7eb; color: #4b5563; transition: all 0.2s ease; }
        .nav-item.active { background-color: #1a2b4c; color: #fff; border-color: #1a2b4c; }
        .nav-item:hover:not(.active) { background-color: #e5e7eb; color: #111827; }
        .main-content { flex: 1; background-color: #ffffff; border-radius: 16px; padding: 32px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .content-header { margin-bottom: 28px; border-bottom: 1px solid #e5e7eb; padding-bottom: 16px; }
        .content-title { font-size: 24px; font-weight: 700; color: #111827; margin: 0 0 4px 0; }
        .content-subtitle { color: #6b7280; font-size: 14px; margin: 0; }
        .form-stack { display: flex; flex-direction: column; gap: 20px; max-width: 480px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: 14px; font-weight: 600; color: #374151; }
        .form-label .required { color: #ef4444; margin-left: 3px; }
        .input-wrapper { position: relative; }
        .form-input { width: 100%; padding: 12px 48px 12px 16px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 15px; color: #111827; background: #fff; outline: none; transition: border-color 0.2s, box-shadow 0.2s; box-sizing: border-box; }
        .form-input:focus { border-color: #3d73ea; box-shadow: 0 0 0 3px rgba(61,115,234,0.12); }
        .form-input.error { border-color: #ef4444 !important; box-shadow: 0 0 0 3px rgba(239,68,68,0.12) !important; }
        .toggle-btn { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #6b7280; font-size: 16px; padding: 0; line-height: 1; }
        .toggle-btn:hover { color: #374151; }
        .field-error { color: #ef4444; font-size: 12px; margin-top: 4px; display: none; }
        .field-error.show { display: block; }
        .divider { border: none; border-top: 1px solid #e5e7eb; margin: 8px 0; }
        .form-actions { display: flex; gap: 12px; margin-top: 8px; }
        .btn-save { padding: 12px 28px; background-color: #3d73ea; color: #fff; border: none; border-radius: 24px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background-color 0.2s, transform 0.1s; }
        .btn-save:hover { background-color: #2d5fd4; transform: translateY(-1px); }
        .btn-cancel { padding: 12px 28px; background-color: #f9fafb; color: #374151; border: 1px solid #d1d5db; border-radius: 24px; font-size: 15px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; }
        .btn-cancel:hover { background-color: #e5e7eb; }
        .alert-success { padding: 12px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; background-color: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; margin-bottom: 20px; }
        .alert-error { padding: 12px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; background-color: #fef2f2; color: #dc2626; border: 1px solid #fecaca; margin-bottom: 20px; }
        .strength-bar { height: 4px; border-radius: 4px; background: #e5e7eb; margin-top: 6px; overflow: hidden; }
        .strength-bar__fill { height: 100%; width: 0; border-radius: 4px; transition: width 0.3s, background-color 0.3s; }
        .strength-label { font-size: 12px; margin-top: 4px; font-weight: 500; }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

    <div class="profile-container">
        <!-- SIDEBAR -->
        <div class="sidebar">
            <div class="user-avatar-section">
                <div class="avatar-circle">${sessionScope.acc.name.substring(0,1).toUpperCase()}</div>
                <div class="user-name">${sessionScope.acc.name}</div>
            </div>
            <div class="nav-menu">
                <a href="profile"        class="nav-item">Tài khoản</a>
                <a href="myOrders"       class="nav-item">Đơn hàng</a>
                <a href="changePassword" class="nav-item active">Đổi mật khẩu</a>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="content-header">
                <h2 class="content-title">Đổi mật khẩu</h2>
            </div>

            <c:if test="${messType == 'success'}">
                <div class="alert-success">${mess}</div>
            </c:if>
            <c:if test="${messType == 'error'}">
                <div class="alert-error">${mess}</div>
            </c:if>

            <form action="changePassword" method="POST" id="changePassForm">
                <div class="form-stack">

                    <!-- MẬT KHẨU HIỆN TẠI -->
                    <div class="form-group">
                        <label class="form-label">Mật khẩu hiện tại <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input class="form-input" type="password" name="currentPass" id="currentPass"
                                   placeholder="Nhập mật khẩu hiện tại" required maxlength="100">
                            <button type="button" class="toggle-btn" onclick="togglePass('currentPass','eyeCurrent')">
                                <i id="eyeCurrent" class="fa fa-eye"></i>
                            </button>
                        </div>
                        <span class="field-error" id="currentPassError">Vui lòng nhập mật khẩu hiện tại!</span>
                    </div>


                    <!-- MẬT KHẨU MỚI -->
                    <div class="form-group">
                        <label class="form-label">Mật khẩu mới <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input class="form-input" type="password" name="newPass" id="newPass"
                                   placeholder="Ít nhất 8 ký tự" required minlength="8" maxlength="100">
                            <button type="button" class="toggle-btn" onclick="togglePass('newPass','eyeNew')">
                                <i id="eyeNew" class="fa fa-eye"></i>
                            </button>
                        </div>
                        
                        <span class="field-error" id="newPassError">Mật khẩu mới phải có ít nhất 8 ký tự!</span>
                    </div>

                    <!-- XÁC NHẬN MẬT KHẨU MỚI -->
                    <div class="form-group">
                        <label class="form-label">Xác nhận mật khẩu mới <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input class="form-input" type="password" name="confirmPass" id="confirmPass"
                                   placeholder="Nhập lại mật khẩu mới" required maxlength="100">
                            <button type="button" class="toggle-btn" onclick="togglePass('confirmPass','eyeConfirm')">
                                <i id="eyeConfirm" class="fa fa-eye"></i>
                            </button>
                        </div>
                        <span class="field-error" id="confirmPassError">Mật khẩu xác nhận không khớp!</span>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-save">Lưu thay đổi</button>
                        <a href="profile" class="btn-cancel">Hủy</a>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <script>
        function togglePass(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon  = document.getElementById(iconId);
            if (input.type === "password") {
                input.type = "text";
                icon.className = "fa fa-eye-slash";
            } else {
                input.type = "password";
                icon.className = "fa fa-eye";
            }
        }

        function showError(id, errId) {
            document.getElementById(id).classList.add("error");
            document.getElementById(errId).classList.add("show");
        }
        function clearError(id, errId) {
            document.getElementById(id).classList.remove("error");
            document.getElementById(errId).classList.remove("show");
        }

        document.getElementById("newPass").addEventListener("input", function () {
            const val   = this.value;
            const fill  = document.getElementById("strengthFill");
            const label = document.getElementById("strengthLabel");

            val.length < 8 ? showError("newPass","newPassError") : clearError("newPass","newPassError");

            const levels = [
                { w:"20%",  color:"#ef4444", text:"Rất yếu" },
                { w:"40%",  color:"#f97316", text:"Yếu" },
                { w:"60%",  color:"#eab308", text:"Trung bình" },
                { w:"80%",  color:"#22c55e", text:"Mạnh" },
                { w:"100%", color:"#16a34a", text:"Rất mạnh" },
            ];

            const confirm = document.getElementById("confirmPass");
            if (confirm.value.length > 0) {
                confirm.value !== val
                    ? showError("confirmPass","confirmPassError")
                    : clearError("confirmPass","confirmPassError");
            }
        });

        document.getElementById("confirmPass").addEventListener("input", function () {
            this.value !== document.getElementById("newPass").value
                ? showError("confirmPass","confirmPassError")
                : clearError("confirmPass","confirmPassError");
        });

        document.getElementById("currentPass").addEventListener("blur", function () {
            this.value.trim() === ""
                ? showError("currentPass","currentPassError")
                : clearError("currentPass","currentPassError");
        });

        document.getElementById("changePassForm").addEventListener("submit", function (e) {
            let valid = true;
            const current = document.getElementById("currentPass");
            const newP    = document.getElementById("newPass");
            const confirm = document.getElementById("confirmPass");

            if (current.value.trim() === "") { showError("currentPass","currentPassError"); valid = false; }
            else { clearError("currentPass","currentPassError"); }

            if (newP.value.length < 8) { showError("newPass","newPassError"); valid = false; }
            else { clearError("newPass","newPassError"); }

            if (confirm.value !== newP.value) { showError("confirmPass","confirmPassError"); valid = false; }
            else { clearError("confirmPass","confirmPassError"); }

            if (!valid) e.preventDefault();
        });
    </script>
</body>
</html>
