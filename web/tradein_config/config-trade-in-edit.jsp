<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Cấu hình Trade-in - Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        :root {
            --bg-body: #f4f7fe;
            --bg-card: #ffffff;
            --primary: #4318ff;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border: #e9edf7;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
        }

        .config-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 32px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }

        .form-group { margin-bottom: 24px; }
        .form-label { font-size: 0.9rem; font-weight: 700; color: var(--text-main); margin-bottom: 8px; display: block; }
        .form-control-custom {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-size: 0.95rem;
            transition: 0.3s;
            background: #f8fafc;
        }
        .form-control-custom:focus { outline: none; border-color: var(--primary); background: #fff; box-shadow: 0 0 0 4px rgba(67, 24, 255, 0.1); }

        .section-title {
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
        }

        .btn-submit {
            background: var(--primary);
            color: white;
            padding: 12px 32px;
            border-radius: 12px;
            font-weight: 700;
            border: none;
            transition: 0.3s;
            cursor: pointer;
        }
        .btn-submit:hover { background: #3311cc; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(67, 24, 255, 0.3); }

        .btn-cancel {
            background: white;
            color: var(--text-main);
            padding: 12px 32px;
            border-radius: 12px;
            font-weight: 600;
            border: 1px solid var(--border);
            text-decoration: none;
            transition: 0.2s;
            display: inline-block;
        }
        .btn-cancel:hover { background: #f8fafc; color: var(--text-main); }

        .error-feedback {
            color: #dc2626;
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 6px;
            display: none;
        }
        .form-group.has-error .form-control-custom { border-color: #dc2626; background: #fff1f2; }
        .form-group.has-error .error-feedback { display: block; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="config_tradein" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header" style="margin-bottom: 32px;">
                <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Cấu hình trang chủ</p>
                <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0;">Chỉnh sửa Cấu hình Trade-in</h2>
            </header>

            <div class="config-card">
                <form action="${ctx}/TradeInConfigServlet" method="POST" id="configForm">
                    <div class="row">
                        <div class="col-md-12">
                            <h4 class="section-title">📌 Thông tin chính</h4>
                            <div class="form-group" id="group-title">
                                <label class="form-label">Tiêu đề Section <span class="text-danger">*</span></label>
                                <input type="text" id="title" name="title" class="form-control-custom" value="${config.Title}" required maxlength="120">
                                <div class="error-feedback"></div>
                            </div>
                            <div class="form-group" id="group-description">
                                <label class="form-label">Mô tả Section <span class="text-danger">*</span></label>
                                <textarea id="description" name="description" class="form-control-custom" rows="3" required maxlength="500">${config.Description}</textarea>
                                <div class="error-feedback"></div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <h4 class="section-title">📝 Lưu ý 1</h4>
                            <div class="form-group" id="group-note1Title">
                                <label class="form-label">Tiêu đề lưu ý 1</label>
                                <input type="text" id="note1Title" name="note1Title" class="form-control-custom" value="${config.Note1_Title}" required maxlength="100">
                                <div class="error-feedback"></div>
                            </div>
                            <div class="form-group" id="group-note1Desc">
                                <label class="form-label">Nội dung chi tiết 1</label>
                                <textarea id="note1Desc" name="note1Desc" class="form-control-custom" rows="4" required maxlength="500">${config.Note1_Desc}</textarea>
                                <div class="error-feedback"></div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <h4 class="section-title">📝 Lưu ý 2</h4>
                            <div class="form-group" id="group-note2Title">
                                <label class="form-label">Tiêu đề lưu ý 2</label>
                                <input type="text" id="note2Title" name="note2Title" class="form-control-custom" value="${config.Note2_Title}" required maxlength="100">
                                <div class="error-feedback"></div>
                            </div>
                            <div class="form-group" id="group-note2Desc">
                                <label class="form-label">Nội dung chi tiết 2</label>
                                <textarea id="note2Desc" name="note2Desc" class="form-control-custom" rows="4" required maxlength="500">${config.Note2_Desc}</textarea>
                                <div class="error-feedback"></div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <h4 class="section-title">📝 Lưu ý 3</h4>
                            <div class="form-group" id="group-note3Title">
                                <label class="form-label">Tiêu đề lưu ý 3</label>
                                <input type="text" id="note3Title" name="note3Title" class="form-control-custom" value="${config.Note3_Title}" required maxlength="100">
                                <div class="error-feedback"></div>
                            </div>
                            <div class="form-group" id="group-note3Desc">
                                <label class="form-label">Nội dung chi tiết 3</label>
                                <textarea id="note3Desc" name="note3Desc" class="form-control-custom" rows="4" required maxlength="500">${config.Note3_Desc}</textarea>
                                <div class="error-feedback"></div>
                            </div>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 32px; border-top: 1px solid var(--border); padding-top: 24px;">
                        <a href="${ctx}/TradeInConfigServlet" class="btn-cancel">Hủy bỏ</a>
                        <button type="submit" class="btn-submit">Lưu thay đổi <i class="fas fa-check-circle ms-2"></i></button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        const rules = {
            title: { label: 'Tiêu đề', max: 120 },
            description: { label: 'Mô tả', max: 500 },
            note1Title: { label: 'Tiêu đề lưu ý 1', max: 100 },
            note1Desc: { label: 'Nội dung lưu ý 1', max: 500 },
            note2Title: { label: 'Tiêu đề lưu ý 2', max: 100 },
            note2Desc: { label: 'Nội dung lưu ý 2', max: 500 },
            note3Title: { label: 'Tiêu đề lưu ý 3', max: 100 },
            note3Desc: { label: 'Nội dung lưu ý 3', max: 500 }
        };

        function validate(id) {
            const input = document.getElementById(id);
            const group = document.getElementById('group-' + id);
            const error = group.querySelector('.error-feedback');
            const val = input.value.trim();
            let msg = '';

            if (!val) msg = `\${rules[id].label} không được để trống`;
            else if (val.length > rules[id].max) msg = `\${rules[id].label} tối đa \${rules[id].max} ký tự`;

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

        Object.keys(rules).forEach(id => {
            const el = document.getElementById(id);
            el.addEventListener('input', () => validate(id));
            el.addEventListener('blur', () => validate(id));
        });

        document.getElementById('configForm').addEventListener('submit', function(e) {
            let ok = true;
            Object.keys(rules).forEach(id => {
                if (!validate(id)) ok = false;
            });
            if (!ok) {
                e.preventDefault();
                alert('Vui lòng kiểm tra lại thông tin nhập vào!');
            }
        });
    </script>
</body>
</html>