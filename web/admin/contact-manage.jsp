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

        .char-counter { font-size: 10px; color: var(--text-muted); text-align: right; margin-top: 4px; }
        .has-error .notes-area { border-color: var(--danger) !important; background-color: #fff5f5 !important; }
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
                    
                    <div class="msg-content">
                        <p style="font-weight: 800; font-size: 0.7rem; text-transform: uppercase; color: var(--text-muted); margin-bottom: 8px; letter-spacing: 0.5px;">Nội dung tin nhắn:</p>
                        <div style="color: #1e293b;">${m.messageContent}</div>
                    </div>

                    <div class="admin-action-box">
                        <form action="${ctx}/admin/contacts" method="post">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="id" value="${m.contactId}"/>
                            <input type="hidden" name="page" value="${currentPage}"/>
                            
                            <div style="display: flex; gap: 20px; align-items: flex-start; flex-wrap: wrap;">
                                <div style="flex: 1; min-width: 300px;">
                                    <label class="field-label">Ghi chú xử lý nội bộ</label>
                                    <textarea name="adminNotes" class="notes-area admin-notes-input" rows="2" placeholder="Nhập ghi chú về kết quả liên hệ, tư vấn cho khách hàng..." maxlength="500">${m.adminNotes}</textarea>
                                    <div class="char-counter">0/500</div>
                                </div>
                                <div style="width: 200px;">
                                    <label class="field-label">Trạng thái xử lý</label>
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

            <c:if test="${totalPages > 1}">
                <nav class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
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
