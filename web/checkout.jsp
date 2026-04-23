<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Đặt hàng" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <section class="surface-card checkout-placeholder">
                    <span class="section-eyebrow">Đặt hàng</span>
                    <h1>Checkout đang chờ tích hợp</h1>
                    <p>Trang này đang được giữ làm điểm nối an toàn cho bước thanh toán tiếp theo. Khi teammate hoàn tất màn checkout thật, chỉ cần thay route từ nút “Đặt hàng” trong giỏ hàng sang flow mới.</p>
                    <div class="summary-actions checkout-placeholder__actions">
                        <a class="pill-link pill-link--primary" href="${ctx}/cart">Quay lại giỏ hàng</a>
                        <a class="pill-link" href="${ctx}/product">Tiếp tục mua sắm</a>
                    </div>
                </section>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
