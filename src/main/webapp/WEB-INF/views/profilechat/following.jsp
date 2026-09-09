<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}"><title>Following</title></head>
<body>
<h2>You Are Following</h2>
<c:forEach var="u" items="${following}">
  <div class="user-card">
    <img src="${pageContext.request.contextPath}${u.profilePhoto}" width="50" height="50"/>
    <span>${u.fullName}</span>
  </div>
</c:forEach>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
