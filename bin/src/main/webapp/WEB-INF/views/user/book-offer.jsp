<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Offer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
 
        h2.page-title {
            text-align: center;
            color: #6a0572;
            font-weight: bold;
            margin: 40px 0;
        }
 
        form.container {
            max-width: 600px;
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            margin-bottom: 50px;
        }
 
        .form-label {
            font-weight: 600;
            color: #6a0572;
        }
 
        input.form-control,
        select.form-control,
        textarea.form-control {
            border-radius: 10px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }
 
        input.form-control:focus,
        select.form-control:focus,
        textarea.form-control:focus {
            box-shadow: 0 0 8px rgba(106,5,114,0.3);
            border-color: #6a0572;
        }
 
        button.btn-book {
            background: linear-gradient(90deg, #8e2de2, #4a00e0);
            border: none;
            color: #fff;
            font-weight: 500;
            padding: 12px 0;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
 
        button.btn-book:hover {
            background: linear-gradient(90deg, #4a00e0, #8e2de2);
            box-shadow: 0 4px 12px rgba(78,0,224,0.3);
            transform: scale(1.05);
        }
 
        .mb-3 label {
            display: block;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="page-title">Book Offer: ${offer.title}</h2>
 
    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/salon/saveOfferBooking" method="post" class="container">
        <input type="hidden" name="offerId" value="${offer.id}" />
 
        <!-- Full Name -->
        <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="customerName" class="form-control" value="${user.fullName}" required>
        </div>
 
        <!-- Mobile Number -->
        <div class="mb-3">
            <label class="form-label">Mobile Number</label>
            <input type="text" name="customerPhone" class="form-control" value="${user.phoneNumber}" required>
        </div>
 
        <!-- Booking Type -->
        <div class="mb-3">
            <label class="form-label">Booking Type</label>
            <select name="bookingType" class="form-control" required>
                <option value="ONLINE">ONLINE</option>
                <option value="DOOR">DOOR</option>
            </select>
        </div>
 
        <!-- Address -->
        <div class="mb-3">
            <label class="form-label">Address (required if Door Booking)</label>
            <input type="text" name="address" class="form-control" value="${user.homeAddress}">
        </div>
 
        <!-- Price -->
        <div class="mb-3">
            <label class="form-label">Price</label>
            <input type="number" step="0.01" name="price" class="form-control" required
                   value="${offer.discountPercent}">
        </div>
 
        <!-- Notes -->
        <div class="mb-3">
            <label class="form-label">Notes (optional)</label>
            <textarea name="notes" class="form-control" rows="2"></textarea>
        </div>
 
        <!-- Emergency Contact -->
        <div class="mb-3">
            <label class="form-label">Emergency Contact</label>
            <input type="text" name="emergencyContact" class="form-control"
                   value="${user.phoneNumber}" required>
        </div>
 
        <!-- Allergy Info -->
        <div class="mb-3">
            <label class="form-label">Allergy Info</label>
            <input type="text" name="allergyInfo" class="form-control">
        </div>
 
        <button type="submit" class="btn btn-book w-100">Book Now</button>
    </form>
</div>
 
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
