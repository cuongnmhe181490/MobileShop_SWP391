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
                    <form action="${pageContext.request.contextPath}/contact" method="post" class="clearfix">
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Họ và tên</label>
                                <input type="text" name="name" class="input-field" placeholder="Nhập tên của bạn">
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Email</label>
                                <input type="email" name="email" class="input-field" placeholder="example@gmail.com">
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="input-label">Số điện thoại</label>
                                <input type="tel" name="phone" class="input-field" placeholder="0xxx ...">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="input-label">Nội dung</label>
                            <textarea name="message" class="input-field" placeholder="Bạn cần hỗ trợ điều gì?"></textarea>
                        </div>
                        <button type="submit" class="btn-submit">Gửi liên hệ</button>
                    </form>
                </section>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
    </body>
</html>
