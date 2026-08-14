<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Services</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">My Services</h2>
    <a href="${pageContext.request.contextPath}/stylists/services/add" class="btn btn-primary mb-3">Add New Service</a>

    <c:if test="${not empty services}">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Name</th>
                    <th>Price (₹)</th>
                    <th>Duration (min)</th>
                    <th>Ingredients</th>
                    <th>Allergens</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${services}">
                    <tr>
                        <td>${s.name}</td>
                        <td>${s.price}</td>
                        <td>${s.durationMinutes}</td>
                        <td>${s.ingredients}</td>
                        <td>${s.allergenInfo}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/stylists/services/edit/${s.id}" class="btn btn-warning btn-sm">Edit</a>
                            <a href="${pageContext.request.contextPath}/stylists/services/delete/${s.id}" 
                               onclick="return confirm('Are you sure you want to delete this service?');" 
                               class="btn btn-danger btn-sm">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty services}">
        <p class="text-muted">You have not added any services yet.</p>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

