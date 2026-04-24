<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý trang chủ - MobileShop Admin</title>
        
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

            .grid-layout {
                display: grid;
                grid-template-columns: repeat(12, minmax(0, 1fr));
                gap: 24px;
            }

            .span-6 { grid-column: span 6; }
            .span-4 { grid-column: span 4; }
            .span-12 { grid-column: 1 / -1; }

            .card-box {
                background: var(--bg-card);
                border-radius: 24px;
                border: 1px solid var(--border);
                padding: 24px;
                display: flex;
                flex-direction: column;
                min-height: 250px;
                box-shadow: var(--shadow);
                transition: 0.3s;
            }
            .card-box:hover { transform: translateY(-5px); }

            .tag {
                display: inline-flex;
                align-items: center;
                width: fit-content;
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 0.7rem;
                font-weight: 700;
                margin-bottom: 16px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .card-box h5 { margin: 0 0 12px; font-size: 1.25rem; font-weight: 800; color: var(--text-main); }
            .card-box p { margin: 0 0 20px; font-size: 0.9rem; line-height: 1.6; color: var(--text-muted); }

            .card-visual {
                width: 100%;
                height: 80px;
                border-radius: 16px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                background: #f8fafc;
            }

            .shape-white, .shape-dark { width: 32px; height: 52px; border-radius: 12px; }
            .shape-white { background: #e0f2fe; transform: rotate(8deg); box-shadow: 0 6px 14px rgba(0,0,0,0.05); }
            .shape-dark { background: var(--sidebar-bg, #1e293b); transform: rotate(-8deg); }

            .btn-group-custom { display: flex; gap: 10px; margin-top: auto; flex-wrap: wrap; }
            .btn-f {
                padding: 8px 16px;
                border-radius: 10px;
                font-size: 0.85rem;
                font-weight: 700;
                text-decoration: none;
                border: 1px solid transparent;
                transition: 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-edit { background: #fffbeb; border-color: #fef3c7; color: #d97706; }
            .btn-edit:hover { background: #fef3c7; }
            .btn-add { background: #eef2ff; border-color: #e0e7ff; color: #4338ca; }
            .btn-add:hover { background: #e0e7ff; }
            .btn-list { background: #f0fdf4; border-color: #dcfce7; color: #166534; }
            .btn-list:hover { background: #dcfce7; }

            .bg-hero { background: #fff1f2; }
            .bg-brand { background: #f5f3ff; }
            .bg-product { background: #fffbeb; }
            .bg-promo { background: #f0fdf4; }

            .page-header { margin-bottom: 32px; }
            .page-header h2 { font-size: 1.8rem; font-weight: 800; color: var(--text-main); margin: 0; }
        </style>
    </head>
    <body>
        <div class="admin-layout">
            <c:set var="activePage" value="config_home" />
            <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

            <main class="main-content">
                <header class="page-header">
                    <p style="text-transform: uppercase; font-size: 0.75rem; color: var(--text-muted); font-weight: 700; letter-spacing: 1px; margin-bottom: 8px;">Giao diện & Trải nghiệm</p>
                    <h2>Cấu hình trang chủ</h2>
                </header>

                <div class="grid-layout">
                    <%-- Biểu ngữ chính --%>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#fff1f2; color:#e11d48;">Biểu ngữ</span>
                            <h5>Biểu ngữ chính (Hero)</h5>
                            <p>Quản lý các banner lớn hiển thị ngay đầu trang chủ để thu hút khách hàng.</p>
                            <div class="card-visual bg-hero">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <c:choose>
                                    <c:when test="${not empty activeHero}">
                                        <a href="${ctx}/HeroEditServlet?id=${activeHero.id}" class="btn-f btn-edit"><i class="fas fa-pen me-2"></i>Sửa</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/HeroListServlet" class="btn-f btn-edit"><i class="fas fa-pen me-2"></i>Sửa</a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${ctx}/HeroAddServlet" class="btn-f btn-add"><i class="fas fa-plus me-2"></i>Thêm</a>
                                <a href="${ctx}/HeroListServlet" class="btn-f btn-list"><i class="fas fa-list me-2"></i>Danh sách</a>
                            </div>
                        </div>
                    </div>

                    <%-- Thương hiệu --%>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#f5f3ff; color:#7c3aed;">Thương hiệu</span>
                            <h5>Thương hiệu đối tác</h5>
                            <p>Quản lý logo và thông tin các hãng sản xuất (Apple, Samsung, Oppo...).</p>
                            <div class="card-visual bg-brand">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <c:choose>
                                    <c:when test="${not empty latestSupplier}">
                                        <a href="${ctx}/BrandEditServlet?id=${latestSupplier.idSupplier}" class="btn-f btn-edit"><i class="fas fa-pen me-2"></i>Sửa</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/BrandListServlet" class="btn-f btn-edit"><i class="fas fa-pen me-2"></i>Sửa</a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${ctx}/BrandAddServlet" class="btn-f btn-add"><i class="fas fa-plus me-2"></i>Thêm</a>
                                <a href="${ctx}/BrandListServlet" class="btn-f btn-list"><i class="fas fa-list me-2"></i>Danh sách</a>
                            </div>
                        </div>
                    </div>

                    <%-- Sản phẩm nổi bật --%>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#fffbeb; color:#d97706;">Sản phẩm</span>
                            <h5>Sản phẩm nổi bật</h5>
                            <p>Lựa chọn các sản phẩm tốt nhất để hiển thị tại khu vực tiêu điểm trang chủ.</p>
                            <div class="card-visual bg-product">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <a href="${ctx}/TopProductListServlet" class="btn-f btn-edit"><i class="fas fa-gear me-2"></i>Quản lý</a>
                                <a href="${ctx}/TopProductAddServlet" class="btn-f btn-add"><i class="fas fa-plus me-2"></i>Thêm</a>
                                <a href="${ctx}/TopProductListServlet" class="btn-f btn-list"><i class="fas fa-list me-2"></i>Danh sách</a>
                            </div>
                        </div>
                    </div>

                    <%-- Trade-in --%>
                    <div class="span-6">
                        <div class="card-box">
                            <span class="tag" style="background:#f0fdf4; color:#16a34a;">Chương trình</span>
                            <h5>Cấu hình Trade-in</h5>
                            <p>Tùy chỉnh thông tin và các chính sách cho chương trình Thu cũ đổi mới.</p>
                            <div class="card-visual bg-promo">
                                <div class="shape-white"></div><div class="shape-dark"></div>
                            </div>
                            <div class="btn-group-custom">
                                <a href="${ctx}/TradeInConfigServlet?action=edit" class="btn-f btn-edit"><i class="fas fa-pen me-2"></i>Sửa</a>
                                <a href="${ctx}/TradeInConfigServlet?action=add" class="btn-f btn-add"><i class="fas fa-plus me-2"></i>Thêm</a>
                                <a href="${ctx}/TradeInConfigServlet" class="btn-f btn-list"><i class="fas fa-list me-2"></i>Danh sách</a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>

        <script>
            function showToast(message, type = 'success') {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                toast.style.cssText = `
                    min-width: 280px;
                    padding: 16px 20px;
                    margin-bottom: 12px;
                    border-radius: 12px;
                    background: \${type === 'success' ? '#4caf50' : '#f44336'};
                    color: white;
                    font-size: 13px;
                    font-weight: 600;
                    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
                    opacity: 0;
                    transform: translateX(50px);
                    transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                    display: flex;
                    align-items: center;
                    gap: 12px;
                `;
                
                const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';
                toast.innerHTML = `<i class="fa-solid \${icon}"></i> <span>\${message}</span>`;
                
                container.appendChild(toast);
                
                setTimeout(() => {
                    toast.style.opacity = '1';
                    toast.style.transform = 'translateX(0)';
                }, 10);
                
                setTimeout(() => {
                    toast.style.opacity = '0';
                    toast.style.transform = 'translateX(50px)';
                    setTimeout(() => toast.remove(), 400);
                }, 4000);
            }

            window.onload = function() {
                <c:if test="${not empty sessionScope.flashSuccess}">
                    showToast('${sessionScope.flashSuccess}', 'success');
                    <% session.removeAttribute("flashSuccess"); %>
                </c:if>
                <c:if test="${not empty sessionScope.flashError}">
                    showToast('${sessionScope.flashError}', 'error');
                    <% session.removeAttribute("flashError"); %>
                </c:if>
            };
        </script>
    </body>
</html>
