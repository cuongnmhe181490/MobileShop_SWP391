<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Chỉnh sửa Cấu hình Trade-in</title>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
    <style>
        :root {
            --page-bg: #f5f7ff;
            --heading: #24345f;
            --text: #64748b;
            --border-color: #e7ecfb;
            --primary-blue: #5b74f1;
            --success-color: #059669;
        }

        html, body { height: 100%; margin: 0; background: var(--page-bg); font-family: 'Inter', 'Segoe UI', sans-serif; color: var(--heading); }
        body { padding: 18px; overflow: auto; }

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

        .content { flex: 1; min-width: 0; padding: 4px 2px 8px; overflow-y: auto; }
        .header-section { margin-bottom: 18px; padding-left: 6px; display: flex; justify-content: space-between; align-items: center; }
        .header-section h2 { margin: 0; font-size: 18px; font-weight: 800; color: var(--heading); }

        .form-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
        }

        .form-section { margin-bottom: 28px; }
        .form-section h4 { font-size: 14px; font-weight: 800; color: var(--primary-blue); margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid var(--border-color); }
        
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 12px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-size: 13px;
            transition: 0.2s;
            font-family: inherit;
        }
        .form-control:focus { outline: none; border-color: var(--primary-blue); box-shadow: 0 0 0 3px rgba(91, 116, 241, 0.1); }
        textarea.form-control { resize: vertical; min-height: 80px; }

        .btn-group { display: flex; gap: 12px; margin-top: 24px; }
        .btn-save {
            padding: 12px 28px;
            background: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-save:hover { background: #4a63d9; }
        .btn-cancel {
            padding: 12px 28px;
            background: #f1f5ff;
            color: var(--text);
            border: none;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: 0.2s;
        }
        .btn-cancel:hover { background: #e2e8f0; }

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
        .form-group.has-error .form-control {
            border-color: #ff7b8f !important;
            background-color: #fff5f5 !important;
        }
        .form-group.has-error .error-feedback {
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
                <div>
                    <h2>Chỉnh sửa Cấu hình Trade-in</h2>
                    <p style="font-size: 12px; color: #7e8eb8; margin: 0;">Cập nhật nội dung hiển thị section Trade-in.</p>
                </div>
            </div>

            <div class="form-card">
                <form action="${ctx}/TradeInConfigServlet" method="POST">
                    <!-- Thông tin chính -->
                    <div class="form-section">
                        <h4>📌 Thông tin chính</h4>
                        <div class="form-group">
                            <label for="title">Tiêu đề <span style="color:#ea4f68">*</span></label>
                            <input type="text" id="title" name="title" class="form-control" 
                                   value="${config.Title}" placeholder="Ví dụ: Đổi máy cũ - Giá hời ngay" 
                                   required minlength="5" maxlength="120" title="Bắt buộc, 5-120 ký tự">
                            <div class="error-feedback"></div>
                        </div>
                        <div class="form-group">
                            <label for="description">Mô tả <span style="color:#ea4f68">*</span></label>
                            <textarea id="description" name="description" class="form-control" 
                                      placeholder="Mô tả ngắn về chương trình Trade-in"
                                      required maxlength="300" title="Bắt buộc, tối đa 300 ký tự">${config.Description}</textarea>
                            <div class="error-feedback"></div>
                        </div>
                    </div>

                    <!-- Note 1 -->
                    <div class="form-section">
                        <h4>📝 Lưu ý 1</h4>
                        <div class="form-group">
                            <label for="note1Title">Tiêu đề lưu ý 1 <span style="color:#ea4f68">*</span></label>
                            <input type="text" id="note1Title" name="note1Title" class="form-control" 
                                   value="${config.Note1_Title}" placeholder="Ví dụ: Đánh giá công bằng"
                                   required maxlength="50" title="Bắt buộc, tối đa 50 ký tự">
                            <div class="error-feedback"></div>
                        </div>
                        <div class="form-group">
                            <label for="note1Desc">Nội dung lưu ý 1 <span style="color:#ea4f68">*</span></label>
                            <textarea id="note1Desc" name="note1Desc" class="form-control" 
                                      placeholder="Mô tả chi tiết lưu ý 1"
                                      required maxlength="255" title="Bắt buộc, tối đa 255 ký tự">${config.Note1_Desc}</textarea>
                            <div class="error-feedback"></div>
                        </div>
                    </div>

                    <!-- Note 2 -->
                    <div class="form-section">
                        <h4>📝 Lưu ý 2</h4>
                        <div class="form-group">
                            <label for="note2Title">Tiêu đề lưu ý 2 <span style="color:#ea4f68">*</span></label>
                            <input type="text" id="note2Title" name="note2Title" class="form-control" 
                                   value="${config.Note2_Title}" placeholder="Ví dụ: Thủ tục nhanh gọn"
                                   required maxlength="50" title="Bắt buộc, tối đa 50 ký tự">
                            <div class="error-feedback"></div>
                        </div>
                        <div class="form-group">
                            <label for="note2Desc">Nội dung lưu ý 2 <span style="color:#ea4f68">*</span></label>
                            <textarea id="note2Desc" name="note2Desc" class="form-control" 
                                      placeholder="Mô tả chi tiết lưu ý 2"
                                      required maxlength="255" title="Bắt buộc, tối đa 255 ký tự">${config.Note2_Desc}</textarea>
                            <div class="error-feedback"></div>
                        </div>
                    </div>

                    <!-- Note 3 -->
                    <div class="form-section">
                        <h4>📝 Lưu ý 3</h4>
                        <div class="form-group">
                            <label for="note3Title">Tiêu đề lưu ý 3 <span style="color:#ea4f68">*</span></label>
                            <input type="text" id="note3Title" name="note3Title" class="form-control" 
                                   value="${config.Note3_Title}" placeholder="Ví dụ: Giá trị cao nhất"
                                   required maxlength="50" title="Bắt buộc, tối đa 50 ký tự">
                            <div class="error-feedback"></div>
                        </div>
                        <div class="form-group">
                            <label for="note3Desc">Nội dung lưu ý 3 <span style="color:#ea4f68">*</span></label>
                            <textarea id="note3Desc" name="note3Desc" class="form-control" 
                                      placeholder="Mô tả chi tiết lưu ý 3"
                                      required maxlength="255" title="Bắt buộc, tối đa 255 ký tự">${config.Note3_Desc}</textarea>
                            <div class="error-feedback"></div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="btn-group">
                        <button type="submit" class="btn-save">💾 Lưu thay đổi</button>
                        <a href="${ctx}/TradeInConfigServlet" class="btn-cancel">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
<script>
    const validationRules = {
        title: { required: true, min: 5, max: 120, label: 'Tiêu đề' },
        description: { required: true, max: 300, label: 'Mô tả' },
        note1Title: { required: true, max: 50, label: 'Tiêu đề lưu ý 1' },
        note1Desc: { required: true, max: 255, label: 'Nội dung lưu ý 1' },
        note2Title: { required: true, max: 50, label: 'Tiêu đề lưu ý 2' },
        note2Desc: { required: true, max: 255, label: 'Nội dung lưu ý 2' },
        note3Title: { required: true, max: 50, label: 'Tiêu đề lưu ý 3' },
        note3Desc: { required: true, max: 255, label: 'Nội dung lưu ý 3' }
    };

    function validateField(id) {
        const field = document.getElementById(id);
        const group = field.closest('.form-group');
        const errorDiv = group.querySelector('.error-feedback');
        const rules = validationRules[id];
        const value = field.value.trim();
        let errorMsg = '';

        if (rules.required && !value) {
            errorMsg = `\${rules.label} không được để trống.`;
        } else if (rules.min && value.length < rules.min) {
            errorMsg = `\${rules.label} phải có ít nhất \${rules.min} ký tự.`;
        } else if (rules.max && value.length > rules.max) {
            errorMsg = `\${rules.label} không được vượt quá \${rules.max} ký tự.`;
        }

        if (errorMsg) {
            group.classList.add('has-error');
            errorDiv.textContent = errorMsg;
            return false;
        } else {
            group.classList.remove('has-error');
            errorDiv.textContent = '';
            return true;
        }
    }

    Object.keys(validationRules).forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('input', () => validateField(id));
            el.addEventListener('blur', () => validateField(id));
        }
    });

    document.querySelector('form').addEventListener('submit', function(e) {
        let isValid = true;
        Object.keys(validationRules).forEach(id => {
            if (!validateField(id)) isValid = false;
        });
        if (!isValid) {
            e.preventDefault();
            alert('Vui lòng kiểm tra lại các trường thông tin!');
        }
    });
</script>
</body>

</html>