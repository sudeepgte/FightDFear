<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="in.sp.main.Repository.UserRepository" %>
<%@ page import="in.sp.main.Entities.User" %>
<%@ page import="java.util.List" %>
<%
ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(application);
UserRepository userRepo = ctx.getBean(UserRepository.class);
List<User> users = userRepo.findAll();
for(User u : users) {
    out.println(u.getFullName() + " : " + u.getProfilePhoto() + "<br>");
}
%>
