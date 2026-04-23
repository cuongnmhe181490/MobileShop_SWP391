<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="checkoutPlaceholderUrl" value="${ctx}/checkout.jsp" />
<c:set var="pageTitle" value="Giỏ hàng" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <div class="cart-title">
                    <span class="section-eyebrow">Giỏ hàng</span>
                    <h1>Kiểm tra sản phẩm trước khi đặt hàng.</h1>
                    <p>Giỏ hàng sẽ lưu các sản phẩm bạn vừa chọn để tiếp tục thanh toán ở bước sau.</p>
                </div>

                <c:if test="${empty cartItems}">
                    <div class="order-empty">
                        <p>Giỏ hàng của bạn đang trống. Hãy quay lại cửa hàng để thêm sản phẩm phù hợp.</p>
                        <a class="pill-link pill-link--primary" href="${ctx}/product">Tiếp tục mua sắm</a>
                    </div>
                </c:if>

                <c:if test="${not empty cartItems}">
                    <div class="checkout-grid">
                        <section class="cart-list">
                            <c:forEach items="${cartItems}" var="item">
                                <c:url var="cartFallbackImageUrl" value="/product-image">
                                    <c:param name="brand" value="${item.product.idSupplier}" />
                                    <c:param name="name" value="${item.product.productName}" />
                                </c:url>
                                <article class="cart-item">
                                    <a class="cart-item__media" href="${ctx}/detail?pid=${item.product.idProduct}">
                                        <img src="${item.product.imagePath}" alt="${item.product.productName}" onerror="this.onerror=null;this.src='${cartFallbackImageUrl}';">
                                    </a>
                                    <div class="cart-item__content">
                                        <h3><a href="${ctx}/detail?pid=${item.product.idProduct}">${item.product.productName}</a></h3>
                                        <div class="cart-item__chips">
                                            <span class="status-chip ${item.displayStock > 0 ? 'status-chip--blue' : 'status-chip--pink'}">Còn ${item.displayStock} sản phẩm khả dụng</span>
                                        </div>
                                        <div class="cart-item__actions">
                                            <form class="cart-qty-form" action="${ctx}/cart/update" method="post">
                                                <input type="hidden" name="idProduct" value="${item.product.idProduct}">
                                                <div class="cart-item__qty-group" data-stock="${item.maxQuantity}">
                                                    <button class="qty-button" type="button" data-qty-action="decrease" aria-label="Giảm số lượng">-</button>
                                                    <label class="cart-item__qty">
                                                        <span>Số lượng</span>
                                                        <input type="number" name="quantity" min="1" max="${item.maxQuantity}" step="1" value="${item.quantity}" inputmode="numeric" required>
                                                    </label>
                                                    <button class="qty-button" type="button" data-qty-action="increase" aria-label="Tăng số lượng">+</button>
                                                </div>
                                                <button class="pill-button" type="submit">Cập nhật</button>
                                            </form>
                                            <form action="${ctx}/cart/remove" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?');">
                                                <input type="hidden" name="idProduct" value="${item.product.idProduct}">
                                                <button class="pill-button" type="submit">Xóa</button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="cart-item__price">
                                        <strong>${item.subtotalLabel}</strong>
                                        <span>Đơn giá: ${item.priceLabel}</span>
                                    </div>
                                </article>
                            </c:forEach>
                        </section>

                        <aside>
                            <div class="summary-card">
                                <h2>Tóm tắt đơn hàng</h2>
                                <div class="summary-row">
                                    <span>Số lượng sản phẩm</span>
                                    <strong>${sessionScope.size}</strong>
                                </div>
                                <div class="summary-row summary-row--total">
                                    <span>Tạm tính</span>
                                    <strong><fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0"/> đ</strong>
                                </div>
                                <div class="summary-actions">
                                    <a class="pill-link pill-link--primary summary-actions__checkout" href="${checkoutPlaceholderUrl}">Đặt hàng</a>
                                    <a class="pill-link" href="${ctx}/product">Tiếp tục mua sắm</a>
                                </div>
                                <p class="summary-note">Màn thanh toán đang chờ tích hợp. Nút này là điểm nối tạm để teammate gắn checkout thật ở bước sau.</p>
                            </div>
                        </aside>
                    </div>
                </c:if>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
        <script>
            document.querySelectorAll('.cart-item__qty-group').forEach(function (group) {
                const input = group.querySelector('input[name="quantity"]');
                const stock = Number(group.dataset.stock || input.max || 1);

                function clampValue(value) {
                    if (!Number.isFinite(value)) {
                        return 1;
                    }
                    return Math.min(stock, Math.max(1, Math.trunc(value)));
                }

                group.querySelectorAll('[data-qty-action]').forEach(function (button) {
                    button.addEventListener('click', function () {
                        const delta = button.dataset.qtyAction === 'increase' ? 1 : -1;
                        input.value = clampValue(Number(input.value || 1) + delta);
                    });
                });

                input.addEventListener('input', function () {
                    this.value = this.value.replace(/[^0-9]/g, '');
                });

                input.addEventListener('change', function () {
                    this.value = clampValue(Number(this.value || 1));
                });
            });
        </script>
    </body>
</html>
