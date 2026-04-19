package controller;

import dao.TradeInConfigDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý cấu hình Trade-in.
 * 
 * GET  /TradeInConfigServlet → hiển thị danh sách cấu hình (admin-trade-in-config.jsp)
 * GET  /TradeInConfigServlet?action=edit → hiển thị form chỉnh sửa (config-trade-in-edit.jsp)
 * POST /TradeInConfigServlet → cập nhật cấu hình → redirect về list
 */
@WebServlet(name = "TradeInConfigServlet", urlPatterns = {"/TradeInConfigServlet"})
public class TradeInConfigServlet extends HttpServlet {

    private final TradeInConfigDAO tradeInDAO = new TradeInConfigDAO();

    // ── GET: hiển thị danh sách hoặc form edit ───────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                // Hiển thị form chỉnh sửa
                Map<String, Object> config = tradeInDAO.getConfig();
                request.setAttribute("config", config);
                request.getRequestDispatcher("/config-trade-in-edit.jsp").forward(request, response);
            } else {
                // Hiển thị danh sách (chỉ có 1 bản ghi)
                Map<String, Object> config = tradeInDAO.getConfig();
                String search = request.getParameter("search");
                if (search != null && !search.trim().isEmpty() && config != null) {
                    String s = search.trim().toLowerCase();
                    String title = config.get("Title") != null ? config.get("Title").toString().toLowerCase() : "";
                    String desc = config.get("Description") != null ? config.get("Description").toString().toLowerCase() : "";
                    if (!title.contains(s) && !desc.contains(s)) {
                        config = null; // Filter logic
                    }
                }
                request.setAttribute("tradeInConfig", config);
                request.setAttribute("search", request.getParameter("search"));
                request.getRequestDispatcher("/admin-trade-in-list.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin-trade-in-list.jsp").forward(request, response);
        }
    }

    // ── POST: cập nhật cấu hình ─────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy các tham số từ form
            Map<String, String> params = new HashMap<>();
            params.put("title", request.getParameter("title"));
            params.put("description", request.getParameter("description"));
            params.put("note1Title", request.getParameter("note1Title"));
            params.put("note1Desc", request.getParameter("note1Desc"));
            params.put("note2Title", request.getParameter("note2Title"));
            params.put("note2Desc", request.getParameter("note2Desc"));
            params.put("note3Title", request.getParameter("note3Title"));
            params.put("note3Desc", request.getParameter("note3Desc"));

            boolean success = tradeInDAO.updateConfig(params);
            if (success) {
                System.out.println("✅ TradeInConfig updated successfully");
            } else {
                System.err.println("❌ Failed to update TradeInConfig");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lưu cấu hình: " + e.getMessage());
        }

        // Redirect về trang danh sách
        response.sendRedirect(request.getContextPath() + "/TradeInConfigServlet");
    }
}