<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add / Edit Service</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4"><c:out value="${service.id != null ? 'Edit Service' : 'Add New Service'}"/></h2>
    <form action="${pageContext.request.contextPath}/stylists/services/save" method="post">
        <input type="hidden" name="id" value="${service.id}">

        <div class="mb-3">
            <label class="form-label">Service Name</label>
            <input type="text" name="name" value="${service.name}" class="form-control" placeholder="e.g., Haircut, Facial" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Price (₹)</label>
            <input type="number" step="0.01" name="price" value="${service.price}" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Duration (minutes)</label>
            <input type="number" name="durationMinutes" value="${service.durationMinutes}" class="form-control">
        </div>

        <div class="mb-3">
            <label class="form-label">Ingredients</label>
            <input type="text" name="ingredients" value="${service.ingredients}" class="form-control" placeholder="Optional">
        </div>

        <div class="mb-3">
            <label class="form-label">Allergen Info</label>
            <input type="text" name="allergenInfo" value="${service.allergenInfo}" class="form-control" placeholder="Optional">
        </div>

        <button type="submit" class="btn btn-success"><c:out value="${service.id != null ? 'Update' : 'Add'}"/></button>
        <a href="${pageContext.request.contextPath}/stylists/services" class="btn btn-secondary">Cancel</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

