<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>Followers</title></head>
<body>
<h2>Your Followers</h2>
<c:forEach var="u" items="${followers}">
  <div class="user-card">
    <img src="${pageContext.request.contextPath}${u.profilePhoto}" width="50" height="50"/>
    <span>${u.fullName}</span>
  </div>
</c:forEach>
</body>
</html>
