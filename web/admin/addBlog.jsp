<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm bài viết mới - MobileShop Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-custom.css">
</head>
<body>
    <div class="admin-layout">
        <c:set var="activePage" value="blog" />
        <%@ include file="/WEB-INF/jspf/admin/sidebar.jspf" %>

        <main class="main-content">
            <header class="page-header">
                <div class="page-title">
                    <p class="admin-shell-eyebrow">Quản lý nội dung</p>
                    <h1>Thêm bài viết mới</h1>
                    <p class="admin-shell-subtitle">Sáng tạo nội dung mới để thu hút khách hàng của bạn.</p>
                </div>
                <button onclick="history.back()" class="btn-cancel" style="padding: 10px 24px; font-size: 0.9rem;">
                    <i class="fas fa-arrow-left me-2"></i> Quay lại
                </button>
            </header>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="form-container">
                <form action="${ctx}/admin/blog" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="service" value="insertBlog">
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="label-custom">Tiêu đề bài viết <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="titleInput" class="form-input-custom" placeholder="Nhập tiêu đề hấp dẫn..." required maxlength="255">
                                <div class="counter-wrap"><span class="counter-label" id="titleCounter">0 / 255</span></div>
                            </div>
                            
                            <div class="form-group">
                                <label class="label-custom">Phụ đề (SubTitle)</label>
                                <input type="text" name="subTitle" id="subTitleInput" class="form-input-custom" placeholder="Câu dẫn dắt ngắn gọn (không bắt buộc)..." maxlength="255">
                                <div class="counter-wrap"><span class="counter-label" id="subTitleCounter">0 / 255</span></div>
                            </div>

                            <div class="form-group">
                                <label class="label-custom">Tóm tắt ngắn (Description) <span class="text-danger">*</span></label>
                                <textarea name="description" id="descInput" class="form-input-custom" rows="3" required maxlength="255" placeholder="Mô tả ngắn cho bài viết hiển thị ở danh sách..."></textarea>
                                <div class="counter-wrap"><span class="counter-label" id="descCounter">0 / 255</span></div>
                            </div>

                            <div class="form-group mt-3">
                                <label class="label-custom">Nội dung chi tiết <span class="text-danger">*</span></label>
                                <textarea name="content" id="blogContent" class="form-input-custom" rows="15" required maxlength="4000" placeholder="Viết nội dung bài viết ở đây..."></textarea>
                                <div class="counter-wrap"><span class="counter-label" id="contentCounter">0 / 4000</span></div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <label class="label-custom mb-0">Danh mục bài viết <span class="text-danger">*</span></label>
                                    <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none fw-bold" data-bs-toggle="modal" data-bs-target="#manageCatModal" style="font-size: 0.75rem; color: var(--primary);">+ Quản lý</button>
                                </div>
                                <select name="idBlogCat" id="categorySelect" class="form-input-custom" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach items="${catList}" var="cat">
                                        <option value="${cat.idBlogCat}">${cat.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="label-custom">Ảnh bìa bài viết <span class="text-danger">*</span></label>
                                <div class="upload-zone" id="uploadZone">
                                    <i class="fas fa-image upload-icon"></i>
                                    <div class="upload-text">Kéo thả hoặc <span>chọn file</span></div>
                                    <div class="text-muted small mt-2">Định dạng JPG, PNG, GIF (Tối đa 500KB)</div>
                                    <input type="file" name="image" id="thumbInput" accept="image/*" required>
                                </div>
                                <div id="thumbPreview" class="mt-3 d-none">
                                    <img src="" id="imgShow" class="rounded-4 shadow-sm" style="width: 100%; aspect-ratio: 16/9; object-fit: cover; border: 1px solid var(--border);">
                                    <p class="text-center small text-muted mt-2 fw-bold">Xem trước ảnh bìa</p>
                                </div>
                            </div>
                            
                            <div class="alert alert-info border-0 rounded-4 p-3 mt-4" style="background: #f0f7ff;">
                                <h6 class="fw-bold mb-2" style="color: #0369a1;"><i class="fas fa-lightbulb me-2"></i>Mẹo nhỏ</h6>
                                <p class="small mb-0 text-secondary">Sử dụng tiêu đề ngắn gọn và ảnh bìa chất lượng cao để tăng tỉ lệ người đọc.</p>
                            </div>
                        </div>
                    </div>

                    <div class="action-footer">
                        <button type="button" onclick="history.back()" class="btn-cancel">Hủy bỏ</button>
                        <button type="submit" class="btn-submit">Đăng bài viết <i class="fas fa-paper-plane ms-2"></i></button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- Modal Quản lý danh mục -->
    <div class="modal fade" id="manageCatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header-custom">
                    <h5 class="modal-title-custom">Quản lý danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body-custom">
                    <div class="cat-input-group">
                        <input type="text" id="newCatName" class="form-input-custom" placeholder="Tên danh mục mới..." maxlength="50">
                        <button type="button" id="btnAddCat" class="btn-add-cat">Thêm</button>
                    </div>
                    <div class="cat-list" id="catListContainer">
                        <div class="empty-cats text-center p-4 text-muted">Đang tải danh mục...</div>
                    </div>
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
            
            counter.textContent = input.value.length + " / " + maxLength;
            input.addEventListener('input', function() {
                counter.textContent = input.value.length + " / " + maxLength;
            });
        }
        updateCounter('titleInput', 'titleCounter', 255);
        updateCounter('subTitleInput', 'subTitleCounter', 255);
        updateCounter('descInput', 'descCounter', 255);
        updateCounter('blogContent', 'contentCounter', 4000);

        // Preview Image & Dimension Validation
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
                
                // 2. Kiểm tra kích thước (Chiều dài/Rộng)
                var _URL = window.URL || window.webkitURL;
                var img = new Image();
                img.onload = function() {
                    var width = this.width;
                    var height = this.height;
                    var minWidth = 800;
                    var minHeight = 400;

                    if (width < minWidth || height < minHeight) {
                        alert("CẢNH BÁO: Ảnh quá nhỏ (" + width + "x" + height + "px).\n\n" +
                              "Để bài viết trông chuyên nghiệp và không bị mờ trên màn hình lớn, " +
                              "vui lòng chọn ảnh có kích thước tối thiểu " + minWidth + "x" + minHeight + "px.");
                        document.getElementById('thumbInput').value = "";
                        document.getElementById('thumbPreview').classList.add('d-none');
                    } else {
                        // Nếu OK thì mới hiển thị preview
                        document.getElementById('imgShow').src = this.src;
                        document.getElementById('thumbPreview').classList.remove('d-none');
                    }
                };
                img.src = _URL.createObjectURL(file);
            }
        });

        // AJAX Category Management
        const categoryModal = document.getElementById('manageCatModal');
        const catListContainer = document.getElementById('catListContainer');
        const btnAddCat = document.getElementById('btnAddCat');
        const newCatNameInput = document.getElementById('newCatName');
        const categorySelect = document.getElementById('categorySelect');

        function loadCategories() {
            fetch('${ctx}/admin/blog?service=listCategories')
                .then(response => response.json())
                .then(data => {
                    renderCatList(data);
                    updateSelectOptions(data);
                });
        }

        function renderCatList(cats) {
            if (cats.length === 0) {
                catListContainer.innerHTML = '<div class="empty-cats text-center p-4">Chưa có danh mục nào</div>';
                return;
            }
            let html = '';
            cats.forEach(cat => {
                html += `
                    <div class="cat-item">
                        <div class="cat-name-wrapper" id="cat-display-\${cat.id}">
                            <span class="cat-name fw-bold">\${cat.name}</span>
                            <button type="button" class="btn btn-sm text-primary ms-2" onclick="showEditInput(\${cat.id}, '\${cat.name.replace(/'/g, "\\'")}')">
                                <i class="fas fa-pen"></i>
                            </button>
                        </div>
                        <div class="cat-edit-wrapper d-none" id="cat-edit-\${cat.id}" style="flex: 1; display: flex; gap: 5px;">
                            <input type="text" class="form-input-custom" value="\${cat.name}" id="input-edit-\${cat.id}" style="padding: 4px 10px; height: 36px; font-size: 0.85rem;">
                            <button type="button" class="btn-add-cat" style="padding: 0 12px; height: 36px; font-size: 0.75rem;" onclick="saveCategory(\${cat.id})">Lưu</button>
                            <button type="button" class="btn-cancel" style="padding: 0 12px; height: 36px; font-size: 0.75rem;" onclick="cancelEdit(\${cat.id})">Hủy</button>
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
            fetch(`${ctx}/admin/blog?service=updateCategory&id=\${id}&name=` + encodeURIComponent(newName))
                .then(r => r.text()).then(res => {
                    if (res === 'success') loadCategories();
                    else alert('Lỗi cập nhật danh mục!');
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
            if (!name) return;
            fetch(`${ctx}/admin/blog?service=addCategory&name=` + encodeURIComponent(name))
                .then(r => r.text()).then(res => { 
                    if (res === 'success') { newCatNameInput.value = ''; loadCategories(); }
                    else if (res === 'duplicate') alert('Tên danh mục này đã tồn tại!');
                    else alert('Lỗi: ' + res);
                });
        });

        window.deleteCategory = function(id) {
            if (!confirm('Xóa danh mục này?')) return;
            fetch(`${ctx}/admin/blog?service=deleteCategory&id=` + id)
                .then(r => r.text()).then(res => { 
                    if (res === 'success') loadCategories(); 
                    else alert('Lỗi: Danh mục đang được sử dụng!'); 
                });
        };

        categoryModal.addEventListener('show.bs.modal', loadCategories);
    </script>
</body>
</html>
