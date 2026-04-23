<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Đăng nhập" />
<c:set var="activePage" value="catalog" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        
    </head>
    <body>
        <main class="page-section">
            <div class="mobile-shell">
                <div class="auth-layout">
                    <section class="auth-panel">
                        <div class="auth-copy">
                            <span class="section-eyebrow">MobileShop</span>
                            <h1>Đăng nhập để tiếp tục</h1>
                        </div>
                    </section>

                    <section class="auth-form">
                        <div class="auth-form__tabs">
                            <span class="pill-link pill-link--dark">Đăng nhập</span>
                            <a class="pill-link" href="${ctx}/signup.jsp">Tạo tài khoản</a>
                        </div>

                        <h2 style="font-size: 54px; line-height: 1.05; margin-top: 8px;">Chào mừng trở lại</h2>
                        
                        <c:if test="${not empty sessionScope.errorMsg}">
                            <div style="color: #ee5d50; background: #feebeb; padding: 12px; border-radius: 8px; margin-top: 16px; margin-bottom: 20px; font-size: 0.9rem; border: 1px solid #f5b7b1;">
                                <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.errorMsg}
                            </div>
                            <c:remove var="errorMsg" scope="session" />
                        </c:if>

                       <form class="auth-form__stack" action="login" method="post" style="margin-top: 34px;">
                            <label>
                                <span class="subtle-link">Tên đăng nhập</span>
                                <input class="auth-input" name="user" type="text" placeholder="Tên đăng nhập" required autofocus>
                            </label>
                            <label>
                                <span class="subtle-link">Mật khẩu</span>
                                <div style="position: relative;">
                                    <input class="auth-input" name="pass" id="passInput"
                                           type="password" placeholder="••••••••" required
                                           style="padding-right: 48px;">
                                    <button type="button" onclick="togglePass()"
                                            style="position: absolute; right: 14px; top: 50%;
                                                   transform: translateY(-50%); background: none;
                                                   border: none; cursor: pointer; color: #6b7280;
                                                   font-size: 18px; padding: 0; line-height: 1;">
                                        <i id="eyeIcon" class="fa fa-eye"></i>
                                    </button>
                                </div>
                            </label>                            <c:if test="${not empty mess}">
                                <p style="margin: 0; color: var(--danger); font-weight: 600;">${mess}</p>
                            </c:if>

                            <div class="auth-form__actions">
                                <button class="pill-button pill-button--primary" type="submit">Đăng nhập</button>
                                <a class="pill-link" href="${ctx}/requestPassword.jsp">Quên mật khẩu</a>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </main>
        <script>
            function togglePass() {
                const input = document.getElementById("passInput");
                const icon  = document.getElementById("eyeIcon");
                if (input.type === "password") {
                    input.type = "text";
                    icon.className = "fa fa-eye-slash";
                } else {
                    input.type = "password";
                    icon.className = "fa fa-eye";
                }
            }
        </script>
    </body>
</html>
