<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Thanh toán" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <!-- Css Styles -->
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/style.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/mobileshop.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/custom.css" type="text/css">
        <style>
            .error-message {
                color: #ef4444;
                font-size: 13px;
                margin-top: 6px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .error-message i { font-size: 14px; }
            .auth-input.is-invalid {
                border-color: #ef4444;
                background-color: #fef2f2;
            }
            .checkout-product-item {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 16px 0;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
            .checkout-product-item img {
                width: 72px;
                height: 72px;
                object-fit: contain;
                background: #fff;
                border-radius: 16px;
                border: 1px solid var(--line);
                padding: 6px;
                flex-shrink: 0;
            }
            .checkout-product-info { flex: 1; }
            .checkout-product-name {
                font-weight: 600;
                font-size: 16px;
                color: #ffffff;
                margin-bottom: 4px;
                line-height: 1.4;
            }
            .checkout-product-meta {
                font-size: 13px;
                color: rgba(255, 255, 255, 0.7);
            }
            .checkout-product-price {
                font-weight: 700;
                font-size: 16px;
                color: #ffffff;
                text-align: right;
                white-space: nowrap;
            }
            /* Đảm bảo chữ tiêu đề card trắng */
            .summary-card h2 { color: #ffffff; font-size: 24px; margin-bottom: 20px; }
            .summary-row span { color: rgba(255, 255, 255, 0.8); font-size: 15px; }
            .summary-row strong { color: #ffffff; font-size: 16px; }
            .summary-row--total span { font-size: 18px; color: #ffffff; }
            .summary-row--total strong { font-size: 24px; color: #ffffff; }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <div class="cart-title">
                    <span class="section-eyebrow">Thanh toán</span>
                    <h1>Hoàn tất đơn hàng của bạn.</h1>
                    <p>Vui lòng kiểm tra lại thông tin nhận hàng và danh sách sản phẩm trước khi xác nhận đặt hàng.</p>
                </div>

                <form id="checkoutForm" action="${ctx}/order/place" method="post">
                    <div class="checkout-grid">
                        <section class="auth-form" style="padding: 32px;">
                            <h2 style="margin-bottom: 24px;">Thông tin giao hàng</h2>
                            <c:if test="${not empty formError}">
                                <div class="error-message" style="margin-bottom: 16px;">
                                    <i class="fa-solid fa-circle-exclamation"></i> ${formError}
                                </div>
                            </c:if>
                            <div class="auth-form__stack">
                                <!-- Họ tên -->
                                <div class="filter-group">
                                    <h3>Họ và tên người nhận</h3>
                                    <input type="text" name="fullName" class="auth-input ${not empty errorFullName ? 'is-invalid' : ''}" 
                                           value="${not empty fullName ? fullName : sessionScope.acc.name}" placeholder="Ví dụ: Nguyễn Văn A">
                                    <c:if test="${not empty errorFullName}">
                                        <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> ${errorFullName}</div>
                                    </c:if>
                                </div>

                                <!-- Số điện thoại -->
                                <div class="filter-group">
                                    <h3>Số điện thoại</h3>
                                    <input type="tel" name="phone" class="auth-input ${not empty errorPhone ? 'is-invalid' : ''}" 
                                           value="${not empty phone ? phone : sessionScope.acc.phone}" placeholder="Ví dụ: 0912345678">
                                    <c:if test="${not empty errorPhone}">
                                        <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> ${errorPhone}</div>
                                    </c:if>
                                </div>

                                <!-- Email -->
                                <div class="filter-group">
                                    <h3>Email</h3>
                                    <input type="email" name="email" class="auth-input ${not empty errorEmail ? 'is-invalid' : ''}" 
                                           value="${not empty email ? email : sessionScope.acc.email}" placeholder="Ví dụ: email@domain.com">
                                    <c:if test="${not empty errorEmail}">
                                        <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> ${errorEmail}</div>
                                    </c:if>
                                </div>

                                <!-- Địa chỉ -->
                                <div class="filter-group">
                                    <h3>Địa chỉ nhận hàng (Chi tiết)</h3>
                                    <input type="text" name="address" class="auth-input ${not empty errorAddress ? 'is-invalid' : ''}" 
                                           value="${not empty address ? address : sessionScope.acc.address}" placeholder="Số nhà, tên đường, phường/xã, quận/huyện...">
                                    <c:if test="${not empty errorAddress}">
                                        <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> ${errorAddress}</div>
                                    </c:if>
                                </div>

                                <!-- Ghi chú -->
                                <div class="filter-group">
                                    <h3>Ghi chú (Tùy chọn)</h3>
                                    <textarea name="note" class="auth-input" style="min-height: 100px; padding: 12px; resize: vertical;" placeholder="Lời nhắn cho nhân viên giao hàng...">${note}</textarea>
                                </div>

                                <!-- Phương thức thanh toán -->
                                <div class="filter-group">
                                    <h3>Phương thức thanh toán</h3>
                                    <div class="filter-chip-row">
                                        <label class="filter-chip is-active">
                                            <input type="radio" name="paymentMethod" value="COD" checked>
                                            Thanh toán khi nhận hàng (COD)
                                        </label>
                                    </div>
                                    <p style="font-size: 13px; color: var(--muted); margin-top: 8px;">* Hiện tại chúng tôi chỉ hỗ trợ thanh toán khi nhận hàng.</p>
                                </div>
                            </div>
                        </section>

                        <aside>
                            <div class="summary-card">
                                <h2>Đơn hàng của bạn</h2>
                                <c:if test="${not empty reservationExpiresAtMillis}">
                                    <div class="error-message" style="background: rgba(255, 247, 237, .12); border: 1px solid rgba(251, 146, 60, .35); border-radius: 14px; padding: 12px; margin-bottom: 14px; color: #fed7aa;">
                                        <i class="fa-solid fa-clock"></i>
                                        Giữ hàng sắp hết trong <strong id="reservationCountdown" data-expires-at="${reservationExpiresAtMillis}">15:00</strong>
                                    </div>
                                </c:if>
                                <div class="checkout-items-list" style="margin: 20px 0; max-height: 400px; overflow-y: auto;">
                                    <c:forEach items="${cartItems}" var="item">
                                        <div class="checkout-product-item">
                                            <img src="${item.product.imagePath}" alt="${item.product.productName}">
                                            <div class="checkout-product-info">
                                                <div class="checkout-product-name">${item.product.productName}</div>
                                                <div class="checkout-product-meta">${item.quantity} x ${item.priceLabel}</div>
                                            </div>
                                            <div class="checkout-product-price">${item.subtotalLabel}</div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="summary-row">
                                    <span>Tạm tính</span>
                                    <strong><fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0"/> đ</strong>
                                </div>
                                <div class="summary-row" style="color: var(--success);">
                                    <span>Phí vận chuyển</span>
                                    <strong>Miễn phí</strong>
                                </div>
                                <div class="summary-row summary-row--total">
                                    <span>Tổng cộng</span>
                                    <strong><fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0"/> đ</strong>
                                </div>
                                <div class="summary-actions">
                                    <button type="submit" class="pill-button pill-button--primary" style="width: 100%; min-height: 54px; font-size: 16px;">Xác nhận đặt hàng</button>
                                    <a class="pill-link" href="${ctx}/cart" style="width: 100%;">Quay lại giỏ hàng</a>
                                </div>
                            </div>
                        </aside>
                    </div>
                </form>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
        <script>
            (function () {
                const countdown = document.getElementById('reservationCountdown');
                if (!countdown) return;
                const expiresAt = Number(countdown.dataset.expiresAt);
                function tick() {
                    const remaining = Math.max(0, expiresAt - Date.now());
                    const minutes = Math.floor(remaining / 60000);
                    const seconds = Math.floor((remaining % 60000) / 1000);
                    countdown.textContent = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
                    if (remaining <= 0) {
                        countdown.textContent = '00:00 - đã hết thời gian giữ hàng';
                        return;
                    }
                    window.setTimeout(tick, 1000);
                }
                tick();
            })();
        </script>
    </body>
</html>
