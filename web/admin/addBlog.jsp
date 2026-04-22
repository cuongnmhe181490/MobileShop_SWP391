<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm bài viết mới - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-custom.css">
    <style>
        :root {
            --primary-bg: #ffffff;
            --input-bg: #fdfdfd;
            --border-clr: #e5e7eb;
            --text-main: #111827;
            --text-sub: #6b7280;
        }
        * { box-sizing: border-box; }
        body { background-color: #f9fafb; font-family: 'Inter', sans-serif; margin: 0; }
        
        /* Cấu trúc Layout chính kế thừa từ admin-custom.css */
        .main-content { margin-left: 260px; padding: 40px; background: #f9fafb; min-height: 100vh; }
        
        /* Định dạng Form */
        .form-container { background: var(--primary-bg); border-radius: 12px; padding: 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); width: 100%; }
        .form-group { margin-bottom: 20px; position: relative; }
        .label-custom { display: block; font-weight: 600; color: var(--text-main); margin-bottom: 8px; font-size: 0.95rem; }
        .form-input-custom { 
            width: 100%; border: 1px solid var(--border-clr); border-radius: 8px; 
            padding: 8px 12px; background: var(--input-bg); color: var(--text-main);
            transition: border-color 0.2s; resize: none; font-size: 0.9rem;
        }
        .form-input-custom:focus { outline: none; border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); }
        
        /* Bộ đếm ký tự nằm dưới góc phải */
        .counter-wrap { display: flex; justify-content: flex-end; margin-top: 4px; }
        .counter-label { font-size: 0.75rem; color: var(--text-sub); }

        /* Khung Upload Ảnh */
        .upload-zone {
            border: 2px dashed var(--border-clr); border-radius: 12px;
            padding: 40px 20px; text-align: center; cursor: pointer;
            transition: all 0.2s; background: #fafafa; position: relative;
        }
        .upload-zone:hover { border-color: #4f46e5; background: #f5f3ff; }
        .upload-icon { font-size: 2rem; color: #9ca3af; margin-bottom: 12px; }
        .upload-text { font-size: 0.9rem; color: var(--text-sub); }
        .upload-text span { color: #4f46e5; font-weight: 600; }
        #thumbInput { position: absolute; width: 100%; height: 100%; top: 0; left: 0; opacity: 0; cursor: pointer; }

        /* Nút bấm ở dưới cùng bên phải */
        .action-footer { display: flex; justify-content: flex-end; gap: 12px; margin-top: 40px; padding-top: 20px; border-top: 1px solid var(--border-clr); }
        .btn-cancel { padding: 10px 24px; border-radius: 8px; background: #f3f4f6; color: var(--text-main); border: none; font-weight: 600; }
        .btn-submit { padding: 10px 24px; border-radius: 8px; background: #111827; color: white; border: none; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .btn-submit:hover { background: #1f2937; }

        /* Modal Quản lý danh mục - Light Theme */
        .modal-content-custom { background: #ffffff; border-radius: 16px; border: 1px solid #e5e7eb; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); padding: 0; overflow: hidden; }
        .modal-header-custom { padding: 20px 24px; border-bottom: 1px solid #f3f4f6; display: flex; justify-content: space-between; align-items: center; }
        .modal-title-custom { font-size: 1.25rem; font-weight: 700; color: #111827; margin: 0; }
        .modal-body-custom { padding: 24px; }
        .modal-footer-custom { padding: 16px 24px; border-top: 1px solid #f3f4f6; display: flex; justify-content: flex-end; background: #f9fafb; }
        .cat-input-group { display: flex; gap: 10px; margin-bottom: 20px; }
        .cat-list { max-height: 300px; overflow-y: auto; border: 1px solid #f3f4f6; border-radius: 8px; background: #fdfdfd; }
        .cat-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 16px; border-bottom: 1px solid #f3f4f6; transition: background 0.2s; }
        .cat-item:last-child { border-bottom: none; }
        .cat-item:hover { background: #f9fafb; }
        .cat-name-wrapper { flex: 1; display: flex; align-items: center; gap: 8px; }
        .cat-name { font-weight: 500; color: #374151; }
        .btn-edit-cat { color: #6366f1; background: transparent; border: none; cursor: pointer; padding: 4px 8px; border-radius: 4px; opacity: 0.6; transition: opacity 0.2s; }
        .btn-edit-cat:hover { opacity: 1; color: #4f46e5; }
        .btn-delete-cat { color: #ef4444; background: transparent; border: none; cursor: pointer; padding: 4px 8px; border-radius: 4px; opacity: 0.6; transition: opacity 0.2s; }
        .btn-delete-cat:hover { opacity: 1; color: #dc2626; }
        .btn-manage-cat { padding: 8px 14px; border: 1px solid #e5e7eb; border-radius: 8px; background: #ffffff; color: #374151; font-weight: 600; font-size: 0.85rem; display: flex; align-items: center; gap: 6px; cursor: pointer; white-space: nowrap; }
        .btn-manage-cat:hover { background: #f9fafb; border-color: #d1d5db; }
        .btn-add-cat { padding: 0 20px; background: #111827; color: white; border: none; border-radius: 8px; font-weight: 600; }
        .close-modal-btn { background: #f3f4f6; border: none; border-radius: 6px; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; color: #6b7280; cursor: pointer; }
        .empty-cats { padding: 40px; text-align: center; color: #9ca3af; font-style: italic; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-table-columns"></i>Dashboard</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="#" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                    <li class="menu-item">
                        <a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link">
                            <i class="fa-solid fa-receipt"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="menu-item"><a href="#" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active"><i class="fa-solid fa-newspaper"></i>Blog</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/AdminHomeConfigServlet" class="menu-link"><i class="fa-solid fa-home"></i>Trang chủ</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">HỆ THỐNG</span>
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-house"></i>Về trang chủ</a></li>
                </ul>
            </div>

            <div style="margin-top: auto;">
                <ul class="sidebar-menu">
                    <li class="menu-item"><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-arrow-right-from-bracket"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">Thêm bài viết mới</h2>
                    <p class="text-secondary small">Vui lòng điền đầy đủ các thông tin dưới đây.</p>
                </div>
                <button onclick="history.back()" class="btn btn-sm btn-light border">
                    <i class="fas fa-arrow-left me-2"></i> Quay lại
                </button>
            </div>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/blog" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="service" value="insertBlog">
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="label-custom">Tiêu đề bài viết <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="titleInput" class="form-input-custom" placeholder="Nhập tiêu đề ..." required maxlength="255">
                                <div class="counter-wrap"><span class="counter-label" id="titleCounter">0 / 255</span></div>
                            </div>
                            
                            <div class="form-group">
                                <label class="label-custom">Phụ đề </label>
                                <input type="text" name="subTitle" id="subTitleInput" class="form-input-custom" placeholder="(Không bắt buộc)..." maxlength="255">
                                <div class="counter-wrap"><span class="counter-label" id="subTitleCounter">0 / 255</span></div>
                            </div>

                            <div class="form-group">
                                <label class="label-custom">Tóm tắt ngắn  <span class="text-danger">*</span></label>
                                <textarea name="description" id="descInput" class="form-input-custom" rows="3" required maxlength="255" placeholder="Mô tả  cho bài viết..."></textarea>
                                <div class="counter-wrap"><span class="counter-label" id="descCounter">0 / 255</span></div>
                            </div>

                            <div class="form-group mt-3">
                                <label class="label-custom">Nội dung chi tiết <span class="text-danger">*</span></label>
                                <textarea name="content" id="blogContent" class="form-input-custom" rows="15" required maxlength="4000" placeholder="Viết nội dung bài viết..."></textarea>
                                <div class="counter-wrap"><span class="counter-label" id="contentCounter">0 / 4000</span></div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="label-custom">Danh mục bài viết <span class="text-danger">*</span></label>
                                <div class="d-flex gap-2">
                                    <select name="idBlogCat" id="categorySelect" class="form-select form-input-custom" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <c:forEach items="${catList}" var="cat">
                                            <option value="${cat.idBlogCat}">${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="button" class="btn-manage-cat" data-bs-toggle="modal" data-bs-target="#manageCatModal">
                                        <i class="fa-solid fa-square-pen"></i> Quản lý
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="label-custom">Ảnh bìa bài viết <span class="text-danger">*</span></label>
                                <div class="upload-zone" id="uploadZone">
                                    <i class="fas fa-folder-open upload-icon"></i>
                                    <div class="upload-text">Kéo thả hoặc <span>chọn file</span></div>
                                    <div class="text-muted small mt-1">PNG, JPG, GIF tối đa 500KB</div>
                                    <input type="file" name="image" id="thumbInput" accept="image/*" required>
                                </div>
                                <div id="thumbPreview" class="mt-3 d-none">
                                    <img src="" id="imgShow" class="rounded shadow-sm" style="width: 100% !important; aspect-ratio: 16/9; object-fit: cover; border: 1px solid #e5e7eb; display: block;">
                                    <p class="text-center small text-muted mt-2">Xem trước ảnh bìa (Tỉ lệ 16:9)</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="action-footer">
                        <button type="button" onclick="history.back()" class="btn-cancel">Hủy</button>
                        <button type="submit" class="btn-submit">Đăng bài viết <i class="fas fa-external-link-alt ms-1" style="font-size: 0.8rem;"></i></button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <div class="modal fade" id="manageCatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header-custom">
                    <h5 class="modal-title-custom">Quản lý danh mục</h5>
                    <button type="button" class="close-modal-btn" data-bs-dismiss="modal"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body-custom">
                    <div class="cat-input-group">
                        <input type="text" id="newCatName" class="form-input-custom" placeholder="Tên danh mục mới...">
                        <button type="button" id="btnAddCat" class="btn-add-cat">+ Thêm</button>
                    </div>
                    <div class="cat-list" id="catListContainer"><div class="empty-cats">Đang tải danh mục...</div></div>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-cancel" data-bs-dismiss="modal" style="padding: 8px 20px;">Đóng</button>
                </div>
            </div>
        </div>
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

        // Preview Image and Validation
        document.getElementById('thumbInput').addEventListener('change', function() {
            var file = this.files[0];
            if (file) {
                // 1. Kiểm tra dung lượng (500KB)
                if (file.size > 500 * 1024) {
                    alert("Ảnh quá lớn! Vui lòng chọn ảnh dưới 500KB để tối ưu tốc độ tải trang.");
                    this.value = "";
                    document.getElementById('thumbPreview').classList.add('d-none');
                    return;
                }
                
                var reader = new FileReader();
                reader.onload = function(e) {
                    var img = new Image();
                    img.onload = function() {
                        // 2. Kiểm tra độ phân giải (Tối thiểu 800x450 để tránh bị mờ)
                        if (this.width < 800 || this.height < 450) {
                            alert("Ảnh có độ phân giải quá thấp (" + this.width + "x" + this.height + "px). \nVui lòng chọn ảnh có chiều ngang tối thiểu 800px để tránh bị mờ trên giao diện.");
                            document.getElementById('thumbInput').value = "";
                            document.getElementById('thumbPreview').classList.add('d-none');
                            return;
                        }
                        
                        document.getElementById('imgShow').src = e.target.result;
                        document.getElementById('thumbPreview').classList.remove('d-none');
                        document.getElementById('uploadZone').style.borderColor = "#4f46e5";
                    };
                    img.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });

        // Safe AJAX for Category Management
        try {
            const categoryModal = document.getElementById('manageCatModal');
            const catListContainer = document.getElementById('catListContainer');
            const btnAddCat = document.getElementById('btnAddCat');
            const newCatNameInput = document.getElementById('newCatName');
            const categorySelect = document.getElementById('categorySelect');

            function loadCategories() {
                fetch('${pageContext.request.contextPath}/admin/blog?service=listCategories')
                    .then(response => response.json())
                    .then(data => {
                        renderCatList(data);
                        updateSelectOptions(data);
                    });
            }

            function renderCatList(cats) {
                if (cats.length === 0) {
                    catListContainer.innerHTML = '<div class="empty-cats">Chưa có danh mục nào</div>';
                    return;
                }
                let html = '';
                cats.forEach(cat => {
                    html += `
                        <div class="cat-item">
                            <div class="cat-name-wrapper" id="cat-display-\${cat.id}">
                                <span class="cat-name">\${cat.name}</span>
                                <button type="button" class="btn-edit-cat" onclick="showEditInput(\${cat.id}, '\${cat.name.replace(/'/g, "\\'")}')">
                                    <i class="fas fa-pen-to-square"></i>
                                </button>
                            </div>
                            <div class="cat-edit-wrapper d-none" id="cat-edit-\${cat.id}" style="flex: 1; display: flex; gap: 5px;">
                                <input type="text" class="form-input-custom" value="\${cat.name}" id="input-edit-\${cat.id}" style="padding: 4px 8px; height: 32px;">
                                <button type="button" class="btn-add-cat" style="padding: 0 10px; height: 32px; font-size: 0.75rem;" onclick="saveCategory(\${cat.id})">Lưu</button>
                                <button type="button" class="btn-cancel" style="padding: 0 10px; height: 32px; font-size: 0.75rem;" onclick="cancelEdit(\${cat.id})">Hủy</button>
                            </div>
                            <button type="button" class="btn-delete-cat" onclick="deleteCategory(\${cat.id})">
                                <i class="fas fa-trash-can"></i>
                            </button>
                        </div>
                    `;
                });
                catListContainer.innerHTML = html;
            }

            window.showEditInput = function(id, currentName) {
                document.getElementById('cat-display-' + id).classList.add('d-none');
                document.getElementById('cat-edit-' + id).classList.remove('d-none');
                const input = document.getElementById('input-edit-' + id);
                input.focus();
                input.select();
            };

            window.cancelEdit = function(id) {
                document.getElementById('cat-display-' + id).classList.remove('d-none');
                document.getElementById('cat-edit-' + id).classList.add('d-none');
            };

            window.saveCategory = function(id) {
                const newName = document.getElementById('input-edit-' + id).value.trim();
                if (!newName) return;
                fetch(`${pageContext.request.contextPath}/admin/blog?service=updateCategory&id=\${id}&name=` + encodeURIComponent(newName))
                    .then(r => r.text()).then(res => {
                        if (res === 'success') {
                            loadCategories();
                        } else {
                            alert('Lỗi cập nhật danh mục!');
                        }
                    });
            };

            function updateSelectOptions(cats) {
                const currentValue = categorySelect.value;
                let html = '<option value="">-- Chọn danh mục --</option>';
                cats.forEach(cat => {
                    html += `<option value="\${cat.id}" \${currentValue == cat.id ? 'selected' : ''}>\${cat.name}</option>`;
                });
                categorySelect.innerHTML = html;
            }

            btnAddCat.addEventListener('click', function() {
                const name = newCatNameInput.value.trim();
                if (!name) {
                    alert('Tên danh mục không được để trống!');
                    return;
                }
                if (name.length < 2 || name.length > 50) {
                    alert('Tên danh mục phải từ 2 đến 50 ký tự!');
                    return;
                }
                const regex = /^[a-zA-Z0-9À-ỹ\s]+$/;
                if (!regex.test(name)) {
                    alert('Tên danh mục không được chứa ký tự đặc biệt!');
                    return;
                }
                
                fetch(`${pageContext.request.contextPath}/admin/blog?service=addCategory&name=` + encodeURIComponent(name))
                    .then(r => r.text()).then(res => { 
                        if (res === 'success') { 
                            newCatNameInput.value = ''; 
                            loadCategories(); 
                        } else if (res === 'duplicate') {
                            alert('Tên danh mục này đã tồn tại!');
                        } else if (res === 'invalid_length') {
                            alert('Tên danh mục không hợp lệ (2-50 ký tự)!');
                        }
                    });
            });

            window.deleteCategory = function(id) {
                if (!confirm('Xóa danh mục này? Bạn có chắc không?')) return;
                fetch(`${pageContext.request.contextPath}/admin/blog?service=deleteCategory&id=` + id)
                    .then(r => r.text()).then(res => { if (res === 'success') loadCategories(); else alert('Lỗi xóa danh mục! Có thể danh mục đang được sử dụng.'); });
            };

            categoryModal.addEventListener('show.bs.modal', function () { loadCategories(); });
        } catch (e) { console.error("Cat Manage JS Error: ", e); }
    </script>
</body>
</html>
