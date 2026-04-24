<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cấu hình Trade-in - Admin</title>
    
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
                <form action="${ctx}/TradeInConfigServlet" method="POST">
                    <input type="hidden" name="action" value="save">
                    
                    <div class="row">
                        <div class="col-md-12">
                            <h4 class="section-title">📌 Thông tin chính</h4>
                            <div class="form-group">
                                <label class="form-label">Tiêu đề Section (Title)</label>
                                <input type="text" name="title" class="form-control-custom" value="${tradeInConfig.Title}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Mô tả Section (Description)</label>
                                <textarea name="description" class="form-control-custom" rows="3" required>${tradeInConfig.Description}</textarea>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <h4 class="section-title">📝 Note 1</h4>
                            <div class="form-group">
                                <label class="form-label">Tiêu đề Note 1</label>
                                <input type="text" name="note1_title" class="form-control-custom" value="${tradeInConfig.Note1_Title}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nội dung Note 1</label>
                                <textarea name="note1_desc" class="form-control-custom" rows="4" required>${tradeInConfig.Note1_Desc}</textarea>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <h4 class="section-title">📝 Note 2</h4>
                            <div class="form-group">
                                <label class="form-label">Tiêu đề Note 2</label>
                                <input type="text" name="note2_title" class="form-control-custom" value="${tradeInConfig.Note2_Title}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nội dung Note 2</label>
                                <textarea name="note2_desc" class="form-control-custom" rows="4" required>${tradeInConfig.Note2_Desc}</textarea>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <h4 class="section-title">📝 Note 3</h4>
                            <div class="form-group">
                                <label class="form-label">Tiêu đề Note 3</label>
                                <input type="text" name="note3_title" class="form-control-custom" value="${tradeInConfig.Note3_Title}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nội dung Note 3</label>
                                <textarea name="note3_desc" class="form-control-custom" rows="4" required>${tradeInConfig.Note3_Desc}</textarea>
                            </div>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 32px; border-top: 1px solid var(--border); padding-top: 24px;">
                        <a href="${ctx}/TradeInConfigServlet" class="btn-cancel">Hủy bỏ</a>
                        <button type="submit" class="btn-submit">Lưu cấu hình <i class="fas fa-check-circle ms-2"></i></button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>