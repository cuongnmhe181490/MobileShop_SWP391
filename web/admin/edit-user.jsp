<%-- 
    Document   : edit-user
    Created on : Apr 22, 2026, 6:05:09 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ người dùng | Admin Panel</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
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
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); }
        .dashboard-container { display: flex; min-height: 100vh; }

        .sidebar { width: 260px; background: var(--bg-sidebar); padding: 24px 0; display: flex; flex-direction: column; position: fixed; height: 100vh; z-index: 100; color: white; }
        .brand { padding: 0 24px; margin-bottom: 40px; text-decoration: none; color: white; display: block; }
        .brand h2 { font-size: 1.5rem; font-weight: 700; }
        .brand p { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        .nav-section { margin-bottom: 32px; }
        .nav-label { font-size: 0.7rem; text-transform: uppercase; color: #64748b; letter-spacing: 1px; margin-bottom: 12px; display: block; padding: 0 24px; }
        .sidebar-menu { list-style: none; }
        .menu-link { display: flex; align-items: center; gap: 12px; padding: 12px 24px; color: #94a3b8; text-decoration: none; transition: 0.3s; font-weight: 500; font-size: 0.95rem; border-left: 4px solid transparent; }
        .menu-link i { width: 20px; text-align: center; }
        .menu-link:hover { color: white; background: rgba(255,255,255,0.05); }
        .menu-link.active { background: rgba(175, 242, 47, 0.1); color: var(--sidebar-active); border-left-color: var(--sidebar-active); font-weight: 600; }

        .main-content { flex: 1; margin-left: 260px; padding: 40px; display: flex; flex-direction: column; align-items: center; }
        .page-header { width: 100%; max-width: 1100px; margin-bottom: 24px; }
        .page-header h1 { font-size: 1.6rem; font-weight: 700; color: var(--text-main); }
        .card { background: var(--bg-card); border-radius: 20px; padding: 35px 40px; box-shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08); width: 100%; max-width: 1100px; }

        .form-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .col-span-1 { grid-column: span 1; }
        .col-span-2 { grid-column: span 2; }
        .col-span-3 { grid-column: span 3; }
        .col-span-4 { grid-column: span 4; }
        
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: var(--text-main); }
        .form-label .required { color: #ef4444; margin-left: 3px; }
        
        .form-input, .form-select { width: 100%; padding: 12px 16px; border: 1px solid var(--border); border-radius: 10px; font-size: 0.95rem; color: var(--text-main); outline: none; transition: 0.3s; background: #fff; }
        .form-input:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(67, 24, 255, 0.1); }
        .form-input[readonly], .form-input:disabled { background-color: #f8f9fc; color: var(--text-muted); cursor: not-allowed; }

        /* Validation CSS */
        .form-input.error, .form-select.error { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12); }
        .field-error { color: #ef4444; font-size: 0.8rem; margin-top: 4px; display: none; }
        .field-error.show { display: block; }
        
        .char-count { font-size: 0.8rem; color: #a3aed0; text-align: right; margin-top: -4px; }
        .char-count.warning { color: #f59e0b; }
        .char-count.danger { color: #ef4444; }

        /* SECTIONS & BUTTONS */
        .section-title { grid-column: span 4; font-size: 1.1rem; font-weight: 700; color: var(--primary); margin: 10px 0 0 0; display: flex; align-items: center; gap: 10px; }
        .section-title::after { content: ""; flex: 1; height: 1px; background: var(--border); }
        .role-warning { grid-column: span 4; background: #fff8e6; color: #856404; padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; border-left: 4px solid #ffb81c; }

        .btn-group { grid-column: span 4; display: flex; gap: 12px; margin-top: 15px; border-top: 1px solid var(--border); padding-top: 24px; }
        .btn { padding: 12px 28px; border-radius: 12px; font-weight: 700; font-size: 0.95rem; cursor: pointer; border: none; transition: 0.3s; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .btn-save { background: var(--primary); color: white; }
        .btn-save:hover { background: #3208ff; transform: translateY(-1px); }
        .btn-cancel { background: #f4f7fe; color: var(--text-main); border: 1px solid var(--border); }
        .btn-cancel:hover { background: #e9edf7; }
    </style>
</head>
<body>

    <div class="dashboard-container">
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <div class="page-header">
                <h1>Chỉnh sửa hồ sơ người dùng</h1>
            </div>

            <div class="card">
                <form action="${pageContext.request.contextPath}/admin/edit-user" method="POST" class="form-grid" id="editForm">
                    <input type="hidden" name="id" value="${editUser.id}">

                    <div class="section-title"><i class="fa-solid fa-id-card"></i> Thông tin hệ thống</div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Tên đăng nhập</label>
                        <input type="text" class="form-input" value="${editUser.user}" readonly>
                    </div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Địa chỉ Email</label>
                        <input type="email" class="form-input" value="${editUser.email}" readonly>
                    </div>

                    <div class="section-title"><i class="fa-solid fa-user-pen"></i> Thông tin cá nhân</div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Họ và tên <span class="required">*</span></label>
                        <input type="text" class="form-input" name="fullName" id="name" value="${editUser.name}" maxlength="50" required>
                        <span class="field-error" id="nameError">Họ và tên không hợp lệ!</span>
                        <span class="char-count" id="nameCount">0/50</span>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Số điện thoại <span class="required">*</span></label>
                        <input type="text" class="form-input" name="phone" id="phone" value="${editUser.phone}" required>
                        <span class="field-error" id="phoneError">Số điện thoại không hợp lệ!</span>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Giới tính</label>
                        <select class="form-select" name="gender">
                            <option value="Male"   ${editUser.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                            <option value="Female" ${editUser.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                            <option value="Other"  ${editUser.gender == 'Other'  ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group col-span-3">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" class="form-input" name="address" id="address" value="${editUser.address}" maxlength="200">
                        <span class="char-count" id="addressCount">0/200</span>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-input" name="birthday" value="${editUser.birthday}">
                    </div>

                    <div class="section-title"><i class="fa-solid fa-user-shield"></i> Phân quyền & Quản trị</div>

                    <c:if test="${not empty sessionScope.acc and editUser.id == sessionScope.acc.id}">
                        <div class="role-warning">
                            <i class="fa-solid fa-circle-exclamation"></i> 
                            Bạn đang thao tác trên tài khoản của chính mình. Tính năng đổi Vai trò bị khóa để tránh việc tự hạ quyền.
                        </div>
                    </c:if>

                    <div class="form-group col-span-2">
                        <label class="form-label">Vai trò hệ thống</label>
                        <select name="roleId" class="form-select" ${editUser.id == sessionScope.acc.id ? 'disabled' : ''}>
                            <option value="0" ${editUser.role.roleId == 0 ? 'selected' : ''}>Khách hàng</option>
                            <option value="1" ${editUser.role.roleId == 1 ? 'selected' : ''}>Admin</option>
                        </select>
                        <c:if test="${editUser.id == sessionScope.acc.id}">
                            <input type="hidden" name="roleId" value="${editUser.role.roleId}">
                        </c:if>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-save">Lưu thay đổi</button>
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-cancel">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        const form = document.getElementById("editForm");

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
                document.getElementById("phoneError").textContent = "Số điện thoại phải gồm 10 số và bắt đầu bằng 0!";
                showError("phone", "phoneError"); 
            } else { 
                clearError("phone", "phoneError"); 
            }
        });

        form.addEventListener("submit", function (e) {
            let valid = true;
            const name = document.getElementById("name");
            const phone = document.getElementById("phone");
            const nameError = document.getElementById("nameError");
            
            const phoneRegex = /^0\d{9}$/;
            const nameValue = name.value.trim();

            if (nameValue === "") {
                nameError.textContent = "Họ và tên không được để trống!";
                showError("name", "nameError");
                valid = false;
            } else if (!nameRegex.test(nameValue)) {
                nameError.textContent = "Họ và tên không được chứa số hay ký tự đặc biệt!";
                showError("name", "nameError");
                valid = false;
            }

            if (!phoneRegex.test(phone.value.trim())) {
                document.getElementById("phoneError").textContent = "Số điện thoại phải gồm 10 số và bắt đầu bằng 0!";
                showError("phone", "phoneError");
                valid = false;
            }
            
            if (!valid) e.preventDefault();
        });

        function setupCharCount(inputId, countId, max) {
            const input = document.getElementById(inputId);
            const counter = document.getElementById(countId);
            
            let startLen = input.value ? input.value.length : 0;
            counter.textContent = startLen + "/" + max;

            input.addEventListener("input", function () {
                const len = this.value.length;
                counter.textContent = len + "/" + max;
                counter.classList.remove("warning", "danger");
                if (len >= max) { counter.classList.add("danger"); } 
                else if (len >= max * 0.8) { counter.classList.add("warning"); }
            });
        }

        setupCharCount("name", "nameCount", 50);
        setupCharCount("address", "addressCount", 200);
    </script>
</body>
</html>
