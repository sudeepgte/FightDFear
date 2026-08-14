<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>Following</title></head>
<body>
<h2>You Are Following</h2>
<c:forEach var="u" items="${following}">
  <div class="user-card">
    <img src="${pageContext.request.contextPath}${u.profilePhoto}" width="50" height="50"/>
    <span>${u.fullName}</span>
  </div>
</c:forEach>
</body>
</html>
