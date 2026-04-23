package controller.product;

import dao.product.ProductAdminDAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import util.CloudinaryUtil;

@MultipartConfig(
        fileSizeThreshold = 1024 * 512,
        maxFileSize = 500 * 1024,
        maxRequestSize = 1024 * 1024 
)
public class ProductManageController extends HttpServlet {

    private static final long MAX_IMAGE_SIZE = 500 * 1024;
    private static final int PAGE_SIZE = 4;
    private static final int PAGE_WINDOW = 4;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        ProductAdminDAO dao = new ProductAdminDAO();
        String service = trim(request.getParameter("service"));
        if (service.isBlank()) {
            service = "listAll";
        }

        switch (service) {
            case "addProduct":
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    handleSave(request, response, dao, false);
                } else {
                    showForm(request, response, dao, new Product(), new LinkedHashMap<>(), false, false, null);
                }
                break;
            case "editProduct":
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    handleSave(request, response, dao, true);
                } else {
                    showExistingProductForm(request, response, dao, false);
                }
                break;
            case "viewProduct":
                showExistingProductForm(request, response, dao, true);
                break;
            case "deleteProduct":
                handleDelete(request, response, dao);
                break;
            default:
                showProductList(request, response, dao);
                break;
        }
    }

    private void showExistingProductForm(HttpServletRequest request, HttpServletResponse response, ProductAdminDAO dao, boolean viewMode)
            throws ServletException, IOException {
        String id = trim(request.getParameter("id"));
        Product product = dao.getProductByID(id);
        if (product == null) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm.");
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        showForm(request, response, dao, product, new LinkedHashMap<>(), true, viewMode, null);
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response, ProductAdminDAO dao)
            throws ServletException, IOException {
        String keyword = trim(request.getParameter("keyword"));
        String supplierFilter = trim(request.getParameter("supplier"));
        String sortBy = trim(request.getParameter("sort"));
        int currentPage = parseIntOrDefault(request.getParameter("page"), 1);
        if (currentPage < 1) {
            currentPage = 1;
        }

        boolean productDataAvailable = dao.canAccessProductData();
        int totalProducts = productDataAvailable ? dao.countProducts(keyword, supplierFilter) : 0;
        int totalPages = Math.max(1, (int) Math.ceil(totalProducts / (double) PAGE_SIZE));
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * PAGE_SIZE;
        List<Product> productList = productDataAvailable
                ? dao.getProducts(keyword, supplierFilter, sortBy, offset, PAGE_SIZE)
                : Collections.emptyList();

        request.setAttribute("productList", productList);
        request.setAttribute("supplierIds", productDataAvailable ? dao.getSupplierIds() : Collections.emptyList());
        request.setAttribute("keyword", keyword);
        request.setAttribute("supplierFilter", supplierFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);
        populatePaginationAttributes(request, currentPage, totalPages);
        if (!productDataAvailable) {
            request.setAttribute("productDataError", "Không thể tải dữ liệu sản phẩm từ cơ sở dữ liệu. Vui lòng kiểm tra cấu hình DB.");
        }
        request.getRequestDispatcher("/admin/product-manage.jsp").forward(request, response);
    }

    private void populatePaginationAttributes(HttpServletRequest request, int currentPage, int totalPages) {
        int startPage;
        int endPage;

        if (totalPages <= PAGE_WINDOW + 1) {
            startPage = 1;
            endPage = totalPages;
        } else if (currentPage <= 3) {
            startPage = 1;
            endPage = Math.min(totalPages, PAGE_WINDOW);
        } else if (currentPage >= totalPages - 2) {
            endPage = totalPages;
            startPage = Math.max(1, totalPages - (PAGE_WINDOW - 1));
        } else {
            startPage = currentPage - 1;
            endPage = currentPage + 1;
        }

        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("prevPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        request.setAttribute("showFirstPage", startPage > 1);
        request.setAttribute("showLeadingEllipsis", startPage > 2);
        request.setAttribute("showLastPage", endPage < totalPages);
        request.setAttribute("showTrailingEllipsis", endPage < totalPages - 1);
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response, ProductAdminDAO dao, boolean editMode)
            throws ServletException, IOException {
        Product product = buildProductFromRequest(request, dao);
        Product existingProduct = editMode ? dao.getProductByID(product.getIdProduct()) : null;

        if (!editMode) {
            if (product.getReleaseDate().isBlank()) {
                product.setReleaseDate(LocalDate.now().toString());
            }
            product.setIdProduct(dao.getNextProductId());
            product.setOriginalQuantity(product.getCurrentQuantity());
            product.setIsFeatured(0);
            product.setDiscount(0d);
        } else if (existingProduct != null) {
            if (product.getReleaseDate().isBlank()) {
                product.setReleaseDate(existingProduct.getReleaseDate());
            }
            product.setDiscount(existingProduct.getDiscount());
            product.setIsFeatured(existingProduct.getIsFeatured());
            product.setOriginalQuantity(Math.max(existingProduct.getOriginalQuantity(), product.getCurrentQuantity()));
        }

        boolean duplicateProduct = !editMode
                && !product.getProductName().isBlank()
                && !product.getIdSupplier().isBlank()
                && dao.productExistsByNameAndSupplier(product.getProductName(), product.getIdSupplier());

        Map<String, String> errors = validateProduct(request, product, editMode);
        if (!errors.isEmpty()) {
            showForm(
                    request,
                    response,
                    dao,
                    product,
                    errors,
                    editMode,
                    false,
                    duplicateProduct ? "Sản phẩm đã tồn tại. Nếu lưu, hệ thống sẽ cộng thêm số lượng tồn kho." : null
            );
            return;
        }

        boolean success;
        String successMessage;
        if (duplicateProduct) {
            success = dao.restockExistingProduct(product.getProductName(), product.getIdSupplier(), product.getCurrentQuantity());
            successMessage = success
                    ? "Sản phẩm đã tồn tại, hệ thống đã cộng thêm số lượng vào kho."
                    : "Không thể cập nhật số lượng cho sản phẩm đã tồn tại.";
        } else {
            success = editMode ? dao.updateProduct(product) : dao.addProduct(product);
            successMessage = success
                    ? (editMode ? "Cập nhật sản phẩm thành công." : "Thêm sản phẩm thành công.")
                    : (editMode ? "Cập nhật sản phẩm thất bại." : "Thêm sản phẩm thất bại.");
        }

        if (success) {
            request.getSession().setAttribute("successMessage", successMessage);
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        showForm(
                request,
                response,
                dao,
                product,
                new LinkedHashMap<>(),
                editMode,
                false,
                duplicateProduct
                        ? "Cập nhật số lượng thất bại. Vui lòng kiểm tra lại dữ liệu."
                        : "Lưu sản phẩm thất bại. Vui lòng thử lại."
        );
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, ProductAdminDAO dao)
            throws IOException {
        String id = trim(request.getParameter("id"));
        boolean success = !id.isBlank() && dao.deleteProduct(id);
        request.getSession().setAttribute(
                success ? "successMessage" : "errorMessage",
                success ? "Xóa sản phẩm thành công." : "Xóa sản phẩm thất bại."
        );
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, ProductAdminDAO dao,
            Product product, Map<String, String> errors, boolean editMode, boolean viewMode, String formError)
            throws ServletException, IOException {
        String resolvedImagePath = product != null && product.getImagePath() != null && !product.getImagePath().isBlank()
                ? product.getImagePath()
                : request.getContextPath() + "/img/categories/cat-1.jpg";

        request.setAttribute("product", product);
        request.setAttribute("productForm", product);
        request.setAttribute("errors", errors);
        request.setAttribute("editMode", editMode);
        request.setAttribute("viewMode", viewMode);
        request.setAttribute("supplierIds", dao.getSupplierIds());
        request.setAttribute("formError", formError);
        request.setAttribute("resolvedImagePath", resolvedImagePath);
        request.setAttribute("todayDate", LocalDate.now().toString());
        request.getRequestDispatcher("/admin/editProduct.jsp").forward(request, response);
    }

    private Product buildProductFromRequest(HttpServletRequest request, ProductAdminDAO dao) throws IOException, ServletException {
        Product product = new Product();
        product.setIdProduct(trim(request.getParameter("idProduct")));
        product.setProductName(trim(request.getParameter("productName")));
        product.setIdSupplier(trim(request.getParameter("idSupplier")));
        product.setReleaseDate(normalizeReleaseDate(trim(request.getParameter("releaseDate"))));
        product.setScreen(trim(request.getParameter("screen")));
        product.setOperatingSystem(trim(request.getParameter("operatingSystem")));
        product.setCpu(trim(request.getParameter("cpu")));
        product.setRam(trim(request.getParameter("ram")));
        product.setCamera(trim(request.getParameter("camera")));
        product.setBattery(trim(request.getParameter("battery")));
        product.setDescription(trim(request.getParameter("description")));
        product.setPrice(parseDouble(request.getParameter("price"), -1));
        int quantity = parseIntOrDefault(request.getParameter("quantity"), -1);
        product.setCurrentQuantity(quantity);
        product.setOriginalQuantity(quantity);
        Integer idCat = dao.getCategoryIdBySupplier(product.getIdSupplier());
        product.setIdCat(idCat == null ? 0 : idCat);
        product.setDiscount(0d);
        product.setIsFeatured(0);
        product.setImagePath(resolveImagePath(request));
        return product;
    }

    private Map<String, String> validateProduct(HttpServletRequest request, Product product, boolean editMode)
            throws IOException, ServletException {
        Map<String, String> errors = new LinkedHashMap<>();
        Part imageFile = request.getPart("imageFile");
        boolean hasUploadedImage = imageFile != null && imageFile.getSize() > 0;

        validateRequired(product.getProductName(), "productName", "Tên sản phẩm không được để trống.", errors);
        validateRequired(product.getIdSupplier(), "idSupplier", "Nhà cung cấp không được để trống.", errors);
        if (!hasUploadedImage) {
            validateRequired(product.getImagePath(), "imagePath", "Vui lòng nhập URL ảnh hoặc tải ảnh lên.", errors);
        }

        validateMaxLength(product.getProductName(), 150, "productName", "Tên sản phẩm tối đa 150 ký tự.", errors);
        validateMaxLength(product.getScreen(), 50, "screen", "Màn hình tối đa 50 ký tự.", errors);
        validateMaxLength(product.getOperatingSystem(), 30, "operatingSystem", "Hệ điều hành tối đa 30 ký tự.", errors);
        validateMaxLength(product.getCpu(), 50, "cpu", "CPU tối đa 50 ký tự.", errors);
        validateMaxLength(product.getRam(), 10, "ram", "RAM tối đa 10 ký tự.", errors);
        validateMaxLength(product.getCamera(), 80, "camera", "Camera tối đa 80 ký tự.", errors);
        validateMaxLength(product.getBattery(), 20, "battery", "Pin tối đa 20 ký tự.", errors);
        validateMaxLength(product.getDescription(), 1000, "description", "Mô tả tối đa 1000 ký tự.", errors);
        validateMaxLength(product.getImagePath(), 500, "imagePath", "Đường dẫn ảnh tối đa 500 ký tự.", errors);

        if (product.getPrice() < 0) {
            errors.put("price", "Giá phải là số lớn hơn hoặc bằng 0.");
        }
        if (product.getCurrentQuantity() < 0) {
            errors.put("quantity", "Số lượng phải là số nguyên lớn hơn hoặc bằng 0.");
        }

        if (!product.getReleaseDate().isBlank()) {
            try {
                LocalDate releaseDate = LocalDate.parse(product.getReleaseDate());
                if (releaseDate.isAfter(LocalDate.now())) {
                    errors.put("releaseDate", "Ngày ra mắt không được lớn hơn ngày hiện tại.");
                }
            } catch (Exception ex) {
                errors.put("releaseDate", "Ngày ra mắt không hợp lệ.");
            }
        }

        if (!product.getImagePath().isBlank() && !isValidImageReference(product.getImagePath())) {
            errors.put("imagePath", "Không thể tải ảnh từ đường dẫn đã nhập.");
        }

        if (hasUploadedImage) {
            String contentType = imageFile.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                errors.put("imageFile", "Tệp tải lên phải là ảnh hợp lệ.");
            }
            if (imageFile.getSize() > MAX_IMAGE_SIZE) {
                errors.put("imageFile", "Ảnh tải lên không được vượt quá 500KB.");
            }
        }

        if (editMode && product.getIdProduct().isBlank()) {
            errors.put("idProduct", "Không tìm thấy mã sản phẩm để cập nhật.");
        }

        return errors;
    }

    private String resolveImagePath(HttpServletRequest request) throws IOException, ServletException {
        Part imageFile = request.getPart("imageFile");
        if (imageFile != null && imageFile.getSize() > 0) {            String uploadedUrl = CloudinaryUtil.uploadImage(imageFile);
            if (uploadedUrl != null && !uploadedUrl.isBlank()) {                return uploadedUrl;
            }

            String localUploadPath = saveLocalProductImage(request, imageFile);
            if (localUploadPath != null && !localUploadPath.isBlank()) {                return localUploadPath;
            }        }

        String imagePath = trim(request.getParameter("imagePath"));
        if (!imagePath.isBlank()) {
            return imagePath;
        }

        return trim(request.getParameter("existingImagePath"));
    }

    private String saveLocalProductImage(HttpServletRequest request, Part imageFile) {
        try {
            String submittedName = imageFile.getSubmittedFileName();
            String extension = getSafeImageExtension(submittedName);
            if (extension == null) {                return null;
            }

            String webRoot = request.getServletContext().getRealPath("/");
            if (webRoot == null || webRoot.isBlank()) {                return null;
            }            Path uploadDir = Path.of(webRoot, "uploads", "products");
            Files.createDirectories(uploadDir);

            String fileName = "product-" + UUID.randomUUID() + extension;
            Path targetPath = uploadDir.resolve(fileName);
            try (InputStream input = imageFile.getInputStream()) {
                Files.copy(input, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }
            return request.getContextPath() + "/uploads/products/" + fileName;
        } catch (Exception ex) {            return null;
        }
    }

    private String getSafeImageExtension(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            return null;
        }
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return null;
        }
        String extension = fileName.substring(dotIndex).toLowerCase();
        switch (extension) {
            case ".png":
            case ".jpg":
            case ".jpeg":
            case ".gif":
            case ".webp":
                return extension;
            default:
                return null;
        }
    }

    private boolean isValidImageReference(String imageUrl) {
        if (imageUrl == null || imageUrl.isBlank()) {
            return false;
        }
        String normalized = imageUrl.trim();
        if (normalized.startsWith("/")) {
            return true;
        }
        String lower = normalized.toLowerCase();
        if (!lower.contains("://")) {
            return lower.matches(".*\\.(png|jpg|jpeg|gif|webp|svg)$");
        }
        return isValidRemoteImageUrl(normalized);
    }

    private boolean isValidRemoteImageUrl(String imageUrl) {
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(imageUrl).openConnection();
            connection.setRequestMethod("HEAD");
            connection.setConnectTimeout(3000);
            connection.setReadTimeout(3000);
            String contentType = connection.getContentType();
            return connection.getResponseCode() < 400 && contentType != null && contentType.startsWith("image/");
        } catch (Exception ex) {
            return false;
        }
    }

    private void validateRequired(String value, String field, String message, Map<String, String> errors) {
        if (value == null || value.isBlank()) {
            errors.put(field, message);
        }
    }

    private void validateMaxLength(String value, int maxLength, String field, String message, Map<String, String> errors) {
        if (value != null && value.length() > maxLength) {
            errors.put(field, message);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeReleaseDate(String rawValue) {
        String normalized = trim(rawValue);
        if (normalized.isBlank()) {
            return "";
        }
        try {
            return LocalDate.parse(normalized).toString();
        } catch (DateTimeParseException ex) {
            return normalized;
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(trim(value));
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return Double.parseDouble(trim(value));
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin product management";
    }
}
