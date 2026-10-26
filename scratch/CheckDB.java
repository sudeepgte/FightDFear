import java.sql.*;
public class CheckDB {
    public static void main(String[] args) throws Exception {
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/womenbesafety?useSSL=false&allowPublicKeyRetrieval=true", "root", "Sarah@07");
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT count(*) FROM entrepreneurs");
        rs1.next(); System.out.println("Entrepreneurs: " + rs1.getInt(1));
        ResultSet rs2 = stmt.executeQuery("SELECT count(*) FROM business_proposals");
        rs2.next(); System.out.println("Proposals: " + rs2.getInt(1));
        conn.close();
    }
}
