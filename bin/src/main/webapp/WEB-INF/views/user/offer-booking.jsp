<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Book Offer</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f9f9f9;
        }
        .container {
            width: 50%;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }
        h2, h3 {
            text-align: center;
        }
        label {
            display: inline-block;
            width: 150px;
            margin-bottom: 10px;
        }
        input, textarea {
            width: 60%;
            padding: 5px;
            margin-bottom: 10px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Book This Offer</h2>

    <h3>Offer Details</h3>
    <p><strong>Offer Name:</strong> ${offer.title}</p>
    <p><strong>Description:</strong> ${offer.description}</p>
    <p><strong>Discount:</strong> ${offer.discountPercent}%</p>
    <p><strong>Salon:</strong> ${offer.salon.name}</p>

    <hr>

    <h3>Enter Booking Details</h3>

    <form:form action="${pageContext.request.contextPath}/salon/saveBooking?offerId=${offer.id}"
               method="post" modelAttribute="booking">

        <div>
            <label>Your Name:</label>
            <form:input path="customerName" required="true"/>
        </div>

        <div>
            <label>Email:</label>
            <form:input path="customerEmail" required="true"/>
        </div>

        <div>
            <label>Date:</label>
            <form:input path="date" type="date" required="true"/>
        </div>

        <div>
            <label>Time:</label>
            <form:input path="time" type="time" required="true"/>
        </div>

        <div>
            <label>Additional Notes:</label>
            <form:textarea path="notes" rows="3" cols="40" placeholder="Any special requests..."/>
        </div>

        <div style="text-align:center; margin-top:20px;">
            <button type="submit">Confirm Booking</button>
        </div>

    </form:form>
</div>

</body>
</html>
