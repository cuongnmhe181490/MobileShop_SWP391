<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${viewMode ? 'Chi tiết sản phẩm' : (editMode ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm')} - MobileShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- ===== SIDEBAR (đồng bộ từ dashboard.jsp) ===== -->
        <aside class="sidebar">
            <a href="${ctx}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin/dashboard" class="menu-link">
                            <i class="fa-solid fa-chart-line"></i>Dashboard
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin/orders" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/products" class="menu-link active">
                            <i class="fa-solid fa-boxes-stacked"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/accounts" class="menu-link">
                            <i class="fa-solid fa-user-gear"></i>Tài khoản
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/admin/blog" class="menu-link">
                            <i class="fa-solid fa-newspaper"></i>Blog / Tin tức
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/admin-home-config.jsp" class="menu-link">
                            <i class="fa-solid fa-house-chimney-window"></i>Trang chủ
                        </a>
                    </li>
                </ul>
            </div>

            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li class="menu-item">
                        <a href="${ctx}/home" class="menu-link">
                            <i class="fa-solid fa-globe"></i>Xem Website
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${ctx}/logout" class="menu-link">
                            <i class="fa-solid fa-power-off"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <header class="header">
                <div class="welcome">
                    <p class="admin-shell-eyebrow">QUẢN LÝ SẢN PHẨM</p>
                    <h1>${viewMode ? 'Chi tiết sản phẩm' : (editMode ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm')}</h1>
                    <p class="admin-shell-subtitle">${viewMode ? 'Xem thông tin chi tiết sản phẩm trong đúng shell dashboard admin.' : 'Cập nhật thông tin sản phẩm với cùng sidebar, spacing và vùng nội dung như dashboard gốc.'}</p>
                </div>
                <div class="header-actions">
                    <a href="${ctx}/admin/products" class="btn-outline" style="text-decoration: none;">Quay lại</a>
                    <div class="user-profile">
                        <div class="avatar">${sessionScope.acc != null ? sessionScope.acc.name.substring(0,1).toUpperCase() : "A"}</div>
                        <span style="font-weight: 600;">${sessionScope.acc != null ? sessionScope.acc.name : "Admin"}</span>
                    </div>
                </div>
            </header>

            <c:if test="${not empty formError}">
                <div class="admin-flash admin-flash--danger" role="alert">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>${formError}</span>
                </div>
            </c:if>

            <section class="content-card product-form-shell">
                <form id="productForm" action="${ctx}/admin/products?service=${editMode ? 'editProduct' : 'addProduct'}" method="POST" enctype="multipart/form-data" novalidate>
                    <input type="hidden" name="existingImagePath" value="${productForm.imagePath}">
                    <c:if test="${editMode or viewMode}">
                        <input type="hidden" name="idProduct" value="${productForm.idProduct}">
                    </c:if>

                    <div class="product-form-grid">
                        <label class="field-block">
                            <span class="field-label">Tên sản phẩm</span>
                            <input class="form-control form-input admin-product-input" type="text" name="productName" value="${param.productName != null ? param.productName : productForm.productName}" minlength="2" maxlength="200" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="productName">${errors.productName}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Giá</span>
                            <c:choose>
                                <c:when test="${viewMode}">
                                    <div class="product-detail-value"><fmt:formatNumber value="${productForm.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
                                </c:when>
                                <c:otherwise>
                                    <%
                                        String formattedPriceValue = "";
                                        Object productFormAttr = request.getAttribute("productForm");
                                        if (productFormAttr != null) {
                                            try {
                                                Object priceValue = productFormAttr.getClass().getMethod("getPrice").invoke(productFormAttr);
                                                if (priceValue != null) {
                                                    formattedPriceValue = new BigDecimal(String.valueOf(priceValue)).stripTrailingZeros().toPlainString();
                                                }
                                            } catch (Exception ignored) {
                                            }
                                        }
                                        pageContext.setAttribute("formattedPriceValue", formattedPriceValue);
                                    %>
                                    <div class="input-suffix-wrap">
                                        <input class="form-control form-input admin-product-input admin-product-input--suffix" type="text" inputmode="numeric" name="price" id="price" value="${param.price != null ? param.price : formattedPriceValue}">
                                        <span class="input-suffix">VNĐ</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <span class="field-help">Giá được nhập theo đơn vị VNĐ.</span>
                            <span class="field-error" data-error-for="price">${errors.price}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Số lượng hiện tại</span>
                            <input class="form-control form-input admin-product-input" type="text" inputmode="numeric" name="quantity" id="quantity" value="${param.quantity != null ? param.quantity : productForm.quantity}" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="quantity">${errors.quantity}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Ngày ra mắt</span>
                            <input class="form-control form-input admin-product-input" type="date" name="releaseDate" value="${param.releaseDate != null ? param.releaseDate : productForm.releaseDate}" max="${todayDate}" ${viewMode ? 'disabled' : ''}>
                            <span class="field-help">Nếu bỏ trống khi thêm mới, hệ thống sẽ dùng ngày hiện tại.</span>
                            <span class="field-error" data-error-for="releaseDate">${errors.releaseDate}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Nhà cung cấp</span>
                            <select class="form-select admin-product-input" name="idSupplier" id="idSupplier" ${viewMode ? 'disabled' : ''}>
                                <option value="">-- Chọn nhà cung cấp --</option>
                                <c:set var="selectedSupplier" value="${param.idSupplier != null ? param.idSupplier : productForm.idSupplier}" />
                                <option value="Apple" ${selectedSupplier == 'Apple' ? 'selected' : ''}>Apple</option>
                                <option value="Samsung" ${selectedSupplier == 'Samsung' ? 'selected' : ''}>Samsung</option>
                                <option value="Oppo" ${selectedSupplier == 'Oppo' ? 'selected' : ''}>Oppo</option>
                                <option value="Xiaomi" ${selectedSupplier == 'Xiaomi' ? 'selected' : ''}>Xiaomi</option>
                                <option value="Huawei" ${selectedSupplier == 'Huawei' ? 'selected' : ''}>Huawei</option>
                                <option value="Realme" ${selectedSupplier == 'Realme' ? 'selected' : ''}>Realme</option>
                                <option value="Google" ${selectedSupplier == 'Google' ? 'selected' : ''}>Google</option>
                            </select>
                            <span class="field-error" data-error-for="idSupplier">${errors.idSupplier}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Màn hình</span>
                            <input class="form-control form-input admin-product-input" type="text" name="screen" value="${param.screen != null ? param.screen : productForm.screen}" maxlength="200" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="screen">${errors.screen}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Hệ điều hành</span>
                            <input class="form-control form-input admin-product-input" type="text" name="operatingSystem" value="${param.operatingSystem != null ? param.operatingSystem : productForm.operatingSystem}" maxlength="100" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="operatingSystem">${errors.operatingSystem}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">CPU</span>
                            <input class="form-control form-input admin-product-input" type="text" name="cpu" value="${param.cpu != null ? param.cpu : productForm.cpu}" maxlength="100" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="cpu">${errors.cpu}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">RAM</span>
                            <input class="form-control form-input admin-product-input" type="text" name="ram" id="ram" value="${param.ram != null ? param.ram : productForm.ram}" maxlength="50" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="ram">${errors.ram}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Camera</span>
                            <input class="form-control form-input admin-product-input" type="text" name="camera" value="${param.camera != null ? param.camera : productForm.camera}" maxlength="200" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="camera">${errors.camera}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Pin</span>
                            <input class="form-control form-input admin-product-input" type="text" name="battery" id="battery" value="${param.battery != null ? param.battery : productForm.battery}" maxlength="5" inputmode="numeric" ${viewMode ? 'disabled' : ''}>
                            <span class="field-error" data-error-for="battery">${errors.battery}</span>
                        </label>
                    </div>

                    <label class="field-block field-block--full">
                        <span class="field-label">Mô tả</span>
                        <textarea class="form-control form-input admin-product-input admin-textarea" name="description" maxlength="2000" ${viewMode ? 'disabled' : ''}>${param.description != null ? param.description : productForm.description}</textarea>
                        <span class="field-error" data-error-for="description">${errors.description}</span>
                    </label>

                    <div class="product-image-grid">
                        <label class="field-block">
                            <span class="field-label">Ảnh sản phẩm (URL)</span>
                            <input class="form-control form-input admin-product-input" type="url" name="imagePath" id="imagePath" value="${param.imagePath != null ? param.imagePath : productForm.imagePath}" placeholder="https://example.com/image.jpg" maxlength="500" ${viewMode ? 'disabled' : ''}>
                            <span class="field-help">Nhập URL ảnh hoặc chọn file cục bộ bên cạnh.</span>
                            <span class="field-error" data-error-for="imagePath">${errors.imagePath}</span>
                        </label>

                        <label class="field-block">
                            <span class="field-label">Tải ảnh từ máy</span>
                            <input class="form-control form-input admin-product-input" type="file" name="imageFile" id="imageFile" accept="image/png,image/jpeg,image/jpg,image/gif,image/webp" ${viewMode ? 'disabled' : ''}>
                            <span class="field-help">Chỉ nhận ảnh hợp lệ, tối đa 500KB.</span>
                            <span class="field-error" data-error-for="imageFile">${errors.imageFile}</span>
                        </label>
                    </div>

                    <div class="image-preview-panel">
                        <span class="field-label">Xem trước ảnh</span>
                        <div class="image-preview-frame">
                            <img id="imagePreview" src="${resolvedImagePath}" alt="Product preview" onerror="this.onerror=null;this.src='${ctx}/img/categories/cat-1.jpg';">
                        </div>
                    </div>

                    <c:if test="${viewMode}">
                        <div class="product-detail-grid">
                            <div class="field-block">
                                <span class="field-label">Nhà cung cấp</span>
                                <div class="product-detail-value">${productForm.idSupplier}</div>
                            </div>
                            <div class="field-block">
                                <span class="field-label">Số lượng hiện tại</span>
                                <div class="product-detail-value">${productForm.quantity}</div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not viewMode}">
                        <div class="form-actions-row">
                            <a href="${ctx}/admin/products" class="btn-outline" style="text-decoration: none;">Hủy</a>
                            <button type="submit" class="btn-primary">${editMode ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm'}</button>
                        </div>
                    </c:if>
                </form>
            </section>
        </main>
    </div>

    <script>
        const form = document.getElementById('productForm');
        const viewMode = ${viewMode ? 'true' : 'false'};
        const imageUrlInput = document.getElementById('imagePath');
        const imageFileInput = document.getElementById('imageFile');
        const preview = document.getElementById('imagePreview');
        const priceInput = document.getElementById('price');
        const quantityInput = document.getElementById('quantity');
        const batteryInput = document.getElementById('battery');

        function setError(field, message) {
            const el = document.querySelector('[data-error-for="' + field + '"]');
            if (el) {
                el.textContent = message || '';
            }
        }

        function clearClientErrors() {
            document.querySelectorAll('.field-error').forEach((item) => {
                item.dataset.serverMessage = item.textContent || '';
                item.textContent = item.dataset.serverMessage || '';
            });
        }

        function validateMaxLength(fieldName, maxLength, message) {
            const input = form.elements[fieldName];
            if (!input) {
                return false;
            }
            if (input.value.trim().length > maxLength) {
                setError(fieldName, message);
                return true;
            }
            return false;
        }

        function validatePositiveIntegerNoLeadingZero(fieldName, options) {
            const input = form.elements[fieldName];
            const value = input.value.trim();
            if (!value) {
                if (options.required) {
                    setError(fieldName, options.requiredMessage || 'Trường này là bắt buộc.');
                    return true;
                }
                return false;
            }

            if (!/^[0-9]+$/.test(value)) {
                setError(fieldName, options.invalidMessage || 'Chỉ được nhập số nguyên dương.');
                return true;
            }

            if (value.length > 1 && value.startsWith('0')) {
                setError(fieldName, options.leadingZeroMessage || 'Giá trị không được bắt đầu bằng số 0.');
                return true;
            }

            const number = Number(value);
            if (!Number.isSafeInteger(number) || number <= 0) {
                setError(fieldName, options.invalidMessage || 'Chỉ được nhập số nguyên dương.');
                return true;
            }

            if (options.maxDigits && value.length > options.maxDigits) {
                setError(fieldName, options.maxDigitsMessage || ('Giá trị tối đa ' + options.maxDigits + ' chữ số.'));
                return true;
            }

            return false;
        }

        function validateQuantity(fieldName) {
            const input = form.elements[fieldName];
            const value = input.value.trim();
            if (!value) {
                setError(fieldName, 'Trường này là bắt buộc.');
                return true;
            }
            if (!/^[0-9]+$/.test(value)) {
                setError(fieldName, 'Số lượng phải là số nguyên hợp lệ.');
                return true;
            }
            return false;
        }

        function trimFormValues() {
            ['productName', 'releaseDate', 'screen', 'operatingSystem', 'cpu', 'ram', 'camera', 'battery', 'description', 'idSupplier', 'imagePath', 'price', 'quantity'].forEach((field) => {
                if (form.elements[field] && typeof form.elements[field].value === 'string') {
                    form.elements[field].value = form.elements[field].value.trim();
                }
            });
        }

        function validateImageUrl(url) {
            return new Promise((resolve) => {
                if (!url) {
                    resolve(true);
                    return;
                }
                const img = new Image();
                const timeout = setTimeout(() => resolve(false), 5000);
                img.onload = () => {
                    clearTimeout(timeout);
                    preview.src = url;
                    resolve(true);
                };
                img.onerror = () => {
                    clearTimeout(timeout);
                    resolve(false);
                };
                img.src = url;
            });
        }

        function restrictNumericInput(input) {
            if (!input) {
                return;
            }

            input.addEventListener('keydown', (event) => {
                const allowedKeys = ['Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight', 'Home', 'End'];
                if (allowedKeys.includes(event.key) || event.ctrlKey || event.metaKey) {
                    return;
                }
                if (!/^[0-9]$/.test(event.key)) {
                    event.preventDefault();
                }
            });

            input.addEventListener('input', () => {
                input.value = input.value.replace(/[^0-9]/g, '');
            });
        }

        if (!viewMode) {
            restrictNumericInput(priceInput);
            restrictNumericInput(quantityInput);
            restrictNumericInput(batteryInput);

            imageUrlInput.addEventListener('blur', async () => {
                const value = imageUrlInput.value.trim();
                if (!value) {
                    return;
                }
                const ok = await validateImageUrl(value);
                if (!ok) {
                    setError('imagePath', 'Không thể tải ảnh từ URL đã nhập.');
                }
            });

            imageFileInput.addEventListener('change', () => {
                setError('imageFile', '');
                const file = imageFileInput.files[0];
                if (!file) {
                    return;
                }

                const validTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/gif', 'image/webp'];
                if (!validTypes.includes(file.type)) {
                    setError('imageFile', 'Chỉ chấp nhận file ảnh hợp lệ: png, jpg, jpeg, gif, webp.');
                    imageFileInput.value = '';
                    return;
                }
                if (file.size > 500 * 1024) {
                    setError('imageFile', 'Kích thước ảnh tối đa là 500KB.');
                    imageFileInput.value = '';
                    return;
                }
                preview.src = URL.createObjectURL(file);
            });

            form.addEventListener('submit', async (event) => {
                clearClientErrors();
                trimFormValues();

                let hasError = false;
                ['productName', 'idSupplier', 'price', 'quantity', 'battery'].forEach((field) => {
                    if (!form.elements[field].value.trim()) {
                        setError(field, 'Trường này là bắt buộc.');
                        hasError = true;
                    }
                });

                if (form.elements['productName'].value.trim().length > 0 && form.elements['productName'].value.trim().length < 2) {
                    setError('productName', 'Tên sản phẩm phải có ít nhất 2 ký tự.');
                    hasError = true;
                }

                hasError = validatePositiveIntegerNoLeadingZero('price', {
                    required: true,
                    invalidMessage: 'Giá phải là số nguyên dương lớn hơn 0.',
                    leadingZeroMessage: 'Giá không được bắt đầu bằng số 0.'
                }) || hasError;

                hasError = validateQuantity('quantity') || hasError;

                hasError = validatePositiveIntegerNoLeadingZero('battery', {
                    required: true,
                    invalidMessage: 'Pin phải là giá trị số hợp lệ.',
                    leadingZeroMessage: 'Pin không được bắt đầu bằng số 0.',
                    maxDigits: 5,
                    maxDigitsMessage: 'Pin không được vượt quá 5 chữ số.'
                }) || hasError;

                hasError = validateMaxLength('productName', 200, 'Tên sản phẩm không được vượt quá 200 ký tự.') || hasError;
                hasError = validateMaxLength('screen', 200, 'Màn hình không được vượt quá 200 ký tự.') || hasError;
                hasError = validateMaxLength('operatingSystem', 100, 'Hệ điều hành không được vượt quá 100 ký tự.') || hasError;
                hasError = validateMaxLength('cpu', 100, 'CPU không được vượt quá 100 ký tự.') || hasError;
                hasError = validateMaxLength('ram', 50, 'RAM không được vượt quá 50 ký tự.') || hasError;
                hasError = validateMaxLength('camera', 200, 'Camera không được vượt quá 200 ký tự.') || hasError;
                hasError = validateMaxLength('description', 2000, 'Mô tả không được vượt quá 2000 ký tự.') || hasError;
                hasError = validateMaxLength('imagePath', 500, 'Đường dẫn ảnh không được vượt quá 500 ký tự.') || hasError;

                if (!imageFileInput.files.length && !imageUrlInput.value.trim() && !form.elements['existingImagePath'].value.trim()) {
                    setError('imagePath', 'Ảnh sản phẩm là bắt buộc. Chọn file hoặc nhập URL ảnh hợp lệ.');
                    hasError = true;
                }

                if (!imageFileInput.files.length && imageUrlInput.value.trim()) {
                    const ok = await validateImageUrl(imageUrlInput.value.trim());
                    if (!ok) {
                        setError('imagePath', 'Không thể tải ảnh từ URL đã nhập.');
                        hasError = true;
                    }
                }

                if (hasError) {
                    event.preventDefault();
                }
            });
        }
    </script>
</body>
</html>
