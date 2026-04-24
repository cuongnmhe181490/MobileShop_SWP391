
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
                System.out.println("Connected in " + (end - start) + "ms");
                
                String query2 = "SELECT IdProduct, ProductName FROM ProductDetail WHERE TRY_CAST(IdProduct AS INT) IN (1, 2, 3, 49, 58, 74)";
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(query2)) {
                    System.out.println("--- ProductDetail IDs ---");
                    while (rs.next()) {
                        System.out.println("PID in DB: '" + rs.getString("IdProduct") + "' | Name: " + rs.getString("ProductName"));
                    }
                }
                
                conn.close();
            }
        } catch (Exception e) {
            System.out.println("Failed: " + e.getMessage());
        }
    }
}
