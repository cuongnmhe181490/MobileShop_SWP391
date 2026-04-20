<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isEdit" value="${mode eq 'edit'}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <style>
            .form-shell {
                max-width: 640px;
                margin: 0 auto;
                padding: 40px 20px;
            }
            .form-shell h1 {
                font-size: 22px;
                font-weight: 700;
                margin-bottom: 28px;
                color: var(--color-text-primary);
            }

            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: var(--color-text-secondary);
                margin-bottom: 6px;
            }
            .form-group textarea {
                width: 100%;
                padding: 12px;
                border-radius: 10px;
                font-size: 14px;
                border: 1px solid var(--color-border-secondary);
                resize: vertical;
                min-height: 120px;
                background: var(--color-background-secondary);
                color: var(--color-text-primary);
                font-family: inherit;
            }
            .form-group textarea:focus {
                outline: none;
                border-color: #0284c7;
            }

            /* Star picker */
            .star-picker {
                display: flex;
                gap: 6px;
                flex-direction: row-reverse;
                justify-content: flex-end;
            }
            .star-picker input {
                display: none;
            }
            .star-picker label {
                font-size: 36px;
                color: #d1d5db;
                cursor: pointer;
                transition: color .1s;
                line-height: 1;
            }
            .star-picker input:checked ~ label,
            .star-picker label:hover,
            .star-picker label:hover ~ label {
                color: #f59e0b;
            }

            /* Image upload */
            .img-upload-area {
                border: 2px dashed var(--color-border-secondary);
                border-radius: 12px;
                padding: 24px;
                text-align: center;
                cursor: pointer;
                transition: .15s;
            }
            .img-upload-area:hover {
                border-color: #0284c7;
            }
            .img-upload-area p {
                font-size: 13px;
                color: var(--color-text-secondary);
                margin: 0;
            }
            .img-preview-list {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-top: 12px;
            }
            .img-preview-item {
                position: relative;
            }
            .img-preview-item img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                display: block;
            }
            .img-preview-item .remove-img {
                position: absolute;
                top: -6px;
                right: -6px;
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #ef4444;
                color: #fff;
                border: none;
                font-size: 12px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                line-height: 1;
                font-weight: 700;
            }
            .upload-progress {
                font-size: 12px;
                color: #0284c7;
                margin-top: 6px;
                display: none;
            }

            /* Alert */
            .rv-alert {
                padding: 12px 16px;
                border-radius: 10px;
                font-size: 14px;
                margin-bottom: 20px;
            }
            .rv-alert--error {
                background: #fef2f2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* Buttons */
            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 28px;
            }
            .btn-submit {
                padding: 10px 28px;
                border-radius: 999px;
                background: #0284c7;
                color: #fff;
                font-size: 14px;
                font-weight: 600;
                border: none;
                cursor: pointer;
            }
            .btn-submit:hover {
                background: #0369a1;
            }
            .btn-submit:disabled {
                opacity: .6;
                cursor: not-allowed;
            }
            .btn-cancel {
                padding: 10px 20px;
                border-radius: 999px;
                border: 1px solid var(--color-border-secondary);
                color: var(--color-text-secondary);
                font-size: 14px;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main>
            <div class="form-shell">
                <h1>${isEdit ? 'Chỉnh sửa đánh giá' : 'Viết đánh giá'}</h1>

                <c:if test="${not empty errorMsg}">
                    <div class="rv-alert rv-alert--error">${errorMsg}</div>
                </c:if>

                <form id="reviewForm" method="post" action="${ctx}/review/write">
                    <input type="hidden" name="mode"     value="${mode}"/>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="reviewId" value="${review.reviewId}"/>
                    </c:if>
                    <c:if test="${not isEdit}">
                        <input type="hidden" name="pid" value="${pid}"/>
                    </c:if>

                    <%-- Chọn sao --%>
                    <div class="form-group">
                        <label>Đánh giá của bạn *</label>
                        <div class="star-picker">
                            <c:forEach begin="1" end="5" var="s" varStatus="st">
                                <c:set var="val" value="${6 - s}"/>
                                <input type="radio" name="ranking" id="star${val}" value="${val}"
                                       ${(isEdit && review.ranking == val) || (!isEdit && val == 5) ? 'checked' : ''} required/>
                                <label for="star${val}">★</label>
                            </c:forEach>
                        </div>
                    </div>

                    <%-- Nội dung --%>
                    <div class="form-group">
                        <label for="reviewContent">Nội dung đánh giá *</label>
                        <textarea id="reviewContent" name="reviewContent"
                                  placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."
                                  required maxlength="2000"><c:if test="${isEdit}">${review.reviewContent}</c:if></textarea>
                        </div>

                    <%-- Upload ảnh (Cloudinary) --%>
                    <div class="form-group">
                        <label>Ảnh đính kèm (tối đa 5 ảnh)</label>
                        <div class="img-upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                            <p>Nhấn để chọn ảnh &nbsp;·&nbsp; JPG, PNG, WEBP &nbsp;·&nbsp; Tối đa 5MB / ảnh</p>
                        </div>
                        <input type="file" id="fileInput" accept="image/*" multiple style="display:none"
                               onchange="handleFiles(this.files)"/>
                        <div class="upload-progress" id="uploadProgress">Đang tải ảnh lên...</div>
                        <div class="img-preview-list" id="previewList">
                            <%-- Hiển thị ảnh cũ khi ở chế độ sửa --%>
                            <c:if test="${isEdit}">
                                <c:forEach items="${images}" var="img" varStatus="st">
                                    <div class="img-preview-item" id="imgItem${st.index}">
                                        <img src="${img.imageUrl}" alt="ảnh ${st.index + 1}"/>
                                        <button type="button" class="remove-img"
                                                onclick="removeImg(${st.index})">×</button>
                                        <input type="hidden" name="imageUrls" value="${img.imageUrl}"/>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit" id="submitBtn">
                            ${isEdit ? 'Lưu thay đổi' : 'Gửi đánh giá'}
                        </button>
                        <a class="btn-cancel"
                           href="${isEdit ? ctx.concat('/review/mine') : ctx.concat('/reviews?pid=').concat(pid)}">
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>

        <script>
            // ── Cloudinary config ── Thay bằng cloud_name và upload_preset của bạn
            const CLOUD_NAME = 'YOUR_CLOUD_NAME';
            const UPLOAD_PRESET = 'YOUR_UPLOAD_PRESET';  // unsigned preset

            let uploadedUrls = [];  // lưu url đã upload thành công
            let imgCount = document.querySelectorAll('#previewList .img-preview-item').length;

            function removeImg(idx) {
                const el = document.getElementById('imgItem_' + idx);
                if (el)
                    el.remove();
            }

            async function handleFiles(files) {
                if (imgCount + files.length > 5) {
                    alert('Chỉ được đính kèm tối đa 5 ảnh.');
                    return;
                }

                const progress = document.getElementById('uploadProgress');
                const btn = document.getElementById('submitBtn');
                progress.style.display = 'block';
                btn.disabled = true;

                for (const file of files) {
                    try {
                        const url = await uploadToCloudinary(file);
                        addPreview(url);
                    } catch (e) {
                        alert('Tải ảnh thất bại: ' + file.name);
                    }
                }

                progress.style.display = 'none';
                btn.disabled = false;
            }

            async function uploadToCloudinary(file) {
                const fd = new FormData();
                fd.append('file', file);
                fd.append('upload_preset', UPLOAD_PRESET);
                fd.append('folder', 'reviews');

                const res = await fetch(`https://api.cloudinary.com/v1_1/${CLOUD_NAME}/image/upload`, {
                    method: 'POST', body: fd
                });
                const data = await res.json();
                if (!data.secure_url)
                    throw new Error(data.error?.message || 'Upload failed');
                return data.secure_url;
            }

            function addPreview(url) {
                const list = document.getElementById('previewList');
                const idx = imgCount++;
                const div = document.createElement('div');
                div.className = 'img-preview-item';
                div.id = 'imgItem_' + idx;
                div.innerHTML = `
                    <img src="${url}" alt="ảnh"/>
                    <button type="button" class="remove-img" onclick="removeImg(${idx})">×</button>
                    <input type="hidden" name="imageUrls" value="${url}"/>
                `;
                list.appendChild(div);
            }
        </script>
    </body>
</html>
