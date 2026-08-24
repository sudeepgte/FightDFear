<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Partner Register — Women Products</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        body { font-family:'Poppins',sans-serif; min-height:100vh; margin:0; background:#fffcfd; }
        .wrap { max-width:560px; margin:40px auto; background:#fff; padding:32px; border-radius:20px; border:1px solid #f1f3f5; }
        h1 { font-family:Montserrat,sans-serif; color:#3F1430; }
        .fdf-form-group { margin-bottom:16px; }
        label { display:block; font-size:0.75rem; font-weight:800; text-transform:uppercase; margin-bottom:6px; }
        input, textarea { width:100%; padding:12px 14px; border:2px solid #f1f3f5; border-radius:12px; box-sizing:border-box; font-family:inherit; }
        .btn { width:100%; padding:14px; background:linear-gradient(135deg,#1e1b4b,#f43f5e); color:#fff; border:none; border-radius:14px; font-weight:800; cursor:pointer; }
        .alert { padding:12px 16px; border-radius:12px; margin-bottom:16px; font-weight:600; }
        .err { background:#fef2f2; color:#b91c1c; }
        .ok { background:#f0fdf4; color:#15803d; }
        a { color:#f43f5e; font-weight:700; text-decoration:none; }
    </style>
</head>
<body>
<div class="wrap">
    <h1>Delivery partner registration</h1>
    <p>Women Products deliveries only. Admin verification is required before assignments.</p>
    <c:if test="${not empty error}"><div class="alert err">${error}</div></c:if>
    <c:if test="${not empty success}"><div class="alert ok">${success}</div></c:if>
    <form action="${pageContext.request.contextPath}/women-products/delivery/register" method="post">
        <div class="fdf-form-group"><label>Full name</label><input name="fullName" required minlength="2"></div>
        <div class="fdf-form-group"><label>Mobile number</label><input name="phone" required pattern="\d{10}" maxlength="10"></div>
        <div class="fdf-form-group"><label>Email</label><input type="email" name="email" required></div>
        <div class="fdf-form-group"><label>Password</label><input type="password" name="password" required minlength="6"></div>
        <div class="fdf-form-group"><label>City</label><input name="city"></div>
        <div class="fdf-form-group"><label>Address</label><textarea name="address" rows="3"></textarea></div>
        <button class="btn" type="submit">Submit registration</button>
    </form>
    <p style="margin-top:16px;">Already registered? <a href="${pageContext.request.contextPath}/women-products/delivery/login">Sign in</a></p>
</div>
</body>
</html>
