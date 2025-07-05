package utilities;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://high.phaplamvua.net:2359;databaseName=ProductIntro";
    private static final String USER = "sa";
    private static final String PASSWORD = "12345";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server Driver not found", e);
        }
    }
}