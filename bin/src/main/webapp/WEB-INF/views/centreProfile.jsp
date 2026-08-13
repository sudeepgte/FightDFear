<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Martial Arts Center Details</title> 
     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
   <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container mt-4">
        <h2 class="text-center">${center.name}</h2>
        
        <p><strong>📍 Location:</strong> ${center.location}</p>
        <p><strong>📞 Phone:</strong> ${center.phoneNumber}</p>
        <p><strong>📧 Email:</strong> ${center.email}</p>
        
        <hr>
        <h4>📝 About the Centre:</h4>
        <p>${center.about}</p>

        <h4>📖 How We Teach:</h4>
        <p>${center.howWeTeach}</p>

        <h4>🎁 What We Offer:</h4>
        <p>${center.whatWeOffer}</p>

        <h4>📅 Available Days:</h4>
        <p>
            <c:forEach var="day" items="${sortedAvailableDays}" varStatus="status">
                ✔ ${day}<c:if test="${!status.last}">, </c:if>
            </c:forEach>
        </p>

        <hr>
        <h4>🖼 Training Gallery:</h4>
        <div class="row">
            <c:forEach var="photo" items="${center.galleryPhotos}">
                <div class="col-md-3 mb-3">
                    <img src="${pageContext.request.contextPath}${photo}" class="img-fluid rounded shadow-sm" style="height: 150px; width: 100%; object-fit: cover;">
                </div>
            </c:forEach>
        </div>

        <hr>
        <p><strong>✅ Approval Status:</strong> 
            <c:choose>
                <c:when test="${center.approved}">✅ Approved</c:when>
                <c:otherwise>❌ Pending Approval</c:otherwise>
            </c:choose>
        </p>

        <h4>🏆 Martial Arts Types & Fees:</h4>
        <ul>
            <c:forEach var="type" items="${center.martialArtsTypes}">
                <li>${type.name} - ₹${type.cost}</li>
            </c:forEach>
        </ul>

        <h4>📅 Available Training Batches:</h4>
        <ul>
            <c:forEach var="batch" items="${batches}">
                <li><strong>${batch.name}</strong> (${batch.style}) - ₹${batch.fee} [${batch.timeSlot}]</li>
            </c:forEach>
            <c:if test="${empty batches}">
                <li>No batches added yet.</li>
            </c:if>
        </ul>

        <h4>📜 Trainer Certificate:</h4>
        <c:if test="${not empty center.trainerCertificatePath}">
            <p>
                <a href="${pageContext.request.contextPath}${center.trainerCertificatePath}" target="_blank" class="btn btn-primary">
    View Certificate
</a>

            </p>
        </c:if>
        <c:if test="${empty center.trainerCertificatePath}">
            <p>No certificate uploaded</p>
        </c:if>
      
    </div>
</body>
</html>

