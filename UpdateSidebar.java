import java.nio.file.*;
import java.util.regex.*;
import java.io.*;

public class UpdateSidebar {
    public static void main(String[] args) throws Exception {
        String dashboardPath = "src/main/webapp/WEB-INF/views/salon/salon-dashboard.jsp";
        String dashboardContent = Files.readString(Paths.get(dashboardPath));

        // 1. Extract CSS
        Matcher cssMatcher = Pattern.compile("(:root\\s*\\{[^}]*--fdf-burgundy.*?)/\\*\\s*Main Content\\s*\\*/", Pattern.DOTALL).matcher(dashboardContent);
        if (!cssMatcher.find()) {
            System.out.println("Could not find CSS in dashboard");
            return;
        }
        String cssToInject = cssMatcher.group(1);

        // 2. Extract Sidebar HTML
        Matcher sidebarMatcher = Pattern.compile("(<!-- Sidebar -->.*?)(?=<!-- Main Content -->)", Pattern.DOTALL).matcher(dashboardContent);
        if (!sidebarMatcher.find()) {
            System.out.println("Could not find Sidebar HTML in dashboard");
            return;
        }
        String sidebarHtml = sidebarMatcher.group(1);

        processFile("src/main/webapp/WEB-INF/views/salon/salon-profile.jsp", "Salon Profile", true, cssToInject, sidebarHtml);
        processFile("src/main/webapp/WEB-INF/views/salon/viewBookings.jsp", "Appointments", false, cssToInject, sidebarHtml);
        processFile("src/main/webapp/WEB-INF/views/salon/view-services.jsp", "Services", false, cssToInject, sidebarHtml);
    }

    static void processFile(String filePath, String activeText, boolean isOldProfile, String cssToInject, String sidebarHtml) throws Exception {
        String content = Files.readString(Paths.get(filePath));
        
        if (isOldProfile) {
            content = content.replaceFirst("(?s):root\\s*\\{.*?(?=\\.main-wrapper|\\.top-header)", Matcher.quoteReplacement(cssToInject));
            content = content.replaceFirst("(?s)<!-- Sidebar -->.*?<!-- Main Content Area -->", Matcher.quoteReplacement(sidebarHtml + "\n    <!-- Main Content Area -->"));
        } else {
            content = content.replaceFirst("(?s):root\\s*\\{.*?(?=/\\*\\s*Main Content\\s*\\*/|\\.main-content)", Matcher.quoteReplacement(cssToInject));
            content = content.replaceFirst("(?s)<!-- Sidebar -->.*?<!-- Main Content -->", Matcher.quoteReplacement(sidebarHtml + "<!-- Main Content -->"));
        }
        
        content = content.replace("class=\"nav-link-custom active\"", "class=\"nav-link-custom\"");
        
        String pattern = "(class=\"nav-link-custom\")([^>]*>\\s*<i[^>]*>\\s*</i>\\s*<span>" + activeText + "</span>)";
        content = content.replaceAll(pattern, "class=\"nav-link-custom active\"");
        
        Files.writeString(Paths.get(filePath), content);
        System.out.println("Updated " + filePath);
    }
}
