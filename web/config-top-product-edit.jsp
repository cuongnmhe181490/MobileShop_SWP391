<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">

<head>
    <title>Sửa Top Product</title>
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
            padding: 18px;
            box-shadow: 0 10px 26px rgba(130, 145, 197, 0.06);
        }

        .form-grid-3 { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; }
        .form-grid-1 { display: grid; grid-template-columns: 1fr; gap: 16px; }

        .field label { display: block; font-size: 10px; font-weight: 800; color: #7e8eb8; margin-bottom: 8px; }
        
        .input, .textarea {
            width: 100%;
            border: 1px solid #eaf0ff;
            background: #ffffff;
            border-radius: 14px;
            padding: 10px 12px;
            font-size: 12px;
            outline: none;
        }

        .input:focus, .textarea:focus {
            border-color: #c9d6ff;
            box-shadow: 0 0 0 3px rgba(91, 116, 241, 0.12);
        }

        .actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 18px; }

        .btn-f {
            padding: 8px 18px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            text-decoration: none;
            border: 1px solid transparent;
            cursor: pointer;
        }

        .btn-save { background: var(--primary-blue); border-color: var(--primary-blue); color: #ffffff; box-shadow: 0 8px 18px rgba(91, 116, 241, 0.24); }
        .btn-cancel { background: #ffffff; border-color: #e2e8f0; color: #1f2a56; }

        .flash-error {
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            color: var(--danger-text);
            border-radius: 14px;
            padding: 10px 14px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 14px;
        }

        .product-selector {
            background: #f8faff;
            border: 1px solid #e7ecfb;
            border-radius: 14px;
            padding: 12px;
            margin-bottom: 16px;
        }

        .product-selector label { font-size: 11px; font-weight: 700; color: #7e8eb8; margin-bottom: 6px; display: block; }
        .product-selector select {
            width: 100%;
            border: 1px solid #eaf0ff;
            background: #ffffff;
            border-radius: 10px;
            padding: 8px 12px;
            font-size: 12px;
            outline: none;
            cursor: pointer;
        }

        @media (max-width: 991px) {
            body { padding: 12px; }
            .dashboard-shell { flex-direction: column; }
            .sidebar { width: 100%; flex-basis: auto; height: auto; margin-top: 0; }
            .form-grid-3 { grid-template-columns: 1fr; }
            .actions { justify-content: center; }
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
                <a href="${ctx}/TopProductListServlet" class="active">Sản phẩm bán chạy</a>
                <a href="${ctx}/TradeInConfigServlet">Cấu hình Trade-in</a>
            </div>
        </div>

        <div class="content">
            <div class="header-section">
                <h2>Sửa sản phẩm nổi bật</h2>
            </div>

            <div class="form-card">
                <%-- Hiển thị lỗi nếu có --%>
                <c:if test="${not empty error}">
                    <div class="flash-error">${error}</div>
                </c:if>

                <%-- Dropdown chọn sản phẩm để sửa --%>
                <div class="product-selector">
                    <label>Chọn sản phẩm cần sửa:</label>
                    <select onchange="window.location.href='${ctx}/TopProductEditServlet?id=' + this.value">
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="tp" items="${topProductList}">
                            <option value="${tp.id}" ${topProduct != null && topProduct.id == tp.id ? 'selected' : ''}>
                                ${tp.displayOrder}. ${tp.productName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <c:choose>
                    <c:when test="${not empty topProduct}">
                        <form action="${ctx}/TopProductEditServlet" method="post" id="topproductForm">
                            <input type="hidden" name="id" value="${topProduct.id}">
                            
                            <div class="form-grid-3">
                                <div class="field">
                                    <label>Tên sản phẩm <span style="color:#ea4f68">*</span></label>
                                    <input class="input" type="text" name="productName"
                                           placeholder="Ví dụ: iPhone 15 Pro Max"
                                           required maxlength="100"
                                           value="${topProduct.productName}"
                                           title="Bắt buộc, tối đa 100 ký tự">
                                </div>
                                <div class="field">
                                    <label>Giá bán (VNĐ) <span style="color:#ea4f68">*</span></label>
                                    <input class="input" type="number" name="price"
                                           placeholder="Ví dụ: 29990000"
                                           required min="0" step="1000"
                                           value="${topProduct.price}"
                                           title="Bắt buộc, số dương">
                                </div>
                                <div class="field">
                                    <label>Giá gốc (VNĐ)</label>
                                    <input class="input" type="number" name="originalPrice"
                                           placeholder="Ví dụ: 32990000"
                                           min="0" step="1000"
                                           value="${topProduct.originalPrice > 0 ? topProduct.originalPrice : ''}"
                                           title="Giá trước khi giảm (optional)">
                                </div>
                            </div>

                            <div class="form-grid-1" style="margin-top: 16px;">
                                <div class="field">
                                    <label>URL Ảnh sản phẩm</label>
                                    <input class="input" type="url" name="productImage"
                                           placeholder="https://example.com/image.jpg"
                                           value="${topProduct.productImage}"
                                           title="Link ảnh sản phẩm (jpg, png, gif, webp)">
                                </div>

                                <div class="form-grid-3" style="margin-top: 0;">
                                    <div class="field">
                                        <label>Thứ tự hiển thị</label>
                                        <input class="input" type="number" name="displayOrder"
                                               min="1" value="${topProduct.displayOrder}"
                                               title="Thứ tự hiển thị trên trang chủ">
                                    </div>
                                    <div class="field">
                                        <label>Giảm giá (%)</label>
                                        <input class="input" type="number" name="discountPercent"
                                               placeholder="Ví dụ: 10"
                                               min="0" max="100"
                                               value="${topProduct.discountPercent}"
                                               title="Phần trăm giảm giá (0-100)">
                                    </div>
                                    <div class="field">
                                        <label>Trạng thái</label>
                                        <div style="display: flex; align-items: center; gap: 8px; margin-top: 8px;">
                                            <input type="checkbox" id="isActive" name="isActive" 
                                                   ${topProduct.active ? 'checked' : ''}
                                                   style="width: 16px; height: 16px; accent-color: #5b74f1;">
                                            <label for="isActive" style="margin: 0; font-size: 12px; color: #64748b;">Hiển thị trên trang chủ</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="actions">
                                    <button type="submit" class="btn-f btn-save">Lưu thay đổi</button>
                                    <a href="${ctx}/TopProductListServlet" class="btn-f btn-cancel">Hủy</a>
                                </div>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 40px; color: #94a3b8;">
                            Vui lòng chọn sản phẩm cần sửa từ danh sách trên.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>

</html>