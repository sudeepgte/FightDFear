<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Successful</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
 
    <style>
        body {
            background-color: #fff0f6;
            font-family: 'Arial', sans-serif;
        }
 
        .success-container {
            text-align: center;
            margin-top: 100px;
        }
 
        .success-card {
            display: inline-block;
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            max-width: 500px;
        }
 
        .success-icon {
            font-size: 60px;
            color: #28a745;
            margin-bottom: 20px;
        }
 
        h2 {
            color: #ff4081;
            margin-bottom: 15px;
        }
 
        p {
            color: #555;
            font-size: 16px;
        }
 
        .btn-home {
            margin-top: 25px;
            background-color: #ff4081;
            border-color: #ff4081;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            padding: 10px 20px;
            transition: 0.3s;
        }
 
        .btn-home:hover {
            background-color: #e73370;
        }
    </style>
</head>
<body>
 
<div class="container success-container">
    <div class="success-card">
        <div class="success-icon">✅</div>
        <h2>Booking Confirmed!</h2>
        <p>Thank you for booking your treatment. We’ve sent your booking details to your registered email.</p>
        <a href="${pageContext.request.contextPath}/user/treatments/viewAll" class="btn btn-home">Back to Treatments</a>
    </div>
</div>
 
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
 
