<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Quản lý Cấu hình Trade-in</title>
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

        .config-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 20px;
            box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
        }

        .config-section { margin-bottom: 24px; }
        .config-section h4 { font-size: 14px; font-weight: 800; color: var(--primary-blue); margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid var(--border-color); }
        
        .note-card {
            background: #f8faff;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 16px;
            margin-bottom: 12px;
        }
        .note-card h5 { font-size: 13px; font-weight: 800; color: var(--heading); margin: 0 0 8px; }
        .note-card p { font-size: 12px; color: var(--text); margin: 0; }

        .btn-edit {
            display: inline-block;
            padding: 8px 20px;
            background: var(--primary-blue);
            color: white;
            border-radius: 999px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s;
        }
        .btn-edit:hover { background: #4a63d9; }

        .sidebar-footer { margin-top: 26px; background: #ffffff; color: #1e2b57; padding: 14px 12px; border-radius: 18px; }
        .sidebar-footer strong { display: block; font-size: 12px; line-height: 1.2; }
        .sidebar-footer span { display: block; font-size: 10px; color: #7381a8; }

        .empty-state { text-align: center; padding: 40px; color: #94a3b8; }
        .empty-state a { color: #5b74f1; font-weight: 600; }
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
                    <h2>Danh sách Cấu hình Trade-in</h2>
                    <p style="font-size: 12px; color: #7e8eb8; margin: 0;">Quản lý nội dung hiển thị section Trade-in trên trang chủ.</p>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <form action="${ctx}/TradeInConfigServlet" method="get" style="display: flex; gap: 5px; margin: 0;">
                        <input type="text" name="search" value="${search}" placeholder="Tìm kiếm theo tiêu đề..." style="padding: 8px 12px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 12px; outline: none; width: 220px;">
                        <button type="submit" class="btn btn-primary" style="border-radius: 8px; font-size: 12px; font-weight: 600; padding: 8px 16px; border: none; background: var(--primary-blue); color: white; cursor: pointer;">Tìm</button>
                    </form>
                    <a href="${ctx}/TradeInConfigServlet?action=edit" class="btn-edit" style="margin: 0;">✏️ Chỉnh sửa</a>
                </div>
            </div>

            <div class="config-card">
                <c:choose>
                    <c:when test="${not empty tradeInConfig}">
                        <!-- Title & Description -->
                        <div class="config-section">
                            <h4>📌 Thông tin chính</h4>
                            <h3 style="font-size: 20px; font-weight: 800; margin: 0 0 8px; color: var(--heading);">${tradeInConfig.Title}</h3>
                            <p style="font-size: 14px; color: var(--text); margin: 0;">${tradeInConfig.Description}</p>
                        </div>

                        <!-- Note 1 -->
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note1_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note1_Desc}</p>
                            </div>
                        </div>

                        <!-- Note 2 -->
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note2_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note2_Desc}</p>
                            </div>
                        </div>

                        <!-- Note 3 -->
                        <div class="config-section">
                            <h4>📝 ${tradeInConfig.Note3_Title}</h4>
                            <div class="note-card">
                                <p>${tradeInConfig.Note3_Desc}</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>Chưa có cấu hình Trade-in.</p>
                            <a href="${ctx}/TradeInConfigServlet?action=edit">Tạo mới</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>

</html>