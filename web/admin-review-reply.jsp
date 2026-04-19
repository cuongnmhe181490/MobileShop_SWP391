<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Phản hồi Review</title>
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
                --danger-bg: #fff4f5;
                --danger-text: #ea4f68;
                --success-bg: #ecfdf5;
                --success-text: #059669;
            }

            html, body {
                height: 100%;
                margin: 0;
                background: var(--page-bg);
                font-family: 'Inter', 'Segoe UI', sans-serif;
                color: var(--heading);
            }

            body { padding: 18px; overflow: hidden; }

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

            .sidebar {
                width: 160px;
                flex: 0 0 160px;
                background: var(--sidebar-bg);
                color: white;
                border-radius: 24px;
                padding: 20px 12px;
                display: flex;
                flex-direction: column;
            }

            .sidebar h4 { margin: 0 0 20px; font-size: 18px; font-weight: 800; text-align: center; }

            .nav-list { display: flex; flex-direction: column; gap: 8px; }

            .sidebar a {
                display: block;
                color: var(--sidebar-muted);
                padding: 10px 14px;
                text-decoration: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 12px;
                transition: 0.2s;
            }

            .sidebar a:hover { color: white; background: rgba(255,255,255,0.05); }

            .sidebar a.active {
                background: #ffffff;
                color: #1f2a56;
                box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16);
            }

            .sidebar-footer {
                margin-top: auto;
                padding-top: 20px;
            }

            .sidebar-footer strong { display: block; font-size: 12px; margin-bottom: 2px; }
            .sidebar-footer span { display: block; font-size: 10px; color: #7381a8; }

            .logout-link {
                margin-top: 8px;
                padding: 0 12px;
                text-decoration: none;
                color: #f8faff;
                font-weight: 800;
                font-size: 12px;
            }

            .content { flex: 1; padding: 10px; overflow-y: auto; }

            .header-section { margin-bottom: 24px; }

            .header-section h2 { 
                font-size: 22px; 
                font-weight: 800; 
                color: var(--heading); 
                margin: 0 0 8px 0;
            }

            .header-section p { 
                color: var(--text); 
                font-size: 13px; 
                margin: 0;
            }

            .form-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 30px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.05);
                max-width: 800px;
            }

            .review-info {
                background: #f8fafc;
                border-radius: 16px;
                padding: 20px;
                margin-bottom: 24px;
            }

            .review-info__header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 12px;
            }

            .review-info__user {
                font-weight: 700;
                font-size: 16px;
                color: var(--heading);
            }

            .review-info__stars {
                color: #fbbf24;
                font-size: 18px;
            }

            .review-info__content {
                color: var(--text);
                font-size: 14px;
                line-height: 1.6;
                margin-bottom: 12px;
            }

            .review-info__date {
                font-size: 12px;
                color: #94a3b8;
            }

            .reply-section {
                border-left: 3px solid var(--primary-blue);
                padding-left: 20px;
                margin-top: 16px;
            }

            .reply-section__label {
                font-size: 11px;
                font-weight: 800;
                color: var(--primary-blue);
                text-transform: uppercase;
                margin-bottom: 8px;
            }

            .reply-section__content {
                color: var(--heading);
                font-size: 14px;
                line-height: 1.6;
            }

            .reply-section__date {
                font-size: 11px;
                color: #94a3b8;
                margin-top: 8px;
            }

            .field { margin-bottom: 20px; }

            .field label {
                display: block;
                font-size: 11px;
                font-weight: 800;
                color: #7e8eb8;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .textarea {
                width: 100%;
                border: 1px solid #eaf0ff;
                border-radius: 14px;
                padding: 12px 16px;
                font-size: 14px;
                outline: none;
                transition: all 0.2s;
                background: #fcfdff;
                resize: vertical;
                min-height: 120px;
            }

            .textarea:focus {
                border-color: var(--primary-blue);
                background: #fff;
                box-shadow: 0 0 0 4px rgba(91, 116, 241, 0.1);
            }

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
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-save:hover { opacity: 0.9; transform: translateY(-1px); }

            .btn-cancel {
                background: #f8fafc;
                color: #64748b;
                border-color: #e2e8f0;
            }

            .btn-cancel:hover { background: #f1f5f9; }

            .error-msg {
                background: var(--danger-bg);
                color: var(--danger-text);
                padding: 12px;
                border-radius: 12px;
                font-size: 13px;
                margin-bottom: 20px;
                border: 1px solid #ffccd2;
            }

            @media (max-width: 991px) {
                body { padding: 12px; }
                .dashboard-shell { flex-direction: column; }
                .sidebar { width: 100%; flex-basis: auto; }
                .form-card { padding: 20px; }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <div class="sidebar">
                <h4>MobileShop</h4>
                <div class="nav-list">
                    <a href="${ctx}/HeroListServlet">Biểu ngữ chính</a>
                    <a href="${ctx}/BrandListServlet">Thương hiệu</a>
                    <a href="${ctx}/ReviewListServlet" class="active">Đánh giá</a>
                    <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                    <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
                </div>

                <div class="sidebar-footer">
                    <strong>Xin chào admin</strong>
                    <span>Trả lời đánh giá</span>
                </div>
                <a href="#" class="logout-link">Đăng xuất</a>
            </div>

            <div class="content">
                <div class="header-section">
                    <h2>Phản hồi Review</h2>
                    <p>Admin phản hồi đánh giá của khách hàng.</p>
                </div>

                <div class="form-card">
                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <c:if test="${not empty review}">
                        <%-- Hiển thị thông tin review gốc --%>
                        <div class="review-info">
                            <div class="review-info__header">
                                <div class="review-info__user">${review.reviewerName}</div>
                                <div class="review-info__stars">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${star <= review.ranking}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="review-info__content">${review.review}</div>
                            <div class="review-info__date">
                                <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                <c:if test="${review.verified}">
                                    <span style="margin-left: 12px; color: #059669;">✓ Đã xác nhận mua hàng</span>
                                </c:if>
                            </div>

                            <%-- Nếu đã có phản hồi --%>
                            <c:if test="${not empty review.replyContent}">
                                <div class="reply-section">
                                    <div class="reply-section__label">Phản hồi của Admin</div>
                                    <div class="reply-section__content">${review.replyContent}</div>
                                    <div class="reply-section__date">
                                        <fmt:formatDate value="${review.replyDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <%-- Form phản hồi --%>
                        <form action="${ctx}/ReviewReplyServlet" method="post">
                            <input type="hidden" name="id" value="${review.idReview}">

                            <div class="field">
                                <label>Phản hồi của Admin</label>
                                <textarea class="textarea" name="replyContent" placeholder="Nhập phản hồi cho khách hàng...">${review.replyContent}</textarea>
                            </div>

                            <div class="actions">
                                <a href="${ctx}/ReviewListServlet" class="btn-f btn-cancel">Hủy</a>
                                <button type="submit" class="btn-f btn-save">Lưu phản hồi</button>
                            </div>
                        </form>
                    </c:if>

                    <c:if test="${empty review}">
                        <div class="error-msg">Không tìm thấy review.</div>
                        <a href="${ctx}/ReviewListServlet" class="btn-f btn-cancel">Quay lại</a>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>