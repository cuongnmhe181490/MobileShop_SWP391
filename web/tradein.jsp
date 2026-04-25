<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Thu cũ đổi mới" />
<c:set var="activePage" value="tradein" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <section class="tradein-hero">
                    <div class="tradein-hero__copy">
                        <span class="hero-card__eyebrow">Định giá</span>
                        <h1>Máy cũ của bạn đáng bao nhiêu?</h1>
                        <p>Hãy chọn hãng, model và tình trạng máy để hệ thống tính mức thu cũ tạm thời.</p>
                    </div>
                </section>

                <div class="tradein-layout">
                    <section class="tradein-form-card">
                        <div class="section-heading section-heading--compact">
                            <div>
                                <span class="section-eyebrow">Định giá ngay</span>
                                <h2>Cho chúng tôi biết về máy của bạn</h2>
                            </div>
                        </div>

                        <form action="${ctx}/tradein" method="post" class="tradein-form">
                            <label>
                                <span>Hãng sản phẩm</span>
                                <select name="brand" id="brandSelect" onchange="updateProductModels()">
                                    <option value="" disabled ${empty selectedBrand ? 'selected' : ''}>-- Chọn hãng --</option>
                                    <c:forEach items="${brands}" var="brand">
                                        <option value="${brand}" ${selectedBrand == brand ? 'selected' : ''}>${brand}</option>
                                    </c:forEach>
                                </select>
                            </label>
                            <label>
                                <span>Tên sản phẩm</span>
                                <select name="modelName" id="modelSelect" onchange="calculatePrice()">
                                    <c:choose>
                                        <c:when test="${not empty modelName}">
                                            <option value="${modelName}" selected>${modelName}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="" disabled selected>-- Chọn máy --</option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </label>
                            <label>
                                <span>Mức độ mới</span>
                                <select name="condition" id="conditionSelect" onchange="calculatePrice()">
                                    <c:forEach items="${conditionLabels}" var="entry">
                                        <option value="${entry.key}" ${selectedCondition == entry.key ? 'selected' : ''}>${entry.value}</option>
                                    </c:forEach>
                                </select>
                            </label>
                            <button class="pill-button pill-button--primary tradein-form__submit" type="submit">Định giá ngay</button>
                        </form>
                    </section>

                    <section class="tradein-result-card">
                        <div class="section-heading section-heading--compact">
                            <div>
                                <span class="section-eyebrow">Kết quả tạm tính</span>
                                <h2>Mức định giá ngay bên dưới</h2>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty requestScope.tradeInQuote}">
                                <c:set var="quote" value="${requestScope.tradeInQuote}" />
                                <c:choose>
                                    <c:when test="${quote.estimatedValue > 0}">
                                        <div class="tradein-quote">
                                            <span class="tradein-quote__label">Số tiền bạn được nhận:</span>
                                            <strong><fmt:formatNumber value="${quote.estimatedValue}" type="number" maxFractionDigits="0"/>đ</strong>
                                            <p>${quote.brand} · ${quote.modelName} · ${quote.conditionLabel}</p>
                                            
                                            <div class="tradein-quote__actions" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px;">
                                                <p style="font-size: 0.9rem; color: #666; margin-bottom: 15px;">Dùng số tiền này để trừ trực tiếp khi mua máy mới tại MobileShop.</p>
                                                <a href="${ctx}/home" class="pill-button pill-button--primary" style="display: flex; align-items: center; justify-content: center; text-decoration: none; width: 100%;">Lên đời ngay</a>
                                            </div>
                                            <c:if test="${quote.matchedProduct != null}">
                                                <div class="tradein-quote__matched">
                                                    <img src="${quote.matchedProduct.imagePath}" alt="${quote.matchedProduct.productName}">
                                                    <div>
                                                        <h3>${quote.matchedProduct.productName}</h3>
                                                        <p>Giá bán tham chiếu hiện tại: <fmt:formatNumber value="${quote.matchedProduct.price}" type="number" maxFractionDigits="0"/>đ</p>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="tradein-quote tradein-quote--error" style="background: #fff5f5; border: 1px dashed #feb2b2; padding: 30px; border-radius: 12px; text-align: center;">
                                            <i class="fa-solid fa-triangle-exclamation" style="font-size: 2.5rem; color: #f56565; margin-bottom: 15px; display: block;"></i>
                                            <strong style="color: #c53030; font-size: 1.1rem; display: block; margin-bottom: 8px;">Sản phẩm chưa được hỗ trợ</strong>
                                            <p style="color: #9b2c2c; font-size: 0.9rem;">Rất tiếc, mẫu máy "${quote.modelName}" hiện chưa có trong danh mục thu mua trực tuyến của chúng tôi. Vui lòng liên hệ hotline để được tư vấn trực tiếp.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <div class="tradein-quote tradein-quote--empty">
                                    <strong>Chưa có định giá</strong>
                                    <p>Hãy chọn hãng, model và tình trạng máy để hệ thống tính mức thu cũ tạm thời.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>
                </div>
            </div>
        </main>

        <script>
            function updateProductModels() {
                const brand = document.getElementById('brandSelect').value;
                const modelSelect = document.getElementById('modelSelect');
                
                modelSelect.innerHTML = '<option value="" disabled selected>Đang tải...</option>';
                if (!brand) return;

                fetch('${ctx}/get-products-by-brand?brand=' + encodeURIComponent(brand))
                    .then(response => response.json())
                    .then(data => {
                        let html = '<option value="" disabled selected>-- Chọn máy --</option>';
                        data.forEach(item => {
                            // Check if this was the previously selected model to keep it selected
                            const isSelected = item.name === '${modelName}' ? 'selected' : '';
                            html += '<option value="' + item.name + '" ' + isSelected + '>' + item.name + '</option>';
                        });
                        modelSelect.innerHTML = html;
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        modelSelect.innerHTML = '<option value="" disabled selected>Lỗi tải dữ liệu</option>';
                    });
            }

            window.addEventListener('load', () => {
                const brandSelect = document.getElementById('brandSelect');
                if (brandSelect.value) {
                    updateProductModels();
                }
            });
        </script>
        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
