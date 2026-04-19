package dao;

import config.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO cho bảng TradeInConfig.
 * Xử lý cấu hình hiển thị Trade-in trên trang chủ.
 */
public class TradeInConfigDAO {

    // ──────────────────────────────────────────
    //  HELPER: map ResultSet → Map
    // ──────────────────────────────────────────
    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> config = new HashMap<>();
        config.put("Id", rs.getInt("Id"));
        config.put("Title", rs.getString("Title"));
        config.put("Description", rs.getString("Description"));
        config.put("Note1_Title", rs.getString("Note1_Title"));
        config.put("Note1_Desc", rs.getString("Note1_Desc"));
        config.put("Note2_Title", rs.getString("Note2_Title"));
        config.put("Note2_Desc", rs.getString("Note2_Desc"));
        config.put("Note3_Title", rs.getString("Note3_Title"));
        config.put("Note3_Desc", rs.getString("Note3_Desc"));
        return config;
    }

    // ──────────────────────────────────────────
    //  READ: Lấy cấu hình Trade-in (chỉ có 1 bản ghi, Id = 1)
    // ──────────────────────────────────────────
    public Map<String, Object> getConfig() throws Exception {
        String sql = "SELECT * FROM TradeInConfig WHERE Id = 1";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ──────────────────────────────────────────
    //  UPDATE: Cập nhật cấu hình Trade-in
    // ──────────────────────────────────────────
    public boolean updateConfig(Map<String, String> params) throws Exception {
        String sql = """
            UPDATE TradeInConfig SET 
                Title = ?, 
                Description = ?,
                Note1_Title = ?, Note1_Desc = ?,
                Note2_Title = ?, Note2_Desc = ?,
                Note3_Title = ?, Note3_Desc = ?
            WHERE Id = 1
            """;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, params.get("title"));
            ps.setString(2, params.get("description"));
            ps.setString(3, params.get("note1Title"));
            ps.setString(4, params.get("note1Desc"));
            ps.setString(5, params.get("note2Title"));
            ps.setString(6, params.get("note2Desc"));
            ps.setString(7, params.get("note3Title"));
            ps.setString(8, params.get("note3Desc"));
            
            int rows = ps.executeUpdate();
            System.out.println("✅ Updated TradeInConfig, rows: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ SQL Error updating TradeInConfig: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // ──────────────────────────────────────────
    //  READ: Lấy danh sách (dùng cho list, trả về list chứa 1 phần tử)
    // ──────────────────────────────────────────
    public List<Map<String, Object>> getAll() throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> config = getConfig();
        if (config != null) {
            list.add(config);
        }
        return list;
    }
}