<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
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
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

        <style>
            :root {
                --navy: #0E1D35;
                --navy2: #1B2B4B;
                --navy3: #243654;
                --blue: #3B6FE8;
                --blue-dark: #2C59C8;
                --blue-light: #EEF3FD;
                --page-bg: #F2F4F8;
                --white: #FFFFFF;
                --gray-50: #F8F9FC;
                --gray-100: #ECEEF4;
                --gray-200: #D8DCE8;
                --gray-300: #B8BECE;
                --gray-500: #6B7491;
                --gray-700: #374060;
                --text: #1A2340;
                --text2: #4A5370;
                --text3: #8A92A8;
                --green: #12B76A;
                --orange: #F59E0B;
                --red: #EF4444;
                --r-xs: 4px;
                --r-sm: 8px;
                --r-md: 12px;
                --r-lg: 16px;
                --r-xl: 20px;
                --r-2xl: 28px;
                --shadow-sm: 0 1px 3px rgba(14,29,53,.07), 0 1px 2px rgba(14,29,53,.04);
                --shadow-md: 0 4px 16px rgba(14,29,53,.09), 0 2px 4px rgba(14,29,53,.05);
                --shadow-lg: 0 12px 40px rgba(14,29,53,.12), 0 4px 8px rgba(14,29,53,.06);
                --font: 'Be Vietnam Pro', sans-serif;
            }

            *, *::before, *::after {
                box-sizing: border-box;
            }

            html, body, h1, h2, h3, h4, h5, h6, input, select, textarea, button, span, p, a, div {
                font-family: var(--font) !important;
            }

            body {
                background: var(--page-bg);
                color: var(--text);
                -webkit-font-smoothing: antialiased;
                font-size: 14px;
                line-height: 1.6;
            }

            .page-wrap {
                max-width: 1200px;
                margin: 0 auto;
                padding: 48px 40px 80px;
            }

            /* ── PAGE HEADING ── */
            .page-heading {
                margin-bottom: 36px;
            }
            .page-kicker {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .14em;
                color: var(--blue);
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .page-kicker::before {
                content: '';
                width: 22px;
                height: 2px;
                background: var(--blue);
                border-radius: 2px;
            }
            .page-heading h1 {
                font-size: 36px;
                font-weight: 800;
                color: var(--navy);
                letter-spacing: -.03em;
                line-height: 1.08;
                margin-bottom: 10px;
            }
            .page-heading p {
                font-size: 14.5px;
                color: var(--text2);
                max-width: 520px;
                line-height: 1.7;
            }

            /* ── INFO CARDS ROW ── */
            .info-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 14px;
                margin-bottom: 36px;
            }
            .info-card {
                background: var(--white);
                border: 1px solid var(--gray-100);
                border-radius: var(--r-xl);
                padding: 22px 22px 20px;
                box-shadow: var(--shadow-sm);
                transition: .2s;
                position: relative;
                overflow: hidden;
            }
            .info-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 3px;
                border-radius: var(--r-xl) var(--r-xl) 0 0;
                background: var(--blue);
                opacity: 0;
                transition: .2s;
            }
            .info-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-2px);
            }
            .info-card:hover::before {
                opacity: 1;
            }
            .ic-icon {
                width: 40px;
                height: 40px;
                border-radius: var(--r-md);
                background: var(--blue-light);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 14px;
            }
            .ic-icon svg, .ic-icon i {
                width: 18px;
                height: 18px;
                color: var(--blue);
                font-size: 18px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .ic-label {
                font-size: 10.5px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .1em;
                color: var(--gray-500);
                margin-bottom: 5px;
            }
            .ic-value {
                font-size: 15px;
                font-weight: 700;
                color: var(--navy);
                line-height: 1.3;
            }
            .ic-value.sm {
                font-size: 13.5px;
            }

            /* ── MAIN GRID ── */
            .main-grid {
                display: grid;
                grid-template-columns: 1fr 360px;
                gap: 24px;
                align-items: start;
            }

            /* ── FORM CARD ── */
            .form-card {
                background: var(--white);
                border: 1px solid var(--gray-100);
                border-radius: var(--r-2xl);
                box-shadow: var(--shadow-sm);
                overflow: hidden;
            }
            .form-card-head {
                padding: 28px 32px 24px;
                border-bottom: 1px solid var(--gray-100);
            }
            .form-card-head h2 {
                font-size: 20px;
                font-weight: 800;
                color: var(--navy);
                letter-spacing: -.02em;
                margin-bottom: 4px;
            }
            .form-card-head p {
                font-size: 13.5px;
                color: var(--text2);
                line-height: 1.6;
            }
            .form-body {
                padding: 28px 32px 32px;
            }
            .fg {
                display: flex;
                flex-direction: column;
                gap: 7px;
                margin-bottom: 16px;
            }
            .fl {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .1em;
                color: var(--gray-700);
            }
            .fl .req {
                color: var(--red);
                margin-left: 2px;
            }
            .fi {
                border: 1px solid var(--gray-200);
                border-radius: var(--r-md);
                padding: 11px 14px;
                font-family: var(--font);
                font-size: 13.5px;
                color: var(--text);
                outline: none;
                background: var(--gray-50);
                transition: .18s;
                width: 100%;
            }
            .fi:focus {
                border-color: var(--blue);
                background: var(--white);
                box-shadow: 0 0 0 3px rgba(59, 111, 232, .1);
            }
            .fi::placeholder {
                color: var(--gray-300);
            }
            textarea.fi {
                resize: none;
                min-height: 120px;
                line-height: 1.65;
            }

            .form-foot {
                margin-top: 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 16px;
            }
            .form-note {
                font-size: 12px;
                color: var(--text3);
                line-height: 1.5;
                max-width: 280px;
            }
            .btn-submit {
                background: var(--blue);
                color: var(--white);
                border: none;
                border-radius: var(--r-2xl);
                padding: 13px 28px;
                font-family: var(--font);
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: .18s;
                white-space: nowrap;
            }
            .btn-submit:hover {
                background: var(--blue-dark);
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(59, 111, 232, .35);
            }

            .select-custom-arrow {
                cursor: pointer;
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%236B7491' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 14px center;
                padding-right: 36px !important;
            }

            /* ── SIDE PANEL ── */
            .side-panel {
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            /* map card */
            .map-card {
                background: var(--navy2);
                border-radius: var(--r-2xl);
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }
            .map-placeholder {
                height: 180px;
                background: var(--navy3);
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow: hidden;
            }
            .map-grid {
                position: absolute;
                inset: 0;
                background-image: linear-gradient(rgba(255, 255, 255, .04) 1px, transparent 1px), linear-gradient(90deg, rgba(255, 255, 255, .04) 1px, transparent 1px);
                background-size: 28px 28px;
            }
            .map-pin {
                width: 44px;
                height: 44px;
                background: var(--blue);
                border-radius: 50% 50% 50% 0;
                transform: rotate(-45deg);
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 4px 16px rgba(59, 111, 232, .5);
                position: relative;
                z-index: 1;
            }
            .map-pin-inner {
                width: 16px;
                height: 16px;
                background: white;
                border-radius: 50%;
                transform: rotate(45deg);
            }
            .map-pin-ring {
                position: absolute;
                width: 64px;
                height: 64px;
                border: 2px solid rgba(59, 111, 232, .35);
                border-radius: 50%;
                animation: pulse 2s infinite;
            }
            @keyframes pulse {
                0% {
                    transform: scale(.8);
                    opacity: 1;
                }
                100% {
                    transform: scale(1.4);
                    opacity: 0;
                }
            }

            .map-info {
                padding: 20px 22px;
            }
            .map-info-row {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 8px 0;
                border-bottom: 1px solid rgba(255, 255, 255, .07);
            }
            .map-info-row:last-child {
                border: none;
            }
            .mrow-ic {
                width: 28px;
                height: 28px;
                border-radius: var(--r-sm);
                background: rgba(255, 255, 255, .07);
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }
            .mrow-ic i {
                font-size: 13px;
                color: rgba(255, 255, 255, .6);
            }
            .mrow-label {
                font-size: 10px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: .08em;
                color: rgba(255, 255, 255, .3);
                margin-bottom: 1px;
            }
            .mrow-val {
                font-size: 13px;
                font-weight: 600;
                color: rgba(255, 255, 255, .85);
            }

            /* quick actions card */
            .quick-card {
                background: var(--white);
                border: 1px solid var(--gray-100);
                border-radius: var(--r-2xl);
                padding: 22px;
                box-shadow: var(--shadow-sm);
            }
            .quick-title {
                font-size: 13px;
                font-weight: 700;
                color: var(--navy);
                margin-bottom: 14px;
                letter-spacing: -.01em;
            }
            .quick-actions {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .qa-link {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 14px;
                border-radius: var(--r-lg);
                border: 1.5px solid var(--gray-100);
                background: var(--gray-50);
                cursor: pointer;
                transition: .18s;
                text-align: left;
                width: 100%;
                text-decoration: none;
            }
            .qa-link:hover {
                border-color: var(--blue);
                background: var(--blue-light);
                transform: translateX(2px);
            }
            .qa-btn-ic {
                width: 34px;
                height: 34px;
                border-radius: var(--r-sm);
                background: var(--gray-100);
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
                transition: .18s;
            }
            .qa-btn-ic i {
                font-size: 15px;
                color: var(--navy2);
                transition: .18s;
            }
            .qa-link:hover .qa-btn-ic {
                background: var(--blue);
            }
            .qa-link:hover .qa-btn-ic i {
                color: white;
            }
            .qa-btn-text {
                flex: 1;
            }
            .qa-btn-title {
                font-size: 13px;
                font-weight: 700;
                color: var(--navy);
                margin-bottom: 1px;
            }
            .qa-btn-sub {
                font-size: 11.5px;
                color: var(--text3);
            }
            .qa-btn-arr {
                font-size: 16px;
                color: var(--gray-300);
                transition: .18s;
            }
            .qa-link:hover .qa-btn-arr {
                color: var(--blue);
            }

            /* hours card */
            .hours-card {
                background: var(--white);
                border: 1px solid var(--gray-100);
                border-radius: var(--r-2xl);
                padding: 22px;
                box-shadow: var(--shadow-sm);
            }
            .hours-title {
                font-size: 13px;
                font-weight: 700;
                color: var(--navy);
                margin-bottom: 14px;
            }
            .hours-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 0;
                border-bottom: 1px solid var(--gray-100);
                font-size: 13px;
            }
            .hours-row:last-child {
                border: none;
            }
            .hours-day {
                color: var(--text2);
                font-weight: 500;
            }
            .hours-time {
                font-weight: 700;
                color: var(--navy);
            }
            .hours-badge {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                font-size: 11px;
                font-weight: 700;
                padding: 3px 9px;
                border-radius: 999px;
                background: rgba(18, 183, 106, .12);
                color: var(--green);
            }
            .hours-badge::before {
                content: '';
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background: var(--green);
            }

            /* ── CTA BANNER ── */
            .cta-banner {
                background: var(--navy);
                border-radius: var(--r-2xl);
                padding: 28px 36px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 24px;
                margin-top: 24px;
                position: relative;
                overflow: hidden;
            }
            .cta-banner::before {
                content: '';
                position: absolute;
                right: -40px;
                top: -40px;
                width: 200px;
                height: 200px;
                border-radius: 50%;
                background: rgba(59, 111, 232, .18);
            }
            .cta-banner::after {
                content: '';
                position: absolute;
                right: 40px;
                bottom: -60px;
                width: 140px;
                height: 140px;
                border-radius: 50%;
                background: rgba(59, 111, 232, .1);
            }
            .cta-left {
                position: relative;
                z-index: 1;
            }
            .cta-left h3 {
                font-size: 18px;
                font-weight: 800;
                color: var(--white);
                letter-spacing: -.02em;
                margin-bottom: 5px;
            }
            .cta-left p {
                font-size: 13px;
                color: rgba(255, 255, 255, .5);
                line-height: 1.6;
            }
            .cta-btns {
                display: flex;
                gap: 10px;
                position: relative;
                z-index: 1;
                flex-shrink: 0;
            }
            .btn-cta-white {
                background: var(--white);
                color: var(--navy);
                border: none;
                border-radius: var(--r-2xl);
                padding: 12px 22px;
                font-family: var(--font);
                font-size: 13.5px;
                font-weight: 700;
                cursor: pointer;
                transition: .15s;
                white-space: nowrap;
                text-decoration: none;
            }
            .btn-cta-white:hover {
                background: var(--white);
                color: var(--navy);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, .2);
            }
            .btn-cta-outline {
                background: transparent;
                color: var(--white);
                border: 1.5px solid rgba(255, 255, 255, .25);
                border-radius: var(--r-2xl);
                padding: 12px 22px;
                font-family: var(--font);
                font-size: 13.5px;
                font-weight: 600;
                cursor: pointer;
                transition: .15s;
                white-space: nowrap;
                text-decoration: none;
            }
            .btn-cta-outline:hover {
                border-color: rgba(255, 255, 255, .5);
                background: rgba(255, 255, 255, .06);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .main-grid {
                    grid-template-columns: 1fr;
                }
                .info-row {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media (max-width: 600px) {
                .info-row {
                    grid-template-columns: 1fr;
                }
                .cta-banner {
                    flex-direction: column;
                    align-items: flex-start;
                }
            }

            .alert-success {
                padding: 16px;
                background: #f0fdf4;
                color: #166534;
                border: 1px solid #bbf7d0;
                border-radius: 12px;
                margin-bottom: 24px;
                font-weight: 600;
            }

            .error-text {
                color: var(--red);
                font-size: 12px;
                font-weight: 600;
                margin-top: 4px;
                display: none;
            }
            .is-invalid {
                border-color: var(--red) !important;
                background: #fff1f2 !important;
            }

            /* Responsive */
            @media (max-width: 992px) {
                .contact-main {
                    grid-template-columns: 1fr;
                }
                .info-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media (max-width: 600px) {
                .info-grid {
                    grid-template-columns: 1fr;
                }
                .rb-actions {
                    flex-direction: column;
                }
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
                from {
                    opacity: 0;
                    transform: scale(0.92) translateY(16px);
                }
                to   {
                    opacity: 1;
                    transform: scale(1)    translateY(0);
                }
            }
            .login-modal__close {
                position: absolute;
                top: 16px;
                right: 20px;
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
            <div class="page-wrap">
                <div class="page-heading">
                    <div class="page-kicker">Kết nối</div>
                    <h1>Liên hệ</h1>
                </div>

                <div class="info-row">
                    <div class="info-card">
                        <div class="ic-icon"><i class="fa-solid fa-phone"></i></div>
                        <div class="ic-label">Điện thoại</div>
                        <div class="ic-value">0385 842 752</div>
                    </div>
                    <div class="info-card">
                        <div class="ic-icon"><i class="fa-solid fa-location-dot"></i></div>
                        <div class="ic-label">Địa chỉ</div>
                        <div class="ic-value">Khu CNC, Hoà Lạc, Hà Nội</div>
                    </div>
                    <div class="info-card">
                        <div class="ic-icon"><i class="fa-solid fa-clock"></i></div>
                        <div class="ic-label">Giờ mở cửa</div>
                        <div class="ic-value">08:00 – 22:00</div>
                    </div>
                    <div class="info-card">
                        <div class="ic-icon"><i class="fa-solid fa-envelope"></i></div>
                        <div class="ic-label">Email</div>
                        <div class="ic-value sm">mobileshop@example.com</div>
                    </div>
                </div>

                <div class="main-grid">
                    <%-- Left: Form --%>
                    <div>
                        <div class="form-card">
                            <div class="form-card-head">
                                <h2>Gửi yêu cầu tư vấn</h2>
                                <p>Điền thông tin bên dưới, đội ngũ của chúng tôi sẽ liên hệ lại trong vòng 24h.</p>
                            </div>

                            <div class="form-body">
                                <c:if test="${param.success eq 'true'}">
                                    <div class="alert-success">Cảm ơn bạn! Yêu cầu của bạn đã được gửi thành công.</div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/contact" method="post" id="contactForm">
                                    <div class="field-row">
                                        <div class="fg">
                                            <label class="fl">Họ và tên <span class="req">*</span></label>
                                            <input type="text" name="name" id="name" class="fi" placeholder="Nhập tên của bạn">
                                            <div id="err-name" class="error-text">Họ tên không được để trống.</div>
                                        </div>
                                        <div class="fg">
                                            <label class="fl">Email <span class="req">*</span></label>
                                            <input type="email" name="email" id="email" class="fi" placeholder="example@gmail.com">
                                            <div id="err-email" class="error-text">Vui lòng nhập email hợp lệ.</div>
                                        </div>
                                        <div class="fg">
                                            <label class="fl">Số điện thoại <span class="req">*</span></label>
                                            <input type="tel" name="phone" id="phone" class="fi" placeholder="0xxx...">
                                            <div id="err-phone" class="error-text">Số điện thoại không đúng định dạng.</div>
                                        </div>
                                    </div>

                                    <div class="fg">
                                        <label class="fl">Chủ đề</label>
                                        <select name="topic" id="topic" class="fi select-custom-arrow">
                                            <option value="" disabled selected>Chọn chủ đề hỗ trợ...</option>
                                            <option value="Tư vấn mua hàng">Tư vấn mua hàng</option>
                                            <option value="Thu cũ đổi mới">Thu cũ đổi mới</option>
                                            <option value="Bảo hành & sửa chữa">Bảo hành & sửa chữa</option>
                                            <option value="Đơn hàng & vận chuyển">Đơn hàng & vận chuyển</option>
                                            <option value="Khác">Khác</option>
                                        </select>
                                    </div>

                                    <div class="fg" style="margin-bottom:0">
                                        <label class="fl">Nội dung <span class="req">*</span></label>
                                        <textarea name="message" id="message" class="fi" placeholder="Bạn cần hỗ trợ điều gì? Mô tả chi tiết để chúng tôi hỗ trợ nhanh hơn..." style="height: 160px;"></textarea>
                                        <div id="err-message" class="error-text">Nội dung phải có ít nhất 10 ký tự.</div>
                                    </div>

                                    <div class="form-foot">
                                        <p class="form-note">Chúng tôi sẽ liên hệ lại trong vòng <strong>24 giờ</strong> làm việc. Thông tin của bạn được bảo mật hoàn toàn.</p>
                                        <button type="submit" class="btn-submit">
                                            Gửi liên hệ
                                            <i class="fa-solid fa-paper-plane"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <%-- CTA Banner --%>
                        <div class="cta-banner">
                            <div class="cta-left">
                                <h3>Bạn thấy dịch vụ của chúng tôi thế nào?</h3>
                                <p>Ý kiến của bạn giúp chúng tôi cải thiện chất lượng dịch vụ mỗi ngày.</p>
                            </div>
                            <div class="cta-btns">
                                <c:choose>
                                    <c:when test="${sessionScope.acc != null}">
                                        <a href="${ctx}/review/write?type=SERVICE" class="btn-cta-white">Đánh giá dịch vụ</a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-cta-white" onclick="openLoginModal()" style="border:none; cursor:pointer;">Đánh giá dịch vụ</button>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${ctx}/reviews?type=SERVICE" class="btn-cta-outline">Xem đánh giá</a>
                            </div>
                        </div>
                    </div>

                    <%-- Right: Side Panel --%>
                    <div class="side-panel">
                        <div class="map-card">
                            <div class="map-placeholder" style="padding:0; display:block;">
                                <iframe
                                    src="https://maps.google.com/maps?q=21.007859,105.540790&z=16&output=embed&hl=vi"
                                    width="100%"
                                    height="180"
                                    style="border:0; display:block; width:100%; height:180px;"
                                    allowfullscreen=""
                                    loading="lazy"
                                    referrerpolicy="no-referrer-when-downgrade">
                                </iframe>
                            </div>
                            <div class="map-info">
                                <div class="map-info-row">
                                    <div class="mrow-ic"><i class="fa-solid fa-location-dot"></i></div>
                                    <div>
                                        <div class="mrow-label">Địa chỉ</div>
                                        <div class="mrow-val">Khu CNC, Hoà Lạc, TP.Hà Nội</div>
                                    </div>
                                </div>
                                <div class="map-info-row">
                                    <div class="mrow-ic"><i class="fa-solid fa-phone"></i></div>
                                    <div>
                                        <div class="mrow-label">Hotline</div>
                                        <div class="mrow-val">0385 842 752</div>
                                    </div>
                                </div>
                                <div class="map-info-row">
                                    <div class="mrow-ic"><i class="fa-solid fa-clock"></i></div>
                                    <div>
                                        <div class="mrow-label">Giờ mở cửa</div>
                                        <div class="mrow-val">08:00 – 22:00 hàng ngày</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="quick-card">
                            <div class="quick-title">Liên hệ nhanh</div>
                            <div class="quick-actions">
                                <a href="tel:0385842752" class="qa-link">
                                    <div class="qa-btn-ic"><i class="fa-solid fa-phone-volume"></i></div>
                                    <div class="qa-btn-text">
                                        <div class="qa-btn-title">Gọi ngay</div>
                                        <div class="qa-btn-sub">0385 842 752</div>
                                    </div>
                                    <span class="qa-btn-arr">›</span>
                                </a>
                                <a href="mailto:mobileshop@example.com" class="qa-link">
                                    <div class="qa-btn-ic"><i class="fa-solid fa-envelope-open-text"></i></div>
                                    <div class="qa-btn-text">
                                        <div class="qa-btn-title">Gửi email</div>
                                        <div class="qa-btn-sub">mobileshop@example.com</div>
                                    </div>
                                    <span class="qa-btn-arr">›</span>
                                </a>

                            </div>
                        </div>
                    </div>
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
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape')
                    closeLoginModal();
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