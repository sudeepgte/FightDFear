<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            background: #f8fafc;
        }

        .left-panel {
            flex: 1;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #f43f5e 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 40px;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            top: -100px; right: -100px;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }

        .left-panel .brand {
            position: relative; z-index: 2;
            text-align: center;
            color: white;
        }

        .brand-logo {
            font-size: 2.5rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 16px;
        }

        .brand-tagline {
            font-size: 1.15rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 360px;
            line-height: 1.7;
            margin-bottom: 40px;
        }

        .right-panel {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
        }

        .login-card {
            width: 100%;
            max-width: 420px;
        }

        .login-card h2 {
            font-size: 1.85rem;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .login-card .subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 32px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 1rem;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px 14px 46px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #fff;
            color: #0f172a;
        }

        .form-input:focus {
            outline: none;
            border-color: #f43f5e;
            box-shadow: 0 0 0 4px rgba(244, 63, 94, 0.1);
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #1e1b4b, #f43f5e);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.3);
            margin-top: 10px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(244, 63, 94, 0.4);
        }

        .register-link {
            text-align: center;
            font-size: 0.9rem;
            color: #64748b;
            margin-top: 24px;
        }

        .register-link a {
            color: #f43f5e;
            text-decoration: none;
            font-weight: 700;
        }

        .error-alert {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .success-alert {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #16a34a;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .back-home {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #64748b;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 28px;
        }

        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel { padding: 50px 30px; min-height: 35vh; }
            .right-panel { padding: 40px 20px; background: #fff; margin-top: -30px; border-radius: 30px 30px 0 0; }
        }

        @media (max-width: 768px) {
            .left-panel .brand-logo { font-size: 2rem; }
            .left-panel .brand-tagline { font-size: 1rem; }
            .right-panel { padding: 30px 15px; }
            .login-card h2 { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

    <!-- Left Panel -->
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo">
                <i class="bi bi-shield-lock"></i> Account Recovery
            </div>
            <p class="brand-tagline">
                No worries! Enter your registered email address and we'll send you instructions to reset your password.
            </p>
        </div>
    </div>

    <!-- Right Panel -->
    <div class="right-panel">
        <div class="login-card">

            <a href="${pageContext.request.contextPath}/entrepreneur/login" class="back-home">
                <i class="bi bi-arrow-left"></i> Back to Login
            </a>

            <h2>Forgot Password? 🔐</h2>
            <p class="subtitle">Please enter your email to recover your account</p>

            <c:if test="${not empty error}">
                <div class="error-alert">
                    <i class="bi bi-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success-alert">
                    <i class="bi bi-check-circle"></i>
                    ${success}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/entrepreneur/forgot-password" method="post" id="forgotForm" novalidate>
                <div class="form-group mb-4">
                    <label for="email">Account Email Address</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope"></i>
                        <input type="email" id="email" name="email" class="form-input" placeholder="e.g. yourname@business.com" required pattern="^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$">
                    </div>
                    <div id="emailError" style="display: none; color: #dc2626; font-size: 0.85rem; margin-top: 5px;">
                        Please enter a valid email address.
                    </div>
                </div>

                <button type="submit" class="btn-login">
                    Send Reset Link <i class="bi bi-send ms-2"></i>
                </button>
            </form>

        </div>
    </div>
    
    <script>
        document.getElementById('forgotForm').addEventListener('submit', function(e) {
            var emailInput = document.getElementById('email');
            var emailError = document.getElementById('emailError');
            var regex = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
            if (!regex.test(emailInput.value)) {
                e.preventDefault();
                emailError.style.display = 'block';
                emailInput.style.borderColor = '#f43f5e';
            } else {
                emailError.style.display = 'none';
                emailInput.style.borderColor = '';
            }
        });
        
        document.getElementById('email').addEventListener('input', function() {
            document.getElementById('emailError').style.display = 'none';
            this.style.borderColor = '';
        });
    </script>
</body>
</html>
