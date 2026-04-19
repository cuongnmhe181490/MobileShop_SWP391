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

    </head>
    <body>
        <%@ include file="/WEB-INF/jspf/storefront/header.jspf" %>

        <main class="page-section">
            <div class="mobile-shell">
                <section class="hero-card">
                    <div>
                        <%-- Eyebrow --%>
                        <span class="hero-card__eyebrow">
                            <c:out value="${heroBanner.eyebrow}" default="Đợt mở bán nổi bật"/>
                        </span>

                        <%-- Tiêu đề chính --%>
                        <h1 style="color: #fff3cd">
                            <c:out value="${heroBanner.title}" default="Mua điện thoại mới theo cách nhanh gọn và dễ chịu hơn."/>
                        </h1>

                        <%-- Mô tả --%>
                        <p>
                            <c:out value="${heroBanner.description}" default="MobileShop gom rõ nhóm flagship mới, máy nổi bật theo trải nghiệm và lộ trình thu cũ để bạn ra quyết định nhanh hơn mà vẫn đủ thông tin cần thiết."/>
                        </p>

                        <%-- CTA buttons --%>
                        <div class="hero-card__actions">
                            <a class="pill-link pill-link--primary" href="${ctx}/product">
                                <c:out value="${heroBanner.ctaPrimary}" default="Xem cửa hàng"/>
                            </a>
                            <a class="pill-link" href="${ctx}/tradein">
                                <c:out value="${heroBanner.ctaSecondary}" default="Định giá máy cũ"/>
                            </a>
                        </div>

                        <%-- Thống kê hero --%>
                        <div class="hero-card__stats">
                            <%-- Stat 1: Điểm hài lòng – LIVE từ AVG(Ranking) ProductReview --%>
                            <div class="hero-stat">
                                <strong>
                                    <c:out value="${satisfactionRate}" default="0/5"/>
                                </strong>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty heroBanner.stat1Label}">${heroBanner.stat1Label}</c:when>
                                        <c:otherwise>điểm hài lòng từ người mua mới</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <%-- Stat 2: Thời gian phản hồi – admin nhập --%>
                            <div class="hero-stat">
                                <strong><c:out value="${heroBanner.stat2Label}" default="24h"/></strong>
                                <span>phản hồi tư vấn và hỗ trợ trong ngày</span>
                            </div>

                            <%-- Stat 3: Số mẫu máy – LIVE từ COUNT(*) ProductDetail --%>
                            <div class="hero-stat">
                                <strong>
                                    +<c:choose>
                                        <c:when test="${not empty productCount}">${productCount}</c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </strong>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty heroBanner.stat3Label}">${heroBanner.stat3Label}</c:when>
                                        <c:otherwise>mẫu máy nổi bật đang được chọn lọc</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>

                    <%-- Hero visual – ưu tiên ảnh từ banner, fallback sang heroProduct --%>
                    <div class="hero-visual">
                        <div class="device-stack">
                            <c:choose>
                                <c:when test="${not empty heroBanner.imageUrl}">
                                    <div class="device-stack__card device-stack__card--left">
                                        <img src="${heroBanner.imageUrl}" alt="Hero banner">
                                    </div>
                                    <div class="device-stack__card device-stack__card--front">
                                        <img src="${heroBanner.imageUrl}" alt="Hero banner">
                                    </div>
                                    <div class="device-stack__card device-stack__card--right">
                                        <img src="${heroBanner.imageUrl}" alt="Hero banner">
                                    </div>
                                </c:when>
                                <c:when test="${heroProduct != null}">
                                    <div class="device-stack__card device-stack__card--left">
                                        <img src="${heroProduct.imagePath}" alt="${heroProduct.productName}">
                                    </div>
                                    <div class="device-stack__card device-stack__card--front">
                                        <img src="${heroProduct.imagePath}" alt="${heroProduct.productName}">
                                    </div>
                                    <div class="device-stack__card device-stack__card--right">
                                        <img src="${heroProduct.imagePath}" alt="${heroProduct.productName}">
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </section>

                <section class="categories">
                    <div class="container">
                        <div class="row">
                            <div class="categories__slider owl-carousel">
                                <%-- Sử dụng vòng lặp để lấy dữ liệu từ listCC (danh sách Category/Brand) --%>
                                <c:forEach items="${listCC}" var="c">
                                    <div class="col-lg-3">
                                        <%-- set-bg sẽ lấy đường dẫn ảnh từ database --%>
                                        <div class="categories__item set-bg" data-setbg="${c.imagePath}">
                                            <h5>
                                                <%-- Link dẫn tới trang sản phẩm lọc theo hãng --%>
                                                <a href="shop?cid=${c.idCat}">${c.name}</a>
                                            </h5>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
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
                                    <c:if test="${item.discount > 0}">
                                        <span class="discount-badge">
                                            Giảm <fmt:formatNumber value="${item.discount * 100}" maxFractionDigits="0"/>%
                                        </span>
                                    </c:if>
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
                        <h2 style="color: #fff3cd">
                            <c:choose>
                                <c:when test="${not empty tradeInConfig.Title}">${tradeInConfig.Title}</c:when>
                                <c:otherwise>Thu cũ Đổi mới: Lên đời Flagship tiết kiệm đến 80%.</c:otherwise>
                            </c:choose>
                        </h2>
                        <p>
                            <c:choose>
                                <c:when test="${not empty tradeInConfig.Description}">${tradeInConfig.Description}</c:when>
                                <c:otherwise>Đừng để chiếc điện thoại cũ trong ngăn kéo. Chúng tôi thu mua lại với giá cao nhất thị trường để bạn bù tiền lên đời máy mới một cách nhẹ nhàng và kinh tế nhất.</c:otherwise>
                            </c:choose>
                        </p>
                        <div class="hero-card__actions">
                            <a class="pill-link pill-link--primary" href="${ctx}/trade-in">Định giá máy cũ ngay</a>
                            <a class="pill-link" href="${ctx}/contact">Liên hệ tư vấn</a>
                        </div>
                    </div>
                    <div class="story-card__notes">
                        <article class="story-note">
                            <span class="story-note__dot" style="background: #22c55e;"></span>
                            <div>
                                <h3>
                                    <c:choose>
                                        <c:when test="${not empty tradeInConfig.Note1_Title}">${tradeInConfig.Note1_Title}</c:when>
                                        <c:otherwise>Giá thu cũ cao nhất</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty tradeInConfig.Note1_Desc}">${tradeInConfig.Note1_Desc}</c:when>
                                        <c:otherwise>Cam kết giá thu mua tốt nhất thị trường, đánh giá đúng tình trạng máy, không lo bị ép giá.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </article>
                        <article class="story-note">
                            <span class="story-note__dot" style="background: #3b82f6;"></span>
                            <div>
                                <h3>
                                    <c:choose>
                                        <c:when test="${not empty tradeInConfig.Note2_Title}">${tradeInConfig.Note2_Title}</c:when>
                                        <c:otherwise>Trợ giá thêm đến 2 triệu</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty tradeInConfig.Note2_Desc}">${tradeInConfig.Note2_Desc}</c:when>
                                        <c:otherwise>Đặc quyền dành riêng cho khách hàng lên đời: Tặng thêm voucher trợ giá khi thực hiện đổi máy.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </article>
                        <article class="story-note">
                            <span class="story-note__dot" style="background: #a855f7;"></span>
                            <div>
                                <h3>
                                    <c:choose>
                                        <c:when test="${not empty tradeInConfig.Note3_Title}">${tradeInConfig.Note3_Title}</c:when>
                                        <c:otherwise>Thủ tục 5 phút gọn lẹ</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty tradeInConfig.Note3_Desc}">${tradeInConfig.Note3_Desc}</c:when>
                                        <c:otherwise>Kiểm tra máy tại chỗ, sao lưu dữ liệu miễn phí và nhận máy mới ngay trong ngày.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </article>
                    </div>
                </section>
            </div>
        </main>

        <%@ include file="/WEB-INF/jspf/storefront/footer.jspf" %>
        <!-- ===== BACK TO TOP ===== -->
        <button id="back-to-top" title="Lên đầu trang">&#8679;</button>
        <script>
            (function () {
                var btn = document.getElementById('back-to-top');
                window.addEventListener('scroll', function () {
                    btn.classList.toggle('visible', window.scrollY > 400);
                });
                btn.addEventListener('click', function () {
                    window.scrollTo({top: 0, behavior: 'smooth'});
                });
            })();
        </script>

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
