<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Sửa đánh giá</title>
        <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css" type="text/css">
        <style>
            :root {
                --primary-blue: #5b74f1;
                --danger-bg: #fff4f5;
                --danger-text: #ea4f68;
                --success-bg: #ecfdf5;
                --success-text: #059669;
            }

            body {
                font-family: 'Inter', 'Segoe UI', sans-serif;
                background: #f5f7ff;
                margin: 0;
                padding: 20px;
            }

            .edit-container {
                max-width: 600px;
                margin: 0 auto;
                background: #ffffff;
                border-radius: 20px;
                padding: 30px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.08);
            }

            .edit-header {
                margin-bottom: 24px;
            }

            .edit-header h2 {
                margin: 0 0 8px;
                font-size: 24px;
                font-weight: 800;
                color: #24345f;
            }

            .edit-header p {
                margin: 0;
                color: #64748b;
                font-size: 14px;
            }

            .review-info {
                background: #f8fafc;
                border-radius: 14px;
                padding: 16px;
                margin-bottom: 24px;
            }

            .review-info__date {
                font-size: 12px;
                color: #94a3b8;
            }

            .field { margin-bottom: 20px; }

            .field label {
                display: block;
                font-size: 13px;
                font-weight: 700;
                color: #24345f;
                margin-bottom: 10px;
            }

            .textarea {
                width: 100%;
                border: 1px solid #eaf0ff;
                border-radius: 14px;
                padding: 14px 16px;
                font-size: 14px;
                outline: none;
                transition: all 0.2s;
                background: #fcfdff;
                resize: vertical;
                min-height: 120px;
                font-family: inherit;
            }

            .textarea:focus {
                border-color: var(--primary-blue);
                background: #fff;
                box-shadow: 0 0 0 4px rgba(91, 116, 241, 0.1);
            }

            .star-select {
                display: flex;
                gap: 8px;
            }

            .star-option { display: none; }

            .star-label {
                font-size: 32px;
                color: #d1d5db;
                cursor: pointer;
                transition: 0.2s;
            }

            .star-label:hover { transform: scale(1.1); }

            .star-option:checked + .star-label { color: #fbbf24; }

            .actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 24px;
            }

            .btn {
                padding: 12px 24px;
                border-radius: 999px;
                font-size: 14px;
                font-weight: 700;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-primary {
                background: var(--primary-blue);
                color: white;
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }

            .btn-secondary {
                background: #f8fafc;
                color: #64748b;
                border-color: #e2e8f0;
            }

            .btn-secondary:hover { background: #f1f5f9; }

            .error-msg {
                background: var(--danger-bg);
                color: var(--danger-text);
                padding: 14px;
                border-radius: 12px;
                font-size: 14px;
                margin-bottom: 20px;
                border: 1px solid #ffccd2;
            }

            .time-limit {
                background: #fffbeb;
                color: #d97706;
                padding: 12px;
                border-radius: 12px;
                font-size: 13px;
                margin-bottom: 20px;
                border: 1px solid #fcd34d;
            }
        </style>
    </head>
    <body>
        <div class="edit-container">
            <div class="edit-header">
                <h2>Sửa đánh giá của bạn</h2>
                <p>Cập nhật đánh giá sản phẩm.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <div class="time-limit">
                ⏰ Bạn chỉ có thể sửa đánh giá trong vòng 24 giờ kể từ khi đăng.
            </div>

            <c:if test="${not empty review}">
                <div class="review-info">
                    <div class="review-info__date">
                        Đánh giá ngày: <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                </div>

                <form action="${ctx}/UserReviewEditServlet" method="post">
                    <input type="hidden" name="id" value="${review.idReview}">
                    <input type="hidden" name="productId" value="${review.idProduct}">

                    <div class="field">
                        <label>Đánh giá của bạn</label>
                        <div class="star-select">
                            <c:forEach begin="1" end="5" var="star">
                                <input type="radio" name="ranking" value="${star}" id="star${star}" class="star-option" ${star == review.ranking ? 'checked' : ''}>
                                <label for="star${star}" class="star-label">★</label>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="field">
                        <label>Nội dung đánh giá</label>
                        <textarea class="textarea" name="review" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm...">${review.review}</textarea>
                    </div>

                    <div class="actions">
                        <a href="${ctx}/reviews?pid=${review.idProduct}" class="btn btn-secondary">Hủy</a>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </c:if>

            <c:if test="${empty review}">
                <div class="error-msg">Không tìm thấy đánh giá.</div>
                <a href="${ctx}/reviews.jsp" class="btn btn-secondary">Quay lại</a>
            </c:if>
        </div>
    </body>
</html>