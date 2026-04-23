
package scratch;
import java.sql.*;

public class TestDB {
    public static void main(String[] args) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Set a very short timeout to detect hang quickly
            String url = "jdbc:sqlserver://127.0.0.1:1433;databaseName=MOBILESHOP_DEM05;encrypt=true;trustServerCertificate=true;loginTimeout=5;";
            System.out.println("Connecting to " + url + "...");
            long start = System.currentTimeMillis();
            Connection conn = DriverManager.getConnection(url, "sa", "123");
            long end = System.currentTimeMillis();
            if (conn != null) {
                System.out.println("✅ Connected in " + (end - start) + "ms");
                conn.close();
            }
        } catch (Exception e) {
            System.out.println("❌ Failed: " + e.getMessage());
        }
    }
}
