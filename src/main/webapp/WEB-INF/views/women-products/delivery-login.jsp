<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Partner Login — Women Products</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
    <style>
        :root { --primary:#F43F5E; --primary-hover:#E11D48; --navy:#1E1B4B; --text-gray:#64748B; --bg-page:#F8FAFC; --card-bg:#FFFFFF; --border-color:#E2E8F0; --error:#DC2626; --error-bg:#FEF2F2; --rose-soft:#FFE4E6; }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; min-height:100vh; background:var(--bg-page); color:var(--navy); display:flex; flex-direction:column; }
        .app-header { background:#fff; border-bottom:1px solid var(--border-color); padding:14px 24px; display:flex; align-items:center; justify-content:space-between; }
        .header-brand { display:flex; align-items:center; gap:10px; font-size:1.15rem; font-weight:800; color:var(--navy); text-decoration:none; }
        .header-brand i { color:var(--primary); }
        .header-links a { color:var(--text-gray); text-decoration:none; font-weight:600; font-size:0.9rem; }
        .header-links a:hover { color:var(--primary); }
        .main-container { flex:1; max-width:480px; width:100%; margin:40px auto; padding:0 16px; }
        .info-banner { background:var(--rose-soft); border-radius:16px; padding:18px 20px; margin-bottom:20px; border:1px solid #FECDD3; }
        .info-banner h2 { font-size:1.15rem; font-weight:800; margin-bottom:4px; }
        .form-card { background:#fff; border:1px solid var(--border-color); border-radius:16px; padding:28px 24px; box-shadow:0 4px 20px rgba(0,0,0,0.03); }
        .form-group { margin-bottom:18px; }
        .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:6px; }
        .form-input { width:100%; padding:12px 14px; border:1px solid var(--border-color); border-radius:10px; font-size:0.95rem; font-family:inherit; }
        .form-input:focus { outline:none; border-color:var(--primary); box-shadow:0 0 0 3px rgba(244,63,94,0.12); }
        .password-field { position:relative; }
        .password-field .form-input { padding-right:42px; }
        .password-toggle-btn { position:absolute; right:12px; top:50%; transform:translateY(-50%); border:none; background:transparent; color:var(--text-gray); cursor:pointer; }
        .btn-submit { width:100%; padding:14px; background:var(--primary); color:#fff; border:none; border-radius:12px; font-weight:700; font-family:inherit; cursor:pointer; box-shadow:0 4px 14px rgba(244,63,94,0.25); }
        .btn-submit:hover { background:var(--primary-hover); }
        .login-footer { text-align:center; margin-top:20px; font-size:0.9rem; color:var(--text-gray); }
        .login-footer a { color:var(--primary); font-weight:700; text-decoration:none; }
        .alert { background:var(--error-bg); color:var(--error); padding:12px 14px; border-radius:10px; margin-bottom:16px; font-weight:600; }
        @media (max-width:480px) { .form-card { padding:22px 16px; } }
    </style>
</head>
<body class="wp-auth">
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/women-products"><i class="bi bi-truck"></i> Women Products</a>
        <div class="header-links"><a href="${pageContext.request.contextPath}/women-products/delivery/register">Register</a></div>
    </header>
    <main class="main-container">
        <div class="info-banner">
            <h2>Delivery login</h2>
            <p>Sign in to view assigned Women Products deliveries.</p>
        </div>
        <div class="form-card">
            <c:if test="${not empty error}"><div class="alert">${error}</div></c:if>
            <form action="${pageContext.request.contextPath}/women-products/delivery/login" method="post">
                <div class="form-group"><label>Email</label><input class="form-input" type="email" name="email" required></div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="password-field">
                        <input class="form-input" type="password" name="password" id="password" required>
                        <button type="button" class="password-toggle-btn" id="togglePassword" aria-label="Show password"><i class="bi bi-eye-slash"></i></button>
                    </div>
                </div>
                <button class="btn-submit" type="submit">Sign In</button>
            </form>
            <p class="login-footer">New partner? <a href="${pageContext.request.contextPath}/women-products/delivery/register">Register here</a></p>
        </div>
    </main>
    <script>
        document.getElementById('togglePassword').addEventListener('click', function () {
            var input = document.getElementById('password');
            var icon = this.querySelector('i');
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            icon.className = show ? 'bi bi-eye' : 'bi bi-eye-slash';
        });
    </script>
</body>
</html>
