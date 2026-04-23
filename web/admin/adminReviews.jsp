<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đánh giá - MobileShop</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
    
    <style>
        :root {
            --bg-body: #f4f7fe;
            --bg-card: #ffffff;
            --primary: #4318ff;
            --primary-light: #e9e3ff;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border: #e9edf7;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
            --danger: #ee5d50;
        }

        .page-header { margin-bottom: 32px; display: flex; justify-content: space-between; align-items: flex-end; }
        .page-header h1 { font-size: 1.8rem; font-weight: 800; color: var(--text-main); }
        
        .filter-tabs { display: flex; gap: 12px; margin-bottom: 32px; background: white; padding: 6px; border-radius: 12px; width: fit-content; box-shadow: var(--shadow); }
        .tab { padding: 8px 20px; border-radius: 8px; font-size: 0.85rem; font-weight: 700; text-decoration: none; color: var(--text-muted); transition: 0.3s; }
        .tab.active { background: var(--primary); color: white; }
        .tab:hover:not(.active) { background: #f4f7fe; color: var(--primary); }

        .rv-card { background: var(--bg-card); border-radius: 20px; padding: 24px; margin-bottom: 24px; box-shadow: var(--shadow); border: 1px solid transparent; transition: 0.3s; }
        .rv-card:hover { transform: translateY(-5px); border-color: var(--primary-light); }
        
        .rv-card__top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px; }
        .rv-product-name { font-size: 1.1rem; font-weight: 700; color: var(--text-main); margin: 0; }
        .rv-user-info { font-size: 0.85rem; color: var(--text-muted); display: flex; align-items: center; gap: 8px; }
        .stars { color: #ffb800; font-size: 0.8rem; }
        .stars i.off { color: #e2e8f0; }

        .status-badge { padding: 6px 12px; border-radius: 8px; font-size: 0.75rem; font-weight: 700; display: inline-flex; align-items: center; gap: 6px; }
        .status-visible { background: #dcfce7; color: #166534; }
        .status-hidden { background: #fee2e2; color: #991b1b; }

        .rv-content { font-size: 0.95rem; line-height: 1.6; color: #475569; margin-bottom: 20px; padding: 16px; background: #f8fafc; border-radius: 12px; }

        /* Reply Section */
        .reply-box {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px;
            border: 1px solid var(--border);
        }
        .reply-existing {
            padding-bottom: 16px;
            margin-bottom: 16px;
            border-bottom: 1px dashed var(--border);
            font-size: 0.9rem;
            color: #1e293b;
        }
        .reply-existing strong { color: var(--primary); display: block; margin-bottom: 4px; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; }

        .reply-form { display: flex; gap: 12px; }
        .reply-input-wrapper { flex: 1; display: flex; flex-direction: column; }
        .reply-input {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px;
            font-size: 0.9rem;
            resize: none;
            height: 80px;
            transition: 0.3s;
            background: #f8fafc;
        }
        .reply-input:focus { outline: none; border-color: var(--primary); background: #fff; box-shadow: 0 0 0 4px var(--primary-light); }

        .btn-action {
            padding: 10px 24px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.85rem;
            cursor: pointer;
            border: none;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: #3311cc; transform: translateY(-2px); }
        .btn-toggle { background: white; border: 1px solid var(--border); color: var(--text-main); }
        .btn-toggle:hover { background: #f1f5f9; }

        /* Pagination */
        .pagination { display: flex; gap: 8px; justify-content: center; margin-top: 40px; }
        .page-link {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 10px;
            text-decoration: none;
            color: var(--text-main);
            font-weight: 700;
            box-shadow: var(--shadow);
            transition: 0.3s;
        }
        .page-link.active { background: var(--primary); color: white; }
        .page-link:hover:not(.active) { background: var(--primary-light); color: var(--primary); }

        .empty-state { text-align: center; padding: 80px; background: white; border-radius: 30px; box-shadow: var(--shadow); }

        /* Validation */
        .error-feedback { color: var(--danger); font-size: 11px; font-weight: 600; margin-top: 4px; display: none; }
        .has-error .reply-input { border-color: var(--danger) !important; background-color: #fff5f5 !important; }
        .has-error .error-feedback { display: block; }
        .char-counter { font-size: 10px; color: var(--text-muted); text-align: right; margin-top: 2px; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="reviews" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header">
                <div>
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Hệ thống phản hồi</p>
                    <h1>Quản lý đánh giá</h1>
                </div>
                <div style="text-align: right;">
                    <span style="font-weight: 700; color: var(--primary); font-size: 1.2rem;">${totalReviews}</span>
                    <span style="color: var(--text-muted); font-size: 0.85rem; display: block;">Tổng số đánh giá</span>
                </div>
            </header>

            <%-- Filter tabs --%>
            <div style="display: flex; gap: 24px; margin-bottom: 32px; align-items: center; flex-wrap: wrap;">
                <div class="filter-tabs">
                    <a class="tab ${empty statusFilter ? 'active' : ''}" href="${ctx}/admin/reviews?type=${typeFilter}">Tất cả trạng thái</a>
                    <a class="tab ${'VISIBLE' eq statusFilter ? 'active' : ''}" href="${ctx}/admin/reviews?status=VISIBLE&type=${typeFilter}">Đang hiện</a>
                    <a class="tab ${'HIDDEN' eq statusFilter ? 'active' : ''}" href="${ctx}/admin/reviews?status=HIDDEN&type=${typeFilter}">Đang ẩn</a>
                </div>

                <div class="filter-tabs">
                    <a class="tab ${empty typeFilter ? 'active' : ''}" href="${ctx}/admin/reviews?status=${statusFilter}">Mọi loại đánh giá</a>
                    <a class="tab ${'PRODUCT' eq typeFilter ? 'active' : ''}" href="${ctx}/admin/reviews?type=PRODUCT&status=${statusFilter}">Sản phẩm</a>
                    <a class="tab ${'SERVICE' eq typeFilter ? 'active' : ''}" href="${ctx}/admin/reviews?type=SERVICE&status=${statusFilter}">Dịch vụ</a>
                </div>
            </div>

            <%-- Danh sách --%>
            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="empty-state">
                        <i class="fa-solid fa-comment-slash" style="font-size: 3rem; color: #e2e8f0; margin-bottom: 16px;"></i>
                        <p>Không tìm thấy đánh giá nào trong hệ thống.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${reviews}" var="rv">
                        <div class="rv-card">
                            <div class="rv-card__top">
                                <div style="flex: 1;">
                                    <c:choose>
                                        <c:when test="${rv.reviewType eq 'PRODUCT'}">
                                            <h3 class="rv-product-name"><i class="fa-solid fa-box" style="font-size: 0.8rem; margin-right: 8px;"></i>${rv.productName}</h3>
                                        </c:when>
                                        <c:otherwise>
                                            <h3 class="rv-product-name" style="color: var(--primary);"><i class="fa-solid fa-shop" style="font-size: 0.8rem; margin-right: 8px;"></i>Đánh giá dịch vụ</h3>
                                            <c:if test="${not empty rv.reviewTopic}">
                                                <div style="margin-top: 4px;">
                                                    <c:forEach items="${rv.reviewTopic.split(', ')}" var="t">
                                                        <span style="font-size: 11px; background: var(--primary-light); color: var(--primary); padding: 2px 8px; border-radius: 4px; font-weight: 700; margin-right: 4px;">${t}</span>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="rv-user-info" style="margin-top: 8px;">
                                        <span style="font-weight: 700; color: var(--text-main);">${rv.reviewerName}</span>
                                        <span>&bull;</span>
                                        <fmt:formatDate value="${rv.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        <span>&bull;</span>
                                        <span class="stars">
                                            <c:forEach begin="1" end="5" var="s">
                                                <i class="fa-solid fa-star ${s <= rv.ranking ? '' : 'off'}"></i>
                                            </c:forEach>
                                        </span>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 12px; align-items: center;">
                                    <span class="status-badge ${rv.status eq 'VISIBLE' ? 'status-visible' : 'status-hidden'}">
                                        <i class="fa-solid ${rv.status eq 'VISIBLE' ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                        ${rv.status eq 'VISIBLE' ? 'Công khai' : 'Đã ẩn'}
                                    </span>
                                    <form method="post" action="${ctx}/admin/reviews">
                                        <input type="hidden" name="action" value="toggle"/>
                                        <input type="hidden" name="reviewId" value="${rv.reviewId}"/>
                                        <input type="hidden" name="page" value="${currentPage}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <input type="hidden" name="typeFilter" value="${typeFilter}"/>
                                        <button type="submit" class="btn-action btn-toggle">
                                            ${rv.status eq 'VISIBLE' ? 'Ẩn đi' : 'Hiện lại'}
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <div class="rv-content">${rv.reviewContent}</div>

                            <%-- Phản hồi --%>
                            <div class="reply-box">
                                <c:if test="${not empty rv.replyContent}">
                                    <div class="reply-existing">
                                        <strong>Phản hồi từ Admin &bull; <fmt:formatDate value="${rv.replyDate}" pattern="dd/MM/yyyy"/></strong>
                                        ${rv.replyContent}
                                    </div>
                                </c:if>
                                <form method="post" action="${ctx}/admin/reviews" class="reply-form">
                                    <input type="hidden" name="action" value="reply"/>
                                    <input type="hidden" name="reviewId" value="${rv.reviewId}"/>
                                    <input type="hidden" name="page" value="${currentPage}"/>
                                    <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                    <input type="hidden" name="typeFilter" value="${typeFilter}"/>
                                    <div class="reply-input-wrapper">
                                        <textarea name="replyContent" class="reply-input admin-reply-input"
                                                  placeholder="${not empty rv.replyContent ? 'Sửa lại phản hồi...' : 'Gửi lời phản hồi tới khách hàng...'}"
                                                  maxlength="1000">${rv.replyContent}</textarea>
                                        <div class="char-counter">0/1000</div>
                                        <div class="error-feedback">Phản hồi không được vượt quá 1000 ký tự.</div>
                                    </div>
                                    <button type="submit" class="btn-action btn-primary">${not empty rv.replyContent ? 'Cập nhật' : 'Gửi đi'}</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <%-- Phân trang --%>
            <c:if test="${totalPages > 1}">
                <nav class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="${ctx}/admin/reviews?page=${currentPage-1}&status=${statusFilter}&type=${typeFilter}"><i class="fa-solid fa-chevron-left"></i></a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <a class="page-link ${currentPage == p ? 'active' : ''}"
                           href="${ctx}/admin/reviews?page=${p}&status=${statusFilter}&type=${typeFilter}">${p}</a>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="${ctx}/admin/reviews?page=${currentPage+1}&status=${statusFilter}&type=${typeFilter}"><i class="fa-solid fa-chevron-right"></i></a>
                    </c:if>
                </nav>
            </c:if>
        </main>
    </div>

    <script>
        document.querySelectorAll('.admin-reply-input').forEach(textarea => {
            const container = textarea.parentElement;
            const counter = container.querySelector('.char-counter');

            const validate = () => {
                const len = textarea.value.length;
                counter.textContent = `\${len}/1000`;
                
                if (len > 1000) {
                    container.classList.add('has-error');
                    return false;
                } else {
                    container.classList.remove('has-error');
                    return true;
                }
            };

            textarea.addEventListener('input', validate);
            validate();

            const form = textarea.closest('form');
            form.addEventListener('submit', (e) => {
                if (!validate()) {
                    e.preventDefault();
                    alert('Phản hồi quá dài! Vui lòng rút ngắn xuống dưới 1000 ký tự.');
                }
            });
        });
    </script>
</body>
</html>
