
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
    System.out.println("Connecting to: " + url);
    return DriverManager.getConnection(url, userID, password);
}


    private final String serverName = readSetting("DB_SERVER", "127.0.0.1");
    private final String dbName = readSetting("DB_NAME", "MOBILESHOP_DEM05");
    private final String portNumber = readSetting("DB_PORT", "1433");
    private final String instance = readSetting("DB_INSTANCE", "");
    private final String userID = readSetting("DB_USER", "sa");
    private final String password = readSetting("DB_PASSWORD", "123");
    


    private String readSetting(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }


    public static void main(String[] args) {
        try {
            System.out.println("--- ĐANG KIỂM TRA KẾT NỐI DATABASE ---");
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ KẾT NỐI THÀNH CÔNG!");
                System.out.println("Database: " + db.dbName);
                System.out.println("User: " + db.userID);
                conn.close();
            }
        } catch (Exception e) {
            System.out.println("❌ KẾT NỐI THẤT BẠI!");
            System.out.println("Lỗi chi tiết: " + e.getMessage());
            e.printStackTrace();
        }
    }

}