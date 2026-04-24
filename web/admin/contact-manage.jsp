<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý liên hệ - Admin MobileShop</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
    
    <style>
        .page-header { margin-bottom: 32px; display: flex; justify-content: space-between; align-items: flex-end; }
        .page-header h1 { font-size: 1.8rem; font-weight: 800; color: var(--text-main); }

        .msg-card { background: white; border-radius: 20px; padding: 24px; margin-bottom: 24px; box-shadow: var(--shadow); border: 1px solid transparent; transition: 0.3s; }
        .msg-card:hover { transform: translateY(-5px); border-color: var(--primary-light); }

        .msg-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 16px; }
        .user-info h4 { font-size: 1.1rem; font-weight: 700; color: var(--text-main); margin: 0 0 4px 0; }
        .user-info p { font-size: 0.85rem; color: var(--text-muted); margin: 0; display: flex; align-items: center; gap: 12px; }
        
        .badge { padding: 6px 12px; border-radius: 8px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .badge-new { background: #e0e7ff; color: #4338ca; }
        .badge-read { background: #fef3c7; color: #92400e; }
        .badge-replied { background: #dcfce7; color: #166534; }

        .msg-content { font-size: 0.95rem; line-height: 1.6; color: #475569; margin-bottom: 24px; padding: 16px; background: #f8fafc; border-radius: 12px; border-left: 4px solid var(--primary); }

        .admin-action-box { background: #ffffff; border-radius: 16px; padding: 20px; border: 1px solid var(--border); }
        .field-label { font-size: 0.75rem; font-weight: 800; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; display: block; }
        
        .notes-area { width: 100%; border: 1px solid var(--border); border-radius: 12px; padding: 12px; font-size: 0.9rem; transition: 0.3s; background: #f8fafc; resize: none; }
        .notes-area:focus { outline: none; border-color: var(--primary); background: #fff; box-shadow: 0 0 0 4px var(--primary-light); }

        .form-select-custom { width: 100%; border: 1px solid var(--border); border-radius: 12px; padding: 10px; font-size: 0.9rem; background: #f8fafc; cursor: pointer; }

        .btn-save { background: var(--primary); color: white; border: none; padding: 12px 24px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: 0.3s; width: 100%; }
        .btn-save:hover { background: #3311cc; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(67, 24, 255, 0.3); }

        .pagination { display: flex; gap: 8px; justify-content: center; margin-top: 40px; }
        .page-link { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 10px; text-decoration: none; color: var(--text-main); font-weight: 700; box-shadow: var(--shadow); transition: 0.3s; }
        .page-link.active { background: var(--primary); color: white; }
        .page-link:hover:not(.active) { background: var(--primary-light); color: var(--primary); }

        .error-feedback { color: #ee5d50; font-size: 11px; font-weight: 600; margin-top: 4px; display: none; }
        .has-error .notes-area { border-color: #ee5d50 !important; background-color: #fff5f5 !important; }
        .has-error .error-feedback { display: block; }
        .char-counter { font-size: 10px; color: var(--text-muted); text-align: right; margin-top: 2px; }

        /* Filter bar */
        .filter-bar { background: white; border-radius: 16px; padding: 20px 24px; margin-bottom: 24px; box-shadow: var(--shadow); display: flex; gap: 20px; align-items: flex-end; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 6px; }
        .filter-label { font-size: 11px; font-weight: 800; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
        .filter-select { border: 1px solid var(--border); border-radius: 10px; padding: 10px 14px; font-size: 13px; color: var(--text-main); background: #f8fafc; min-width: 180px; outline: none; cursor: pointer; }
        .filter-select:focus { border-color: var(--primary); background: white; }
        .btn-filter { background: var(--primary); color: white; border: none; border-radius: 10px; padding: 10px 24px; font-weight: 700; font-size: 13px; cursor: pointer; transition: 0.2s; height: 40px; }
        .btn-filter:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(67, 24, 255, 0.2); }
        .btn-reset { background: #f1f5f9; color: #64748b; text-decoration: none; border-radius: 10px; padding: 10px 16px; font-weight: 700; font-size: 13px; transition: 0.2s; height: 40px; display: flex; align-items: center; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="contacts" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header">
                <div>
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Tương tác khách hàng</p>
                    <h1>Liên hệ & Tư vấn</h1>
                </div>
                <div style="text-align: right;">
                    <span style="font-weight: 800; color: var(--primary); font-size: 1.5rem;">${totalMessages}</span>
                    <p style="font-size: 12px; color: var(--text-muted); margin: 0;">Tổng số yêu cầu</p>
                </div>
            </header>

            <form action="${ctx}/admin/contacts" method="get" class="filter-bar">
                <div class="filter-group">
                    <label class="filter-label">Trạng thái</label>
                    <select name="status" class="filter-select">
                        <option value="">Tất cả trạng thái</option>
                        <option value="NEW" ${selectedStatus eq 'NEW' ? 'selected' : ''}>Mới tiếp nhận</option>
                        <option value="READ" ${selectedStatus eq 'READ' ? 'selected' : ''}>Đang xử lý / Đã đọc</option>
                        <option value="REPLIED" ${selectedStatus eq 'REPLIED' ? 'selected' : ''}>Đã phản hồi khách</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">Chủ đề</label>
                    <select name="topic" class="filter-select">
                        <option value="">Tất cả chủ đề</option>
                        <option value="Tư vấn mua hàng" ${selectedTopic eq 'Tư vấn mua hàng' ? 'selected' : ''}>Tư vấn mua hàng</option>
                        <option value="Thu cũ đổi mới" ${selectedTopic eq 'Thu cũ đổi mới' ? 'selected' : ''}>Thu cũ đổi mới</option>
                        <option value="Bảo hành & sửa chữa" ${selectedTopic eq 'Bảo hành & sửa chữa' ? 'selected' : ''}>Bảo hành & sửa chữa</option>
                        <option value="Đơn hàng & vận chuyển" ${selectedTopic eq 'Đơn hàng & vận chuyển' ? 'selected' : ''}>Đơn hàng & vận chuyển</option>
                        <option value="Khác" ${selectedTopic eq 'Khác' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
                <button type="submit" class="btn-filter">Lọc kết quả</button>
                <a href="${ctx}/admin/contacts" class="btn-reset">Đặt lại</a>
            </form>

            <c:choose>
                <c:when test="${not empty contacts}">
                    <c:forEach items="${contacts}" var="m">
                        <div class="msg-card">
                            <div class="msg-header">
                                <div class="user-info">
                                    <h4>${m.fullName}</h4>
                                    <p>
                                        <span><i class="fa-solid fa-envelope" style="color: var(--primary);"></i> ${m.email}</span>
                                        <span><i class="fa-solid fa-phone" style="color: var(--primary);"></i> ${m.phoneNumber}</span>
                                    </p>
                                </div>
                                <div style="text-align: right;">
                                    <span class="badge badge-${m.status.toLowerCase()}">${m.status}</span>
                                    <p style="font-size: 11px; color: var(--text-muted); margin-top: 8px;">
                                        <i class="fa-regular fa-clock"></i> <fmt:formatDate value="${m.sentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </div>
                            </div>
                            
                            <div class="content" style="margin-bottom: 24px;">
                                <div style="margin-bottom: 12px;">
                                    <p style="font-weight: 700; font-size: 0.8rem; text-transform: uppercase; color: var(--text-muted); margin-bottom: 4px;">Chủ đề:</p>
                                    <span style="font-weight: 600; color: var(--primary); background: #f0f3ff; padding: 4px 10px; border-radius: 6px; font-size: 0.9rem;">
                                        ${m.subject != null ? m.subject : 'Yêu cầu tư vấn'}
                                    </span>
                                </div>
                                <div class="msg-content">
                                    <p style="font-weight: 800; font-size: 0.7rem; text-transform: uppercase; color: var(--text-muted); margin-bottom: 8px; letter-spacing: 0.5px;">Nội dung tin nhắn:</p>
                                    <div style="color: #1e293b;">${m.messageContent}</div>
                                </div>
                            </div>

                            <div class="admin-action-box">
                                <form action="${ctx}/admin/contacts" method="post">
                                    <input type="hidden" name="action" value="update"/>
                                    <input type="hidden" name="id" value="${m.contactId}"/>
                                    <input type="hidden" name="page" value="${currentPage}"/>
                                    <input type="hidden" name="fStatus" value="${selectedStatus}"/>
                                    <input type="hidden" name="fTopic" value="${selectedTopic}"/>
                                    
                                    <div style="display: flex; gap: 20px; align-items: flex-start; flex-wrap: wrap;">
                                        <div style="flex: 1; min-width: 300px;">
                                            <label class="field-label">Ghi chú xử lý nội bộ</label>
                                            <textarea name="adminNotes" class="notes-area admin-notes-input" rows="2" placeholder="Nhập ghi chú xử lý..." maxlength="500">${m.adminNotes}</textarea>
                                            <div class="char-counter">0/500</div>
                                            <div class="error-feedback">Ghi chú không được vượt quá 500 ký tự.</div>
                                        </div>
                                        <div style="width: 200px;">
                                            <label class="field-label">Trạng thái</label>
                                            <select name="status" class="form-select-custom" style="margin-bottom: 16px;">
                                                <option value="NEW" ${m.status eq 'NEW' ? 'selected' : ''}>Mới tiếp nhận</option>
                                                <option value="READ" ${m.status eq 'READ' ? 'selected' : ''}>Đang xử lý / Đã đọc</option>
                                                <option value="REPLIED" ${m.status eq 'REPLIED' ? 'selected' : ''}>Đã phản hồi khách</option>
                                            </select>
                                            <button type="submit" class="btn-save">Lưu thay đổi</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 80px; background: white; border-radius: 24px; border: 1px solid var(--border);">
                        <i class="fas fa-envelope-open fa-3x mb-3" style="opacity: 0.1;"></i>
                        <p style="color: var(--text-muted);">Không có yêu cầu liên hệ nào phù hợp.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:if test="${totalPages > 1}">
                <nav class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?page=${i}&status=${selectedStatus}&topic=${selectedTopic}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
                    </c:forEach>
                </nav>
            </c:if>
        </main>
    </div>

    <script>
        document.querySelectorAll('.admin-notes-input').forEach(textarea => {
            const container = textarea.parentElement;
            const counter = container.querySelector('.char-counter');

            const validate = () => {
                const len = textarea.value.length;
                counter.textContent = `\${len}/500`;
                
                if (len > 500) {
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
                    alert('Ghi chú quá dài! Vui lòng rút ngắn xuống dưới 500 ký tự.');
                }
            });
        });
    </script>
</body>
</html>
