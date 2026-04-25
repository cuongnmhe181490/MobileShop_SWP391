<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Đặt hàng thành công" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <!-- Css Styles -->
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/style.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/mobileshop.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/custom.css" type="text/css">
    </head>
        <style>
            .success-container {
                max-width: 720px;
                margin: 40px auto;
                background: #ffffff;
                border-radius: 40px;
                padding: 80px 40px;
                text-align: center;
                box-shadow: 0 40px 80px rgba(22, 33, 63, 0.04);
                border: 1px solid var(--line);
                position: relative;
                overflow: hidden;
            }
            .success-image {
                width: 280px;
                height: auto;
                margin-bottom: 40px;
                filter: drop-shadow(0 20px 40px rgba(34, 160, 107, 0.1));
            }
            .success-container h1 {
                font-family: 'Plus Jakarta Sans', sans-serif;
                font-size: 42px;
                font-weight: 800;
                color: var(--text);
                margin-bottom: 16px;
                letter-spacing: -0.02em;
            }
            .success-container p {
                font-size: 17px;
                color: var(--muted);
                line-height: 1.7;
                max-width: 500px;
                margin: 0 auto 48px;
            }
            .order-receipt {
                background: var(--panel-soft);
                padding: 24px 40px;
                border-radius: 24px;
                display: inline-flex;
                flex-direction: column;
                gap: 8px;
                margin-bottom: 48px;
                border: 1px dashed rgba(18, 32, 74, 0.2);
            }
            .order-receipt-row {
                display: flex;
                justify-content: space-between;
                gap: 60px;
                align-items: center;
            }
            .order-receipt-row span {
                font-size: 14px;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.1em;
            }
            .order-receipt-row strong {
                font-size: 16px;
                color: var(--text);
                font-weight: 700;
            }
            .success-actions {
                display: flex;
                justify-content: center;
                gap: 16px;
            }
            .pill-link--secondary {
                background: #ffffff;
                border: 1px solid var(--line);
                color: var(--text) !important;
            }
            .pill-link--secondary:hover {
                background: var(--panel-soft);
                border-color: var(--muted);
            }
        </style>
    </head>
    <body style="background: var(--bg);">
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <div class="success-container">
                    <img src="${ctx}/img/order_success_illustration.png" alt="Đặt hàng thành công" class="success-image">
                    
                    <span class="status-chip status-chip--green" style="margin-bottom: 20px; padding: 10px 24px;">Đặt hàng thành công</span>
                    <h1>Cảm ơn bạn đã tin tưởng!</h1>
                    <p>
                        Đơn hàng của bạn đã được ghi nhận. Chúng tôi sẽ xử lý và liên hệ với bạn trong thời gian sớm nhất để xác nhận giao hàng.
                    </p>
                    
                    <div class="order-receipt">
                        <div class="order-receipt-row">
                            <span>Mã đơn hàng</span>
                            <strong>#ORD-<fmt:formatNumber pattern="000" value="${param.orderId != null ? param.orderId : 0}" /></strong>
                        </div>
                        <div class="order-receipt-row">
                            <span>Ngày đặt hàng</span>
                            <strong><%= new java.text.SimpleDateFormat("dd/MM/yyyy · HH:mm").format(new java.util.Date()) %></strong>
                        </div>
                    </div>
                    
                    <div class="success-actions">
                        <a href="${ctx}/product" class="pill-link pill-link--primary" style="min-height: 56px; padding: 0 40px; display: flex; align-items: center;">Tiếp tục mua hàng</a>
                        <a href="${ctx}/review/mine" class="pill-link pill-link--secondary" style="min-height: 56px; padding: 0 40px; display: flex; align-items: center;">Xem lịch sử mua</a>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
