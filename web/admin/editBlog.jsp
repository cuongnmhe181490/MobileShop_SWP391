<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa bài viết - MobileShop Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <style>
        :root {
            --bg-body: #f4f7fe;
            --sidebar-bg: #1e293b;
            --primary: #4318ff;
            --accent: #aff22f;
            --text-main: #1b2559;
            --text-muted: #a3aed0;
            --border-color: #e9edf7;
            --shadow: 14px 17px 40px 4px rgba(112, 144, 176, 0.08);
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg-body); margin: 0; color: var(--text-main); }

        /* Sidebar Styles */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
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
        .sidebar .brand { padding: 0 24px; margin-bottom: 40px; text-decoration: none; color: white; display: block; }
        .sidebar .brand h2 { font-size: 1.5rem; font-weight: 700; margin: 0; }
        .sidebar .brand p  { font-size: 0.75rem; color: #94a3b8; margin-top: 4px; }
        
        .nav-section { margin-bottom: 32px; }
        .nav-label { font-size: 0.7rem; text-transform: uppercase; color: #64748b; letter-spacing: 1px; margin-bottom: 12px; display: block; padding: 0 24px; }
        
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-link { display: flex; align-items: center; gap: 12px; padding: 12px 24px; color: #94a3b8; text-decoration: none; font-weight: 500; font-size: 0.95rem; border-left: 4px solid transparent; transition: 0.3s; }
        .menu-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .menu-link.active { 
            background: rgba(175, 242, 47, 0.1); 
            color: var(--accent); 
            border-left-color: var(--accent); 
            font-weight: 600; 
        }

        /* Main Content */
        .main-content { margin-left: 260px; padding: 2.5rem; width: calc(100% - 260px); }

        .header-title-area { margin-bottom: 2.5rem; display: flex; justify-content: space-between; align-items: flex-start; }
        .eyebrow { font-size: 0.75rem; font-weight: 700; color: var(--text-sub); text-transform: uppercase; letter-spacing: 1px; }
        .header-title-area h1 { font-size: 2.1rem; font-weight: 800; color: var(--text-main); margin: 5px 0; }
        
        .glass-card { background: white; border-radius: 12px; padding: 2.5rem; border: 1px solid var(--border); box-shadow: 0 1px 3px rgba(0,0,0,0.05); }

        .form-label-bold { font-size: 0.85rem; font-weight: 800; color: #334155; text-transform: uppercase; margin-bottom: 1rem; display: block; }
        .form-group-wrap { margin-bottom: 2rem; position: relative; }

        .input-premium { width: 100%; background: #f8fafc; border: 1.5px solid var(--border); border-radius: 10px; padding: 0.9rem 1.25rem; font-size: 1rem; transition: 0.2s; }
        .input-premium:focus { outline: none; border-color: var(--primary); background: white; }

        .char-counter { position: absolute; bottom: -1.25rem; right: 0.5rem; font-size: 11px; color: #94a3b8; background: #f1f5f9; padding: 2px 8px; border-radius: 4px; }

        .textarea-premium { resize: vertical; min-height: 120px; }

        .upload-area { border: 2px dashed var(--border); border-radius: 12px; padding: 2rem 1rem; text-align: center; cursor: pointer; background: #f8fafc; position: relative; transition: 0.2s; }
        .upload-area:hover { border-color: var(--primary); background: #f1f5f9; }
        .upload-area i { font-size: 2.2rem; color: #94a3b8; margin-bottom: 0.8rem; }
        .upload-area input { position: absolute; opacity: 0; inset: 0; cursor: pointer; }

        .preview-img-box { margin-top: 1.5rem; border-radius: 12px; overflow: hidden; border: 1px solid var(--border); }
        .preview-img-box img { width: 100%; height: auto; display: block; }

        .note-box { background: #fffbeb; border: 1px solid #fde68a; border-radius: 12px; padding: 1.5rem; margin-top: 2rem; }
        .note-box h4 { font-size: 0.95rem; font-weight: 800; color: #92400e; margin-bottom: 0.5rem; }
        .note-box p { font-size: 0.85rem; color: #b45309; margin: 0; line-height: 1.6; }

        .btn-return { background: white; border: 1px solid var(--border); padding: 0.7rem 1.3rem; border-radius: 10px; color: var(--text-main); font-weight: 600; text-decoration: none; font-size: 0.9rem; transition: 0.2s; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
        .btn-return:hover { background: #f8fafc; transform: translateY(-1px); }
        
        .action-bar { margin-top: 3.5rem; display: flex; justify-content: flex-end; gap: 1.5rem; padding-top: 2.5rem; border-top: 1px solid var(--border); }
        .btn-p { padding: 0.9rem 3.5rem; border-radius: 10px; font-weight: 700; border: none; cursor: pointer; transition: 0.2s; font-size: 1rem; }
        .btn-cancel { background: #f1f5f9; color: #475569; text-decoration: none; display: flex; align-items: center; justify-content: center; }
        .btn-submit { background: var(--primary); color: white; box-shadow: 0 4px 6px rgba(67, 24, 255, 0.2); }

        /* Category Management Styles */
        .btn-manage-cat { background: none; border: none; color: var(--primary); font-size: 0.75rem; font-weight: 700; text-transform: uppercase; cursor: pointer; display: flex; align-items: center; gap: 5px; transition: 0.2s; padding: 5px; }
        .btn-manage-cat:hover { color: #8ec426; text-decoration: underline; }
        
        .modal-content { border-radius: 16px; border: none; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); }
        .modal-header { background: #f8fafc; border-bottom: 1px solid #e2e8f0; border-top-left-radius: 16px; border-top-right-radius: 16px; }
        .cat-input-group { display: flex; gap: 8px; margin-bottom: 1.5rem; }
        .cat-list-container { max-height: 300px; overflow-y: auto; border: 1px solid #e2e8f0; border-radius: 10px; }
        .cat-item { display: flex; justify-content: space-between; align-items: center; padding: 0.75rem 1rem; border-bottom: 1px solid #f1f5f9; }
        .cat-item:last-child { border-bottom: none; }
        .cat-name { font-weight: 500; color: #334155; }
        .cat-btn { background: none; border: none; cursor: pointer; padding: 4px; transition: 0.2s; }
        .cat-btn-edit { color: #2563eb; }
        .cat-btn-delete { color: #dc2626; }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand">
                <h2>MobileShop</h2>
                <p>Quản trị hệ thống</p>
            </a>

            <div class="nav-section">
                <span class="nav-label">TỔNG QUAN</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">QUẢN LÝ BÁN HÀNG</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/order-manage.jsp" class="menu-link"><i class="fa-solid fa-receipt"></i>Đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/products" class="menu-link"><i class="fa-solid fa-boxes-stacked"></i>Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/accounts" class="menu-link"><i class="fa-solid fa-user-gear"></i>Tài khoản</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">TƯƠNG TÁC & NỘI DUNG</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/contacts" class="menu-link"><i class="fa-solid fa-envelope-open-text"></i>Liên hệ / Tư vấn</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reviews" class="menu-link"><i class="fa-solid fa-star"></i>Đánh giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/blog" class="menu-link active"><i class="fa-solid fa-newspaper"></i>Blog / Tin tức</a></li>
                </ul>
            </div>

            <div class="nav-section">
                <span class="nav-label">CẤU HÌNH GIAO DIỆN</span>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin-home-config.jsp" class="menu-link"><i class="fa-solid fa-house-chimney-window"></i>Trang chủ</a></li>
                </ul>
            </div>

            <div style="margin-top: auto; padding-bottom: 24px;">
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/home" class="menu-link"><i class="fa-solid fa-globe"></i>Xem Website</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout" class="menu-link"><i class="fa-solid fa-power-off"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="header-title-area">
                <div>
                    <span class="eyebrow">CHỈNH SỬA BÀI VIẾT ID: #${blog.blogId}</span>
                    <h1>Cập nhật nội dung</h1>
                </div>
                <a href="${pageContext.request.contextPath}/admin/blog" class="btn-return">Quay lại danh sách</a>
            </div>

            <div class="glass-card">
                <form action="${pageContext.request.contextPath}/admin/blog" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="service" value="updateBlog">
                    <input type="hidden" name="blogId" value="${blog.blogId}">
                    
                    <div class="row g-5">
                        <div class="col-lg-8">
                            <div class="form-group-wrap">
                                <label class="form-label-bold">TIÊU ĐỀ BÀI VIẾT <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="titleInput" class="input-premium" value="${blog.title}" required maxlength="255">
                                <div class="char-counter" id="titleCounter">0 / 255</div>
                            </div>

                            <div class="form-group-wrap">
                                <label class="form-label-bold">PHỤ ĐỀ (SUBTITLE)</label>
                                <input type="text" name="subTitle" id="subTitleInput" class="input-premium" value="${blog.subTitle}" maxlength="255">
                                <div class="char-counter" id="subTitleCounter">0 / 255</div>
                            </div>

                            <div class="form-group-wrap">
                                <label class="form-label-bold">TÓM TẮT NGẮN <span class="text-danger">*</span></label>
                                <textarea name="description" id="descInput" class="input-premium textarea-premium" required maxlength="255">${blog.description}</textarea>
                                <div class="char-counter" id="descCounter">0 / 255</div>
                            </div>

                            <div class="form-group-wrap mb-0">
                                <label class="form-label-bold">NỘI DUNG CHI TIẾT <span class="text-danger">*</span></label>
                                <textarea name="content" id="blogContent" class="input-premium textarea-premium" style="min-height: 400px;" required maxlength="4000">${blog.content}</textarea>
                                <div class="char-counter" id="contentCounter">0 / 4000</div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="form-group-wrap">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <label class="form-label-bold mb-0">DANH MỤC <span class="text-danger">*</span></label>
                                    <button type="button" class="btn-manage-cat" data-bs-toggle="modal" data-bs-target="#catModal" onclick="loadCategoryList()">
                                        <i class="fa-solid fa-gear"></i> Quản lý
                                    </button>
                                </div>
                                <select name="idBlogCat" id="mainCatSelect" class="input-premium" required>
                                    <c:forEach items="${catList}" var="cat">
                                        <option value="${cat.idBlogCat}" ${cat.idBlogCat == blog.idBlogCat ? 'selected' : ''}>${cat.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>



                            <div class="form-group-wrap">
                                <label class="form-label-bold">ẢNH BÀI VIẾT</label>
                                <div class="upload-area">
                                    <i class="fa-solid fa-image"></i>
                                    <div style="font-weight: 700;">Thay đổi <span>ảnh bài viết</span></div>
                                    <div style="font-size: 0.75rem; color: #64748b; margin-top: 5px;">(Kích thước tối thiểu: 800x400px)</div>
                                    <input type="file" name="image" id="thumbInput" accept="image/*">
                                </div>
                                <div class="preview-img-box">
                                    <p class="small text-muted mb-1 mt-2">Ảnh hiện tại / Mới:</p>
                                    <img src="${not empty blog.imagePath ? blog.imagePath : 'img/no-image.png'}" id="imgPreview">
                                </div>
                                <p class="small text-muted mt-2">Để trống nếu bạn không muốn thay đổi ảnh bìa.</p>
                            </div>

                            <div class="note-box">
                                <h4><i class="fa-solid fa-info-circle"></i> Thông tin</h4>
                                <p>Ngày tạo: <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                                <p>Người đăng ID: ${blog.userId}</p>
                            </div>
                        </div>
                    </div>

                    <div class="action-bar">
                        <a href="${pageContext.request.contextPath}/admin/blog" class="btn-p btn-cancel">Hủy bỏ</a>
                        <button type="submit" class="btn-p btn-submit">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- Category Management Modal (Bootstrap) -->
    <div class="modal fade" id="catModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" style="font-weight: 800; color: #1e293b;">Quản lý danh mục Blog</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="cat-input-group">
                        <input type="text" id="newCatName" placeholder="Tên danh mục mới (2-50 ký tự)..." class="input-premium">
                        <input type="hidden" id="editCatId" value="">
                        <button type="button" id="btnSaveCat" onclick="saveCategory()" class="btn-p btn-submit" style="padding: 0.7rem 1.5rem; height: auto;">Thêm</button>
                        <button type="button" id="btnCancelEdit" onclick="resetCatForm()" class="btn-p btn-cancel" style="padding: 0.7rem 1.5rem; height: auto; display:none;">Hủy</button>
                    </div>
                    <div id="catListContainer" class="cat-list-container">
                        <!-- AJAX content -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateCount(inputId, counterId, max) {
            const input = document.getElementById(inputId);
            const counter = document.getElementById(counterId);
            if(!input || !counter) return;
            const up = () => { counter.innerText = input.value.length + " / " + max; };
            input.addEventListener('input', up);
            up();
        }
        updateCount('titleInput', 'titleCounter', 255);
        updateCount('subTitleInput', 'subTitleCounter', 255);
        updateCount('descInput', 'descCounter', 255);
        updateCount('blogContent', 'contentCounter', 4000);

        document.getElementById('thumbInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Validate dimensions
                const img = new Image();
                img.src = URL.createObjectURL(file);
                img.onload = function() {
                    const width = this.width;
                    const height = this.height;
                    const minWidth = 800;
                    const minHeight = 400;

                    if (width < minWidth || height < minHeight) {
                        alert(`Ảnh quá nhỏ! Vui lòng chọn ảnh có kích thước tối thiểu ${minWidth}x${minHeight}px để tránh bị mờ/vỡ hình.\nKích thước hiện tại: ${width}x${height}px`);
                        document.getElementById('thumbInput').value = '';
                        return;
                    }

                    const reader = new FileReader();
                    reader.onload = function(re) {
                        document.getElementById('imgPreview').src = re.target.result;
                    }
                    reader.readAsDataURL(file);
                };
                img.onerror = function() {
                    alert('File không phải là ảnh hợp lệ!');
                    document.getElementById('thumbInput').value = '';
                };
            }
        });

        // Category Management Functions
        function resetCatForm() {
            document.getElementById('newCatName').value = '';
            document.getElementById('editCatId').value = '';
            document.getElementById('btnSaveCat').innerText = 'Thêm';
            document.getElementById('btnCancelEdit').style.display = 'none';
        }

        function loadCategoryList() {
            const url = '${pageContext.request.contextPath}/admin/blog-category-manage?action=list';
            fetch(url)
                .then(res => res.json())
                .then(data => {
                    let html = '';
                    const currentSelectedId = "${blog.idBlogCat}";
                    let selectHtml = '';
                    data.forEach(cat => {
                        html += '<div class="cat-item">' +
                                '<span class="cat-name">' + cat.name + '</span>' +
                                '<div class="cat-actions">' +
                                    '<button type="button" class="cat-btn cat-btn-edit" title="Sửa" onclick="editCat(' + cat.id + ', \'' + cat.name + '\')"><i class="fa-solid fa-pen-to-square"></i></button>' +
                                    '<button type="button" class="cat-btn cat-btn-delete" title="Xóa" onclick="deleteCat(' + cat.id + ')"><i class="fa-solid fa-trash"></i></button>' +
                                '</div>' +
                                '</div>';
                        selectHtml += '<option value="' + cat.id + '"' + (cat.id == currentSelectedId ? ' selected' : '') + '>' + cat.name + '</option>';
                    });
                    const container = document.getElementById('catListContainer');
                    const select = document.getElementById('mainCatSelect');
                    if (container) container.innerHTML = html || '<p style="padding:1rem; text-align:center; color:#94a3b8;">Chưa có danh mục nào</p>';
                    if (select) select.innerHTML = selectHtml;
                })
                .catch(err => console.error('Lỗi load danh mục:', err));
        }

        function saveCategory() {
            const name = document.getElementById('newCatName').value.trim();
            const id = document.getElementById('editCatId').value;
            const action = id ? 'edit' : 'add';

            if (name.length < 2 || name.length > 50) {
                alert('Độ dài danh mục từ 2-50 ký tự!');
                return;
            }

            const url = '${pageContext.request.contextPath}/admin/blog-category-manage?action=' + action + '&name=' + encodeURIComponent(name) + '&id=' + id;
            fetch(url)
                .then(res => res.json())
                .then(data => {
                    if (data.status === 'success') {
                        loadCategoryList();
                        resetCatForm();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(err => alert('Lỗi kết nối server!'));
        }

        function editCat(id, name) {
            document.getElementById('newCatName').value = name;
            document.getElementById('editCatId').value = id;
            document.getElementById('btnSaveCat').innerText = 'Lưu';
            document.getElementById('btnCancelEdit').style.display = 'inline-block';
            document.getElementById('newCatName').focus();
        }

        function deleteCat(id) {
            if (confirm('Bạn có chắc muốn xóa danh mục này?')) {
                const url = '${pageContext.request.contextPath}/admin/blog-category-manage?action=delete&id=' + id;
                fetch(url)
                    .then(res => res.json())
                    .then(data => {
                        if (data.status === 'success') {
                            loadCategoryList();
                        } else {
                            alert(data.message);
                        }
                    })
                    .catch(err => alert('Lỗi kết nối server!'));
            }
        }

        window.onclick = function(event) {
            const modal = document.getElementById('catModal');
            if (event.target == modal) closeCatModal();
        }
    </script>
</body>
</html>