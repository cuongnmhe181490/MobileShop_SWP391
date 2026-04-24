<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    <link rel="stylesheet" href="css/mobileshop.css" type="text/css">
    <title>Chỉnh sửa hồ sơ - MobileShop</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0; padding: 0; color: #333;
        }
        .profile-container {
            max-width: 1200px;
            margin: 40px auto;
            display: flex;
            gap: 24px;
            padding: 0 20px;
        }
        .sidebar {
            width: 280px;
            background-color: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            height: fit-content;
        }
        .user-avatar-section {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 30px;
        }
        .avatar-circle {
            width: 50px; height: 50px;
            background-color: #dbeaff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 700;
            color: #1e3a8a;
        }
        .user-name { font-weight: 600; font-size: 18px; color: #111827; }
        .nav-menu { display: flex; flex-direction: column; gap: 12px; }
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
        .nav-item.active { background-color: #1a2b4c; color: #fff; border-color: #1a2b4c; }
        .nav-item:hover:not(.active) { 
            background-color: #e5e7eb;  /* Xám đậm hơn */
            color: #111827;              /* Chữ đậm rõ */
        }
        .main-content {
            flex: 1;
            background-color: #ffffff;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .content-header { margin-bottom: 28px; border-bottom: 1px solid #e5e7eb; padding-bottom: 16px; }
        .content-title { font-size: 24px; font-weight: 700; color: #111827; margin: 0 0 4px 0; }
        .content-subtitle { color: #6b7280; font-size: 14px; margin: 0; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full-width { grid-column: span 2; }
        .form-label { font-size: 14px; font-weight: 600; color: #374151; }
        .form-label .required { color: #ef4444; margin-left: 3px; }
        .form-input, .form-select {
            padding: 12px 16px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            font-size: 15px;
            color: #111827;
            background: #fff;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input:focus, .form-select:focus {
            border-color: #3d73ea;
            box-shadow: 0 0 0 3px rgba(61,115,234,0.12);
        }
        .form-input[readonly] { background-color: #f9fafb; color: #6b7280; cursor: not-allowed; }
        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; font-weight: 500;
            margin-bottom: 4px; grid-column: span 2;
        }
        .alert-error { background-color: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }
        .alert-success { background-color: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; }
        .form-actions {
            display: flex; gap: 12px;
            margin-top: 28px; padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }
        .btn-save {
            padding: 12px 28px;
            background-color: #3d73ea; color: #fff;
            border: none; border-radius: 24px;
            font-size: 15px; font-weight: 600;
            cursor: pointer; transition: background-color 0.2s, transform 0.1s;
        }
        .btn-save:hover { background-color: #2d5fd4; transform: translateY(-1px); }
        .btn-cancel {
            padding: 12px 28px;
            background-color: #f9fafb; color: #374151;
            border: 1px solid #d1d5db; border-radius: 24px;
            font-size: 15px; font-weight: 600;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center;
        }
        .btn-cancel:hover { background-color: #f3f4f6; }
        
         .form-input.error, .form-select.error {
        border-color: #ef4444;
        box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12);
        }
        .field-error {
            color: #ef4444;
            font-size: 12px;
            margin-top: 4px;
            display: none;
        }
        .field-error.show {
            display: block;
        }
        
        .char-count {
        font-size: 12px;
        color: #9ca3af;
        text-align: right;
        }
        .char-count.warning {
            color: #f59e0b; /* Vàng khi gần đầy */
        }
        .char-count.danger {
            color: #ef4444; /* Đỏ khi đầy */
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

    <div class="profile-container">
        <!-- SIDEBAR -->
        <div class="sidebar">
            <div class="user-avatar-section">
                <div class="avatar-circle">
                    ${sessionScope.acc.name.substring(0,1).toUpperCase()}
                </div>
                <div class="user-name">${sessionScope.acc.name}</div>
            </div>
            <div class="nav-menu">
                <a href="${ctx}/profile" class="nav-item active">Tài khoản</a>
                <a href="${ctx}/myOrders" class="nav-item">Đơn hàng</a>
                <a href="${ctx}/review/mine" class="nav-item">Lịch sử đánh giá</a>
                <a href="${ctx}/changePassword" class="nav-item">Đổi mật khẩu</a>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="content-header">
                <h2 class="content-title">Chỉnh sửa thông tin</h2>
                <p class="content-subtitle">Cập nhật thông tin cá nhân của bạn</p>
            </div>

            <form action="editProfile" method="POST">
                <div class="form-grid">

                    <%-- Chỉ hiện alert khi THÀNH CÔNG --%>
                    <c:if test="${messType == 'success'}">
                        <div class="alert alert-success full-width">
                            ${mess}
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">Họ và tên <span class="required">*</span></label>
                        <input class="form-input" type="text" name="name" id="name"
                               value="${sessionScope.acc.name}"
                               maxlength="50" required>
                        <span class="field-error" id="nameError">Họ và tên không được để trống!</span>
                        <span class="char-count" id="nameCount">0/50</span>
                    </div>
<!--                      test       
                     <div class="form-group">
                        <label class="form-label">Role <span class="required">*</span></label>
                        <select class="form-input" type="text" name="role" id="role">
                            <option value="${sessionScope.acc.role.roleId}" selected>${sessionScope.acc.role.roleName}</option>
                            <option value="2">Khách hàng</option>
                        </select>    
                    </div>
                        test            -->
                    <div class="form-group">
                        <label class="form-label">Tên đăng nhập</label>
                        <input class="form-input" type="text"
                               value="${sessionScope.acc.user}" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input class="form-input" type="email"
                               value="${sessionScope.acc.email}" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Số điện thoại <span class="required">*</span></label>
                        <input class="form-input" type="text" name="phone" id="phone"
                               value="${sessionScope.acc.phone}" required>
                        <span class="field-error" id="phoneError">Số điện thoại phải gồm 10 số và bắt đầu bằng 0!</span>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Địa chỉ</label>
                        <input class="form-input" type="text" name="address"
                               value="${sessionScope.acc.address}"
                               maxlength="200">
                        <span class="char-count" id="addressCount">0/200</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giới tính</label>
                        <select class="form-select" name="gender">
                            <option value="Male"   ${sessionScope.acc.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                            <option value="Female" ${sessionScope.acc.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                            <option value="Other"  ${sessionScope.acc.gender == 'Other'  ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ngày sinh</label>
                        <input class="form-input" type="date" name="birthday"
                               value="${sessionScope.acc.birthday}">
                        <span class="field-error" id="birthdayError">Ngày sinh không hợp lệ!</span>
                    </div>

                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save">Lưu thay đổi</button>
                    <a href="profile" class="btn-cancel">Hủy</a>
                </div>
            </form>
        </div>
    </div>
    <script>
        const form = document.querySelector("form");

        function showError(inputId, errorId) {
            document.getElementById(inputId).classList.add("error");
            document.getElementById(errorId).classList.add("show");
        }

        function clearError(inputId, errorId) {
            document.getElementById(inputId).classList.remove("error");
            document.getElementById(errorId).classList.remove("show");
        }
        
        const nameRegex = /^[\p{L}\s]+$/u;

        document.getElementById("name").addEventListener("input", function () {
            const nameValue = this.value.trim();
            const errorSpan = document.getElementById("nameError");

            if (nameValue === "") {
                errorSpan.textContent = "Họ và tên không được để trống!";
                showError("name", "nameError");
            } else if (!nameRegex.test(nameValue)) {
                errorSpan.textContent = "Họ và tên không được chứa số hay ký tự đặc biệt!";
                showError("name", "nameError");
            } else {
                clearError("name", "nameError");
            }
        });

        document.getElementById("phone").addEventListener("input", function () {
            const phoneRegex = /^0\d{9}$/;
            if (!phoneRegex.test(this.value.trim())) {
                showError("phone", "phoneError");
            } else {
                clearError("phone", "phoneError");
            }
        });

        form.addEventListener("submit", function (e) {
            let valid = true;

            const name = document.getElementById("name");
            const nameValue = name.value.trim();
            const nameError = document.getElementById("nameError");
            if (nameValue === "") {
                nameError.textContent = "Họ và tên không được để trống!";
                showError("name", "nameError");
                valid = false;
            } else if (!nameRegex.test(nameValue)) {
                nameError.textContent = "Họ và tên không được chứa số hay ký tự đặc biệt!";
                showError("name", "nameError");
                valid = false;
            } else {
                clearError("name", "nameError");
            }

            const phone = document.getElementById("phone");
            const phoneRegex = /^0\d{9}$/;
            if (!phoneRegex.test(phone.value.trim())) {
                showError("phone", "phoneError");
                valid = false;
            } else {
                clearError("phone", "phoneError");
            }

            if (!valid) {
                e.preventDefault();
            }
        });
        function setupCharCount(inputId, countId, max) {
            const input = document.getElementById(inputId);
            const counter = document.getElementById(countId);

            counter.textContent = input.value.length + "/" + max;

            input.addEventListener("input", function () {
                const len = this.value.length;
                counter.textContent = len + "/" + max;

                counter.classList.remove("warning", "danger");
                if (len >= max) {
                    counter.classList.add("danger");
                } else if (len >= max * 0.8) { 
                    counter.classList.add("warning");
                }
            });
        }

        setupCharCount("name", "nameCount", 50);
        setupCharCount("address", "addressCount", 200);
    </script>
</body>
</html>