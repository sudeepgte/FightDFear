<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Salon Services</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Poppins&display=swap%22 rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
            font-family: 'Poppins', sans-serif;
            padding-top: 60px;
        }
        h2 {
            text-align: center;
            color: #6a0572;
            margin-bottom: 40px;
            font-family: 'Playfair Display', serif;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        .card-title {
            color: #6a0572;
            font-weight: bold;
            margin-top: 10px;
        }
        .card-text {
            color: #333;
            font-size: 0.95rem;
        }
        .service-image {
            height: 180px;
            width: 100%;
            object-fit: cover;
            border-radius: 12px;
        }
        .btn-custom {
            border-radius: 25px;
            font-weight: bold;
            padding: 6px 20px;
        }
        .btn-book {
            background-color: #6a0572;
            color: #fff;
            margin-right: 10px;
        }
        .btn-book:hover {
            background-color: #52044a;
            color: #fff;
        }
        .btn-view {
            background-color: #f0ad4e;
            color: #fff;
        }
        .btn-view:hover {
            background-color: #d4912c;
            color: #fff;
        }
        .card-buttons {
            margin-top: 10px;
        }
        .container {
            max-width: 1200px;
        }
        @media (max-width: 768px) {
            .card-text {
                font-size: 0.9rem;
            }
            .card-title {
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
 
<div class="container">
    <h2>All Salon Services</h2>
 
    <div class="row">
        <c:forEach var="service" items="${serviceList}">
            <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                <div class="card p-3 h-100">
                    <c:if test="${not empty service.photoUrl}">
                        <img src="${pageContext.request.contextPath}${service.photoUrl}" class="service-image mb-2" alt="${service.name}">
                    </c:if>
                    <h5 class="card-title">${service.name}</h5>
                    <p class="card-text">
                        <strong>Category:</strong> ${service.category}<br>
                        <strong>Price:</strong> ₹${service.price}<br>
                        <strong>Duration:</strong> ${service.durationMinutes} min<br>
                        <strong>Salon:</strong> ${service.salon.name}<br>
                        <strong>Contact:</strong> ${service.salon.phone}<br>
                        <strong>Address:</strong> ${service.salon.address}
                    </p>
                    <div class="card-buttons">
                        <a href="${pageContext.request.contextPath}/salon/viewSalonProfile?id=${service.salon.id}" class="btn btn-outline-primary btn-sm">View Parlour Profile</a>
                        <a href="${pageContext.request.contextPath}/booking?serviceId=${service.id}" class="btn btn-custom btn-book">Book Now</a>
                        
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
 
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
