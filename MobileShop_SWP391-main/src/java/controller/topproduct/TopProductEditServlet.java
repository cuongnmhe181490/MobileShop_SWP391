package controller.topproduct;

import dao.TopProductDAO;
import entity.TopProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet xử lý chỉnh sửa Top Product.
 *
 * GET  /TopProductEditServlet          → load danh sách sản phẩm + sản phẩm đang chọn vào form
 * GET  /TopProductEditServlet?id=N     → load sản phẩm có id=N vào form để sửa
 * POST /TopProductEditServlet          → cập nhật sản phẩm rồi redirect về TopProductListServlet
 */
@WebServlet(name = "TopProductEditServlet", urlPatterns = {"/TopProductEditServlet"})
public class TopProductEditServlet extends HttpServlet {

    private final TopProductDAO dao = new TopProductDAO();

    // ── GET: hiển thị form sửa ────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách tất cả sản phẩm để hiển thị dropdown chọn
        List<TopProduct> products = new ArrayList<>();
        try {
            products = dao.getAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("topProductList", products);

        // Nếu có param id thì load sản phẩm đó; không thì lấy sản phẩm đầu tiên
        TopProduct selected = null;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                selected = dao.getById(Integer.parseInt(idParam));
            } catch (Exception ignored) {}
        }
        if (selected == null && !products.isEmpty()) {
            selected = products.get(0);
        }

        request.setAttribute("topProduct", selected);
        request.getRequestDispatcher("topproduct_config/config-top-product-edit.jsp").forward(request, response);
    }

    // ── POST: lưu chỉnh sửa ──────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/TopProductEditServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/TopProductEditServlet");
            return;
        }

        // Đọc các trường từ form
        String productName = trim(request.getParameter("productName"));
        String productImage = trim(request.getParameter("productImage"));
        String priceStr = trim(request.getParameter("price"));
        String originalPriceStr = trim(request.getParameter("originalPrice"));
        String displayOrderStr = trim(request.getParameter("displayOrder"));
        String isActiveStr = request.getParameter("isActive");
        String discountStr = trim(request.getParameter("discountPercent"));

        // Validation
        StringBuilder errors = new StringBuilder();

        if (productName == null || productName.isEmpty()) {
            errors.append("Tên sản phẩm không được để trống. ");
        }

        double price = 0;
        if (priceStr == null || priceStr.isEmpty()) {
            errors.append("Giá không được để trống. ");
        } else {
            try {
                price = Double.parseDouble(priceStr);
                if (price < 0) {
                    errors.append("Giá phải là số dương. ");
                }
            } catch (NumberFormatException e) {
                errors.append("Giá phải là số hợp lệ. ");
            }
        }

        double originalPrice = price;
        if (originalPriceStr != null && !originalPriceStr.isEmpty()) {
            try {
                originalPrice = Double.parseDouble(originalPriceStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        int displayOrder = 1;
        if (displayOrderStr != null && !displayOrderStr.isEmpty()) {
            try {
                displayOrder = Integer.parseInt(displayOrderStr);
            } catch (NumberFormatException e) {
                errors.append("Thứ tự hiển thị phải là số nguyên. ");
            }
        }

        boolean isActive = (isActiveStr != null && isActiveStr.equals("on"));

        // DiscountPercent: mặc định = 0
        int discountPercent = 0;
        if (discountStr != null && !discountStr.isEmpty()) {
            try {
                discountPercent = Integer.parseInt(discountStr);
                if (discountPercent < 0 || discountPercent > 100) {
                    errors.append("Phần trăm giảm giá phải từ 0-100. ");
                }
            } catch (NumberFormatException e) {
                errors.append("Phần trăm giảm giá phải là số nguyên. ");
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            // Load lại danh sách để hiển thị form
            try {
                List<TopProduct> products = dao.getAll();
                request.setAttribute("topProductList", products);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.getRequestDispatcher("topproduct_config/config-top-product-edit.jsp").forward(request, response);
            return;
        }

        // Cập nhật vào DB
        TopProduct topProduct = new TopProduct();
        topProduct.setId(id);
        topProduct.setProductName(productName);
        topProduct.setProductImage(productImage != null ? productImage : "");
        topProduct.setPrice(price);
        topProduct.setOriginalPrice(originalPrice);
        topProduct.setDisplayOrder(displayOrder);
        topProduct.setActive(isActive);
        topProduct.setDiscountPercent(discountPercent);

        try {
            boolean success = dao.update(topProduct);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/TopProductListServlet");
            } else {
                request.setAttribute("error", "Lỗi khi cập nhật sản phẩm.");
                request.getRequestDispatcher("topproduct_config/config-top-product-edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("topproduct_config/config-top-product-edit.jsp").forward(request, response);
        }
    }

    private String trim(String s) {
        return (s == null) ? null : s.trim();
    }
}