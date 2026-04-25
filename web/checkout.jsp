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
                                <div class="filter-group">
                                    <h3>Họ và tên người nhận</h3>
                                    <input type="text" name="fullName" class="auth-input ${not empty errorFullName ? 'is-invalid' : ''}"
                <form id="checkoutForm" action="${ctx}/checkout" method="post">
                    <div class="checkout-grid">
                        <section class="auth-form" style="padding: 32px;">
                            <h2 style="margin-bottom: 24px;">Thông tin giao hàng</h2>
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

                                <div class="filter-group">
                                    <h3>Số điện thoại</h3>
                                    <input type="tel" name="phone" class="auth-input ${not empty errorPhone ? 'is-invalid' : ''}"
                                <!-- Số điện thoại -->
                                <div class="filter-group">
                                    <h3>Số điện thoại</h3>
                                    <input type="tel" name="phone" class="auth-input ${not empty errorPhone ? 'is-invalid' : ''}" 
                                           value="${not empty phone ? phone : sessionScope.acc.phone}" placeholder="Ví dụ: 0912345678">
                                    <c:if test="${not empty errorPhone}">
                                        <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> ${errorPhone}</div>
                                    </c:if>
                                </div>

                                <div class="filter-group">
                                    <h3>Email</h3>
                                    <input type="email" name="email" class="auth-input ${not empty errorEmail ? 'is-invalid' : ''}"
                                <!-- Email -->
                                <div class="filter-group">
                                    <h3>Email</h3>
                                    <input type="email" name="email" class="auth-input ${not empty errorEmail ? 'is-invalid' : ''}" 
                                           value="${not empty email ? email : sessionScope.acc.email}" placeholder="Ví dụ: email@domain.com">
                                    <c:if test="${not empty errorEmail}">
                                        <div class="error-message"><i class="fa-solid fa-circle-exclamation"></i> ${errorEmail}</div>
                                    </c:if>
                                </div>

                                <div class="filter-group">
                                    <h3>Địa chỉ nhận hàng (Chi tiết)</h3>
                                    <input type="text" name="address" class="auth-input ${not empty errorAddress ? 'is-invalid' : ''}"
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
                                    <div class="reservation-countdown" style="background: rgba(245, 158, 11, 0.1); border: 1px solid rgba(245, 158, 11, 0.2); border-radius: 12px; padding: 12px 16px; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                                        <i class="fa-regular fa-clock" style="color: #d97706; font-size: 16px;"></i>
                                        <span style="font-size: 13.5px; color: #d97706; font-weight: 500;">Giữ hàng sắp hết trong <strong id="reservationCountdown">15:00</strong></span>
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
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.getElementById('checkoutForm');
                const inputs = form.querySelectorAll('.auth-input');
                const reservationExpiry = Number('${empty reservationExpiresAtMillis ? "" : reservationExpiresAtMillis}');

                const validators = {
                    fullName: (val) => val.trim().length > 0 ? '' : 'Họ tên không được để trống',
                    phone: (val) => /^[0-9]{10,11}$/.test(val) ? '' : 'Số điện thoại phải từ 10-11 chữ số',
                    email: (val) => /^[A-Za-z0-9+_.-]+@(.+)$/.test(val) ? '' : 'Email không hợp lệ',
                    address: (val) => val.trim().length > 0 ? '' : 'Vui lòng nhập địa chỉ nhận hàng'
                };

                function validateField(input) {
                    const name = input.getAttribute('name');
                    if (!validators[name]) return true;

                    const error = validators[name](input.value);
                    const container = input.closest('.filter-group');
                    let errorEl = container.querySelector('.error-message');

                    if (error) {
                        input.classList.add('is-invalid');
                        if (!errorEl) {
                            errorEl = document.createElement('div');
                            errorEl.className = 'error-message';
                            container.appendChild(errorEl);
                        }
                        errorEl.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> ' + error;
                        return false;
                    } else {
                        input.classList.remove('is-invalid');
                        if (errorEl) errorEl.remove();
                        return true;
                    }
                }

                inputs.forEach(input => {
                    input.addEventListener('blur', () => validateField(input));
                    input.addEventListener('input', () => {
                        if (input.classList.contains('is-invalid')) {
                            validateField(input);
                        }
                    });
                });

                form.addEventListener('submit', function(e) {
                    let isValid = true;
                    inputs.forEach(input => {
                        if (!validateField(input)) isValid = false;
                    });
                    if (!isValid) e.preventDefault();
                });

                if (Number.isFinite(reservationExpiry) && reservationExpiry > 0) {
                    const countdownEl = document.getElementById('reservationCountdown');
                    if (countdownEl) {
                        const updateCountdown = () => {
                            const remaining = reservationExpiry - Date.now();
                            if (remaining <= 0) {
                                countdownEl.textContent = '00:00';
                                window.location.href = '${ctx}/checkout';
                                return;
                            }
                            const totalSeconds = Math.floor(remaining / 1000);
                            const minutes = String(Math.floor(totalSeconds / 60)).padStart(2, '0');
                            const seconds = String(totalSeconds % 60).padStart(2, '0');
                            countdownEl.textContent = minutes + ':' + seconds;
                        };

                        updateCountdown();
                        window.setInterval(updateCountdown, 1000);
                    }
                }
            });
        </script>
    </body>
</html>
