package controller;

import dao.DAO;
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

        DAO dao = new DAO();
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

    private void showExistingProductForm(HttpServletRequest request, HttpServletResponse response, DAO dao, boolean viewMode)
            throws ServletException, IOException {
        String id = trim(request.getParameter("id"));
        Product product = dao.getProductByID(id);
        if (product == null) {
            request.getSession().setAttribute("errorMessage", "KhÃ´ng tÃ¬m tháº¥y sáº£n pháº©m.");
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        showForm(request, response, dao, product, new LinkedHashMap<>(), true, viewMode, null);
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response, DAO dao)
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
        if (!productDataAvailable) {
            request.setAttribute("productDataError", "Khong the tai du lieu san pham tu co so du lieu. Vui long kiem tra cau hinh DB.");
        }
        request.getRequestDispatcher("/admin/product-manage.jsp").forward(request, response);
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response, DAO dao, boolean editMode)
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
                    duplicateProduct ? "Sáº£n pháº©m Ä‘Ã£ tá»“n táº¡i. Náº¿u lÆ°u, há»‡ thá»‘ng sáº½ cá»™ng thÃªm sá»‘ lÆ°á»£ng tá»“n kho." : null
            );
            return;
        }

        boolean success;
        String successMessage;
        if (duplicateProduct) {
            success = dao.restockExistingProduct(product.getProductName(), product.getIdSupplier(), product.getCurrentQuantity());
            successMessage = success
                    ? "Sáº£n pháº©m Ä‘Ã£ tá»“n táº¡i, há»‡ thá»‘ng Ä‘Ã£ cá»™ng thÃªm sá»‘ lÆ°á»£ng vÃ o kho."
                    : "KhÃ´ng thá»ƒ cáº­p nháº­t sá»‘ lÆ°á»£ng cho sáº£n pháº©m Ä‘Ã£ tá»“n táº¡i.";
        } else {
            success = editMode ? dao.updateProduct(product) : dao.addProduct(product);
            successMessage = success
                    ? (editMode ? "Cáº­p nháº­t sáº£n pháº©m thÃ nh cÃ´ng." : "ThÃªm sáº£n pháº©m thÃ nh cÃ´ng.")
                    : (editMode ? "Cáº­p nháº­t sáº£n pháº©m tháº¥t báº¡i." : "ThÃªm sáº£n pháº©m tháº¥t báº¡i.");
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
                        ? "Cáº­p nháº­t sá»‘ lÆ°á»£ng tháº¥t báº¡i. Vui lÃ²ng kiá»ƒm tra láº¡i dá»¯ liá»‡u."
                        : "LÆ°u sáº£n pháº©m tháº¥t báº¡i. Vui lÃ²ng thá»­ láº¡i."
        );
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, DAO dao)
            throws IOException {
        String id = trim(request.getParameter("id"));
        boolean success = !id.isBlank() && dao.deleteProduct(id);
        request.getSession().setAttribute(
                success ? "successMessage" : "errorMessage",
                success ? "XÃ³a sáº£n pháº©m thÃ nh cÃ´ng." : "XÃ³a sáº£n pháº©m tháº¥t báº¡i."
        );
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, DAO dao,
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
        request.getRequestDispatcher("/admin/editProduct.jsp").forward(request, response);
    }

    private Product buildProductFromRequest(HttpServletRequest request, DAO dao) throws IOException, ServletException {
        Product product = new Product();
        product.setIdProduct(trim(request.getParameter("idProduct")));
        product.setProductName(trim(request.getParameter("productName")));
        product.setIdSupplier(trim(request.getParameter("idSupplier")));
        product.setReleaseDate(trim(request.getParameter("releaseDate")));
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

        validateRequired(product.getProductName(), "productName", "Ten san pham khong duoc de trong.", errors);
        validateRequired(product.getIdSupplier(), "idSupplier", "Nha cung cap khong duoc de trong.", errors);
        if (!hasUploadedImage) {
            validateRequired(product.getImagePath(), "imagePath", "Vui long nhap URL anh hoac tai anh len.", errors);
        }

        validateMaxLength(product.getProductName(), 150, "productName", "Ten san pham toi da 150 ky tu.", errors);
        validateMaxLength(product.getScreen(), 50, "screen", "Man hinh toi da 50 ky tu.", errors);
        validateMaxLength(product.getOperatingSystem(), 30, "operatingSystem", "He dieu hanh toi da 30 ky tu.", errors);
        validateMaxLength(product.getCpu(), 50, "cpu", "CPU toi da 50 ky tu.", errors);
        validateMaxLength(product.getRam(), 10, "ram", "RAM toi da 10 ky tu.", errors);
        validateMaxLength(product.getCamera(), 80, "camera", "Camera toi da 80 ky tu.", errors);
        validateMaxLength(product.getBattery(), 20, "battery", "Pin toi da 20 ky tu.", errors);
        validateMaxLength(product.getDescription(), 1000, "description", "Mo ta toi da 1000 ky tu.", errors);
        validateMaxLength(product.getImagePath(), 500, "imagePath", "Duong dan anh toi da 500 ky tu.", errors);

        if (product.getPrice() < 0) {
            errors.put("price", "Gia phai la so lon hon hoac bang 0.");
        }
        if (product.getCurrentQuantity() < 0) {
            errors.put("quantity", "So luong phai la so nguyen lon hon hoac bang 0.");
        }

        if (!product.getReleaseDate().isBlank()) {
            try {
                LocalDate.parse(product.getReleaseDate());
            } catch (Exception ex) {
                errors.put("releaseDate", "Ngay ra mat khong hop le.");
            }
        }

        if (!product.getImagePath().isBlank() && !isValidImageReference(product.getImagePath())) {
            errors.put("imagePath", "Khong the tai anh tu duong dan da nhap.");
        }

        if (hasUploadedImage) {
            String contentType = imageFile.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                errors.put("imageFile", "Tep tai len phai la anh hop le.");
            }
            if (imageFile.getSize() > MAX_IMAGE_SIZE) {
                errors.put("imageFile", "Anh tai len khong duoc vuot qua 500kb.");
            }
        }

        if (editMode && product.getIdProduct().isBlank()) {
            errors.put("idProduct", "Khong tim thay ma san pham de cap nhat.");
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

