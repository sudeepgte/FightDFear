<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Partner Register — Women Products</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
    <style>
        :root { --primary:#F43F5E; --primary-hover:#E11D48; --navy:#1E1B4B; --text-gray:#64748B; --bg-page:#F8FAFC; --border-color:#E2E8F0; --error:#DC2626; --error-bg:#FEF2F2; --success:#16A34A; --success-bg:#F0FDF4; --rose-soft:#FFE4E6; }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; min-height:100vh; background:var(--bg-page); color:var(--navy); display:flex; flex-direction:column; }
        .app-header { background:#fff; border-bottom:1px solid var(--border-color); padding:14px 24px; display:flex; align-items:center; justify-content:space-between; }
        .header-brand { display:flex; align-items:center; gap:10px; font-size:1.15rem; font-weight:800; color:var(--navy); text-decoration:none; }
        .header-brand i { color:var(--primary); }
        .header-links a { color:var(--text-gray); text-decoration:none; font-weight:600; font-size:0.9rem; }
        .main-container { flex:1; max-width:560px; width:100%; margin:28px auto 40px; padding:0 16px; }
        .info-banner { background:var(--rose-soft); border-radius:16px; padding:20px; margin-bottom:24px; border:1px solid #FECDD3; }
        .info-banner h2 { font-size:1.15rem; font-weight:800; margin-bottom:6px; }
        .form-card { background:#fff; border:1px solid var(--border-color); border-radius:16px; padding:28px 24px; box-shadow:0 4px 20px rgba(0,0,0,0.03); }
        .form-group { margin-bottom:16px; }
        label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:6px; }
        input, textarea { width:100%; padding:12px 14px; border:1px solid var(--border-color); border-radius:10px; box-sizing:border-box; font-family:inherit; font-size:0.95rem; }
        input:focus, textarea:focus { outline:none; border-color:var(--primary); box-shadow:0 0 0 3px rgba(244,63,94,0.12); }
        .btn { width:100%; padding:14px; background:var(--primary); color:#fff; border:none; border-radius:12px; font-weight:700; cursor:pointer; font-family:inherit; box-shadow:0 4px 14px rgba(244,63,94,0.25); }
        .btn:hover { background:var(--primary-hover); }
        .alert { padding:12px 16px; border-radius:12px; margin-bottom:16px; font-weight:600; }
        .err { background:var(--error-bg); color:var(--error); }
        .ok { background:var(--success-bg); color:var(--success); }
        a { color:var(--primary); font-weight:700; text-decoration:none; }
        .footer { text-align:center; margin-top:16px; color:var(--text-gray); font-size:0.9rem; }
        @media (max-width:480px) { .form-card { padding:22px 16px; } }
    </style>
</head>
<body class="wp-auth">
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/women-products"><i class="bi bi-truck"></i> Women Products</a>
        <div class="header-links"><a href="${pageContext.request.contextPath}/women-products/delivery/login">Sign in</a></div>
    </header>
    <main class="main-container">
        <div class="info-banner">
            <h2>Delivery partner registration</h2>
            <p>Women Products deliveries only. Admin verification is required before assignments.</p>
        </div>
        <div class="form-card">
            <c:if test="${not empty error}"><div class="alert err">${error}</div></c:if>
            <c:if test="${not empty success}"><div class="alert ok">${success}</div></c:if>
            <form action="${pageContext.request.contextPath}/women-products/delivery/register" method="post">
                <div class="form-group"><label>Full name</label><input name="fullName" required minlength="2"></div>
                <div class="form-group"><label>Mobile number</label><input name="phone" required pattern="\d{10}" maxlength="10"></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" required minlength="6"></div>
                <div class="form-group"><label>City</label><input name="city"></div>
                <div class="form-group"><label>Address</label><textarea name="address" rows="3"></textarea></div>
                <button class="btn" type="submit">Submit registration</button>
            </form>
            <p class="footer">Already registered? <a href="${pageContext.request.contextPath}/women-products/delivery/login">Sign in</a></p>
        </div>
    </main>
</body>
</html>
