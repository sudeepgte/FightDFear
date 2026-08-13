<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Live Session - Financial Literacy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">
</head>
<body>
    <c:set var="flAdminTitle" value="Add Live Session" scope="request"/>
    <c:set var="flAdminActive" value="add-live-session" scope="request"/>
    <%@ include file="_topbar.jsp" %>

    <div class="layout">
        <%@ include file="_sidebar.jsp" %>

        <main class="main">
            <div class="mainInner narrow">
                <div class="admin-card">
                    <h3>Add New Live Session</h3>
                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" method="POST">
                        <div class="mb-3">
                            <label for="title" class="form-label">Session Title</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label for="speaker" class="form-label">Speaker Name</label>
                            <input type="text" class="form-control" id="speaker" name="speaker" required>
                        </div>
                        <div class="mb-3">
                            <label for="date" class="form-label">Date</label>
                            <input type="text" class="form-control" id="date" name="date" placeholder="Saturday, 15th July" required>
                        </div>
                        <div class="mb-3">
                            <label for="time" class="form-label">Time</label>
                            <input type="text" class="form-control" id="time" name="time" placeholder="6:00 PM" required>
                        </div>
                        <div class="mb-3">
                            <label for="meetingUrl" class="form-label">Meeting Link</label>
                            <input type="text" class="form-control" id="meetingUrl" name="meetingUrl" placeholder="https://zoom.us/j/..." required>
                        </div>
                        <div class="mb-3">
                            <label for="seats" class="form-label">Number of Seats</label>
                            <input type="number" class="form-control" id="seats" name="seats" min="1" required>
                        </div>
                        <div class="mb-4">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required maxlength="1000"></textarea>
                        </div>
                        <button type="submit" class="btn-purple full">
                            <i class="fas fa-upload me-2"></i> Publish
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
