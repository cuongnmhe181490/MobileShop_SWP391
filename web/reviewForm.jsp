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
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        
        <style>
            :root {
                --rv-primary: #3d73ea;
                --rv-primary-soft: rgba(61, 115, 234, 0.08);
                --rv-bg: #f8fafc;
                --rv-card-bg: #ffffff;
                --rv-text-main: #0f172a;
                --rv-text-muted: #64748b;
                --rv-border: #e2e8f0;
                --rv-shadow: 0 20px 50px rgba(0, 0, 0, 0.04);
                --rv-radius: 24px;
            }

            body {
                background: var(--rv-bg);
                font-family: 'Plus Jakarta Sans', "Be Vietnam Pro", sans-serif;
                color: var(--rv-text-main);
            }

            .rv-page {
                padding: 60px 20px;
                min-height: 100vh;
            }

            .rv-shell {
                max-width: 680px;
                margin: 0 auto;
            }

            .rv-card {
                background: var(--rv-card-bg);
                border-radius: var(--rv-radius);
                padding: 40px;
                box-shadow: var(--rv-shadow);
                border: 1px solid var(--rv-border);
            }

            .rv-card h1 {
                font-size: 32px;
                font-weight: 700;
                color: #0f172a;
                letter-spacing: -0.04em;
                margin-bottom: 12px;
            }

            .rv-card p.subtitle {
                color: #64748b;
                font-size: 16px;
                line-height: 1.6;
                margin-bottom: 40px;
            }

            /* Product Strip */
            .rv-product-strip {
                display: flex;
                align-items: center;
                gap: 24px;
                background: #f8fafc;
                padding: 24px;
                border-radius: 20px;
                margin-bottom: 48px;
                border: 1px solid #e2e8f0;
            }

            .rv-product-strip img {
                width: 90px;
                height: 90px;
                border-radius: 16px;
                object-fit: contain;
                background: #fff;
                box-shadow: 0 8px 20px rgba(0,0,0,0.06);
                padding: 8px;
            }

            .rv-product-name {
                font-weight: 600;
                font-size: 20px;
                color: #1e293b;
                line-height: 1.4;
                letter-spacing: -0.01em;
            }

            /* Form Elements */
            .form-group {
                margin-bottom: 32px;
            }

            .form-label {
                display: block;
                font-size: 11px;
                font-weight: 800;
                color: #94a3b8;
                text-transform: uppercase;
                letter-spacing: 0.12em;
                margin-bottom: 16px;
            }

            .rv-textarea {
                width: 100%;
                border: 1px solid var(--rv-border);
                border-radius: 18px;
                padding: 16px;
                font-size: 15px;
                background: #fcfdfe;
                outline: none;
                transition: all 0.2s;
                min-height: 160px;
                color: var(--rv-text-main);
            }

            .rv-textarea:focus {
                border-color: var(--rv-primary);
                box-shadow: 0 0 0 4px var(--rv-primary-soft);
                background: #fff;
            }

            /* Star Picker */
            .star-picker {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end;
                gap: 8px;
            }
            .star-picker input { display: none; }
            .star-picker label {
                font-size: 40px;
                color: #e2e8f0;
                cursor: pointer;
                transition: all 0.2s;
            }
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label {
                color: #fbbf24;
            }

            /* Upload Area Manager */
            .upload-manager {
                background: #f8fafc;
                border: 2px dashed var(--rv-border);
                border-radius: 20px;
                padding: 32px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s;
            }

            .upload-manager:hover {
                background: var(--rv-primary-soft);
                border-color: var(--rv-primary);
            }

            .upload-icon {
                font-size: 32px;
                color: var(--rv-primary);
                margin-bottom: 12px;
                display: block;
            }

            .upload-manager p {
                font-weight: 700;
                margin-bottom: 4px;
            }

            .upload-manager small {
                color: var(--rv-text-muted);
                font-size: 12px;
            }

            /* Previews */
            .preview-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
                gap: 16px;
                margin-top: 24px;
            }

            .preview-item {
                position: relative;
                aspect-ratio: 1/1;
                border-radius: 12px;
                overflow: visible;
                border: 1px solid var(--rv-border);
                background: #fff;
            }

            .preview-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 12px;
                display: block;
            }

            .btn-remove {
                position: absolute;
                top: -8px;
                right: -8px;
                width: 24px;
                height: 24px;
                background: #ef4444;
                color: white;
                border: none;
                border-radius: 50%;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3);
                z-index: 10;
            }

            /* Actions */
            .footer-actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 40px;
            }

            .btn-f {
                padding: 14px 32px;
                border-radius: 999px;
                font-weight: 700;
                font-size: 14px;
                border: none;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-primary-f {
                background: var(--rv-primary);
                color: white;
                box-shadow: 0 10px 20px rgba(61, 115, 234, 0.2);
            }

            .btn-primary-f:hover {
                background: var(--brand);
                transform: translateY(-2px);
            }

            .btn-ghost-f {
                background: transparent;
                color: var(--rv-text-muted);
            }

            .btn-ghost-f:hover {
                background: #f1f5f9;
            }

            .rv-alert {
                background: #fff1f2;
                border: 1px solid #fecaca;
                color: #b91c1c;
                padding: 12px 16px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: 600;
                margin-bottom: 24px;
                display: none;
                animation: slideIn 0.3s ease-out;
            }
            @keyframes slideIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
            .rv-alert.show { display: block; }

            /* ─── Validation / Error states ─── */
            .field-error {
                color: #ef4444;
                font-size: 12px;
                font-weight: 600;
                margin-top: 8px;
                display: none;
                align-items: center;
                gap: 6px;
                animation: slideIn 0.2s ease-out;
            }
            .field-error.show { display: flex; }

            .rv-textarea.error,
            .star-picker.error label {
                /* Bắt lỗi border textarea */
            }
            .rv-textarea.error {
                border-color: #ef4444;
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12);
            }
            .star-picker.error label { color: #fca5a5; }

            .char-counter {
                font-size: 12px;
                color: var(--rv-text-muted);
                text-align: right;
                margin-top: 6px;
                transition: color 0.2s;
            }
            .char-counter.warn { color: #f59e0b; }
            .char-counter.ok   { color: #22c55e; }

            /* Topic Grid (Service mode) */
            .topic-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                gap: 12px;
                margin-top: 12px;
            }
            .topic-item {
                position: relative;
            }
            .topic-item input {
                position: absolute;
                opacity: 0;
                cursor: pointer;
            }
            .topic-item label {
                display: block;
                padding: 12px;
                background: #f8fafc;
                border: 1px solid var(--rv-border);
                border-radius: 12px;
                font-size: 13px;
                font-weight: 600;
                text-align: center;
                cursor: pointer;
                transition: all 0.2s;
            }
            .topic-item input:checked + label {
                background: var(--rv-primary-soft);
                border-color: var(--rv-primary);
                color: var(--rv-primary);
                box-shadow: 0 4px 12px rgba(61, 115, 234, 0.1);
            }
            .topic-item label:hover {
                background: #f1f5f9;
                border-color: var(--rv-text-muted);
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <div class="rv-page">
            <div class="rv-shell">
                <div class="rv-card">
                    <h1>${isEdit ? 'Chỉnh sửa đánh giá' : 'Viết đánh giá'}</h1>
                    <p class="subtitle">Chia sẻ cảm nhận của bạn để giúp cộng đồng mua sắm tốt hơn.</p>

                    <c:if test="${type eq 'PRODUCT'}">
                        <div class="rv-product-strip">
                            <img src="${productImage != null ? productImage : 'https://res.cloudinary.com/dovcx8lxl/image/upload/v1713581000/placeholder.png'}" 
                                 alt="product" onerror="this.src='https://res.cloudinary.com/dovcx8lxl/image/upload/v1713581000/placeholder.png'"/>
                            <div class="rv-product-name">${productName != null ? productName : 'Sản phẩm MobileShop'}</div>
                        </div>
                    </c:if>

                    <c:if test="${type eq 'SERVICE'}">
                        <div class="rv-product-strip" style="background:#f1f5f9; border-color:#e2e8f0;">
                            <div style="width: 80px; height: 80px; background: white; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 32px; color: var(--rv-primary);">
                                <i class="fa-solid fa-shop"></i>
                            </div>
                            <div>
                                <div class="rv-product-name" style="color: var(--rv-text-main);">Đánh giá dịch vụ MobileShop</div>
                                <div style="font-size:13px; color: var(--rv-text-muted);">Trải nghiệm mua sắm & chăm sóc khách hàng</div>
                            </div>
                        </div>
                    </c:if>

                    <div id="fileAlert" class="rv-alert"></div>

                    <form id="reviewForm" method="post" action="${ctx}/review/write" enctype="multipart/form-data">
                        <input type="hidden" name="mode" value="${mode}"/>
                        <input type="hidden" name="type" value="${type}"/>
                        <c:if test="${isEdit}">
                            <input type="hidden" name="reviewId" value="${review.reviewId}"/>
                        </c:if>
                        <c:if test="${not isEdit && type eq 'PRODUCT'}">
                            <input type="hidden" name="pid" value="${pid}"/>
                        </c:if>

                        <%-- Rating --%>
                        <div class="form-group">
                            <label class="form-label">${type eq 'SERVICE' ? 'Chất lượng trải nghiệm' : 'Chất lượng sản phẩm'}</label>
                            <div class="star-picker">
                                <c:forEach begin="1" end="5" var="s">
                                    <c:set var="val" value="${6 - s}"/>
                                    <input type="radio" name="ranking" id="star${val}" value="${val}"
                                           ${(isEdit && review.ranking == val) || (!isEdit && val == 5) ? 'checked' : ''} required/>
                                    <label for="star${val}">★</label>
                                </c:forEach>
                            </div>
                        </div>

                        <%-- Service Topics (Conditional) --%>
                        <c:if test="${type eq 'SERVICE'}">
                            <div class="form-group">
                                <label class="form-label">Chủ đề bạn quan tâm <span style="color:#ef4444">*</span></label>
                                <div style="font-size: 13px; color: var(--rv-text-muted); margin-bottom: 12px;">Bạn có thể chọn nhiều mục cùng lúc</div>
                                <div class="topic-grid">
                                    <c:set var="topics" value="Giao hàng, Tư vấn và chăm sóc, Bảo hành, Trải nghiệm Web, Khác" />
                                    <c:forEach var="topic" items="${topics.split(', ')}">
                                        <div class="topic-item">
                                            <input type="checkbox" name="topics" id="topic_${topic}" value="${topic}" 
                                                   ${(isEdit && review.reviewTopic.contains(topic)) ? 'checked' : ''}>
                                            <label for="topic_${topic}">${topic}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="field-error" id="err-topics">
                                    &#9888; Vui lòng chọn ít nhất một chủ đề.
                                </div>
                            </div>
                        </c:if>

                        <%-- Content --%>
                        <div class="form-group">
                            <label class="form-label">Nội dung đánh giá <span style="color:#ef4444">*</span></label>
                            <textarea id="reviewContent" name="reviewContent" class="rv-textarea"
                                      placeholder="Chia sẻ trải nghiệm của bạn (tối thiểu 20 ký tự)..."
                                      oninput="onContentInput(this)">${isEdit ? review.reviewContent : ''}</textarea>
                            <div class="char-counter" id="charCounter">0 / 2000</div>
                            <div class="field-error" id="err-content">
                                &#9888; Vui lòng nhập nội dung đánh giá (ít nhất 20 ký tự).
                            </div>
                        </div>

                        <%-- Multi Images - Cumulative Upload --%>
                        <div class="form-group">
                            <label class="form-label">Hình ảnh đính kèm (Tối đa 5)</label>
                            <div class="upload-manager" onclick="document.getElementById('fileInput').click()">
                                <i class="fa-solid fa-cloud-arrow-up upload-icon"></i>
                                <p>Nhấn để chọn ảnh</p>
                                <small>Bạn có thể chọn tối đa 5 ảnh &nbsp;·&nbsp; JPG, PNG, WEBP ( < 500KB )</small>
                            </div>
                            
                            <input type="file" id="fileInput" name="imageFiles" 
                                   accept="image/*" multiple style="display:none" 
                                   onchange="handleSelection(this)"/>

                            <div class="preview-grid" id="previewList">
                                <%-- Ảnh hiện tại nếu là Edit --%>
                                <c:if test="${isEdit}">
                                    <c:forEach items="${images}" var="img">
                                        <div class="preview-item">
                                            <img src="${img.imageUrl}" alt="existing img"/>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>

                        <div class="footer-actions">
                            <button type="button" onclick="history.back()" class="btn-f btn-ghost-f">Hủy bỏ</button>
                            <button type="button" onclick="validateAndSubmit()" class="btn-f btn-primary-f" id="submitBtn">Gửi đánh giá</button>
                        </div>
                    </form>
                </div>
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

            // ── Char counter ──
            function onContentInput(el) {
                const len = el.value.length;
                const counter = document.getElementById('charCounter');
                counter.textContent = len + ' / 2000';
                if (len >= 20) {
                    counter.className = 'char-counter ok';
                    el.classList.remove('error');
                    document.getElementById('err-content').classList.remove('show');
                } else if (len > 0) {
                    counter.className = 'char-counter warn';
                } else {
                    counter.className = 'char-counter';
                }
            }

            // Khởi tạo char counter nếu đang ở chế độ edit
            (function() {
                const ta = document.getElementById('reviewContent');
                if (ta && ta.value.length > 0) onContentInput(ta);
                
                // Real-time blur validation for content
                if (ta) ta.addEventListener('blur', function() {
                    if (this.value.trim().length > 0 && this.value.trim().length < 20) {
                        this.classList.add('error');
                        document.getElementById('err-content').classList.add('show');
                    }
                });
            })();

            // ── Validate toàn bộ form trước khi gửi ──
            function validateAndSubmit() {
                let isValid = true;

                // 1. Kiểm tra rating (star)
                const ratingChecked = document.querySelector('input[name="ranking"]:checked');
                const starPicker = document.querySelector('.star-picker');
                if (!ratingChecked) {
                    starPicker.classList.add('error');
                    // Tạo thông báo lỗi sao nếu chưa có
                    let errStar = document.getElementById('err-star');
                    if (!errStar) {
                        errStar = document.createElement('div');
                        errStar.id = 'err-star';
                        errStar.className = 'field-error show';
                        errStar.innerHTML = '&#9888; Vui lòng chọn số sao đánh giá.';
                        starPicker.insertAdjacentElement('afterend', errStar);
                    } else {
                        errStar.classList.add('show');
                    }
                    isValid = false;
                } else {
                    starPicker.classList.remove('error');
                    const errStar = document.getElementById('err-star');
                    if (errStar) errStar.classList.remove('show');
                }

                // 2. Kiểm tra nội dung
                const content = document.getElementById('reviewContent');
                const errContent = document.getElementById('err-content');
                if (!content.value || content.value.trim().length < 20) {
                    content.classList.add('error');
                    errContent.classList.add('show');
                    if (isValid) content.focus();
                    isValid = false;
                } else {
                    content.classList.remove('error');
                    errContent.classList.remove('show');
                }

                // 3. Kiểm tra topics (nếu là Service)
                if ("${type}" === "SERVICE") {
                    const checkedTopics = document.querySelectorAll('input[name="topics"]:checked');
                    const errTopics = document.getElementById('err-topics');
                    if (checkedTopics.length === 0) {
                        errTopics.classList.add('show');
                        isValid = false;
                    } else {
                        errTopics.classList.remove('show');
                    }
                }

                if (!isValid) return;

                // Tất cả hợp lệ → đổi nút thành loading rồi submit
                const btn = document.getElementById('submitBtn');
                btn.disabled = true;
                btn.textContent = 'Đang gửi...';
                document.getElementById('reviewForm').submit();
            }

            // Xóa lỗi sao khi người dùng click chọn sao
            document.querySelectorAll('input[name="ranking"]').forEach(function(radio) {
                radio.addEventListener('change', function() {
                    document.querySelector('.star-picker').classList.remove('error');
                    const errStar = document.getElementById('err-star');
                    if (errStar) errStar.classList.remove('show');
                });
            });

            // Lắng nghe thay đổi topics (Real-time)
            if ("${type}" === "SERVICE") {
                document.querySelectorAll('input[name="topics"]').forEach(function(cb) {
                    cb.addEventListener('change', function() {
                        const checkedTopics = document.querySelectorAll('input[name="topics"]:checked');
                        const errTopics = document.getElementById('err-topics');
                        if (checkedTopics.length > 0) {
                            errTopics.classList.remove('show');
                        } else {
                            errTopics.classList.add('show');
                        }
                    });
                });
            }

            function showAlert(msg) {
                const el = document.getElementById('fileAlert');
                el.innerText = msg;
                el.classList.add('show');
            }
        </script>
    </body>
</html>
