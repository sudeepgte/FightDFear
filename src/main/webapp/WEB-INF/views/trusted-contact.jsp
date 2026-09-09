<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <title>Trusted Contacts</title>
</head>
<body>
<h2>Trusted Contacts for User</h2>

<!-- Form to add a new Trusted Contact -->
<form action="${pageContext.request.contextPath}/users/{userId}/trusted-contacts" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    <label>Name:</label><br>
    <input type="text" name="name" required><br>
    <label>Phone:</label><br>
    <input type="text" name="phone" required><br>
    <input type="submit" value="Add Trusted Contact">
</form>

<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>

