<%@ page import="java.sql.*, org.springframework.context.ApplicationContext, org.springframework.web.context.support.WebApplicationContextUtils, javax.sql.DataSource" %>
<%
    ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    DataSource ds = ctx.getBean(DataSource.class);
    out.println("<h3>User Table</h3>");
    try (Connection conn = ds.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, full_name, profile_photo FROM user WHERE full_name LIKE '%Aasif%'");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            out.println("ID: " + rs.getLong("id") + ", Name: " + rs.getString("full_name") + ", Photo: " + rs.getString("profile_photo") + "<br>");
        }
    } catch(Exception e) { out.println(e.getMessage()); }

    out.println("<h3>Job Application Table</h3>");
    try (Connection conn = ds.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, user_id, profile_image_url FROM job_application WHERE user_id IN (SELECT id FROM user WHERE full_name LIKE '%Aasif%')");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            out.println("ID: " + rs.getLong("id") + ", User ID: " + rs.getLong("user_id") + ", Photo: " + rs.getString("profile_image_url") + "<br>");
        }
    } catch(Exception e) { out.println(e.getMessage()); }

    out.println("<h3>Marketplace Provider Table</h3>");
    try (Connection conn = ds.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, user_id, profile_photo FROM marketplace_provider WHERE user_id IN (SELECT id FROM user WHERE full_name LIKE '%Aasif%')");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            out.println("ID: " + rs.getLong("id") + ", User ID: " + rs.getLong("user_id") + ", Photo: " + rs.getString("profile_photo") + "<br>");
        }
    } catch(Exception e) { out.println("Error: " + e.getMessage()); }

    out.println("<h3>Service Provider Table</h3>");
    try (Connection conn = ds.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT id, user_id, profile_photo FROM service_provider WHERE user_id IN (SELECT id FROM user WHERE full_name LIKE '%Aasif%')");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            out.println("ID: " + rs.getLong("id") + ", User ID: " + rs.getLong("user_id") + ", Photo: " + rs.getString("profile_photo") + "<br>");
        }
    } catch(Exception e) { out.println("Error: " + e.getMessage()); }
%>
