<%-- 
    Document   : account-manage
    Created on : Apr 20, 2026, 11:01:31 PM
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - Admin Panel</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
</head>
<body>
    <div class="dashboard-container">
        <c:set var="activePage" value="users" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="header">
                <div class="welcome">
                    <p class="admin-shell-eyebrow">Hệ thống</p>
                    <h1>Quản lý tài khoản</h1>
                    <p class="admin-shell-subtitle">Quản lý danh sách người dùng, phân quyền và trạng thái hoạt động.</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/admin/add-user.jsp" class="btn-primary" style="text-decoration: none;"><i class="fa-solid fa-user-plus"></i> Thêm người dùng mới</a>
                    <div class="user-profile">
                        <div class="avatar">${sessionScope.acc != null ? sessionScope.acc.name.substring(0,1).toUpperCase() : "A"}</div>
                        <span style="font-weight: 600;">${sessionScope.acc != null ? sessionScope.acc.name : "Admin"}</span>
                    </div>
                </div>
            </header>

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="admin-flash admin-flash--success"><i class="fa-solid fa-check-circle"></i> ${sessionScope.successMsg}</div>
                <c:remove var="successMsg" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMsg}">
                <div class="admin-flash admin-flash--danger"><i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.errorMsg}</div>
                <c:remove var="errorMsg" scope="session"/>
            </c:if>

            <section class="content-card">
                <form action="${pageContext.request.contextPath}/admin/accounts" method="GET" class="filter-bar">
                    <div class="product-search-wrap" style="flex: 1; max-width: 400px;">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="search" class="form-input product-search-input" placeholder="Tìm theo tên, email, SĐT..." value="${searchQuery}">
                    </div>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                    
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/accounts" class="btn-outline" style="text-decoration: none;"><i class="fa-solid fa-xmark"></i> Hủy lọc</a>
                    </c:if>
                </form>    

                <div class="table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th style="text-align: center; width: 15%;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="u">
                                <tr>
                                    <td>
                                        <span style="font-weight: 700; color: var(--text-main);">${u.name}</span>
                                        <c:if test="${not empty sessionScope.acc and u.id == sessionScope.acc.id}">
                                            <span style="font-style: italic; color: var(--primary); font-size: 0.8rem; margin-left: 4px;">(Bạn)</span>
                                        </c:if>
                                    </td>
                                    <td style="color: var(--text-muted);">${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td><span style="font-weight: 600;">${u.role.roleName}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'Hoạt động'}">
                                                <span class="status-active">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-locked" title="Lý do khóa: ${u.lockReason}">Bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty u.createdDate}">
                                                <fmt:formatDate value="${u.createdDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #cbd5e1;">--/--/----</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <a href="${pageContext.request.contextPath}/admin/edit-user?id=${u.id}" class="btn-icon btn-edit" title="Sửa thông tin"><i class="fa-solid fa-pen"></i></a>

                                            <c:choose>
                                                <c:when test="${not empty sessionScope.acc and u.id == sessionScope.acc.id}">
                                                    <button type="button" class="btn-icon" style="background: #e2e8f0; color: #94a3b8; cursor: not-allowed;" disabled title="Không thể tự khóa mình"><i class="fa-solid fa-lock"></i></button>
                                                </c:when>
                                                <c:otherwise>
                                                    <form id="form-action-${u.id}" action="${pageContext.request.contextPath}/admin/accounts" method="POST" style="margin:0; display: none;">
                                                        <input type="hidden" name="id" value="${u.id}">
                                                        <input type="hidden" name="email" value="${u.email}">
                                                        <input type="hidden" name="name" value="${u.name}">
                                                        <input type="hidden" name="action" id="action-${u.id}">
                                                        <input type="hidden" name="reason" id="reason-${u.id}">
                                                    </form>

                                                    <c:choose>
                                                        <c:when test="${u.status == 'Hoạt động'}">
                                                            <button type="button" onclick="confirmLock(${u.id}, '${u.name}')" class="btn-icon btn-lock" title="Khóa tài khoản"><i class="fa-solid fa-lock"></i></button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" onclick="submitForm(${u.id}, 'unlock')" class="btn-icon btn-unlock" title="Mở khóa"><i class="fa-solid fa-unlock"></i></button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty userList}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 60px 0;">
                                        <div style="color: var(--text-muted);">
                                            <i class="fa-solid fa-users" style="font-size: 3rem; opacity: 0.2; margin-bottom: 16px; display: block;"></i>
                                            <p style="font-size: 1.1rem; font-weight: 500;">Không tìm thấy người dùng nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <script>
        function submitForm(id, actionStr) {
            document.getElementById('action-' + id).value = actionStr;
            document.getElementById('form-action-' + id).submit();
        }

        function confirmLock(id, name) {
            let reason = prompt("Nhập lý do khóa tài khoản của " + name + ":\n(Lý do sẽ được gửi qua email cho người dùng)");
            if (reason !== null && reason.trim() !== "") {
                document.getElementById('action-' + id).value = 'lock';
                document.getElementById('reason-' + id).value = reason;
                document.getElementById('form-action-' + id).submit();
            } else if (reason !== null) {
                alert("Bạn phải nhập lý do để khóa tài khoản!");
            }
        }
    </script>
</body>
</html>
