<%-- 
    Document   : add-user
    Created on : Apr 22, 2026, 11:37:08 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm người dùng mới | Admin Panel</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --bg-body: #f4f7fe; --bg-sidebar: #1e293b; --bg-card: #ffffff; --primary: #4318ff; --text-main: #1b2559; --text-muted: #a3aed0; --border: #e9edf7; --sidebar-active: #aff22f; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); }
        .dashboard-container { display: flex; min-height: 100vh; }

        /* SIDEBAR (Rút gọn cho CSS) */
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

        /* MAIN CONTENT & CARD */
        .main-content { flex: 1; margin-left: 260px; padding: 40px; display: flex; flex-direction: column; align-items: center; }
        .page-header { width: 100%; max-width: 1100px; margin-bottom: 24px; }
        .page-header h1 { font-size: 1.6rem; font-weight: 700; color: var(--text-main); }
        .card { background: var(--bg-card); border-radius: 20px; padding: 35px 40px; box-shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08); width: 100%; max-width: 1100px; }

        /* ALERTS */
        .alert { padding: 15px; border-radius: 10px; margin-bottom: 20px; font-weight: 500; font-size: 0.9rem; width: 100%; }
        .alert-error { background: #feebeb; color: #ee5d50; border: 1px solid #f5b7b1; }

        /* FORM GRIDS - 4 COLUMNS */
        .form-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .col-span-1 { grid-column: span 1; }
        .col-span-2 { grid-column: span 2; }
        .col-span-3 { grid-column: span 3; }
        .col-span-4 { grid-column: span 4; }
        
        .form-group { display: flex; flex-direction: column; gap: 6px; position: relative; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: var(--text-main); }
        .form-label .required { color: #ef4444; margin-left: 3px; }
        
        .form-input, .form-select { width: 100%; padding: 12px 16px; border: 1px solid var(--border); border-radius: 10px; font-size: 0.95rem; color: var(--text-main); outline: none; transition: 0.3s; background: #fff; }
        .form-input:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(67, 24, 255, 0.1); }
        
        .form-input.error, .form-select.error { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12); }
        .field-error { color: #ef4444; font-size: 0.8rem; margin-top: 4px; display: none; }
        .field-error.show { display: block; }
        .char-count { font-size: 0.8rem; color: #a3aed0; text-align: right; margin-top: -4px; }
        .char-count.danger { color: #ef4444; }

        .section-title { grid-column: span 4; font-size: 1.1rem; font-weight: 700; color: var(--primary); margin: 10px 0 0 0; display: flex; align-items: center; gap: 10px; }
        .section-title::after { content: ""; flex: 1; height: 1px; background: var(--border); }

        .btn-group { grid-column: span 4; display: flex; gap: 12px; margin-top: 15px; border-top: 1px solid var(--border); padding-top: 24px; }
        .btn { padding: 12px 28px; border-radius: 12px; font-weight: 700; font-size: 0.95rem; cursor: pointer; border: none; transition: 0.3s; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .btn-save { background: var(--primary); color: white; }
        .btn-save:hover { background: #3208ff; transform: translateY(-1px); }
        .btn-cancel { background: #f4f7fe; color: var(--text-main); border: 1px solid var(--border); }
        .btn-cancel:hover { background: #e9edf7; }
        
        /* Icon Mắt xem mật khẩu */
        .toggle-password { position: absolute; right: 15px; top: 38px; background: none; border: none; color: #6b7280; cursor: pointer; font-size: 1rem; }
    </style>
</head>
<body>

    <div class="dashboard-container">
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link"><i class="fa-solid fa-receipt"></i>Đơn hàng</a></li>
                    <li class="menu-item"><a href="#" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link active"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link"><i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link"><i class="fa-solid fa-newspaper"></i>Blog / Tin tức</a></li>
                </ul>
            </div>
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link"><i class="fa-solid fa-house-chimney-window"></i>Trang chủ</a></li>
                </ul>
            </div>
            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-globe"></i>Xem Website</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-power-off"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="page-header">
                <h1>Thêm người dùng mới</h1>
            </div>

            <div class="card">
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> ${errorMsg}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/add-user" method="POST" class="form-grid" id="addForm" autocomplete="off">
                    
                    <div class="section-title"><i class="fa-solid fa-id-card"></i> Thông tin Đăng nhập</div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Tên đăng nhập <span class="required">*</span></label>
                        <input type="text" class="form-input" name="username" id="username" value="${param.username}" maxlength="50" required autofocus>
                        <span class="field-error" id="usernameError">Tên đăng nhập không được để trống!</span>
                    </div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Mật khẩu khởi tạo <span class="required">*</span></label>
                        <input type="password" class="form-input" name="password" id="password" required minlength="8" style="padding-right: 40px;">
                        <button type="button" class="toggle-password" onclick="togglePass('password', 'eyePass')"><i id="eyePass" class="fa-solid fa-eye"></i></button>
                        <span class="field-error" id="passwordError">Mật khẩu phải có ít nhất 8 ký tự!</span>
                    </div>

                    <div class="section-title"><i class="fa-solid fa-user-pen"></i> Thông tin Cá nhân</div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Họ và tên <span class="required">*</span></label>
                        <input type="text" class="form-input" name="fullName" id="name" value="${param.fullName}" maxlength="50" required>
                        <span class="field-error" id="nameError">Họ và tên không hợp lệ!</span>
                        <span class="char-count" id="nameCount">0/50</span>
                    </div>

                    <div class="form-group col-span-2">
                        <label class="form-label">Địa chỉ Email <span class="required">*</span></label>
                        <input type="email" class="form-input" name="email" id="email" value="${param.email}" required>
                        <span class="field-error" id="emailError">Email không hợp lệ!</span>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Số điện thoại <span class="required">*</span></label>
                        <input type="text" class="form-input" name="phone" id="phone" value="${param.phone}" required>
                        <span class="field-error" id="phoneError">Gồm 10 số, bắt đầu bằng 0!</span>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Giới tính</label>
                        <select class="form-select" name="gender">
                            <option value="Male" ${param.gender == 'Male' ? 'selected' : ''}>Nam</option>
                            <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                            <option value="Other" ${param.gender == 'Other' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-input" name="birthday" id="birthday" value="${param.birthday}">
                        <span class="field-error" id="birthdayError">Không được chọn ngày tương lai!</span>
                    </div>

                    <div class="form-group col-span-1">
                        <label class="form-label">Vai trò hệ thống</label>
                        <select name="roleId" class="form-select" style="border-color: var(--primary); font-weight: 600;">
                            <option value="0" ${param.roleId == '0' ? 'selected' : ''}>Khách hàng</option>
                            <option value="1" ${param.roleId == '1' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>

                    <div class="form-group col-span-4">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" class="form-input" name="address" id="address" value="${param.address}" maxlength="200">
                        <span class="char-count" id="addressCount">0/200</span>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-save"><i class="fa-solid"></i> Tạo tài khoản</button>
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-cancel">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        const form = document.getElementById("addForm");

        // Toggle Password Visibility
        function togglePass(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === "password") {
                input.type = "text";
                icon.className = "fa-solid fa-eye-slash";
            } else {
                input.type = "password";
                icon.className = "fa-solid fa-eye";
            }
        }

        function showError(inputId, errorId) {
            document.getElementById(inputId).classList.add("error");
            document.getElementById(errorId).classList.add("show");
        }
        function clearError(inputId, errorId) {
            document.getElementById(inputId).classList.remove("error");
            document.getElementById(errorId).classList.remove("show");
        }

        // Realtime Validations
        document.getElementById("username").addEventListener("blur", function () {
            this.value.trim() === "" ? showError("username", "usernameError") : clearError("username", "usernameError");
        });

        document.getElementById("password").addEventListener("input", function () {
            this.value.length < 8 ? showError("password", "passwordError") : clearError("password", "passwordError");
        });

        const nameRegex = /^[\p{L}\s]+$/u;
        document.getElementById("name").addEventListener("input", function () {
            const val = this.value.trim();
            const err = document.getElementById("nameError");
            if (val === "") { err.textContent = "Họ và tên không được để trống!"; showError("name", "nameError"); }
            else if (!nameRegex.test(val)) { err.textContent = "Không chứa số hay ký tự đặc biệt!"; showError("name", "nameError"); }
            else { clearError("name", "nameError"); }
        });

        document.getElementById("email").addEventListener("blur", function () {
            /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.value) ? clearError("email", "emailError") : showError("email", "emailError");
        });

        document.getElementById("phone").addEventListener("input", function () {
            /^0\d{9}$/.test(this.value.trim()) ? clearError("phone", "phoneError") : showError("phone", "phoneError");
        });

        document.getElementById("birthday").addEventListener("change", function () {
            const today = new Date().toISOString().split("T")[0];
            (this.value && this.value > today) ? showError("birthday", "birthdayError") : clearError("birthday", "birthdayError");
        });

        // Submit form validation
        form.addEventListener("submit", function (e) {
            let valid = true;
            const today = new Date().toISOString().split("T")[0];
            
            const checks = [
                { id: "username", errId: "usernameError", test: v => v.trim() !== "" },
                { id: "password", errId: "passwordError", test: v => v.length >= 8 },
                { id: "name",     errId: "nameError",     test: v => v.trim() !== "" && /^[\p{L}\s]+$/u.test(v) },
                { id: "email",    errId: "emailError",    test: v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) },
                { id: "phone",    errId: "phoneError",    test: v => /^0\d{9}$/.test(v) },
                { id: "birthday", errId: "birthdayError", test: v => !v || v <= today }
            ];

            checks.forEach(({ id, errId, test }) => {
                if (!test(document.getElementById(id).value)) {
                    showError(id, errId);
                    valid = false;
                } else {
                    clearError(id, errId);
                }
            });

            if (!valid) e.preventDefault();
        });

        // Đếm ký tự
        function setupCharCount(inputId, countId, max) {
            const input = document.getElementById(inputId);
            const counter = document.getElementById(countId);
            let startLen = input.value ? input.value.length : 0;
            counter.textContent = startLen + "/" + max;
            input.addEventListener("input", function () {
                const len = this.value.length;
                counter.textContent = len + "/" + max;
                if (len >= max) { counter.classList.add("danger"); } 
                else { counter.classList.remove("danger"); }
            });
        }
        setupCharCount("name", "nameCount", 50);
        setupCharCount("address", "addressCount", 200);
    </script>
</body>
</html>
