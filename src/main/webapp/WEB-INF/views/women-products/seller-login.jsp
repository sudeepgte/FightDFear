<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Login — Women Products</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }
        .app-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            text-decoration: none;
        }
        .header-brand i { color: var(--primary); font-size: 1.3rem; }
        .header-links a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
        }
        .header-links a:hover { color: var(--primary); }
        .main-container {
            flex: 1;
            max-width: 480px;
            width: 100%;
            margin: 40px auto;
            padding: 0 16px;
        }
        .info-banner {
            background: var(--rose-soft);
            border-radius: 16px;
            padding: 18px 20px;
            margin-bottom: 20px;
            border: 1px solid #FECDD3;
        }
        .info-banner h2 { font-size: 1.15rem; font-weight: 800; margin-bottom: 4px; }
        .info-banner p { font-size: 0.88rem; color: var(--navy); }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .input-wrapper { position: relative; }
        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
        }
        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .password-field .form-input { padding-right: 42px; }
        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            padding: 4px;
            font-size: 1.1rem;
        }
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 0.85rem;
            gap: 12px;
            flex-wrap: wrap;
        }
        .form-options a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
        }
        .btn-submit:hover { background: var(--primary-hover); }
        .login-footer { text-align: center; margin-top: 20px; font-size: 0.9rem; color: var(--text-gray); }
        .login-footer a { color: var(--primary); text-decoration: none; font-weight: 700; }
        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .alert-error { background: var(--error-bg); border: 1px solid #FECACA; color: var(--error); }
        .alert-success { background: var(--success-bg); border: 1px solid #BBF7D0; color: var(--success); }
        @media (max-width: 480px) {
            .form-card { padding: 22px 16px; }
            .app-header { padding: 12px 16px; }
        }
    </style>
</head>
<body class="wp-auth">
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/women-products">
            <i class="bi bi-bag-heart-fill"></i> Women Products
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/women-products/seller/register">Register</a>
        </div>
    </header>

    <main class="main-container">
        <div class="info-banner">
            <h2>Seller login</h2>
            <p>Sign in to manage your Women Products catalog, stock, and orders.</p>
        </div>
        <div class="form-card">
            <c:if test="${not empty error}">
                <div class="alert-box alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>
            <c:if test="${param.registered == 'true'}">
                <div class="alert-box alert-success"><i class="bi bi-shield-check"></i> Account registered. Your seller account is awaiting approval.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/women-products/seller/login" method="post">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input class="form-input" type="email" name="email" id="email" required placeholder="Enter your email">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper password-field">
                        <input class="form-input" type="password" name="password" id="password" required placeholder="Enter your password">
                        <button type="button" class="password-toggle-btn" id="togglePassword" aria-label="Show password"><i class="bi bi-eye-slash"></i></button>
                    </div>
                </div>
                <div class="form-options">
                    <span></span>
                    <a href="${pageContext.request.contextPath}/auth/forgot-password">Forgot password?</a>
                </div>
                <button type="submit" class="btn-submit">Sign in</button>
            </form>
            <p class="login-footer">New seller? <a href="${pageContext.request.contextPath}/women-products/seller/register">Create an account</a></p>
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
