<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Tạo tài khoản" />
<c:set var="activePage" value="catalog" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            .auth-form__stack { display: flex; flex-direction: column; gap: 16px; }
            .form-row { display: flex; gap: 16px; width: 100%; }
            .form-row > label { flex: 1; }
            .required { color: #ff0000; font-weight: bold; margin-left: 4px; display: inline-block; }
            .auth-input.error {
                border-color: #ef4444 !important;
                box-shadow: 0 0 0 3px rgba(239,68,68,0.12) !important;
            }
            .field-error { color: #ef4444; font-size: 12px; margin-top: 4px; display: none; }
            .field-error.show { display: block; }
        </style>
    </head>
    <body>
        <main class="page-section">
            <div class="mobile-shell">
                <div class="auth-layout">
                    <section class="auth-panel">
                        <div class="auth-copy">
                            <span class="section-eyebrow">MobileShop</span>
                            <h1 style="font-size: 54px; line-height: 1.1;">Tham gia cùng chúng tôi</h1>
                        </div>
                    </section>

                    <section class="auth-form">
                        <div class="auth-form__tabs">
                            <a class="pill-link" href="${ctx}/login.jsp">Đăng nhập</a>
                            <span class="pill-link pill-link--dark">Tạo tài khoản</span>
                        </div>
                        <h2 style="font-size: 28px; line-height: 1.2; margin-top: 12px;">Đăng ký thành viên</h2>

                        <form class="auth-form__stack" action="signup" method="post"
                              style="margin-top: 24px;" autocomplete="off" id="signupForm">

                            <%-- TÊN ĐĂNG NHẬP --%>
                            <label>
                                <span class="subtle-link">Tên đăng nhập</span><span class="required">*</span>
                                <input class="auth-input" name="user" id="user" type="text"
                                       value="${param.user}" placeholder="Tên đăng nhập" required autofocus maxlength="50">
                                <span class="field-error" id="userError">Tên đăng nhập không được để trống!</span>
                            </label>

                            <%-- MẬT KHẨU --%>
                            <div class="form-row">
                                <label>
                                    <span class="subtle-link">Mật khẩu</span><span class="required">*</span>
                                    <div style="position: relative;">
                                        <input class="auth-input" name="pass" id="pass"
                                               type="password" placeholder="••••••••"
                                               required minlength="8" maxlength="50" style="padding-right: 48px;">
                                        <button type="button" onclick="togglePass('pass','eyePass')"
                                                style="position:absolute;right:14px;top:50%;transform:translateY(-50%);
                                                       background:none;border:none;cursor:pointer;color:#6b7280;
                                                       font-size:16px;padding:0;line-height:1;">
                                            <i id="eyePass" class="fa fa-eye"></i>
                                        </button>
                                    </div>
                                    <span class="field-error" id="passError">Mật khẩu phải có ít nhất 8 ký tự!</span>
                                </label>
                                <label>
                                    <span class="subtle-link">Nhập lại mật khẩu</span><span class="required">*</span>
                                    <div style="position: relative;">
                                        <input class="auth-input" name="repass" id="repass"
                                               type="password" placeholder="••••••••"
                                               required minlength="8" maxlength="50 style="padding-right: 48px;">
                                        <button type="button" onclick="togglePass('repass','eyeRepass')"
                                                style="position:absolute;right:14px;top:50%;transform:translateY(-50%);
                                                       background:none;border:none;cursor:pointer;color:#6b7280;
                                                       font-size:16px;padding:0;line-height:1;">
                                            <i id="eyeRepass" class="fa fa-eye"></i>
                                        </button>
                                    </div>
                                    <span class="field-error" id="repassError">Mật khẩu nhập lại không khớp!</span>
                                </label>
                            </div>

                            <%-- HỌ VÀ TÊN --%>
                            <label>
                                <span class="subtle-link">Họ và tên</span><span class="required">*</span>
                                <input class="auth-input" name="name" id="name" type="text"
                                       value="${param.name}" placeholder="Họ và tên"
                                       required maxlength="50">
                                <span class="field-error" id="nameError">Họ và tên không được để trống!</span>
                            </label>

                            <%-- GIỚI TÍNH & NGÀY SINH --%>
                            <div class="form-row">
                                <label>
                                    <span class="subtle-link">Giới tính</span><span class="required">*</span>
                                    <select class="auth-input" name="gender" id="gender" required style="cursor:pointer;">
                                        <option value="" disabled ${empty param.gender ? 'selected' : ''}>Chọn giới tính</option>
                                        <option value="Male"   ${param.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                                        <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                    </select>
                                    <span class="field-error" id="genderError">Vui lòng chọn giới tính!</span>
                                </label>
                                <label>
                                    <span class="subtle-link">Ngày sinh</span><span class="required">*</span>
                                    <input class="auth-input" name="birthday" id="birthday" type="date"
                                           value="${param.birthday}" required>
                                    <span class="field-error" id="birthdayError">Ngày sinh không hợp lệ hoặc là ngày tương lai!</span>
                                </label>
                            </div>

                            <%-- EMAIL & SĐT --%>
                            <div class="form-row">
                                <label>
                                    <span class="subtle-link">Email</span><span class="required">*</span>
                                    <input class="auth-input" name="email" id="email" type="email"
                                           value="${param.email}" placeholder="email@example.com" required maxlength="100">
                                    <span class="field-error" id="emailError">Email không đúng định dạng!</span>
                                </label>
                                <label>
                                    <span class="subtle-link">Số điện thoại</span><span class="required">*</span>
                                    <input class="auth-input" name="phone" id="phone" type="text"
                                           value="${param.phone}" placeholder="0123456789" required maxlength="200">
                                    <span class="field-error" id="phoneError">Số điện thoại phải gồm 10 số, bắt đầu bằng 0!</span>
                                </label>
                            </div>

                            <%-- ĐỊA CHỈ --%>
                            <label>
                                <span class="subtle-link">Địa chỉ</span><span class="required">*</span>
                                <input class="auth-input" name="address" id="address" type="text"
                                       value="${param.address}" placeholder="Nhập địa chỉ của bạn"
                                       required maxlength="200">
                                <span class="field-error" id="addressError">Địa chỉ không được để trống!</span>
                            </label>

                            <%-- Lỗi server (trùng username/email/sđt) --%>
                            <c:if test="${not empty mess}">
                                <p style="margin:0;color:var(--danger);font-weight:600;">${mess}</p>
                            </c:if>

                            <div class="auth-form__actions" style="margin-top: 8px;">
                                <button class="pill-button pill-button--primary" type="submit"
                                        style="width:100%;justify-content:center;">Đăng ký ngay</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </main>

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

            // Realtime validation
            document.getElementById("user").addEventListener("blur", function () {
                this.value.trim() === "" ? showError("user","userError") : clearError("user","userError");
            });

            document.getElementById("pass").addEventListener("input", function () {
                this.value.length < 8 ? showError("pass","passError") : clearError("pass","passError");
                const repass = document.getElementById("repass");
                if (repass.value.length > 0) {
                    repass.value !== this.value ? showError("repass","repassError") : clearError("repass","repassError");
                }
            });

            document.getElementById("repass").addEventListener("input", function () {
                this.value !== document.getElementById("pass").value
                    ? showError("repass","repassError") : clearError("repass","repassError");
            });

            document.getElementById("name").addEventListener("blur", function () {
                this.value.trim() === "" ? showError("name","nameError") : clearError("name","nameError");
            });

            document.getElementById("gender").addEventListener("change", function () {
                this.value === "" ? showError("gender","genderError") : clearError("gender","genderError");
            });

            document.getElementById("birthday").addEventListener("change", function () {
                const today = new Date().toISOString().split("T")[0];
                !this.value || this.value > today
                    ? showError("birthday","birthdayError") : clearError("birthday","birthdayError");
            });

            document.getElementById("email").addEventListener("blur", function () {
                /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.value)
                    ? clearError("email","emailError") : showError("email","emailError");
            });

            document.getElementById("phone").addEventListener("input", function () {
                /^0\d{9}$/.test(this.value)
                    ? clearError("phone","phoneError") : showError("phone","phoneError");
            });

            document.getElementById("address").addEventListener("blur", function () {
                this.value.trim() === "" ? showError("address","addressError") : clearError("address","addressError");
            });

            // Submit validation
            document.getElementById("signupForm").addEventListener("submit", function (e) {
                let valid = true;
                const today = new Date().toISOString().split("T")[0];
                const checks = [
                    { id:"user",     errId:"userError",     test: v => v.trim() !== "" },
                    { id:"pass",     errId:"passError",     test: v => v.length >= 8 },
                    { id:"repass",   errId:"repassError",   test: v => v === document.getElementById("pass").value },
                    { id:"name",     errId:"nameError",     test: v => v.trim() !== "" },
                    { id:"gender",   errId:"genderError",   test: v => v !== "" },
                    { id:"birthday", errId:"birthdayError", test: v => v !== "" && v <= today },
                    { id:"email",    errId:"emailError",    test: v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) },
                    { id:"phone",    errId:"phoneError",    test: v => /^0\d{9}$/.test(v) },
                    { id:"address",  errId:"addressError",  test: v => v.trim() !== "" },
                ];
                checks.forEach(({ id, errId, test }) => {
                    !test(document.getElementById(id).value)
                        ? (showError(id, errId), valid = false)
                        : clearError(id, errId);
                });
                if (!valid) e.preventDefault();
            });
        </script>
    </body>
</html>