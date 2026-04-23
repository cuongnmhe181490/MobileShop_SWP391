<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Thương hiệu - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        .form-card {
            background: white;
            border-radius: 24px;
            padding: 32px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            max-width: 800px;
        }

        .form-label { font-size: 0.9rem; font-weight: 700; color: var(--text-main); margin-bottom: 8px; display: block; }
        .form-control-custom {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-size: 0.95rem;
            background: #f8fafc;
            transition: 0.3s;
        }
        .form-control-custom:focus { outline: none; border-color: var(--primary); background: white; box-shadow: 0 0 0 4px rgba(67, 24, 255, 0.1); }

        .section-title {
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 24px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
        }

        .error-msg { color: #dc2626; font-size: 0.8rem; margin-top: 6px; font-weight: 600; display: none; }
        .has-error .form-control-custom { border-color: #dc2626; background: #fff1f2; }
        .has-error .error-msg { display: block; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="config_brand" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header" style="margin-bottom: 32px;">
                <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Cấu hình trang chủ</p>
                <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0;">Thêm Thương hiệu mới</h2>
            </header>

            <div class="form-card">
                <form action="${ctx}/BrandAddServlet" method="post" enctype="multipart/form-data" id="brandForm">
                    <h4 class="section-title">📌 Thông tin cơ bản</h4>
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="form-group" id="group-idSupplier">
                                <label class="form-label">Mã Thương hiệu (ID) <span class="text-danger">*</span></label>
                                <input type="text" name="idSupplier" id="idSupplier" class="form-control-custom" placeholder="VD: APPLE, SAMSUNG" required>
                                <div class="error-msg"></div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="form-group" id="group-name">
                                <label class="form-label">Tên Thương hiệu <span class="text-danger">*</span></label>
                                <input type="text" name="name" id="name" class="form-control-custom" placeholder="VD: Apple Inc." required>
                                <div class="error-msg"></div>
                            </div>
                        </div>
                    </div>

                    <h4 class="section-title" style="margin-top: 12px;">📞 Thông tin liên hệ</h4>
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="form-group" id="group-email">
                                <label class="form-label">Email hỗ trợ <span class="text-danger">*</span></label>
                                <input type="email" name="email" id="email" class="form-control-custom" placeholder="brand@example.com" required>
                                <div class="error-msg"></div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="form-group" id="group-phoneNumber">
                                <label class="form-label">Số điện thoại</label>
                                <input type="text" name="phoneNumber" id="phoneNumber" class="form-control-custom" placeholder="0123 456 789">
                                <div class="error-msg"></div>
                            </div>
                        </div>
                        <div class="col-md-12 mb-4">
                            <div class="form-group" id="group-address">
                                <label class="form-label">Địa chỉ trụ sở</label>
                                <input type="text" name="address" id="address" class="form-control-custom" placeholder="Số nhà, tên đường, thành phố...">
                                <div class="error-msg"></div>
                            </div>
                        </div>
                    </div>

                    <h4 class="section-title" style="margin-top: 12px;">🖼️ Hình ảnh đại diện</h4>
                    <div class="form-group mb-4" id="group-logoFile">
                        <label class="form-label">Logo thương hiệu <span class="text-danger">*</span></label>
                        <input type="file" name="logoFile" id="logoFile" class="form-control-custom" accept="image/*" required>
                        <div class="error-msg"></div>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Khuyên dùng ảnh nền trắng hoặc trong suốt, tỷ lệ 1:1.</p>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 32px; border-top: 1px solid var(--border); padding-top: 24px;">
                        <a href="${ctx}/BrandListServlet" class="btn-outline" style="padding: 10px 24px; text-decoration: none; font-weight: 600;">Hủy bỏ</a>
                        <button type="submit" class="btn-primary" style="padding: 10px 32px; font-weight: 700;">Lưu dữ liệu <i class="fas fa-check-circle ms-2"></i></button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>

    <script>
        const rules = {
            idSupplier: { label: 'Mã thương hiệu', required: true },
            name: { label: 'Tên thương hiệu', required: true },
            email: { label: 'Email', required: true, email: true },
            logoFile: { label: 'Logo', required: true }
        };

        function validate(id) {
            const el = document.getElementById(id);
            const group = document.getElementById('group-' + id);
            const error = group.querySelector('.error-msg');
            const val = el.type === 'file' ? el.value : el.value.trim();
            let msg = '';

            if (rules[id].required && !val) msg = `\${rules[id].label} là bắt buộc`;
            else if (rules[id].email && val && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) msg = 'Định dạng email không hợp lệ';

            if (msg) {
                group.classList.add('has-error');
                error.textContent = msg;
                return false;
            } else {
                group.classList.remove('has-error');
                error.textContent = '';
                return true;
            }
        }

        ['idSupplier', 'name', 'email', 'logoFile'].forEach(id => {
            const el = document.getElementById(id);
            el.addEventListener('input', () => validate(id));
            el.addEventListener('change', () => validate(id));
        });

        document.getElementById('brandForm').addEventListener('submit', function(e) {
            let ok = true;
            ['idSupplier', 'name', 'email', 'logoFile'].forEach(id => {
                if (!validate(id)) ok = false;
            });
            if (!ok) e.preventDefault();
        });
    </script>
</body>
</html>