<%-- 
    Document   : resetPassword
    Created on : Apr 16, 2026, 4:06:56 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            .required {
                color: #ff0000 !important;
                font-weight: bold;
                margin-left: 4px;
            }
        </style>
    </head>
    <body>
        <main class="page-section">
            <div class="mobile-shell">
                <div class="auth-layout">
                    <section class="auth-panel">
                        <div class="auth-copy">
                            <span class="section-eyebrow">MobileShop Security</span>
                            <h1 style="font-size: 54px; line-height: 1.1;">Đặt lại mật khẩu</h1>
                        </div>
                    </section>

                    <section class="auth-form">
                        <h2 style="font-size: 28px; line-height: 1.2; margin-top: 12px;">Bảo mật tài khoản</h2>
                        <p style="color: #666; margin-bottom: 24px;">Vui lòng thiết lập mật khẩu mới để tiếp tục sử dụng dịch vụ.</p>

                        <form class="auth-form__stack" action="resetPassword" method="POST" autocomplete="off">
                             <input type="hidden" name="token" value="${token}">
                            <label>
                                <span class="subtle-link">Tài khoản Email</span>
                                <input class="auth-input" name="email" type="email" value="${email}" readonly 
                                       style="background-color: #f5f5f5; cursor: not-allowed; opacity: 0.8;">
                            </label>

                            <label>
                                <span class="subtle-link">Mật khẩu mới</span><span class="required">*</span>
                                <input class="auth-input" name="password" type="password" 
                                       placeholder="Nhập mật khẩu mới" required minlength="8">
                            </label>

                            <label>
                                <span class="subtle-link">Xác nhận mật khẩu mới</span><span class="required">*</span>
                                <input class="auth-input" name="confirm_password" type="password" 
                                       placeholder="Gõ lại mật khẩu mới" required minlength="8">
                            </label>

                            <c:if test="${not empty mess}">
                                <p style="margin: 0; color: #ff0000; font-weight: 600; font-size: 14px;">${mess}</p>
                            </c:if>

                            <div class="auth-form__actions" style="margin-top: 16px;">
                                <button class="pill-button pill-button--primary" type="submit" 
                                        style="width: 100%; justify-content: center;">
                                    Xác nhận thay đổi
                                </button>
                            </div>
                            
                            <div style="text-align: center; margin-top: 24px;">
                                <a href="${ctx}/login.jsp" class="subtle-link">Quay lại trang Đăng nhập</a>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </main>
    </body>
</html>
