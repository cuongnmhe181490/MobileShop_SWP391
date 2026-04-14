<%-- 
    Document   : requestPassword
    Created on : Apr 14, 2026, 8:45:58 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Quên mật khẩu" />
<c:set var="activePage" value="catalog" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            /* Maintain compact layout consistency */
            .page-section { 
                padding-top: 5vh; 
                padding-bottom: 5vh; 
                display: flex;
                align-items: center;
                min-height: 80vh;
            }
            .auth-layout {
                margin: 0 auto;
                min-height: auto;
            }
            .auth-panel {
                padding: 32px;
                justify-content: center;
            }
            .auth-form {
                padding: 32px;
            }
            .auth-form__stack {
                display: flex;
                flex-direction: column;
                gap: 16px;
                margin-top: 24px !important;
            }
            .subtle-link {
                font-size: 13px;
                margin-bottom: 4px;
                display: inline-block;
            }
            .auth-input {
                padding: 10px 12px;
                font-size: 14px;
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
                            <h1 style="font-size: 54px; line-height: 1.1; margin-bottom: 0;">Khôi phục quyền truy cập</h1>
                        </div>
                    </section>

                    <section class="auth-form">
                        <div class="auth-form__tabs" style="margin-bottom: 0;">
                            <a class="pill-link" href="${ctx}/login.jsp">Quay lại Đăng nhập</a>
                        </div>

                        <h2 style="font-size: 24px; line-height: 1.2; margin-top: 16px;">Quên mật khẩu?</h2>
                        <p style="font-size: 14px; color: var(--text-muted); margin-top: 8px; margin-bottom: 0;">
                            Vui lòng nhập địa chỉ email bạn đã sử dụng để đăng ký.
                        </p>

                        <form class="auth-form__stack" action="requestPassword" method="POST">
                            
                            <label>
                                <span class="subtle-link">Địa chỉ Email</span>
                                <input class="auth-input" name="email" type="email" placeholder="email@example.com" required autofocus>
                            </label>

                            <c:if test="${not empty mess}">
                                <p style="margin: 0; color: var(--danger); font-weight: 600; font-size: 13px;">${mess}</p>
                            </c:if>

                            <div class="auth-form__actions" style="margin-top: 8px;">
                                <button class="pill-button pill-button--primary" type="submit" style="width: 100%; justify-content: center;">Gửi yêu cầu khôi phục</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </main>

    </body>
</html>
