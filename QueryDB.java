import java.sql.*;
public class QueryDB {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3306/womenbesafe";
        String user = "root";
        String pass = "root";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            try (ResultSet rs = stmt.executeQuery("SELECT full_name, profile_photo FROM user WHERE full_name IN ('Prakruthi', 'Aasif khan', 'prakruthi')")) {
                while(rs.next()) {
                    System.out.println(rs.getString("full_name") + " -> " + rs.getString("profile_photo"));
                }
            }
        }
    }
}
