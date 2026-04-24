<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Thêm Brand Logo | Admin Panel</title>
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <style>
            :root {
                --page-bg: #f5f7ff;
                --heading: #24345f;
                --text: #64748b;
                --border-color: #e7ecfb;
                --primary-blue: #5b74f1;
                --danger-bg: #fff4f5;
                --danger-text: #ea4f68;
                --success-bg: #ecfdf5;
                --success-border: #a7f3d0;
                --success-text: #059669;
            }

            html, body {
                height: 100%;
                margin: 0;
                background: var(--page-bg);
                font-family: 'Inter', 'Segoe UI', sans-serif;
                color: var(--heading);
                overflow: auto;
            }

            body {
                padding: 18px;
            }

            .dashboard-shell {
                height: calc(100vh - 36px);
                background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
                border: 1px solid #eef2ff;
                border-radius: 30px;
                padding: 14px;
                display: flex;
                gap: 16px;
                box-shadow: 0 14px 34px rgba(110, 124, 180, 0.08);
            }
            /* Content Area */
            .content {
                flex: 1;
                padding: 10px;
                overflow-y: auto;
            }

            .header-section {
                margin-bottom: 24px;
            }
            .header-section h2 {
                font-size: 22px;
                font-weight: 800;
                color: var(--heading);
                margin-bottom: 4px;
            }
            .header-section p {
                color: var(--text);
                font-size: 13px;
            }

            /* Form Card */
            .form-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 30px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.05);
                max-width: 900px;
            }

            .field {
                margin-bottom: 20px;
            }
            .field label {
                display: block;
                font-size: 11px;
                font-weight: 800;
                color: #7e8eb8;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .input {
                width: 100%;
                border: 1px solid #eaf0ff;
                border-radius: 14px;
                padding: 12px 16px;
                font-size: 14px;
                outline: none;
                transition: all 0.2s;
                background: #fcfdff;
            }

            .input:focus {
                border-color: var(--primary-blue);
                background: #fff;
                box-shadow: 0 0 0 4px rgba(91, 116, 241, 0.1);
            }

            /* Group inputs in one row */
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            /* Action Buttons */
            .actions {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 12px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #f1f5f9;
            }

            .btn-f {
                padding: 10px 24px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-save {
                background: var(--primary-blue);
                color: white;
            }
            .btn-save:hover {
                opacity: 0.9;
                transform: translateY(-1px);
            }

            .btn-list {
                background: var(--success-bg);
                color: var(--success-text);
                border-color: var(--success-border);
            }
            .btn-list:hover {
                background: var(--success-border);
            }

            .btn-cancel {
                background: #f8fafc;
                color: #64748b;
                border-color: #e2e8f0;
            }
            .btn-cancel:hover {
                background: #f1f5f9;
            }

            /* Error message */
            .error-msg {
                background: var(--danger-bg);
                color: var(--danger-text);
                padding: 12px;
                border-radius: 12px;
                font-size: 13px;
                margin-bottom: 20px;
                border: 1px solid #ffccd2;
            }

        /* ===== SIDEBAR – Version Gold ===== */
        .sidebar {
            width: 260px;
            background: #1e293b;
            padding: 24px 0;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            z-index: 100;
            color: white;
            overflow-y: auto;
        }
        .sidebar .brand {
            padding: 0 24px;
            margin-bottom: 40px;
            text-decoration: none;
            color: white;
            display: block;
        }
        .sidebar .brand h2 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        
        .nav-section { margin-bottom: 32px; }
        .nav-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            color: #64748b;
            letter-spacing: 1px;
            margin-bottom: 12px;
            display: block;
            padding: 0 24px;
        }
        
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 24px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            border-left: 4px solid transparent;
            transition: 0.3s;
        }
        .menu-link i { width: 20px; text-align: center; }
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active {
            background: rgba(175, 242, 47, 0.1);
            color: #aff22f;
            border-left-color: #aff22f;
            font-weight: 600;
        }
        /* Validation styles */
        .error-feedback {
            color: var(--danger-text);
            font-size: 11px;
            font-weight: 600;
            margin-top: 4px;
            display: none;
        }
        .field.has-error .input {
            border-color: #ff7b8f !important;
            background-color: var(--danger-bg) !important;
        }
        .field.has-error .error-feedback {
            display: block;
        }
        /* ===== END SIDEBAR ===== */

        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

    <body>
        <div class="dashboard-shell">
                    <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <!-- 1. TỔNG QUAN -->
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 2. QUẢN LÝ BÁN HÀNG -->
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 3. TƯƠNG TÁC & NỘI DUNG -->
            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 4. CẤU HÌNH GIAO DIỆN -->
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link active">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 5. HỆ THỐNG -->
            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

            <div class="content" style="margin-left:260px;padding:32px 40px;min-height:100vh;box-sizing:border-box;">
                <div class="header-section">
                    <h2>Thêm Logo Thương Hiệu</h2>
                    <p>Quản lý các đối tác thương hiệu (Category) hiển thị trên hệ thống.</p>
                </div>

                <div class="form-card">
                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <form action="${ctx}/BrandAddServlet" method="post" id="brandForm" enctype="multipart/form-data">
                        <div class="form-row">
                            <div class="field">
                                <label>Mã Thương Hiệu (ID) <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="idSupplier" id="idSupplier"
                                       placeholder="Ví dụ: APPL, SMSG..."
                                       required maxlength="100">
                                <div class="error-feedback"></div>
                            </div>
                            <div class="field">
                                <label>Tên Thương Hiệu <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="name" id="name"
                                       placeholder="Ví dụ: Apple, Samsung, Xiaomi..."
                                       required maxlength="100">
                                <div class="error-feedback"></div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="field">
                                <label>Email liên hệ <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="email" name="email" id="email"
                                       placeholder="contact@brand.com"
                                       required maxlength="100">
                                <div class="error-feedback"></div>
                            </div>
                            <div class="field">
                                <label>Số điện thoại</label>
                                <input class="input" type="text" name="phoneNumber" id="phoneNumber"
                                       placeholder="0912..."
                                       maxlength="15">
                                <div class="error-feedback"></div>
                            </div>
                        </div>

                        <div class="field">
                            <label>Địa chỉ</label>
                            <input class="input" type="text" name="address" id="address"
                                   placeholder="Hội sở chính của thương hiệu"
                                   maxlength="255">
                            <div class="error-feedback"></div>
                        </div>

                        <div class="field">
                            <label>Logo Thương Hiệu (Tải lên từ máy) <span style="color:#ea4f68">*</span></label>
                            <div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 8px;">
                                <div id="previewContainer" style="display: none; width: 120px; height: 120px; border-radius: 20px; overflow: hidden; border: 2px solid #e2e8f0; background: white; align-items: center; justify-content: center; padding: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                                     <img id="logoPreview" src="#" style="width: 100%; height: 100%; object-fit: contain;" alt="Brand Logo Preview">
                                 </div>
                                 <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                                     <input class="input" type="file" name="logoFile" id="logoFile" accept="image/*" required style="flex: 1;">
                                     <div class="error-feedback"></div>
                                 </div>
                            </div>
                            <small style="font-size: 11px; color: #7e8eb8; margin-top: 8px; display: block;">
                                Định dạng: JPG, PNG, WEBP, SVG. Dung lượng: < 500 KB.<br>
                                Kích thước khuyên dùng: <b>400 x 400 px</b> (Tỷ lệ 1:1).
                            </small>
                        </div>

                        <div class="actions">
                            <a href="${ctx}/BrandListServlet" class="btn-f btn-list">Xem danh sách</a>
                            <a href="${ctx}/AdminHomeConfigServlet" class="btn-f btn-cancel">Hủy</a>
                            <button type="submit" class="btn-f btn-save">Lưu dữ liệu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Toast Notifications System -->
        <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>

        <script>
            // Real-time Validation
            const validationRules = {
                idSupplier: { required: true, max: 100, label: 'Mã thương hiệu' },
                name: { required: true, max: 100, label: 'Tên thương hiệu' },
                 email: { required: true, max: 100, format: 'email', label: 'Email liên hệ' },
                phoneNumber: { max: 15, format: 'phone', label: 'Số điện thoại' },
                address: { max: 255, label: 'Địa chỉ' },
                logoFile: { required: true, label: 'Logo thương hiệu' }
            };

            function validateField(id) {
                const field = document.getElementById(id);
                const container = field.closest('.field');
                const errorDiv = container.querySelector('.error-feedback');
                const rules = validationRules[id];
                const value = field.type === 'file' ? field.value : field.value.trim();
                let errorMsg = '';

                if (rules.required && !value) {
                    errorMsg = `\${rules.label} không được để trống.`;
                } else if (value && rules.max && value.length > rules.max) {
                    errorMsg = `\${rules.label} không được vượt quá \${rules.max} ký tự.`;
                } else if (value && rules.format === 'email') {
                    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!re.test(value)) {
                        errorMsg = 'Định dạng email không hợp lệ.';
                    }
                } else if (value && rules.format === 'phone') {
                    const re = /^[\d +()]{7,20}$/;
                    if (!re.test(value)) {
                        errorMsg = 'Định dạng số điện thoại không hợp lệ.';
                    }
                }

                if (errorMsg) {
                    container.classList.add('has-error');
                    errorDiv.textContent = errorMsg;
                    return false;
                } else {
                    container.classList.remove('has-error');
                    errorDiv.textContent = '';
                    return true;
                }
            }

            Object.keys(validationRules).forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', () => validateField(id));
                    el.addEventListener('blur', () => validateField(id));
                    if (id === 'logoFile') el.addEventListener('change', () => validateField(id));
                }
            });

            document.getElementById('brandForm').addEventListener('submit', function(e) {
                let isValid = true;
                Object.keys(validationRules).forEach(id => {
                    if (!validateField(id)) isValid = false;
                });
                if (!isValid) {
                    e.preventDefault();
                    showToast('Vui lòng kiểm tra lại các trường thông tin!', 'error');
                }
            });

            function showToast(message, type = 'success') {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                toast.style.cssText = `
                    min-width: 280px;
                    padding: 16px 20px;
                    margin-bottom: 12px;
                    border-radius: 12px;
                    background: \${type === 'success' ? '#4caf50' : '#f44336'};
                    color: white;
                    font-size: 13px;
                    font-weight: 600;
                    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
                    opacity: 0;
                    transform: translateX(50px);
                    transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                    display: flex;
                    align-items: center;
                    gap: 12px;
                `;
                
                const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';
                toast.innerHTML = `<i class="fa-solid \${icon}"></i> <span>\${message}</span>`;
                
                container.appendChild(toast);
                
                setTimeout(() => {
                    toast.style.opacity = '1';
                    toast.style.transform = 'translateX(0)';
                }, 10);
                
                setTimeout(() => {
                    toast.style.opacity = '0';
                    toast.style.transform = 'translateX(50px)';
                    setTimeout(() => toast.remove(), 400);
                }, 4000);
            }

            document.getElementById('logoFile').addEventListener('change', function(e) {
                const file = e.target.files[0];
                const container = document.getElementById('previewContainer');
                const preview = document.getElementById('logoPreview');
                const fieldId = 'logoFile';
                const field = document.getElementById(fieldId);
                const fieldContainer = field.closest('.field');
                const errorDiv = fieldContainer.querySelector('.error-feedback');

                if (file) {
                    if (file.size > 500 * 1024) {
                        showToast('Ảnh quá lớn! Vui lòng chọn ảnh dưới 500KB.', 'error');
                        e.target.value = '';
                        container.style.display = 'none';
                        fieldContainer.classList.add('has-error');
                        errorDiv.textContent = 'Dung lượng logo tối đa 500KB.';
                    } else {
                        const reader = new FileReader();
                        reader.onload = function(event) {
                            preview.src = event.target.result;
                            container.style.display = 'flex';
                        };
                        reader.readAsDataURL(file);

                        const img = new Image();
                        img.onload = function() {
                            const ratio = this.width / this.height;
                            let errorMsg = '';
                            if (this.width > 1000 || this.height > 1000) {
                                errorMsg = 'Độ phân giải logo quá lớn! Tối đa 1000x1000px.';
                            } else if (ratio < 0.8 || ratio > 1.2) {
                                errorMsg = 'Vui lòng chọn ảnh vuông! Tỷ lệ chuẩn 1:1 (400x400px).';
                            }

                            if (errorMsg) {
                                showToast(errorMsg, 'error');
                                e.target.value = '';
                                container.style.display = 'none';
                                fieldContainer.classList.add('has-error');
                                errorDiv.textContent = errorMsg;
                            } else {
                                fieldContainer.classList.remove('has-error');
                                errorDiv.textContent = '';
                            }
                        };
                        img.src = URL.createObjectURL(file);
                    }
                }
            });

            window.onload = function() {
                <c:if test="${not empty sessionScope.flashSuccess}">
                    showToast('${sessionScope.flashSuccess}', 'success');
                    <% session.removeAttribute("flashSuccess"); %>
                </c:if>
                <c:if test="${not empty sessionScope.flashError}">
                    showToast('${sessionScope.flashError}', 'error');
                    <% session.removeAttribute("flashError"); %>
                </c:if>
            };
        </script>
    </body>

</html>