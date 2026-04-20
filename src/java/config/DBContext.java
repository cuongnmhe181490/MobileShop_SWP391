
package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    protected Connection conn;

  public Connection getConnection() throws Exception {
    String url;
    if (instance == null || instance.trim().isEmpty()) {
        url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName;
    } else {
        url = "jdbc:sqlserver://" + serverName + ":" + portNumber + "\\" + instance + ";databaseName=" + dbName;
    }
    // Thêm dấu ; đảm bảo ngăn cách các tham số
    url += ";encrypt=true;trustServerCertificate=true;loginTimeout=30;";
    
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    return DriverManager.getConnection(url, userID, password);
}

    private final String serverName = readSetting("DB_SERVER", "localhost");
    private final String dbName = readSetting("DB_NAME", "MOBILESHOP_DEM08"
            + "");
    private final String portNumber = readSetting("DB_PORT", "1433");
    private final String instance = readSetting("DB_INSTANCE", "");
    private final String userID = readSetting("DB_USER", "sa");
    private final String password = readSetting("DB_PASSWORD", "diep1611");

    private String readSetting(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }
    
    // --- ĐOẠN CODE TEST KẾT NỐI ---
    public static void main(String[] args) {
        try {
            System.out.println("Đang tiến hành kết nối đến SQL Server...");
            DBContext db = new DBContext();
            Connection testConn = db.getConnection();
            
            if (testConn != null) {
                System.out.println("✅ KẾT NỐI THÀNH CÔNG!");
                System.out.println("👉 Database đang sử dụng: " + testConn.getCatalog());
                testConn.close(); // Đóng kết nối sau khi test xong để giải phóng tài nguyên
            }
        } catch (Exception e) {
            System.out.println("❌ KẾT NỐI THẤT BÀI!");
            System.out.println("Vui lòng kiểm tra lại SQL Server đang chạy chưa, hoặc sai tên tài khoản/mật khẩu.");
            System.out.println("Chi tiết lỗi:");
            e.printStackTrace();
        }
    }

}
