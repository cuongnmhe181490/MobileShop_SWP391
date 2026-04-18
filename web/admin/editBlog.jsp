<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa bài viết - MobileShop</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    
    <!-- Custom Admin Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">MobileShop</div>
        <nav>
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-house"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/accounts">
                        <i class="fa-solid fa-users"></i>
                        <span>Quản lý tài khoản</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/products">
                        <i class="fa-solid fa-box-archive"></i>
                        <span>Quản lý sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/blog" class="active">
                        <i class="fa-solid fa-newspaper"></i>
                        <span>Quản lý blog</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Về trang chủ</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="user-info">
            <h4>Xin chào ${sessionScope.acc != null ? sessionScope.acc.name : "admin"}</h4>
            <p>Quản lý dữ liệu hệ thống</p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header-flex">
            <div>
                <h1 style="font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem;">Chỉnh sửa bài viết</h1>
                <p style="color: var(--text-muted);">Cập nhật thông tin bài viết ID: #${blog.idPost}</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/blog" class="btn-action btn-edit">Quay lại</a>
        </div>

        <div class="info-card" style="max-width: 900px;">
            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>
                    ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <!-- Form points to service=updateBlog -->
            <form id="blogForm" action="${pageContext.request.contextPath}/admin/blog?service=updateBlog" 
                  method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
                <!-- Hidden Field for ID -->
                <input type="hidden" name="idPost" value="${blog.idPost}">

                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-4">
                            <label class="form-label fw-bold">Tiêu đề bài viết <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" value="${blog.title}" 
                                   required maxlength="255" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div class="invalid-feedback">Vui lòng nhập tiêu đề bài viết (không quá 255 ký tự).</div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">Phụ đề (SubTitle)</label>
                            <input type="text" name="subTitle" class="form-control" value="${blog.subTitle}" 
                                   maxlength="255" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div class="invalid-feedback">Phụ đề không được vượt quá 255 ký tự.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Mô tả ngắn (Summary) <span class="text-danger">*</span></label>
                            <textarea name="summary" class="form-control" rows="3" required maxlength="500"
                                      style="padding: 0.75rem; border-radius: 0.75rem;">${blog.summary}</textarea>
                            <div class="invalid-feedback">Vui lòng nhập mô tả ngắn (không quá 500 ký tự).</div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="mb-4">
                            <label class="form-label fw-bold">Nhà cung cấp <span class="text-danger">*</span></label>
                            <select name="idSupplier" class="form-select" required style="padding: 0.75rem; border-radius: 0.75rem;">
                                <c:forEach items="${supList}" var="sup">
                                    <option value="${sup}" ${sup == blog.idSupplier ? 'selected' : ''}>${sup}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhà cung cấp.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Thay đổi ảnh đại diện</label>
                            <div class="mb-2" id="currentThumbnail">
                                <img src="${not empty blog.thumbnailPath ? blog.thumbnailPath : 'img/no-image.png'}" 
                                     class="blog-thumb-sm rounded shadow-sm" style="width: 100px; height: 75px; object-fit: cover;">
                            </div>
                            <input type="file" name="thumbnail" id="thumbnailInput" class="form-control" accept="image/*" 
                                   style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div id="imageFeedback" class="invalid-feedback">Vui lòng chọn ảnh định dạng: jpg, png, webp... và < 5MB.</div>
                            <div class="form-text mt-2">Để trống nếu không muốn thay đổi ảnh.</div>
                            
                            <!-- Image Preview Workspace -->
                            <div id="imagePreview" class="mt-3 d-none">
                                <p class="small mb-1 fw-bold text-success">Ảnh mới chọn:</p>
                                <img src="" id="imgPreview" class="rounded shadow-sm" style="max-width: 100%; height: auto; border: 1px solid #28a745;">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Nội dung chi tiết <span class="text-danger">*</span></label>
                    <textarea name="content" class="form-control" rows="12" required 
                              style="padding: 1rem; border-radius: 1rem;">${blog.content}</textarea>
                    <div class="invalid-feedback">Nội dung bài viết không được để trống.</div>
                </div>

                <hr style="margin: 2rem 0; opacity: 0.1;">

                <div class="d-flex justify-content-end gap-3">
                    <a href="${pageContext.request.contextPath}/admin/blog" class="btn-action btn-edit">Hủy bỏ</a>
                    <button type="submit" class="btn-action">Cập nhật bài viết</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Form Validation Logic
        (function () {
            'use strict'
            
            const form = document.querySelector('#blogForm');
            const thumbnailInput = document.querySelector('#thumbnailInput');
            const imagePreview = document.querySelector('#imagePreview');
            const imgPreview = document.querySelector('#imgPreview');
            const imageFeedback = document.querySelector('#imageFeedback');
            const currentThumbnail = document.querySelector('#currentThumbnail');

            // Handle Image Preview and Validation (Optional in Edit)
            thumbnailInput.addEventListener('change', function() {
                const file = this.files[0];
                if (file) {
                    // Check size (5MB limit)
                    if (file.size > 5 * 1024 * 1024) {
                        imageFeedback.textContent = "Kích thước ảnh quá lớn (Vui lòng chọn ảnh < 5MB).";
                        this.setCustomValidity("Too large");
                        imagePreview.classList.add('d-none');
                        currentThumbnail.style.opacity = "1";
                    } else if (!file.type.startsWith('image/')) {
                        imageFeedback.textContent = "Vui lòng chọn đúng định dạng file ảnh.";
                        this.setCustomValidity("Invalid type");
                        imagePreview.classList.add('d-none');
                        currentThumbnail.style.opacity = "1";
                    } else {
                        // Clear custom validity
                        this.setCustomValidity("");
                        
                        // Show preview
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            imgPreview.src = e.target.result;
                            imagePreview.classList.remove('d-none');
                            currentThumbnail.style.opacity = "0.3"; // Dim current thumbnail
                        };
                        reader.readAsDataURL(file);
                    }
                } else {
                    imagePreview.classList.add('d-none');
                    currentThumbnail.style.opacity = "1";
                }
            });

            // Prevent empty spaces validation
            const textInputs = form.querySelectorAll('input[type="text"], textarea');
            textInputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.value && this.value.trim() === "") {
                        this.value = ""; // Force clear if only spaces
                    }
                });
            });

            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
</html>
