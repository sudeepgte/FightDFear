<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investor Login — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            /* Mobile Flutter Theme Colors - Rose, Plum & neutral Slate */
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --primary-plum: #4c0519;
            --bg-scaffold: #f8fafc;
            --bg-surface: #ffffff;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
            --border-focus: #f43f5e;
            --rose-bg-light: #ffe4e6;
            --rose-text-dark: #be123c;
            --font-heading: 'Poppins', sans-serif;
            --font-body: 'Inter', sans-serif;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: var(--font-body);
            background: var(--bg-scaffold);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            margin: 0;
        }

        .login-container {
            width: 100%;
            max-width: 440px;
            background: var(--bg-surface);
            border-radius: 16px;
            padding: 40px; 
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-light);
            position: relative;
        }

        .back-link-top {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--primary-rose);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 25px;
            transition: color 0.2s;
        }

        .back-link-top:hover {
            color: var(--primary-rose-hover);
        }

        .header-title {
            font-family: var(--font-heading);
            font-weight: 800;
            color: var(--primary-plum);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.6rem;
        }

        .header-title span {
            color: var(--primary-rose);
        }

        .header-subtitle {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 30px;
        }

        .form-label {
            font-size: 0.85rem;
            color: var(--text-primary);
            font-weight: 600;
            margin-bottom: 6px;
        }

        .form-control {
            border-radius: 12px;
            border: 1.5px solid var(--border-light);
            background-color: var(--bg-surface);
            color: var(--text-primary);
            padding: 12px 16px 12px 42px;
            font-size: 0.95rem;
            transition: all 0.3s;
            height: 50px;
        }

        .form-control:focus {
            outline: none;
            background-color: var(--bg-surface);
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }
        
        .input-group-custom {
            position: relative;
        }

        .input-group-custom .field-icon-left {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1.05rem;
        }

        .input-group-custom .field-icon-right {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            cursor: pointer;
            z-index: 10;
        }

        .forgot-password {
            display: block;
            text-align: right;
            font-size: 0.85rem;
            color: var(--primary-rose);
            font-weight: 600;
            text-decoration: none;
            margin-top: 10px;
            margin-bottom: 25px;
            transition: color 0.2s;
        }

        .forgot-password:hover {
            color: var(--primary-rose-hover);
            text-decoration: underline;
        }

        .btn-login {
            background: var(--primary-rose);
            color: white;
            border: none;
            padding: 14px;
            font-weight: 700;
            border-radius: 12px;
            width: 100%;
            transition: all 0.3s;
            font-size: 1rem;
        }

        .btn-login:hover {
            background: var(--primary-rose-hover);
            transform: translateY(-1px);
            box-shadow: 0 8px 15px rgba(244, 63, 94, 0.2);
            color: white;
        }

        .register-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .register-link a {
            color: var(--primary-rose);
            font-weight: 700;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .rose-alert {
            background: var(--rose-bg-light);
            border: 1px solid #fecaca;
            color: var(--rose-text-dark);
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .rose-alert-success {
            background: #fff5f5;
            border: 1px solid #fed7d7;
            color: #9b2c2c;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    
        .bg-rose { background-color: #f43f5e !important; color: white !important; }
        .text-rose { color: #f43f5e !important; }
        .badge-rose { background-color: #ffe4e6 !important; color: #f43f5e !important; border: 1px solid #F8C8D4; }
</style>
</head>
<body>

    <div class="login-container">
        
        <a href="${pageContext.request.contextPath}/" class="back-link-top">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>

        <h2 class="header-title">
            Investor <span>Login</span>
        </h2>
        <p class="header-subtitle">Welcome Back! Log in to view marketplace opportunities</p>

        <!-- Dynamic Success/Error Banners -->
        <c:if test="${not empty error}">
            <div class="rose-alert" role="alert">
                <i class="bi bi-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="rose-alert-success" role="alert">
                <i class="bi bi-check-circle"></i> ${success}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/investor/login" method="post">
            
            <div class="mb-3">
                <label class="form-label" for="email">Email Address *</label>
                <div class="input-group-custom">
                    <i class="field-icon-left bi bi-envelope"></i>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="password">Password *</label>
                <div class="input-group-custom">
                    <i class="field-icon-left bi bi-lock"></i>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required>
                    <i class="field-icon-right bi bi-eye-slash" id="togglePassword"></i>
                </div>
                <a href="${pageContext.request.contextPath}/investor/forgot-password" class="forgot-password">Forgot Password?</a>
            </div>

            <button type="submit" class="btn-login">
                Sign In <i class="bi bi-arrow-right"></i>
            </button>
        </form>

        <p class="register-link">
            Don't have an investor account? <a href="${pageContext.request.contextPath}/investor/register">Register here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const togglePassword = document.getElementById('togglePassword');
        const password = document.getElementById('password');

        if (togglePassword && password) {
            togglePassword.addEventListener('click', function() {
                const type = password.type === 'password' ? 'text' : 'password';
                password.type = type;
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }
    </script>
</body>
</html>
