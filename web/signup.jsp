<%-- 
    Document   : signup
    Created on : Apr 14, 2026, 8:00:03 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Tạo tài khoản" />
<c:set var="activePage" value="catalog" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            /* Additional inline styling to handle the taller signup form elegantly */
            .auth-form__stack {
                display: flex;
                flex-direction: column;
                gap: 16px; /* Consistent spacing between fields */
            }
            .form-row {
                display: flex;
                gap: 16px;
                width: 100%;
            }
            .form-row > label {
                flex: 1;
            }
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

                        <form class="auth-form__stack" action="signup" method="post" style="margin-top: 24px;" autocomplete="off">
    
                            <label>
                                <span class="subtle-link">Tên đăng nhập</span>
                                <input class="auth-input" name="user" type="text" value="${param.user}" placeholder="Tên đăng nhập" required autofocus>
                            </label>

                            <div class="form-row">
                                <label>
                                    <span class="subtle-link">Mật khẩu</span>
                                    <input class="auth-input" name="pass" id="pass" type="password" placeholder="••••••••" required minlength="8">
                                </label>
                                <label>
                                    <span class="subtle-link">Nhập lại mật khẩu</span>
                                    <input class="auth-input" name="repass" id="repass" type="password" placeholder="••••••••" required minlength="8">
                                </label>
                            </div>

                            <label>
                                <span class="subtle-link">Họ và tên</span>
                                <input class="auth-input" name="name" type="text" value="${param.name}" placeholder="Họ và tên" required>
                            </label>

                            <div class="form-row">
                                <label>
                                    <span class="subtle-link">Giới tính</span>
                                    <select class="auth-input" name="gender" required style="cursor: pointer;">
                                        <option value="" disabled ${empty param.gender ? 'selected' : ''}>Chọn giới tính</option>
                                        <option value="Male" ${param.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                        <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                    </select>
                                </label>
                                <label>
                                    <span class="subtle-link">Ngày sinh</span>
                                    <input class="auth-input" name="birthday" type="text" value="${param.birthday}" placeholder="YYYY-MM-DD" required>
                                </label>
                            </div>

                            <div class="form-row">
                                <label>
                                    <span class="subtle-link">Email</span>
                                    <input class="auth-input" name="email" id="email" type="email" value="${param.email}" placeholder="email@example.com" required>   <span class="error-text" id="email-error"></span>
                                </label>
                                <label>
                                    <span class="subtle-link">Số điện thoại</span>
                                    <input class="auth-input" name="phone" id="phone" type="text" value="${param.phone}" placeholder="0123456789" required>
                                </label>
                            </div>

                            <label>
                                <span class="subtle-link">Địa chỉ</span>
                                <input class="auth-input" name="address" type="text" value="${param.address}" placeholder="Nhập địa chỉ của bạn" required>
                            </label>

                            <c:if test="${not empty mess}">
                                <p style="margin: 0; color: var(--danger); font-weight: 600;">${mess}</p>
                            </c:if>

                            <div class="auth-form__actions" style="margin-top: 8px;">
                                <button class="pill-button pill-button--primary" type="submit" style="width: 100%; justify-content: center;">Đăng ký ngay</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </main>
    </body>
</html>
