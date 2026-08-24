<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Partner Login — Women Products</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        body { font-family: 'Poppins', sans-serif; min-height: 100vh; display:flex; background:#fffcfd; color:#1e293b; margin:0; }
        .auth-container { flex:1; display:flex; width:100%; }
        .visual-panel { flex:1; background: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%); color:#fff; display:flex; align-items:center; justify-content:center; padding:60px; }
        .form-panel { flex:1.2; display:flex; justify-content:center; align-items:center; padding:60px; background:#fff; }
        .login-card { width:100%; max-width:450px; }
        .login-card h2 { font-family:'Montserrat',sans-serif; font-size:2rem; font-weight:900; color:#3F1430; margin-bottom:8px; }
        .subtitle { color:#64748b; margin-bottom:28px; }
        .fdf-form-group { margin-bottom:20px; }
        .fdf-form-group label { display:block; font-size:0.75rem; font-weight:800; text-transform:uppercase; margin-bottom:8px; }
        .fdf-input { width:100%; padding:14px 16px; border:2px solid #f1f3f5; border-radius:14px; background:#f8fafc; font-family:inherit; box-sizing:border-box; }
        .btn-fdf-login { width:100%; padding:16px; background:linear-gradient(135deg,#1e1b4b,#f43f5e); color:#fff; border:none; border-radius:16px; font-weight:800; cursor:pointer; }
        .alert { background:#fef2f2; color:#b91c1c; padding:12px 16px; border-radius:12px; margin-bottom:16px; font-weight:600; }
        .register-link { text-align:center; margin-top:20px; color:#64748b; }
        .register-link a { color:#f43f5e; font-weight:800; text-decoration:none; }
        .back-home { color:#64748b; text-decoration:none; font-weight:600; display:inline-block; margin-bottom:20px; }
        @media (max-width:992px) { .auth-container { flex-direction:column; } .visual-panel { min-height:22vh; padding:40px 24px; } }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="visual-panel">
        <div>
            <h2 style="font-family:Montserrat,sans-serif;">Women Products Delivery</h2>
            <p>Pick up assigned orders and update delivery status securely.</p>
        </div>
    </div>
    <div class="form-panel">
        <div class="login-card">
            <a class="back-home" href="${pageContext.request.contextPath}/women-products"><i class="bi bi-arrow-left"></i> Back to shop</a>
            <h2>Delivery login</h2>
            <p class="subtitle">Sign in to view assigned Women Products deliveries.</p>
            <c:if test="${not empty error}"><div class="alert">${error}</div></c:if>
            <form action="${pageContext.request.contextPath}/women-products/delivery/login" method="post">
                <div class="fdf-form-group"><label>Email</label><input class="fdf-input" type="email" name="email" required></div>
                <div class="fdf-form-group"><label>Password</label><input class="fdf-input" type="password" name="password" required></div>
                <button class="btn-fdf-login" type="submit">Sign In</button>
            </form>
            <p class="register-link">New partner? <a href="${pageContext.request.contextPath}/women-products/delivery/register">Register here</a></p>
        </div>
    </div>
</div>
</body>
</html>
