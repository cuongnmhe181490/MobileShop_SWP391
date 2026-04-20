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

    private final String dbName = readSetting("DB_NAME", "MOBILESHOP_DEM05");

    private final String portNumber = readSetting("DB_PORT", "1433");

    private final String instance = readSetting("DB_INSTANCE", "");

    private final String userID = readSetting("DB_USER", "sa");

    private final String password = readSetting("DB_PASSWORD", "123");

    // Cloudinary Configuration
    public final String CLOUD_NAME = readSetting("CLOUDINARY_NAME", "dovcx8lxl");

    public final String CLOUD_API_KEY = readSetting("CLOUDINARY_API_KEY", "686417178596178");

    public final String CLOUD_API_SECRET = readSetting("CLOUDINARY_API_SECRET", "wgqV0cS4ia7kjW8fNJ-n21216hc");

    private String readSetting(String key, String defaultValue) {

        String value = System.getenv(key);

        if (value == null || value.trim().isEmpty()) {

            value = System.getProperty(key);

        }

        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();

    }

   
}
