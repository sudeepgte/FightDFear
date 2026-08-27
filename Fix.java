import java.nio.file.*;

public class Fix {
    public static void main(String[] args) throws Exception {
        String path = "c:/Users/priya/Desktop/FightDfire/FightDFear/src/main/webapp/WEB-INF/views/creatorMyProfile.jsp";
        String content = new String(Files.readAllBytes(Paths.get(path)));
        String replacement = "list.innerHTML += '<div style=\"display:flex; align-items:center; gap:10px; padding:10px 0; border-bottom:1px solid var(--border);\">' + '<img src=\"' + (v.avatar ? v.avatar : \"${pageContext.request.contextPath}/assets/img/default-avatar.png\") + '\" style=\"width:36px;height:36px;border-radius:50%;object-fit:cover;\">' + '<div style=\"font-size:14px;font-weight:600;\">' + v.name + '</div></div>';";
        
        int start = content.indexOf("list.innerHTML += `");
        if (start != -1) {
            int end = content.indexOf("`;", start) + 2;
            content = content.substring(0, start) + replacement + content.substring(end);
            Files.write(Paths.get(path), content.getBytes());
            System.out.println("Fixed");
        } else {
            System.out.println("Not found");
        }
    }
}
