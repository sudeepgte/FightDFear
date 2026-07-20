<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User List</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
   
</head>
<body>

    <h1>User List</h1>

    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Phone Number</th>
                <th>Email</th>
                <th>Profile Photo</th>
            </tr>
        </thead>
        <tbody>
            <!-- Loop through the list of users and display each user's details -->
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td>${user.fullName}</td>
                    <td>${user.phoneNumber}</td>
                    <td>${user.email}</td>
                    <td><img src="<c:url value='${pageContext.request.contextPath}${user.profilePhoto}' />" alt="Profile Photo" width="50" height="50"></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <a href="${pageContext.request.contextPath}/home">Back to Home</a>

</body>
</html>

