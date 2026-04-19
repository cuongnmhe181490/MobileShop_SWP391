<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="heroImageUrl" value="https://cdn2.cellphones.com.vn/---/Hero-visual.jpg" />
<c:if test="${heroProduct != null}">
    <c:set var="heroImageUrl" value="${heroProduct.imagePath}" />
</c:if>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Config Hero banner</title>
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
                --danger-border: #ff7b8f;
                --danger-text: #ea4f68;
            }

            html, body {
                height: 100%;
                margin: 0;
                background: var(--page-bg);
                font-family: 'Inter', 'Segoe UI', sans-serif;
                color: var(--heading);
            }

            body {
                padding: 18px;
                overflow: hidden; /* khóa cuộn toàn trang */
            }

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

            .sidebar {
                width: 140px;
                flex: 0 0 140px;
                background: var(--sidebar-bg);
                color: white;
                border-radius: 24px;
                padding: 14px 10px;
                display: flex;
                flex-direction: column;
                margin-top: 50px;
                height: calc(80% - 10px);
                overflow-y: auto;
                overflow-x: hidden;
            }

            .sidebar h4 {
                margin: 0 0 8px;
                font-size: 20px;
                line-height: 1.15;
                font-weight: 800;
            }

            .brand-title {
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 6px;
            }

            .brand-subtitle {
                font-size: 11px;
                color: var(--sidebar-muted);
                margin-bottom: 18px;
            }

                        .sidebar {
                width: 140px;
                flex: 0 0 140px;
                background: var(--sidebar-bg);
                color: white;
                border-radius: 24px;
                padding: 14px 10px;
                display: flex;
                flex-direction: column;
                margin-top: 50px;
                height: calc(80% - 10px);
                overflow-y: auto;
                overflow-x: hidden;
            }

            .sidebar h4 {
                margin: 0 0 8px;
                font-size: 20px;
                line-height: 1.15;
                font-weight: 800;
            }

            .brand-title {
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 6px;
            }

            .brand-subtitle {
                font-size: 11px;
                color: var(--sidebar-muted);
                margin-bottom: 18px;
            }

            .nav-list {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .sidebar a {
                display: block;
                color: #f8faff;
                padding: 8px 12px;
                text-decoration: none;
                border-radius: 12px;
                font-weight: 600;
                font-size: 12px;
                transition: 0.2s ease;
                white-space: nowrap;
            }

            .sidebar a:not(.active) {
                color: var(--sidebar-muted);
            }

            .sidebar a.active {
                background: #ffffff;
                color: #1f2a56;
                box-shadow: 0 8px 18px rgba(7, 13, 32, 0.16);
            }

            .sidebar-footer {
                margin-top: 26px;
                background: #ffffff;
                color: #1e2b57;
                padding: 14px 12px;
                border-radius: 18px;
            }

            .sidebar-footer strong {
                display: block;
                font-size: 12px;
                margin-bottom: 2px;
                line-height: 1.2;
            }

            .sidebar-footer span {
                display: block;
                font-size: 10px;
                color: #7381a8;
            }

            .logout-link {
                margin-top: 8px;
                padding: 0 12px;
                text-decoration: none;
                color: #f8faff;
                font-weight: 800;
                font-size: 12px;
                white-space: nowrap;
            }

            .content {
                flex: 1;
                min-width: 0;
                padding: 4px 2px 8px;
                overflow-y: auto;
            }

            .header-section {
                margin-bottom: 18px;
                padding-left: 6px;
            }

            .header-section h2 {
                margin: 0 0 8px;
                font-size: 18px;
                font-weight: 800;
                color: var(--heading);
            }

            .header-section p {
                margin: 0;
                max-width: 760px;
                color: #7e8eb8;
                font-size: 13px;
                line-height: 1.55;
            }
            
            .input-readonly {
                width: 100%;
                border: 1px dashed #c9d6ff;
                background: #f0f4ff;
                border-radius: 14px;
                padding: 10px 12px;
                font-size: 12px;
                color: #3b5bdb;
                font-weight: 700;
                cursor: not-allowed;
            }

            .form-card {
                background: #ffffff;
                border: 1px solid var(--border-color);
                border-radius: 24px;
                padding: 18px;
                box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
            }

            .form-grid-3 {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
            }

            .form-grid-1 {
                display: grid;
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .field label {
                display: block;
                font-size: 10px;
                font-weight: 800;
                color: #7e8eb8;
                margin-bottom: 8px;
            }

            .input,
            .textarea {
                width: 100%;
                border: 1px solid #eaf0ff;
                background: #ffffff;
                border-radius: 14px;
                padding: 10px 12px;
                font-size: 12px;
                outline: none;
            }

            .input:focus,
            .textarea:focus {
                border-color: #c9d6ff;
                box-shadow: 0 0 0 3px rgba(91, 116, 241, 0.12);
            }

            .textarea {
                resize: vertical;
                min-height: 44px;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
                margin-top: 2px;
            }

            .actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 18px;
            }

            .btn-f {
                padding: 8px 18px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 800;
                text-decoration: none;
                border: 1px solid transparent;
                cursor: pointer;
            }

            .btn-save {
                background: var(--primary-blue);
                border-color: var(--primary-blue);
                color: #ffffff;
                box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24);
            }

            .btn-cancel {
                background: #ffffff;
                border-color: #e2e8f0;
                color: #1f2a56;
            }

            @media (max-width: 991px) {
                body {
                    padding: 12px;
                }
                .dashboard-shell {
                    flex-direction: column;
                }
                .sidebar {
                    width: 100%;
                    flex-basis: auto;
                    height: auto;
                    margin-top: 0;
                }
                .form-grid-3 {
                    grid-template-columns: 1fr;
                }
                .stats-row {
                    grid-template-columns: 1fr;
                }
                .actions {
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <div class="sidebar">
            <h4>MobileShop</h4>
            <div class="nav-list">
                <a href="${ctx}/HeroListServlet" class="active">Biểu ngữ chính</a>
                <a href="${ctx}/BrandListServlet">Thương hiệu</a>
                <a href="${ctx}/TopProductListServlet">Sản phẩm bán chạy</a>
                <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
            </div>
        </div>

            <div class="content">
                <div class="header-section">
                    <h2>Sửa Hero banner</h2>
                    <p>Cập nhật nội dung hiển thị cho banner chính trên trang chủ.</p>
                </div>

                <div class="form-card">
                    <form action="${ctx}/HeroEditServlet" method="post" id="heroForm">
                        <input type="hidden" name="id" value="${hero.id}">
                        <div class="form-grid-3">
                            <div class="field">
                                <label>Nhãn phụ</label>
                                <input class="input" type="text" name="eyebrow" value="${hero.eyebrow}"
                                       maxlength="50">
                            </div>

                            <div class="field">
                                <label>CTA chính <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="ctaPrimary" value="${hero.ctaPrimary}"
                                       required maxlength="30"
                                       title="Bắt buộc, tối đa 30 ký tự">
                            </div>

                            <div class="field">
                                <label>CTA phụ</label>
                                <input class="input" type="text" name="ctaSecondary" value="${hero.ctaSecondary}"
                                       maxlength="30">
                            </div>
                        </div>

                        <div class="form-grid-1" style="margin-top: 16px;">
                            <div class="field">
                                <label>Tiêu đề chính <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="text" name="title" value="${hero.title}"
                                       required minlength="5" maxlength="120"
                                       title="Bắt buộc, 5-120 ký tự">
                            </div>

                            <div class="field">
                                <label>Mô tả ngắn <span style="color:#ea4f68">*</span></label>
                                <textarea class="textarea" name="description"
                                          required maxlength="300"
                                          title="Bắt buộc, tối đa 300 ký tự">${hero.description}</textarea>
                            </div>

                            <div class="field">
                                <label>Ảnh visual <span style="color:#ea4f68">*</span></label>
                                <input class="input" type="url" name="imageUrl"
                                       value="${heroImageUrl}"
                                       required pattern="https?://.*\.(jpg|jpeg|png|gif|webp|svg)"
                                       title="Bắt buộc, URL ảnh hợp lệ (jpg, png, gif, webp, svg)">
                            </div>

                            <div class="stats-row">
                                <%-- STAT 1: Điểm hài lòng – tự động tính từ AVG(Ranking) ProductReview --%>
                                <div class="field">
                                    <label>Điểm hài lòng</label>
                                    <div class="input-readonly">
                                        <c:out value="${satisfactionRate}" default="0/5"/>
                                    </div>
                                 
                                </div>

                                <%-- STAT 2: Thời gian phản hồi – admin nhập thủ công --%>
                                <div class="field">
                                    <label>Thời gian phản hồi <span style="color:#ea4f68">*</span></label>
                                    <input class="input" type="text" name="stat2"
                                           value="${hero.stat2Label}"
                                           required maxlength="20"
                                           title="Bắt buộc, tối đa 20 ký tự">
                                </div>

                                <%-- STAT 3: Số mẫu máy – tự động đếm COUNT(*) ProductDetail --%>
                                <div class="field">
                                    <label>Số mẫu máy</label>
                                    <div class="input-readonly">
                                        +<c:choose>
                                            <c:when test="${not empty productCount}">${productCount}</c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </div>
                           
                                </div>
                            </div>

                            <div class="actions">
                                <button type="submit" class="btn-f btn-save">Lưu</button>
                                <a href="${ctx}/admin-home-config.jsp" class="btn-f btn-cancel">Hủy</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>

