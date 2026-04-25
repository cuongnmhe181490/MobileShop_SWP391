<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="heroImageUrl" value="https://cdn2.cellphones.com.vn/---/Hero-visual.jpg" />
<c:if test="${heroProduct != null}">
    <c:set var="heroImageUrl" value="${heroProduct.imagePath}" />
</c:if>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Config Hero banner</title>
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <style>
            :root {
                --page-bg: #f5f7ff;
                --heading: #24345f;
                --text: #64748b;
                --border-color: #e7ecfb;
                --primary-blue: #5b74f1;
                --danger-bg: #fff4f5;
                --danger-border: #ff7b8f;
                --danger-text: #ea4f68;
            }

            html, body {
                height: 100%;
                margin: 0;
                background: var(--page-bg);
                font-family: 'Inter', 'Segoe UI', sans-serif;
                color: var(--heading);
            }

            body {
                padding: 18px;
                overflow: auto; /* khóa cuộn toàn trang */
            }

            .dashboard-shell {
                height: calc(99vh - 36px);
                background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
                border: 1px solid #eef2ff;
                border-radius: 30px;
                padding: 14px;
                display: flex;
                gap: 16px;
                overflow: auto;
                box-shadow: 0 14px 34px rgba(110, 124, 180, 0.08);
            }

            .logout-link {
                margin-top: 8px;
                padding: 0 12px;
                text-decoration: none;
                color: #f8faff;
                font-weight: 800;
                font-size: 12px;
                white-space: nowrap;
            }

            .content {
                flex: 1;
                min-width: 0;
                padding: 4px 2px 8px;
                overflow-y: auto;
            }

            .header-section {
                margin-bottom: 18px;
                padding-left: 6px;
            }

            .header-section h2 {
                margin: 0 0 8px;
                font-size: 18px;
                font-weight: 800;
                color: var(--heading);
            }

            .header-section p {
                margin: 0;
                max-width: 760px;
                color: #7e8eb8;
                font-size: 13px;
                line-height: 1.55;
            }
            
            .input-readonly {
                width: 100%;
                border: 1px dashed #c9d6ff;
                background: #f0f4ff;
                border-radius: 14px;
                padding: 10px 12px;
                font-size: 12px;
                color: #3b5bdb;
                font-weight: 700;
                cursor: not-allowed;
            }

            .form-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 18px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
            }

            .form-grid-3 {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
            }

            .form-grid-1 {
                display: grid;
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .field label {
                display: block;
                font-size: 10px;
                font-weight: 800;
                color: #7e8eb8;
                margin-bottom: 8px;
            }

            .input,
            .textarea {
                width: 100%;
                border: 1px solid #eaf0ff;
                background: #ffffff;
                border-radius: 14px;
                padding: 10px 12px;
                font-size: 12px;
                outline: none;
            }

            .input:focus,
            .textarea:focus {
                border-color: #c9d6ff;
                box-shadow: 0 0 0 3px rgba(91, 116, 241, 0.12);
            }

            .textarea {
                resize: vertical;
                min-height: 44px;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
                margin-top: 2px;
            }

            .actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 18px;
            }

            .btn-f {
                padding: 8px 18px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 800;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
            }

            .btn-save {
                background: var(--primary-blue);
                border-color: var(--primary-blue);
                color: #ffffff;
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-cancel {
                background: #ffffff;
                border-color: #e2e8f0;
                color: #1f2a56;
            }

            @media (max-width: 991px) {
                body {
                    padding: 12px;
                }
                .dashboard-shell {
                    flex-direction: column;
                }
                .form-grid-3 {
                    grid-template-columns: 1fr;
                }
                .stats-row {
                    grid-template-columns: 1fr;
                }
                .actions {
                    justify-content: center;
                }
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
            color: #ea4f68;
            font-size: 11px;
            font-weight: 600;
            margin-top: 4px;
            display: none;
        }
        .field.has-error .input, 
        .field.has-error .textarea {
            border-color: #ea4f68 !important;
            background-color: #fff5f5 !important;
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
                    <h2>Sửa Hero banner</h2>
                    <p>Cập nhật nội dung hiển thị cho banner chính trên trang chủ.</p>
                </div>

                <div class="form-card">
                    <form action="${ctx}/HeroEditServlet" method="post" id="heroForm" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${hero.id}">
                        <div class="form-grid-3">
                            <div class="field">
                                <label>Nhãn phụ</label>
                                <input class="input" type="text" name="eyebrow" id="eyebrow" value="${hero.eyebrow}"
                                       maxlength="50">
                                <div class="error-feedback"></div>
                            </div>

                            <div class="field">
                                <label>CTA chính <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="ctaPrimary" id="ctaPrimary" value="${hero.ctaPrimary}"
                                       required maxlength="30"
                                       title="Bắt buộc, tối đa 30 ký tự">
                                <div class="error-feedback"></div>
                            </div>

                            <div class="field">
                                <label>CTA phụ</label>
                                <input class="input" type="text" name="ctaSecondary" id="ctaSecondary" value="${hero.ctaSecondary}"
                                       maxlength="30">
                                <div class="error-feedback"></div>
                            </div>
                        </div>

                        <div class="form-grid-1" style="margin-top: 16px;">
                            <div class="field">
                                <label>Tiêu đề chính <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="title" id="title" value="${hero.title}"
                                       required minlength="5" maxlength="120"
                                       title="Bắt buộc, 5-120 ký tự">
                                <div class="error-feedback"></div>
                            </div>

                            <div class="field">
                                <label>Mô tả ngắn <span style="color:#ea4f68">*</span></label>
                                <textarea class="textarea" name="description" id="description"
                                          required maxlength="300"
                                          title="Bắt buộc, tối đa 300 ký tự">${hero.description}</textarea>
                                <div class="error-feedback"></div>
                            </div>

                            <div class="field">
                                <label>Thay đổi ảnh visual (Tải lên từ máy - tùy chọn)</label>
                                <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 8px;">
                                    <c:if test="${not empty hero.imageUrl}">
                                        <div style="width: 80px; height: 50px; border-radius: 8px; overflow: hidden; border: 1px solid var(--border-color);">
                                            <img src="${hero.imageUrl}" style="width: 100%; height: 100%; object-fit: cover;" alt="Current Image">
                                        </div>
                                    </c:if>
                                    <input class="input" type="file" name="imageFile" id="imageFile" accept="image/*">
                                    <div class="error-feedback"></div>
                                </div>
                                <small style="font-size: 11px; color: #7e8eb8; display: block;">
                                    Bỏ trống nếu muốn giữ ảnh cũ. Định dạng: JPG, PNG, WEBP. Dung lượng: < 500 KB. <br>
                                    Kích thước khuyên dùng: <b>600 x 800 px</b> (Tỷ lệ 3:4).
                                </small>
                            </div>

                            <div class="stats-row">
                                <%-- STAT 1: Điểm hài lòng – tự động tính từ AVG(Ranking) ProductReview --%>
                                <div class="field">
                                    <label>Điểm hài lòng</label>
                                    <div class="input-readonly">
                                        <c:out value="${satisfactionRate}" default="0/5"/>
                                    </div>
                                 
                                </div>

                                <%-- STAT 2: Thời gian phản hồi – admin nhập thủ công --%>
                                <div class="field">
                                    <label>Thời gian phản hồi <span style="color:#ea4f68">*</span></label>
                                    <input class="input" type="text" name="stat2" id="stat2"
                                           value="${hero.stat2Label}"
                                           required maxlength="20"
                                           title="Bắt buộc, tối đa 20 ký tự">
                                    <div class="error-feedback"></div>
                                </div>

                                <%-- STAT 3: Số mẫu máy – tự động đếm COUNT(*) ProductDetail --%>
                                <div class="field">
                                    <label>Số mẫu máy</label>
                                    <div class="input-readonly">
                                        +<c:choose>
                                            <c:when test="${not empty productCount}">${productCount}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </div>
                           
                                </div>
                            </div>

                            <div class="actions">
                                <button type="submit" class="btn-f btn-save">Lưu thay đổi</button>
                                <a href="${ctx}/AdminHomeConfigServlet" class="btn-f btn-cancel">Hủy</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Toast Notifications System -->
        <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>

        <script>
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

            // New Real-time Validation Configuration
            const validationRules = {
                eyebrow: {
                    max: 50,
                    label: 'Nhãn phụ'
                },
                ctaPrimary: {
                    required: true,
                    max: 30,
                    label: 'CTA chính'
                },
                ctaSecondary: {
                    max: 30,
                    label: 'CTA phụ'
                },
                title: {
                    required: true,
                    min: 5,
                    max: 120,
                    label: 'Tiêu đề chính'
                },
                description: {
                    required: true,
                    max: 300,
                    label: 'Mô tả ngắn'
                },
                stat2: {
                    required: true,
                    max: 20,
                    label: 'Thời gian phản hồi'
                },
                imageFile: {
                    required: false, // Optional for Edit
                    label: 'Ảnh visual'
                }
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
                } else if (value && rules.min && value.length < rules.min) {
                    errorMsg = `\${rules.label} phải có ít nhất \${rules.min} ký tự.`;
                } else if (value && rules.max && value.length > rules.max) {
                    errorMsg = `\${rules.label} không được vượt quá \${rules.max} ký tự.`;
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

            // Attach listeners
            Object.keys(validationRules).forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', () => validateField(id));
                    el.addEventListener('blur', () => validateField(id));
                    if (id === 'imageFile') {
                        el.addEventListener('change', () => validateField(id));
                    }
                }
            });

            // Form submission check
            document.getElementById('heroForm').addEventListener('submit', function(e) {
                let isValid = true;
                Object.keys(validationRules).forEach(id => {
                    if (!validateField(id)) isValid = false;
                });

                if (!isValid) {
                    e.preventDefault();
                    showToast('Vui lòng kiểm tra lại các trường thông tin!', 'error');
                }
            });

            // Client-side validation for image size
            document.getElementById('imageFile').addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    if (file.size > 500 * 1024) { // 500 KB
                        showToast('Ảnh quá lớn! Vui lòng chọn ảnh dưới 500KB.', 'error');
                        e.target.value = '';
                    } else {
                        const img = new Image();
                        img.onload = function() {
                            // Enforce reasonable limits for Hero Portrait
                            if (this.width > 1200 || this.height > 1600) {
                                showToast('Kích thước ảnh quá lớn! Khuyên dùng 600x800px.', 'error');
                                e.target.value = '';
                            } else if (this.width > this.height) {
                                showToast('Vui lòng chọn ảnh dọc (Portrait)! Khuyên dùng 600x800px.', 'error');
                                e.target.value = '';
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

