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
            --sidebar-bg: #27315f;
            --sidebar-muted: #c8d0ee;
            --heading: #24345f;
            --text: #64748b;
            --border-color: #e7ecfb;
            --primary-blue: #5b74f1;
            --success-color: #059669;
        }

        html, body { height: 100%; margin: 0; background: var(--page-bg); font-family: 'Inter', 'Segoe UI', sans-serif; color: var(--heading); }
        body { padding: 18px; overflow: hidden; }

        .dashboard-shell {
            height: calc(99vh - 36px);
            background: linear-gradient(180deg, #fcfdff 0%, #f7f9ff 100%);
            border: 1px solid #eef2ff;
            border-radius: 30px;
            padding: 14px;
            display: flex;
            gap: 16px;
            overflow: hidden;
            box-shadow: 0 14px 34px rgba(110, 124, 180, 0.08);
        }

        .sidebar { width: 140px; flex: 0 0 140px; background: var(--sidebar-bg); color: white; border-radius: 24px; padding: 14px 10px; display: flex; flex-direction: column; margin-top: 50px; height: calc(80% - 10px); }
        .sidebar h4 { margin: 0 0 8px; font-size: 20px; font-weight: 800; }
        .nav-list { display: flex; flex-direction: column; gap: 8px; }
        .sidebar a { display: block; color: var(--sidebar-muted); padding: 8px 12px; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 12px; transition: 0.2s ease; }
        .sidebar a.active { background: #ffffff; color: #1f2a56; box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16); }

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

        .sidebar-footer { margin-top: 26px; background: #ffffff; color: #1e2b57; padding: 14px 12px; border-radius: 18px; }
        .sidebar-footer strong { display: block; font-size: 12px; line-height: 1.2; }
        .sidebar-footer span { display: block; font-size: 10px; color: #7381a8; }
    </style>
</head>

<body>
    <div class="dashboard-shell">
        <div class="sidebar">
            <h4>MobileShop</h4>
            <div class="nav-list">
                <a href="${ctx}/HeroListServlet">Biểu ngữ chính</a>
                <a href="${ctx}/BrandListServlet">Thương hiệu</a>
                <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                <a href="${ctx}/TradeInConfigServlet" class="active">Cấu hình Trade-in</a>
            </div>
        </div>

        <div class="content">
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
                        </div>
                        <div class="form-group">
                            <label for="description">Mô tả <span style="color:#ea4f68">*</span></label>
                            <textarea id="description" name="description" class="form-control" 
                                      placeholder="Mô tả ngắn về chương trình Trade-in"
                                      required maxlength="300" title="Bắt buộc, tối đa 300 ký tự">${config.Description}</textarea>
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
                        </div>
                        <div class="form-group">
                            <label for="note1Desc">Nội dung lưu ý 1 <span style="color:#ea4f68">*</span></label>
                            <textarea id="note1Desc" name="note1Desc" class="form-control" 
                                      placeholder="Mô tả chi tiết lưu ý 1"
                                      required maxlength="255" title="Bắt buộc, tối đa 255 ký tự">${config.Note1_Desc}</textarea>
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
                        </div>
                        <div class="form-group">
                            <label for="note2Desc">Nội dung lưu ý 2 <span style="color:#ea4f68">*</span></label>
                            <textarea id="note2Desc" name="note2Desc" class="form-control" 
                                      placeholder="Mô tả chi tiết lưu ý 2"
                                      required maxlength="255" title="Bắt buộc, tối đa 255 ký tự">${config.Note2_Desc}</textarea>
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
                        </div>
                        <div class="form-group">
                            <label for="note3Desc">Nội dung lưu ý 3 <span style="color:#ea4f68">*</span></label>
                            <textarea id="note3Desc" name="note3Desc" class="form-control" 
                                      placeholder="Mô tả chi tiết lưu ý 3"
                                      required maxlength="255" title="Bắt buộc, tối đa 255 ký tự">${config.Note3_Desc}</textarea>
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
</body>

</html>