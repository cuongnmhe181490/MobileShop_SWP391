<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isEdit" value="${mode eq 'edit'}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/style.css" type="text/css">
        <link rel="stylesheet" href="${ctx}/css/custom.css" type="text/css">
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        
        <style>
            :root {
                --brand: #3B6FE8;
                --brand-soft: #EEF3FD;
                --bg: #F8F9FC;
                --white: #FFFFFF;
                --text-main: #0E1D35;
                --text-muted: #6B7491;
                --text-light: #8A92A8;
                --border: #D8DCE8; /* Darker border for better visibility */
                --shadow-sm: 0 2px 8px rgba(14,29,53,.04);
                --shadow-md: 0 8px 30px rgba(14,29,53,.08);
                --r-lg: 16px;
                --r-xl: 24px;
            }

            body {
                background: #F2F4F8; /* Refined slightly darker background */
                font-family: 'Be Vietnam Pro', 'Plus Jakarta Sans', sans-serif;
                color: var(--text-main);
                -webkit-font-smoothing: antialiased;
            }

            .rv-page {
                padding: 60px 20px 100px;
            }

            .rv-shell {
                max-width: 800px;
                margin: 0 auto;
            }

            /* ── HEADER ── */
            .rv-header {
                text-align: center; /* Centered */
                margin-bottom: 48px;
            }
            .rv-badge {
                display: inline-block;
                background: var(--brand-soft);
                color: var(--brand);
                font-size: 11px;
                font-weight: 800;
                padding: 6px 14px;
                border-radius: 99px;
                margin-bottom: 16px;
                letter-spacing: 0.02em;
            }
            .rv-header h1 {
                font-family: 'Be Vietnam Pro', sans-serif !important;
                font-size: 36px;
                font-weight: 800;
                color: var(--text-main);
                margin-bottom: 12px;
                letter-spacing: -0.03em;
                line-height: 1.2;
            }
            .rv-header p {
                font-size: 16px;
                color: var(--text-muted);
                line-height: 1.6;
            }

            /* ── MAIN CARD WRAPPER ── */
            .main-card {
                background: var(--white);
                border-radius: 32px;
                padding: 48px;
                box-shadow: 0 20px 40px rgba(14, 29, 53, 0.06);
                border: 1px solid var(--border);
            }

            /* ── PRODUCT CARD ── */
            .product-card {
                background: #F8FAFC;
                border: 1px solid #E2E8F0;
                border-radius: 20px;
                padding: 32px;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 16px;
                margin-bottom: 40px;
            }
            .product-card img {
                width: 120px;
                height: 120px;
                object-fit: contain;
                border-radius: 12px;
            }
            .product-info h3 {
                font-size: 20px;
                font-weight: 800;
                color: var(--text-main);
                margin: 0;
            }
            .product-info .price {
                display: block;
                font-size: 18px;
                font-weight: 600;
                color: var(--brand);
                margin-top: 8px;
            }

            /* ── FORM SECTIONS ── */
            .rv-section {
                margin-bottom: 40px;
                padding-top: 32px;
                border-top: 1px solid var(--border);
            }
            .rv-section:first-of-type { border-top: none; padding-top: 0; }

            .rv-label {
                display: block;
                font-size: 11px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0.1em;
                color: var(--text-main);
                margin-bottom: 20px;
            }
            .rv-label .req { color: #EF4444; margin-left: 2px; }

            /* Star Picker */
            .star-row {
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .star-picker {
                display: flex;
                flex-direction: row-reverse;
                gap: 4px;
            }
            .star-picker input { display: none; }
            .star-picker label {
                font-size: 32px;
                color: #e5e7eb;
                cursor: pointer;
                transition: transform 0.2s;
            }
            .star-picker label:hover { transform: scale(1.1); }
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label {
                color: #e5e7eb; /* Default back slightly */
            }
            /* Actual Selected & Hover stars - following Figma grayish-blue or gold? 
               Figma shows light blue/gray empty stars, colored gold when active/hover */
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label {
                color: #DDE2F0; /* Selected/Hover base */
            }
            /* Let's use a cleaner star color logic */
            .star-picker label { color: #DDE2F0; }
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label {
                color: #DDE2F0; /* Keep it light */
            }
            /* Wait, user Figma shows gold-ish stars for rating? Let's check. 
               Correction: Standard star rating use gold #F59E0B / #FBBF24 */
            .star-picker label { color: #DDE2F0; }
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label { color: #DDE2F0; }
            /* Hover/Active logic */
            .star-picker input:checked ~ label { color: #DDE2F0; }
            /* Wait, I'll use SVGs or font Awesome for cleaner stars */

            .star-hint { font-size: 14px; color: var(--text-light); }

            /* Chips Selection (Highlights) */
            .highlight-grid {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                margin-top: 16px;
            }
            .chip-item {
                position: relative;
            }
            .chip-item input {
                position: absolute;
                opacity: 0;
                cursor: pointer;
            }
            .chip-item label {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 18px;
                background: var(--white);
                border: 1px solid var(--border);
                border-radius: 99px;
                font-size: 13.5px;
                font-weight: 600;
                color: var(--text-muted);
                cursor: pointer;
                transition: all 0.2s;
            }
            .chip-item label::before {
                content: '';
                width: 16px;
                height: 16px;
                border: 1px solid var(--border);
                border-radius: 50%;
                background: var(--white);
            }
            .chip-item input:checked + label {
                border-color: var(--brand);
                color: var(--text-main);
                background: var(--brand-soft);
            }
            .chip-item input:checked + label::before {
                border: 5px solid var(--brand);
            }

            /* Textarea */
            .ta-wrap { position: relative; }
            .rv-textarea {
                width: 100%;
                min-height: 140px;
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 16px;
                font-size: 14.5px;
                color: var(--text-main);
                background: #fbfbfc;
                outline: none;
                resize: none;
                transition: .2s;
            }
            .rv-textarea:focus {
                border-color: var(--brand);
                background: var(--white);
                box-shadow: 0 0 0 4px rgba(59, 111, 232, 0.08);
            }
            .ta-counter {
                position: absolute;
                bottom: -24px;
                right: 0;
                font-size: 12px;
                font-weight: 700;
                color: var(--text-light);
            }

            /* Upload Area */
            .upload-zone {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                gap: 12px;
                border: 1px dashed var(--border);
                border-radius: var(--r-lg);
                padding: 40px;
                background: #fbfbfc;
                cursor: pointer;
                transition: .2s;
            }
            .upload-zone:hover {
                border-color: var(--brand);
                background: var(--brand-soft);
            }
            .upload-icon-box {
                width: 48px;
                height: 48px;
                background: var(--brand-soft);
                color: var(--brand);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
            }
            .upload-zone p { font-weight: 700; font-size: 14px; margin: 0; }
            .upload-zone small { color: var(--text-light); font-size: 12px; }

            .preview-grid {
                display: flex;
                gap: 12px;
                margin-top: 16px;
            }
            .preview-add-btn {
                width: 80px;
                height: 80px;
                border: 1px dashed var(--border);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                color: var(--text-light);
                cursor: pointer;
            }

            /* Footer */
            .rv-footer {
                margin-top: 40px;
                padding: 24px 0;
                border-top: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .footer-note { font-size: 12px; color: var(--text-light); line-height: 1.5; max-width: 300px; }
            .footer-btns { display: flex; gap: 12px; }

            .btn-rv {
                padding: 12px 28px;
                border-radius: 99px;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                transition: .2s;
                border: none;
            }
            .btn-rv-cancel { background: var(--white); border: 1px solid var(--border); color: var(--text-main); }
            .btn-rv-cancel:hover { background: #f8fafc; }
            .btn-rv-submit {
                background: #AABCF2; /* Disabled state in Figma? */
                color: white;
            }
            .btn-rv-submit.ready {
                background: var(--brand);
                box-shadow: 0 4px 14px rgba(59, 111, 232, 0.3);
            }
            .btn-rv-submit:hover.ready {
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(59, 111, 232, 0.4);
            }

            /* Overrides for star color */
            .star-picker label { color: #E5E7EB; font-size: 38px; }
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label {
                color: #FBBF24 !important; /* Golden Yellow */
            }
            
            .field-error { color: #EF4444; font-size: 12px; margin-top: 8px; display: none; }
            .field-error.show { display: block; }
        </style>        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <div class="rv-page">
            <div class="rv-shell">
                <div class="rv-header">
                    <span class="rv-badge">${type eq 'SERVICE' ? 'Đánh giá dịch vụ' : 'Đánh giá sản phẩm'}</span>
                    <c:choose>
                        <c:when test="${type eq 'SERVICE'}">
                            <h1>Viết đánh giá dịch vụ</h1>
                            <p>Chia sẻ cảm nhận sau khi sử dụng dịch vụ của chúng tôi để giúp người dùng sau đưa ra quyết định tốt hơn.</p>
                        </c:when>
                        <c:otherwise>
                            <h1>${isEdit ? 'Chỉnh sửa đánh giá' : 'Viết đánh giá sản phẩm'}</h1>
                            <p>Chia sẻ cảm nhận về sản phẩm bạn đã mua để giúp người mua sau đưa ra quyết định tốt hơn.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="fileAlert" class="rv-alert"></div>

                <div class="main-card">
                    <form id="reviewForm" method="post" action="${ctx}/review/write" enctype="multipart/form-data">
                    <input type="hidden" name="mode" value="${mode}"/>
                    <input type="hidden" name="type" value="${type}"/>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="reviewId" value="${review.reviewId}"/>
                    </c:if>
                    <c:if test="${not isEdit && type eq 'PRODUCT'}">
                        <input type="hidden" name="pid" value="${pid}"/>
                    </c:if>

                    <%-- 1. Product Card --%>
                    <c:if test="${type eq 'PRODUCT'}">
                        <div class="product-card">
                            <img src="${productImage != null ? productImage : 'https://res.cloudinary.com/dovcx8lxl/image/upload/v1713581000/placeholder.png'}" 
                                 alt="product" onerror="this.src='https://res.cloudinary.com/dovcx8lxl/image/upload/v1713581000/placeholder.png'"/>
                            <div class="product-info">
                                <h3>${productName != null ? productName : 'Sản phẩm MobileShop'}</h3>
                                <span class="price"><fmt:formatNumber value="${productPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${type eq 'SERVICE'}">
                        <div class="product-card" style="background:#f1f5f9; border-color:#e2e8f0;">
                            <div style="width: 64px; height: 64px; background: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: var(--brand);">
                                <i class="fa-solid fa-shop"></i>
                            </div>
                            <div class="product-info">
                                <h3 style="font-family: 'Be Vietnam Pro', sans-serif !important; font-weight: 800;">Trải nghiệm dịch vụ MobileShop</h3>
                                <p style="font-size: 13px; color: var(--text-muted); margin: 0;">Mua sắm & Chăm sóc khách hàng</p>
                            </div>
                        </div>
                    </c:if>

                    <%-- 2. Star Rating --%>
                    <div class="rv-section">
                        <label class="rv-label">ĐÁNH GIÁ CHẤT LƯỢNG SẢN PHẨM <span class="req">*</span></label>
                        <div class="star-row">
                            <div class="star-picker">
                                <c:forEach begin="1" end="5" var="s">
                                    <c:set var="val" value="${6 - s}"/>
                                    <input type="radio" name="ranking" id="star${val}" value="${val}"
                                           ${(isEdit && review.ranking == val) ? 'checked' : ''} required/>
                                    <label for="star${val}">★</label>
                                </c:forEach>
                            </div>
                            <span class="star-hint">Chọn số sao</span>
                        </div>
                    </div>

                    <%-- 3. Highlights (Chips) --%>
                    <div class="rv-section">
                        <label class="rv-label">ĐIỂM NỔI BẬT <span class="req">*</span></label>
                        <p style="font-size: 13px; color: var(--text-light); margin-bottom: 20px;">Chọn các điểm bạn muốn chia sẻ về sản phẩm</p>
                        <div class="highlight-grid">
                            <c:choose>
                                <c:when test="${type eq 'PRODUCT'}">
                                    <c:set var="items" value="Thiết kế & ngoại hình, Hiệu năng & tốc độ, Camera & chụp ảnh, Pin & sạc, Màn hình, Chất lượng âm thanh, Độ bền, Giá cả" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="items" value="Giao hàng, Tư vấn và chăm sóc, Bảo hành, Trải nghiệm Web, Giá cả dịch vụ, Khác" />
                                </c:otherwise>
                            </c:choose>
                            <c:forEach var="item" items="${items.split(', ')}">
                                <div class="chip-item">
                                    <input type="checkbox" name="topics" id="chip_${item}" value="${item}" 
                                           ${(isEdit && review.reviewTopic.contains(item)) ? 'checked' : ''}>
                                    <label for="chip_${item}">${item}</label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="field-error" id="err-topics">Vui lòng chọn ít nhất một khía cạnh.</div>
                    </div>

                    <%-- 4. Content --%>
                    <div class="rv-section">
                        <label class="rv-label">NỘI DUNG ĐÁNH GIÁ <span class="req">*</span></label>
                        <div class="ta-wrap">
                            <textarea id="reviewContent" name="reviewContent" class="rv-textarea"
                                      placeholder="Mô tả chi tiết trải nghiệm sử dụng sản phẩm của bạn (tối thiểu 20 ký tự)..."
                                      maxlength="2000" oninput="onContentInput(this)">${isEdit ? review.reviewContent : ''}</textarea>
                            <div class="ta-counter" id="charCounter">0 / 2000</div>
                        </div>
                        <div class="field-error" id="err-content">Nội dung đánh giá quá ngắn (tối thiểu 20 ký tự).</div>
                    </div>

                    <%-- 5. Upload --%>
                    <div class="rv-section">
                        <label class="rv-label">HÌNH ẢNH THỰC TẾ <span style="font-weight: 500; font-size: 11px; text-transform: none; color: var(--text-light); margin-left: 4px;">(tối đa 5 ảnh)</span></label>
                        <div class="upload-zone" onclick="document.getElementById('fileInput').click()">
                            <div class="upload-icon-box">
                                <i class="fa-solid fa-cloud-arrow-up"></i>
                            </div>
                            <p>Nhấn để chọn ảnh</p>
                            <small>Bạn có thể chọn tối đa 5 ảnh · JPG, PNG, WEBP · <500KB mỗi ảnh</small>
                        </div>
                        
                        <input type="file" id="fileInput" name="imageFiles" 
                               accept="image/*" multiple style="display:none" 
                               onchange="handleSelection(this)"/>

                        <div class="preview-grid" id="previewList">
                            <c:if test="${isEdit}">
                                <c:forEach items="${images}" var="img">
                                    <div class="preview-item">
                                        <img src="${img.imageUrl}" alt="existing img"/>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>

                    <div class="rv-footer">
                        <div class="footer-note">
                            Đánh giá sẽ được kiểm duyệt và hiển thị trong vòng 24h.
                        </div>
                        <div class="footer-btns">
                            <button type="button" onclick="history.back()" class="btn-rv btn-rv-cancel">Huỷ bỏ</button>
                            <button type="button" onclick="validateAndSubmit()" class="btn-rv btn-rv-submit" id="submitBtn">Gửi đánh giá <i class="fa-solid fa-paper-plane" style="margin-left: 6px; font-size: 12px; opacity: 0.8;"></i></button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <script>
            /**
             * Logic cộng dồn file ảnh (Cumulative Upload)
             * Cho phép người dùng chọn ảnh nhiều lần cho đến khi đủ 5 ảnh.
             */
            const MAX_FILES = 5;
            const MAX_SIZE = 500 * 1024;
            
            // Đối tượng quản lý danh sách file thực sự sẽ gửi đi
            let dataTransfer = new DataTransfer();

            function handleSelection(input) {
                const list = document.getElementById('previewList');
                const alertEl = document.getElementById('fileAlert');
                alertEl.classList.remove('show');

                const newFiles = Array.from(input.files);
                
                newFiles.forEach(file => {
                    // Kiểm tra giới hạn số lượng
                    if (dataTransfer.items.length >= MAX_FILES) {
                        showAlert('Bạn đã chọn tối đa ' + MAX_FILES + ' ảnh.');
                        return;
                    }

                    // Kiểm tra dung lượng
                    if (file.size > MAX_SIZE) {
                        showAlert('Ảnh "' + file.name + '" quá lớn ( > 500KB).');
                        return;
                    }

                    // Thêm vào danh sách thực tế
                    dataTransfer.items.add(file);
                    
                    // Hiển thị preview
                    renderPreview(file, dataTransfer.items.length - 1);
                });

                // Cập nhật lại input.files để Form submit đúng các file này
                input.files = dataTransfer.files;
            }

            function renderPreview(file, index) {
                const list = document.getElementById('previewList');
                const reader = new FileReader();

                reader.onload = function(e) {
                    const div = document.createElement('div');
                    div.className = 'preview-item';
                    div.setAttribute('data-index', index);

                    // Dùng string concatenation thay template literal để tránh xung đột với JSP EL 
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'preview';
                    
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'btn-remove';
                    btn.title = 'Xóa ảnh';
                    btn.textContent = '×';
                    btn.onclick = function() { removeFile(index); };

                    div.appendChild(img);
                    div.appendChild(btn);
                    list.appendChild(div);
                };
                reader.readAsDataURL(file);
            }

            function removeFile(index) {
                const list = document.getElementById('previewList');
                const fileInput = document.getElementById('fileInput');
                
                // Tạo DataTransfer mới để lọc bỏ file bị xóa
                const newDataTransfer = new DataTransfer();
                
                for (let i = 0; i < dataTransfer.files.length; i++) {
                    if (i !== index) {
                        newDataTransfer.items.add(dataTransfer.files[i]);
                    }
                }
                
                // Cập nhật trạng thái
                dataTransfer = newDataTransfer;
                fileInput.files = dataTransfer.files;
                
                // Vẽ lại toàn bộ preview để đồng bộ index
                list.innerHTML = '';
                // Nếu là edit thì có thể có ảnh cũ (không nằm trong dataTransfer)
                // Tuy nhiên ở đây chúng ta chỉ quản lý các file MỚI đang được chọn
                Array.from(dataTransfer.files).forEach((file, idx) => {
                    renderPreview(file, idx);
                });
            }

            // ── Business Logic ──
            function updateFormState() {
                const btn = document.getElementById('submitBtn');
                const content = document.getElementById('reviewContent').value.trim();
                const star = document.querySelector('input[name="ranking"]:checked');
                
                if (content.length >= 20 && star) {
                    btn.classList.add('ready');
                } else {
                    btn.classList.remove('ready');
                }
            }

            // ── Char counter ──
            function onContentInput(el) {
                const len = el.value.length;
                const counter = document.getElementById('charCounter');
                counter.textContent = len + ' / 2000';
                
                if (len >= 20) {
                    el.classList.remove('error');
                    document.getElementById('err-content').classList.remove('show');
                }
                updateFormState();
            }

            // Init
            (function() {
                const ta = document.getElementById('reviewContent');
                if (ta) {
                    onContentInput(ta);
                    ta.addEventListener('blur', function() {
                        if (this.value.trim().length > 0 && this.value.trim().length < 20) {
                            document.getElementById('err-content').classList.add('show');
                        }
                    });
                }
                
                document.querySelectorAll('input[name="ranking"]').forEach(r => {
                    r.addEventListener('change', () => {
                        const err = document.getElementById('err-star');
                        if (err) err.classList.remove('show');
                        updateFormState();
                    });
                });
            })();

            function validateAndSubmit() {
                let isValid = true;

                const ratingChecked = document.querySelector('input[name="ranking"]:checked');
                if (!ratingChecked) {
                    let errStar = document.getElementById('err-star');
                    if (!errStar) {
                        errStar = document.createElement('div');
                        errStar.id = 'err-star';
                        errStar.className = 'field-error show';
                        errStar.style.marginTop = '12px';
                        errStar.innerHTML = 'Vui lòng chọn số sao đánh giá.';
                        document.querySelector('.star-row').insertAdjacentElement('afterend', errStar);
                    } else {
                        errStar.classList.add('show');
                    }
                    isValid = false;
                }

                const content = document.getElementById('reviewContent');
                if (!content.value || content.value.trim().length < 20) {
                    document.getElementById('err-content').classList.add('show');
                    if (isValid) content.focus();
                    isValid = false;
                }

                // Chi tiết cho Service
                if ("${type}" === "SERVICE") {
                    const checkedTopics = document.querySelectorAll('input[name="topics"]:checked');
                    if (checkedTopics.length === 0) {
                        document.getElementById('err-topics').classList.add('show');
                        isValid = false;
                    } else {
                        document.getElementById('err-topics').classList.remove('show');
                    }
                }

                if (!isValid) return;

                const btn = document.getElementById('submitBtn');
                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin" style="margin-right:8px"></i> Đang gửi...';
                document.getElementById('reviewForm').submit();
            }

            function showAlert(msg) {
                const el = document.getElementById('fileAlert');
                el.innerText = msg;
                el.classList.add('show');
                setTimeout(() => el.classList.remove('show'), 5000);
            }
        </script>
    </body>
</html>
