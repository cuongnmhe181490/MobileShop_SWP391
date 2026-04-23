<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa bài viết - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
    <style>
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
    </style>
</head>
<body>
    <div class="admin-layout">
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
                        <a href="${pageContext.request.contextPath}/admin/products" class="menu-link">
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
                        <a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link">
                            <i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link">
                            <i class="fa-solid fa-star"></i>Đánh giá
                        </a>
                    </li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active">
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

        <main class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">Chỉnh sửa bài viết</h2>
                    <p class="text-secondary small">Cập nhật thông tin chi tiết bài viết ID: #${blog.blogId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/blog" class="btn btn-sm btn-light border">
                    <i class="fas fa-arrow-left me-2"></i> Quay lại
                </a>
            </div>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/blog" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="service" value="updateBlog">
                    <input type="hidden" name="blogId" value="${blog.blogId}">
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="label-custom">Tiêu đề bài viết <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="titleInput" class="form-input-custom" value="${blog.title}" required maxlength="255">
                                <div class="counter-wrap"><span class="counter-label" id="titleCounter">0 / 255</span></div>
                            </div>
                            
                            <div class="form-group">
                                <label class="label-custom">Phụ đề (SubTitle)</label>
                                <input type="text" name="subTitle" id="subTitleInput" class="form-input-custom" value="${blog.subTitle}" maxlength="255">
                                <div class="counter-wrap"><span class="counter-label" id="subTitleCounter">0 / 255</span></div>
                            </div>

                            <div class="form-group">
                                <label class="label-custom">Tóm tắt ngắn (Description) <span class="text-danger">*</span></label>
                                <textarea name="description" id="descInput" class="form-input-custom" rows="3" required maxlength="255">${blog.description}</textarea>
                                <div class="counter-wrap"><span class="counter-label" id="descCounter">0 / 255</span></div>
                            </div>

                            <div class="form-group mt-3">
                                <label class="label-custom">Nội dung chi tiết <span class="text-danger">*</span></label>
                                <textarea name="content" id="blogContent" class="form-input-custom" rows="15" required maxlength="4000">${blog.content}</textarea>
                                <div class="counter-wrap"><span class="counter-label" id="contentCounter">0 / 4000</span></div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="label-custom">Hãng / Category <span class="text-danger">*</span></label>
                                <select name="idSupplier" class="form-select form-input-custom" required>
                                    <c:forEach items="${supList}" var="sup">
                                        <option value="${sup}" ${sup == blog.idSupplier ? 'selected' : ''}>${sup}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="label-custom">Ảnh đại diện bài viết</label>
                                <div class="mb-2">
                                    <p class="small text-secondary mb-1">Ảnh hiện tại:</p>
                                    <img src="${not empty blog.imagePath ? blog.imagePath : 'img/no-image.png'}" class="rounded shadow-sm" style="width: 100%; height: 120px; object-fit: cover; border: 1px solid #e5e7eb;">
                                </div>
                                <div class="upload-zone" id="uploadZone">
                                    <i class="fas fa-folder-open upload-icon"></i>
                                    <div class="upload-text">Chọn ảnh mới hoặc <span>kéo thả</span></div>
                                    <div class="text-muted small mt-1">PNG, JPG, GIF tối đa 500KB</div>
                                    <input type="file" name="image" id="thumbInput" accept="image/*">
                                </div>
                                <div id="thumbPreview" class="mt-3 d-none">
                                    <img src="" id="imgShow" class="rounded shadow-sm" style="width: 100% !important; aspect-ratio: 16/9; object-fit: cover; border: 1px solid #e5e7eb; display: block;">
                                    <p class="text-center small text-muted mt-2">Xem trước ảnh bìa mới</p>
                                </div>
                                <p class="small text-muted mt-2">Để trống nếu không muốn thay đổi ảnh bìa.</p>
                            </div>
                        </div>
                    </div>

                    <div class="action-footer">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="btn-cancel">Hủy</a>
                        <button type="submit" class="btn-submit">Cập nhật bài viết <i class="fas fa-check-circle ms-1"></i></button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateCounter(inputId, counterId, maxLength) {
            var input = document.getElementById(inputId);
            var counter = document.getElementById(counterId);
            if (!input || !counter) return;
            
            // Khởi tạo giá trị ban đầu
            counter.textContent = input.value.length + " / " + maxLength;
            
            input.addEventListener('input', function() {
                var len = input.value.length;
                counter.textContent = len + " / " + maxLength;
            });
        }
        updateCounter('titleInput', 'titleCounter', 255);
        updateCounter('subTitleInput', 'subTitleCounter', 255);
        updateCounter('descInput', 'descCounter', 255);
        updateCounter('blogContent', 'contentCounter', 4000);

        document.getElementById('thumbInput').addEventListener('change', function() {
            var file = this.files[0];
            if (file) {
                // Kiểm tra dung lượng ngay tại Client (500KB)
                if (file.size > 500 * 1024) {
                    alert("Ảnh quá lớn! Vui lòng chọn ảnh dưới 500KB (Ảnh bạn chọn: " + (file.size/1024).toFixed(2) + "KB)");
                    this.value = ""; // Xóa file
                    document.getElementById('thumbPreview').classList.add('d-none');
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imgShow').src = e.target.result;
                    document.getElementById('thumbPreview').classList.remove('d-none');
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>
