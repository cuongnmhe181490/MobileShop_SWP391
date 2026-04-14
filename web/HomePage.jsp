<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Trang chủ" />
<c:set var="activePage" value="home" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ include file="/WEB-INF/jspf/storefront/head.jspf" %>
        <!-- Css Styles -->
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="css/owl.carousel.min.css" type="text/css">
        <link rel="stylesheet" href="css/style.css" type="text/css">
        <link rel="stylesheet" href="css/mobileshop.css" type="text/css">
        <link rel="stylesheet" href="css/custom.css" type="text/css">
        <style>/* Khoảng cách cho phần Slider thương hiệu */
            .categories {
                margin-top: 50px; /* Tăng con số này nếu bạn muốn thưa hơn nữa */
                margin-bottom: 40px;
            }

            /* Hoặc nếu bạn muốn đẩy chính xác cái thanh chứa các logo */
            .categories__slider {
                padding-top: 30px;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <section class="hero-card">
                    <div>
                        <span class="hero-card__eyebrow">Đợt mở bán nổi bật</span>
                        <h1 style="color: #fff3cd">Mua điện thoại mới theo cách gọn và dễ chịu hơn.</h1>
                        <p>MobileShop gom rõ nhóm flagship mới, máy nổi bật theo trải nghiệm và lộ trình thu cũ để bạn ra quyết định nhanh hơn mà vẫn đủ thông tin cần thiết.</p>
                        <div class="hero-card__actions">
                            <a class="pill-link pill-link--primary" href="${ctx}/product">Xem cửa hàng</a>
                            <a class="pill-link" href="${ctx}/tradein">Định giá máy cũ</a>
                        </div>
                        <div class="hero-card__stats">
                            <div class="hero-stat">
                                <strong>4.9/5</strong>
                                <span>điểm hài lòng từ người mua mới</span>
                            </div>
                            <div class="hero-stat">
                                <strong>24h</strong>
                                <span>phản hồi tư vấn và hỗ trợ trong ngày</span>
                            </div>
                            <div class="hero-stat">
                                <strong>30+</strong>
                                <span>mẫu máy nổi bật đang được chọn lọc</span>
                            </div>
                        </div>
                    </div>
                    <div class="hero-visual">
                        <div class="device-stack">
                            <c:if test="${heroProduct != null}">
                                <div class="device-stack__card device-stack__card--left">
                                    <img src="${heroProduct.imagePath}" alt="${heroProduct.productName}">
                                </div>
                                <div class="device-stack__card device-stack__card--front">
                                    <img src="${heroProduct.imagePath}" alt="${heroProduct.productName}">
                                </div>
                                <div class="device-stack__card device-stack__card--right">
                                    <img src="${heroProduct.imagePath}" alt="${heroProduct.productName}">
                                </div>
                            </c:if>
                        </div>
                    </div>
                </section>

                <section class="categories">
                    <div class="container">
                        <div class="row">
                            <div class="categories__slider owl-carousel">
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-1.jpg">
                                        <h5><a href="#">IPhone</a></h5>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-2.jpg">
                                        <h5><a href="#">Samsung</a></h5>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-3.jpg">
                                        <h5><a href="#">Xiaomi</a></h5>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-4.jpg">
                                        <h5><a href="#">Realme</a></h5>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-5.jpg">
                                        <h5><a href="#">Huawei</a></h5>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-6.jpg">
                                        <h5><a href="#">Oppo</a></h5>
                                    </div>
                                </div>
                                <div class="col-lg-3">
                                    <div class="categories__item set-bg" data-setbg="img/categories/cat-7.jpg">
                                        <h5><a href="#">Google</a></h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section>
                    <div class="section-heading">
                        <div>
                            <span class="section-eyebrow" style="color: #666">Hệ thống Reference</span>
                            <h2>Mua máy đúng nhu cầu trải nghiệm</h2>
                        </div>
                        <a class="pill-link" href="${ctx}/reviews">Xem tất cả bài đánh giá</a>
                    </div>

                    <div class="collection-grid">
                        <article class="collection-card collection-card--blue" onclick="location.href = '${ctx}/product?tag=pin-trau'" style="cursor: pointer;">
                            <div>
                                <span class="hero-card__eyebrow">Thử nghiệm thực tế</span>
                                <h3>Smartphone Pin "trâu" & Sạc nhanh</h3>
                                <p>Bảng xếp hạng dựa trên kết quả test onscreen thực tế > 8 tiếng và khả năng nạp đầy pin dưới 45 phút.</p>
                            </div>
                            <div class="collection-card__visual">
                            </div>
                        </article>

                        <article class="collection-card collection-card--navy" onclick="location.href = '${ctx}/product?tag=camera'" style="cursor: pointer;">
                            <div>
                                <span class="hero-card__eyebrow">Dành cho sáng tạo</span>
                                <h3>Chuyên gia nhiếp ảnh & Quay Vlog</h3>
                                <p>So sánh blind-test camera flagship. Gợi ý các dòng có cảm biến 1-inch và chống rung điện ảnh tốt nhất.</p>
                            </div>
                            <div class="collection-card__visual"></div>
                        </article>

                        <article class="collection-card collection-card--sunset" onclick="location.href = '${ctx}/product?tag=gaming'" style="cursor: pointer;">
                            <div>
                                <span class="hero-card__eyebrow">Hiệu năng thuần túy</span>
                                <h3>Cỗ máy chiến Game & Đồ họa</h3>
                                <p>Tổng hợp các máy tối ưu tản nhiệt, tần số quét 144Hz+ và chipset không bị bóp hiệu năng khi dùng lâu.</p>
                            </div>
                            <div class="collection-card__visual"></div>
                        </article>
                    </div>
                </section>

                <section>
                    <div class="section-heading">
                        <div>
                            <span class="section-eyebrow">Xu hướng mua sắm</span>
                            <h2>Top sản phẩm bán chạy.</h2>
                        </div>
                        <a class="pill-link" href="${ctx}/product">Xem tất cả</a>
                    </div>

                    <div class="catalog-grid">
                        <c:forEach items="${featuredProducts}" var="item" varStatus="status">
                            <c:set var="toneClass" value="${status.index % 4 == 0 ? 'status-chip--blue' : status.index % 4 == 1 ? 'status-chip--orange' : status.index % 4 == 2 ? 'status-chip--green' : 'status-chip--pink'}" />
                            <c:set var="labelText" value="${status.index % 4 == 0 ? 'Nổi bật' : status.index % 4 == 1 ? 'Đáng mua' : status.index % 4 == 2 ? 'Giá tốt' : 'Mới về'}" />
                            <article class="product-card">
                                <a class="product-card__media" href="${ctx}/detail?pid=${item.idProduct}">
                                    <img src="${item.imagePath}" alt="${item.productName}">
                                </a>
                                <div class="product-card__body">
                                    <h3><a href="${ctx}/detail?pid=${item.idProduct}">${item.productName}</a></h3>
                                    <div class="product-card__meta">${item.idSupplier} · ${item.ram}GB RAM · ${item.releaseDate}</div>
                                    <div class="product-card__row">
                                        <div class="product-price"><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/>đ</div>
                                        <span class="status-chip ${toneClass}">${labelText}</span>
                                    </div>
                                    <div class="product-card__actions">
                                        <a class="pill-link pill-link--dark" href="${ctx}/detail?pid=${item.idProduct}">Xem chi tiết</a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>

                <section class="story-card" id="tradein">
                    <div class="story-card__lead">
                        <span class="section-eyebrow">Chương trình Trade-in</span>
                        <h2 style="color: #fff3cd">Thu cũ Đổi mới: Lên đời Flagship tiết kiệm đến 80%.</h2>
                        <p>Đừng để chiếc điện thoại cũ trong ngăn kéo. Chúng tôi thu mua lại với giá cao nhất thị trường để bạn bù tiền lên đời máy mới một cách nhẹ nhàng và kinh tế nhất.</p>
                        <div class="hero-card__actions">
                            <a class="pill-link pill-link--primary" href="${ctx}/trade-in">Định giá máy cũ ngay</a>
                            <a class="pill-link" href="${ctx}/contact">Liên hệ tư vấn</a>
                        </div>
                    </div>
                    <div class="story-card__notes">
                        <article class="story-note">
                            <span class="story-note__dot" style="background: #22c55e;"></span>
                            <div>
                                <h3>Giá thu cũ cao nhất</h3>
                                <p>Cam kết giá thu mua tốt nhất thị trường, đánh giá đúng tình trạng máy, không lo bị ép giá.</p>
                            </div>
                        </article>
                        <article class="story-note">
                            <span class="story-note__dot" style="background: #3b82f6;"></span>
                            <div>
                                <h3>Trợ giá thêm đến 2 triệu</h3>
                                <p>Đặc quyền dành riêng cho khách hàng lên đời: Tặng thêm voucher trợ giá khi thực hiện đổi máy.</p>
                            </div>
                        </article>
                        <article class="story-note">
                            <span class="story-note__dot" style="background: #a855f7;"></span>
                            <div>
                                <h3>Thủ tục 5 phút gọn lẹ</h3>
                                <p>Kiểm tra máy tại chỗ, sao lưu dữ liệu miễn phí và nhận máy mới ngay trong ngày.</p>
                            </div>
                        </article>
                    </div>
                </section>


                <section>
                    <div class="section-heading">
                        <div>
                            <span class="section-eyebrow">Cẩm nang</span>
                            <h2>Đọc để mua đúng, không mua nhầm.</h2>
                        </div>
                        <a class="pill-link" href="${ctx}/blog">Mở cẩm nang</a>
                    </div>

                    <div class="editorial-grid">
                        <c:forEach items="${blogPosts}" var="post">
                            <article class="editorial-card editorial-card--article">
                                <div class="editorial-card__image">
                                    <img src="${post.imageUrl}" alt="${post.title}">
                                </div>
                                <div class="editorial-card__body">
                                    <span class="editorial-card__tag">${post.category}</span>
                                    <h3>${post.title}</h3>
                                    <p>${post.excerpt}</p>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </section>
            </div>
        </main>
                    
        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
        <!-- Js Plugins -->
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.nice-select.min.js"></script>
        <script src="js/jquery-ui.min.js"></script>
        <script src="js/jquery.slicknav.js"></script>
        <script src="js/mixitup.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>
        <script src="js/backtop.js"></script>
    </body>
</html>
