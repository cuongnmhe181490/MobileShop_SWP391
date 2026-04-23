<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <%-- Additional core stylesheets for Header/Footer consistency --%>
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="css/owl.carousel.min.css" type="text/css">
        <link rel="stylesheet" href="css/style.css" type="text/css">
        <link rel="stylesheet" href="css/mobileshop.css" type="text/css">
        <link rel="stylesheet" href="css/custom.css" type="text/css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        
        <style>
            /* Sync with Review Form Typography */
            body {
                background-color: var(--bg);
                font-family: 'Plus Jakarta Sans', sans-serif;
                color: var(--text);
                line-height: 1.7;
            }

            h1, h2, h3, h4, .section-eyebrow {
                font-family: 'Plus Jakarta Sans', sans-serif;
            }

            .contact-wrapper {
                max-width: 1200px;
                margin: 80px auto;
                padding: 0 40px;
            }

            .contact-header {
                margin-bottom: 64px;
                text-align: left;
            }

            .contact-header h1 {
                font-size: 42px;
                font-weight: 700;
                margin-bottom: 12px;
                color: #0f172a;
                letter-spacing: -0.04em;
                line-height: 1.2;
            }

            .contact-header p {
                font-size: 16px;
                color: #64748b;
                max-width: 600px;
                margin: 0;
                line-height: 1.6;
            }

            .section-eyebrow {
                font-size: 12px;
                font-weight: 800;
                color: var(--accent);
                text-transform: uppercase;
                letter-spacing: 0.1em;
                margin-bottom: 8px;
                display: block;
            }

            /* Info Cards Grid */
            .info-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 24px;
                margin-bottom: 64px;
            }

            .info-card {
                background: #ffffff;
                padding: 32px;
                border-radius: 32px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.03);
                transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
                border: 1px solid var(--line);
                display: flex;
                flex-direction: column;
                min-height: 160px;
            }

            .info-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 30px 60px rgba(18, 32, 74, 0.08);
                border-color: var(--accent);
            }

            .info-card__label {
                font-size: 11px;
                font-weight: 800;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.12em;
                margin-bottom: 16px;
                display: block;
            }

            .info-card__value {
                font-size: 18px;
                font-weight: 700;
                line-height: 1.5;
                color: var(--text);
                overflow-wrap: break-word;
            }

            /* Form Section */
            .form-section {
                background: #ffffff;
                padding: 56px;
                border-radius: 40px;
                box-shadow: 0 30px 80px rgba(18, 32, 74, 0.05);
                border: 1px solid var(--line);
            }

            .form-section h2 {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 40px;
                letter-spacing: -0.04em;
                text-align: left;
                color: #0f172a;
            }

            .input-field {
                width: 100%;
                padding: 16px 20px;
                background: #f8fafc;
                border: 1px solid var(--line);
                border-radius: 18px;
                font-size: 15px;
                outline: none;
                transition: all 0.3s;
                color: var(--text);
                margin-top: 10px;
                font-family: inherit;
            }

            .input-field:focus {
                border-color: var(--accent);
                background: #fff;
                box-shadow: 0 0 0 4px var(--accent-soft);
            }

            .input-label {
                font-size: 12px;
                font-weight: 800;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
                display: block;
            }

            .required-mark {
                color: #ef4444;
                margin-left: 2px;
                font-size: 14px;
            }

            textarea.input-field {
                height: 180px;
                resize: none;
            }

            .btn-submit {
                background: var(--accent);
                color: white;
                padding: 14px 36px;
                border-radius: 999px;
                font-weight: 700;
                font-size: 14px;
                border: none;
                cursor: pointer;
                transition: all 0.3s;
                float: right;
            }

            .btn-submit:hover {
                background: var(--brand);
                box-shadow: 0 10px 20px rgba(61, 115, 234, 0.2);
                transform: translateY(-2px);
            }

            /* Error markers */
            .error-text {
                color: #ef4444;
                font-size: 12px;
                font-weight: 600;
                margin-top: 4px;
                display: none;
                animation: fadeIn 0.2s ease;
            }
            @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
            .input-field.is-invalid { border-color: #ef4444; background: #fff1f2; }

            /* Service Review Section */
            .service-review-cta {
                margin-top: 40px;
                padding: 32px;
                background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
                border-radius: 24px;
                color: white;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 24px;
            }
            .service-review-cta h3 { margin: 0; font-size: 20px; font-weight: 700; }
            .service-review-cta p { margin: 8px 0 0; font-size: 14px; opacity: 0.8; }
            .btn-review {
                background: #9fcdff;
                color: #0f172a;
                padding: 12px 28px;
                border-radius: 999px;
                font-weight: 800;
                font-size: 14px;
                text-decoration: none;
                transition: 0.3s;
                white-space: nowrap;
            }
            .btn-review:hover { transform: scale(1.05); box-shadow: 0 0 20px rgba(175, 242, 47, 0.3);}

            .alert-success {
                padding: 16px;
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
                border-radius: 12px;
                margin-bottom: 24px;
                font-weight: 600;
            }

            .clearfix::after {
                content: "";
                clear: both;
                display: table;
            }

            /* ─── Login Modal ─── */
            .login-modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.5);
                backdrop-filter: blur(4px);
                z-index: 1000;
                align-items: center;
                justify-content: center;
            }
            .login-modal-overlay.active {
                display: flex;
            }
            .login-modal {
                background: #ffffff;
                border-radius: 24px;
                padding: 40px 36px;
                max-width: 380px;
                width: 90%;
                text-align: center;
                position: relative;
                box-shadow: 0 25px 60px rgba(0,0,0,0.15);
                animation: modalIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            }
            @keyframes modalIn {
                from { opacity: 0; transform: scale(0.92) translateY(16px); }
                to   { opacity: 1; transform: scale(1)    translateY(0);     }
            }
            .login-modal__close {
                position: absolute;
                top: 16px; right: 20px;
                background: none;
                border: none;
                font-size: 22px;
                color: #94a3b8;
                cursor: pointer;
                line-height: 1;
                padding: 4px;
                border-radius: 6px;
                transition: color 0.2s, background 0.2s;
            }
            .login-modal__close:hover {
                color: #0f172a;
                background: #f1f5f9;
            }
            .login-modal__icon {
                font-size: 48px;
                margin-bottom: 16px;
                display: block;
            }
            .login-modal__title {
                font-size: 20px;
                font-weight: 800;
                color: #0f172a;
                margin: 0 0 10px;
            }
            .login-modal__desc {
                font-size: 14px;
                color: #64748b;
                line-height: 1.6;
                margin: 0 0 28px;
            }
            .login-modal__actions {
                display: flex;
                gap: 10px;
                justify-content: center;
            }
            .login-modal__btn-primary {
                padding: 12px 28px;
                border-radius: 999px;
                background: linear-gradient(135deg, #0284c7, #2563eb);
                color: #fff;
                font-size: 14px;
                font-weight: 700;
                text-decoration: none;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
            }
            .login-modal__btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
            }
            .login-modal__btn-secondary {
                padding: 12px 24px;
                border-radius: 999px;
                background: #f1f5f9;
                color: #475569;
                font-size: 14px;
                font-weight: 600;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .login-modal__btn-secondary:hover {
                background: #e2e8f0;
                color: #0f172a;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main>
            <div class="contact-wrapper">
                <div class="contact-header">
                    <span class="section-eyebrow">Kết nối</span>
                    <h1>Liên hệ</h1>
                    <p>Mọi thắc mắc của bạn sẽ được giải đáp trong vòng 24h. Vui lòng kết nối với chúng tôi qua các kênh bên dưới.</p>
                </div>

                <div class="info-grid">
                    <div class="info-card">
                        <span class="info-card__label">Điện thoại</span>
                        <div class="info-card__value">0385 842 752</div>
                    </div>
                    <div class="info-card">
                        <span class="info-card__label">Địa chỉ</span>
                        <div class="info-card__value">Khu Công Nghệ cao, Hoà lạc</div>
                    </div>
                    <div class="info-card">
                        <span class="info-card__label">Giờ mở cửa</span>
                        <div class="info-card__value">08:00 - 22:00</div>
                    </div>
                    <div class="info-card">
                        <span class="info-card__label">Email</span>
                        <div class="info-card__value">mobileshop@example.com</div>
                    </div>
                </div>

                <section class="form-section">
                    <h2>Gửi yêu cầu tư vấn</h2>

                    <c:if test="${param.success eq 'true'}">
                        <div class="alert-success">Cảm ơn bạn! Yêu cầu của bạn đã được gửi thành công.</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/contact" method="post" class="clearfix" id="contactForm">
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Họ và tên <span class="required-mark">*</span></label>
                                <input type="text" name="name" id="name" class="input-field" placeholder="Nhập tên của bạn">
                                <div id="err-name" class="error-text">Họ tên không được để trống.</div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Email <span class="required-mark">*</span></label>
                                <input type="email" name="email" id="email" class="input-field" placeholder="example@gmail.com">
                                <div id="err-email" class="error-text">Vui lòng nhập email hợp lệ.</div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Số điện thoại <span class="required-mark">*</span></label>
                                <input type="tel" name="phone" id="phone" class="input-field" placeholder="0xxx ...">
                                <div id="err-phone" class="error-text">Số điện thoại không đúng định dạng.</div>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="input-label">Nội dung <span class="required-mark">*</span></label>
                            <textarea name="message" id="message" class="input-field" placeholder="Bạn cần hỗ trợ điều gì?"></textarea>
                            <div id="err-message" class="error-text">Nội dung phải có ít nhất 10 ký tự.</div>
                        </div>
                        <button type="submit" class="btn-submit">Gửi liên hệ</button>
                    </form>
                </section>

                <div class="service-review-cta">
                    <div>
                        <h3 style="color : #fff3cd">Bạn thấy dịch vụ của chúng tôi thế nào?</h3>
                        <p  style="color : #fff8e6">Ý kiến của bạn giúp chúng tôi cải thiện chất lượng mỗi ngày.</p>
                    </div>
                    <c:choose>
                        <c:when test="${sessionScope.acc != null}">
                            <a href="${pageContext.request.contextPath}/review/write?type=SERVICE" class="btn-review">Đánh giá dịch vụ</a>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-review" onclick="openLoginModal()" style="border:none; cursor:pointer;">Đánh giá dịch vụ</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <script>
            const form = document.getElementById('contactForm');
            const inputs = {
                name: document.getElementById('name'),
                email: document.getElementById('email'),
                phone: document.getElementById('phone'),
                message: document.getElementById('message')
            };

            // Validation rules
            const validate = {
                name: (val) => val.trim().length > 0,
                email: (val) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val),
                phone: (val) => /^0[0-9]{9}$/.test(val.replace(/\s/g, '')),
                message: (val) => val.trim().length >= 10
            };

            function checkField(id) {
                const val = inputs[id].value;
                const isValid = validate[id](val);
                const errEl = document.getElementById('err-' + id);
                
                if (!isValid) {
                    inputs[id].classList.add('is-invalid');
                    errEl.style.display = 'block';
                } else {
                    inputs[id].classList.remove('is-invalid');
                    errEl.style.display = 'none';
                }
                return isValid;
            }

            // Real-time listeners
            Object.keys(inputs).forEach(id => {
                inputs[id].addEventListener('input', () => checkField(id));
                inputs[id].addEventListener('blur', () => checkField(id));
            });

            form.addEventListener('submit', (e) => {
                let isFormValid = true;
                Object.keys(inputs).forEach(id => {
                    if (!checkField(id)) {
                        isFormValid = false;
                        inputs[id].classList.add('is-invalid');
                        document.getElementById('err-' + id).style.display = 'block';
                    }
                });

                if (!isFormValid) {
                    e.preventDefault();
                }
            });

            // ── Login Modal ──
            function openLoginModal() {
                document.getElementById('loginModalOverlay').classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeLoginModal() {
                document.getElementById('loginModalOverlay').classList.remove('active');
                document.body.style.overflow = '';
            }

            // Close when clicking outside
            function handleOverlayClick(e) {
                if (e.target === document.getElementById('loginModalOverlay')) {
                    closeLoginModal();
                }
            }

            // Close when pressing Escape
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') closeLoginModal();
            });
        </script>
        <div class="login-modal-overlay" id="loginModalOverlay" onclick="handleOverlayClick(event)">
            <div class="login-modal">
                <button class="login-modal__close" onclick="closeLoginModal()">&#x2715;</button>
                <span class="login-modal__icon">⭐</span>
                <h3 class="login-modal__title">Vui lòng đăng nhập</h3>
                <p class="login-modal__desc">
                    Bạn cần đăng nhập để có thể thực hiện đánh giá dịch vụ này.
                </p>
                <div class="login-modal__actions">
                    <a class="login-modal__btn-primary"
                       href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/review/write?type=SERVICE">
                        Đăng nhập
                    </a>
                    <button class="login-modal__btn-secondary" onclick="closeLoginModal()">
                        Để sau
                    </button>
                </div>
            </div>
        </div>
    </body>
</html>
