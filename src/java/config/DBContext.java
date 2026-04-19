package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    protected Connection conn;

    public Connection getConnection() throws Exception {
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + "\\" + instance + ";databaseName=" + dbName;
        if (instance == null || instance.trim().isEmpty()) {
            url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true" + ";sendStringParametersAsUnicode=true";

        } else {
            url += ";encrypt=true;trustServerCertificate=true" + ";sendStringParametersAsUnicode=true";
        }
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(url, userID, password);
        return conn;
    }

    private final String serverName = readSetting("DB_SERVER", "localhost");
    private final String dbName = readSetting("DB_NAME", "MOBILESHOP_DEM08");
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
}
