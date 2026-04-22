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
        
        <style>
            :root {
                --bg-body: #f4f7fe;
                --bg-sidebar: #1e293b;
                --bg-card: #ffffff;
                --primary: #4318ff;
                --text-main: #1b2559;
                --text-muted: #a3aed0;
                --border: #e9edf7;
                --success: #05cd99;
                --warning: #ffb81c;
                --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
                --sidebar-active: #aff22f;
            }

            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
            body { background-color: var(--bg-body); color: var(--text-main); }
            
            .container { display: flex; min-height: 100vh; }
            
        /* ===== SIDEBAR – Version Gold ===== */
        .sidebar {
            width: 260px;
            background: #1e293b;
            padding: 24px 0;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            z-index: 100;
            color: white;
            overflow-y: auto;
        }
        .sidebar .brand {
            padding: 0 24px;
            margin-bottom: 40px;
            text-decoration: none;
            color: white;
            display: block;
        }
        .sidebar .brand h2 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        
        .nav-section { margin-bottom: 32px; }
        .nav-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            color: #64748b;
            letter-spacing: 1px;
            margin-bottom: 12px;
            display: block;
            padding: 0 24px;
        }
        
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 24px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            border-left: 4px solid transparent;
            transition: 0.3s;
        }
        .menu-link i { width: 20px; text-align: center; }
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active {
            background: rgba(175, 242, 47, 0.1);
            color: #aff22f;
            border-left-color: #aff22f;
            font-weight: 600;
        }
        /* ===== END SIDEBAR ===== */

            .main { flex: 1; margin-left: 260px; padding: 40px; }
            .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
            
            .msg-card { background: white; border-radius: 20px; padding: 24px; margin-bottom: 20px; box-shadow: var(--shadow); border: 1px solid transparent; }
            .msg-header { display: flex; justify-content: space-between; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 16px; }
            .user-info h4 { font-size: 1.1rem; font-weight: 700; margin-bottom: 4px; }
            .user-info p { font-size: 0.85rem; color: var(--text-muted); }
            
            .badge { padding: 4px 12px; border-radius: 999px; font-size: 11px; font-weight: 800; text-transform: uppercase; }
            .badge-new { background: #e9e3ff; color: var(--primary); }
            .badge-read { background: #e6f9f4; color: var(--success); }
            .badge-replied { background: #fff8e6; color: var(--warning); }
            
            .content { font-size: 0.95rem; line-height: 1.6; color: #475569; margin-bottom: 20px; }
            
            .admin-action { background: #f8fafc; border-radius: 12px; padding: 16px; border: 1px solid var(--border); }
            .notes-area { width: 100%; border: 1px solid var(--border); border-radius: 8px; padding: 10px; font-size: 0.9rem; margin-bottom: 12px; }
            .btn-save { background: var(--primary); color: white; border: none; padding: 8px 20px; border-radius: 8px; font-weight: 700; cursor: pointer; }
            
            .pagination { display: flex; gap: 8px; justify-content: center; margin-top: 32px; }
            .page-link { width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 8px; text-decoration: none; color: inherit; font-weight: 700; box-shadow: var(--shadow); }
            .page-link.active { background: var(--primary); color: white; }

            /* Validation styles */
            .error-feedback {
                color: #ee5d50;
                font-size: 11px;
                font-weight: 600;
                margin-top: 4px;
                display: none;
            }
            .has-error .notes-area {
                border-color: #ee5d50 !important;
                background-color: #fff5f5 !important;
            }
            .has-error .error-feedback {
                display: block;
            }
            .char-counter {
                font-size: 10px;
                color: var(--text-muted);
                text-align: right;
                margin-top: 2px;
            }
        </style>
    </head>
    <body>
        <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <!-- 1. TỔNG QUAN -->
            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 2. QUẢN LÝ BÁN HÀNG -->
            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="#" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 3. TƯƠNG TÁC & NỘI DUNG -->
            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link active">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 4. CẤU HÌNH GIAO DIỆN -->
            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 5. HỆ THỐNG -->
            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

            <main class="main">
                <div class="header">
                    <h1>Liên hệ khách hàng</h1>
                    <div>
                        <span style="font-weight: 800; color: var(--primary); font-size: 1.5rem;">${totalMessages}</span>
                        <p style="font-size: 12px; color: var(--text-muted); text-align: right;">Tin nhắn yêu cầu</p>
                    </div>
                </div>

                <c:forEach items="${contacts}" var="m">
                    <div class="msg-card">
                        <div class="msg-header">
                            <div class="user-info">
                                <h4>${m.fullName}</h4>
                                <p><i class="fa-solid fa-envelope" style="margin-right: 5px;"></i> ${m.email} &nbsp; | &nbsp; <i class="fa-solid fa-phone" style="margin-right: 5px;"></i> ${m.phoneNumber}</p>
                            </div>
                            <div>
                                <span class="badge badge-${m.status.toLowerCase()}">${m.status}</span>
                                <p style="font-size: 11px; color: var(--text-muted); margin-top: 8px; text-align: right;">
                                    <fmt:formatDate value="${m.sentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </p>
                            </div>
                        </div>
                        
                        <div class="content">
                            <p style="font-weight: 700; font-size: 0.8rem; text-transform: uppercase; color: var(--text-muted); margin-bottom: 8px;">Nội dung yêu cầu:</p>
                            ${m.messageContent}
                        </div>

                        <div class="admin-action">
                            <form action="${ctx}/admin/contacts" method="post">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="id" value="${m.contactId}"/>
                                <input type="hidden" name="page" value="${currentPage}"/>
                                
                                <div style="display: flex; gap: 16px; align-items: flex-start;">
                                    <div style="flex: 1;">
                                        <label style="font-size: 11px; font-weight: 800; margin-bottom: 4px; display: block;">GHI CHÚ / PHẢN HỒI NỘI BỘ</label>
                                        <textarea name="adminNotes" class="notes-area admin-notes-input" rows="2" placeholder="Ghi chú kết quả xử lý tại đây..." maxlength="500">${m.adminNotes}</textarea>
                                        <div class="char-counter">0/500</div>
                                        <div class="error-feedback">Ghi chú không được vượt quá 500 ký tự.</div>
                                    </div>
                                    <div style="width: 180px;">
                                        <label style="font-size: 11px; font-weight: 800; margin-bottom: 4px; display: block;">TRẠNG THÁI</label>
                                        <select name="status" class="notes-area" style="margin-bottom: 12px;">
                                            <option value="NEW" ${m.status eq 'NEW' ? 'selected' : ''}>Mới tiếp nhận</option>
                                            <option value="READ" ${m.status eq 'READ' ? 'selected' : ''}>Đang xử lý / Đã đọc</option>
                                            <option value="REPLIED" ${m.status eq 'REPLIED' ? 'selected' : ''}>Đã phản hồi khách</option>
                                        </select>
                                        <button type="submit" class="btn-save" style="width: 100%;">Cập nhật lưu</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>
                    </div>
                </c:if>
            </main>
        </div>
        <script>
            document.querySelectorAll('.admin-notes-input').forEach(textarea => {
                const container = textarea.parentElement;
                const counter = container.querySelector('.char-counter');
                const errorFeedback = container.querySelector('.error-feedback');

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
                textarea.addEventListener('blur', validate);
                
                // Initialize
                validate();

                // Form submit validation
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
