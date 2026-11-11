package dao;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * Lop DAO co so: giu ket noi CSDL dung chung cho tat ca cac lop DAO con.
 * Thong tin ket noi (db.url, db.user, db.password) doc tu file db.properties
 * nam trong classpath (src/db.properties, duoc chep vao WEB-INF/classes khi build).
 * Tao file nay bang cach sao chep src/db.properties.example roi sua lai.
 */
public class DAO6 {
    public static Connection con;

    private static final String dbClass = "com.mysql.cj.jdbc.Driver";
    private static final String CONFIG_FILE = "db.properties";

    public DAO6() {
        try {
            if (con == null || con.isClosed()) {
                Properties cfg = loadConfig();
                Class.forName(dbClass);
                con = DriverManager.getConnection(cfg.getProperty("db.url"),
                        cfg.getProperty("db.user"), cfg.getProperty("db.password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** Doc file cau hinh ket noi CSDL tu classpath. */
    private static Properties loadConfig() throws Exception {
        InputStream in = DAO6.class.getClassLoader().getResourceAsStream(CONFIG_FILE);
        if (in == null) {
            throw new IllegalStateException("Khong tim thay " + CONFIG_FILE
                    + ". Hay sao chep src/db.properties.example thanh src/db.properties va sua thong tin ket noi.");
        }
        Properties p = new Properties();
        try (InputStreamReader reader = new InputStreamReader(in, StandardCharsets.UTF_8)) {
            p.load(reader);
        }
        return p;
    }
}
