<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>Medical Details</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<h2>Medical Details for User</h2>

<!-- Form to add/update Medical Details -->
<form action="${pageContext.request.contextPath}/users/{userId}/medical-details" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    <label>Blood Group:</label><br>
    <input type="text" name="bloodGroup" required><br>
    <label>Allergies:</label><br>
    <input type="text" name="allergies" required><br>
    <label>Medical History:</label><br>
    <textarea name="medicalHistory"></textarea><br>
    <label>Medications:</label><br>
    <textarea name="medications"></textarea><br>
    <input type="submit" value="Update Medical Details">
</form>

<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>

