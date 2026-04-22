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
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
        
        <style>
            /* Reset body to match global store style but use the requested Jakarta font */
            body {
                background-color: var(--bg);
                font-family: 'Plus Jakarta Sans', "Be Vietnam Pro", sans-serif;
                color: var(--text);
                line-height: 1.6;
            }

            .contact-wrapper {
                max-width: 1100px;
                margin: 60px auto;
                padding: 0 15px;
            }

            .contact-header {
                margin-bottom: 48px;
            }

            .contact-header h1 {
                font-size: 36px;
                font-weight: 800;
                margin-bottom: 12px;
                color: var(--text);
                letter-spacing: -0.04em;
            }

            .contact-header p {
                font-size: 16px;
                color: var(--muted);
                max-width: 600px;
            }

            /* Info Cards Grid */
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 20px;
                margin-bottom: 48px;
            }

            .info-card {
                background: #ffffff;
                padding: 24px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid var(--line);
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                min-height: 140px;
            }

            .info-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow);
                border-color: var(--accent);
            }

            .info-card__label {
                font-size: 12px;
                font-weight: 700;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 12px;
                display: block;
            }

            .info-card__value {
                font-size: 17px;
                font-weight: 700;
                line-height: 1.4;
                color: var(--text);
                /* Fix for long text (e.g. emails) jumping out of box */
                overflow-wrap: break-word;
                word-wrap: break-word;
                word-break: break-word;
            }

            /* Form Section */
            .form-section {
                background: #ffffff;
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.03);
                border: 1px solid var(--line);
            }

            .form-section h2 {
                font-size: 24px;
                font-weight: 800;
                margin-bottom: 32px;
                letter-spacing: -0.03em;
            }

            .input-field {
                width: 100%;
                padding: 14px 18px;
                background: #fcfdfe;
                border: 1px solid var(--line);
                border-radius: 14px;
                font-size: 14px;
                outline: none;
                transition: all 0.2s;
                color: var(--text);
                margin-top: 8px;
            }

            .input-field:focus {
                border-color: var(--accent);
                background: #fff;
                box-shadow: 0 0 0 4px var(--accent-soft);
            }

            .input-label {
                font-size: 13px;
                font-weight: 700;
                color: var(--muted);
                display: block;
            }

            textarea.input-field {
                height: 140px;
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

            /* Responsive tweaks */
            @media (max-width: 992px) {
                .info-grid { grid-template-columns: repeat(2, 1fr); }
            }
            @media (max-width: 576px) {
                .info-grid { grid-template-columns: 1fr; }
                .form-section { padding: 24px; }
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main>
            <div class="contact-wrapper">
                <div class="contact-header">
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
                                <label class="input-label">Họ và tên</label>
                                <input type="text" name="name" id="name" class="input-field" placeholder="Nhập tên của bạn">
                                <div id="err-name" class="error-text">Họ tên không được để trống.</div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Email</label>
                                <input type="email" name="email" id="email" class="input-field" placeholder="example@gmail.com">
                                <div id="err-email" class="error-text">Vui lòng nhập email hợp lệ.</div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Số điện thoại</label>
                                <input type="tel" name="phone" id="phone" class="input-field" placeholder="0xxx ...">
                                <div id="err-phone" class="error-text">Số điện thoại không đúng định dạng.</div>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="input-label">Nội dung</label>
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
                    <a href="${pageContext.request.contextPath}/review/write?type=SERVICE" class="btn-review">Đánh giá dịch vụ</a>
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
                    // Shake effect or scroll to first error?
                }
            });
        </script>
    </body>
</html>
