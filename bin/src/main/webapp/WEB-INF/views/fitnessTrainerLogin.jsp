<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Coach Login — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
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
            background: linear-gradient(135deg, #0f172a 0%, #be123c 50%, #f43f5e 100%);
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
            font-size: 2.3rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .brand-tagline {
            font-size: 1.1rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 380px;
            line-height: 1.7;
            margin-bottom: 40px;
        }

        .feature-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 16px;
            text-align: left;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            gap: 14px;
            color: rgba(255,255,255,0.9);
            font-size: 0.95rem;
            font-weight: 400;
        }

        .feature-list li .feat-icon {
            width: 40px; height: 40px;
            border-radius: 12px;
            background: rgba(255,255,255,0.15);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.1rem;
            flex-shrink: 0;
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
            border-color: #be123c;
            box-shadow: 0 0 0 4px rgba(190, 18, 60, 0.1);
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
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(244, 63, 94, 0.4);
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 16px;
            margin: 24px 0;
            color: #94a3b8;
            font-size: 0.8rem;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e2e8f0;
        }

        .register-link {
            text-align: center;
            font-size: 0.9rem;
            color: #64748b;
        }

        .register-link a {
            color: #f43f5e;
            text-decoration: none;
            font-weight: 700;
        }

        .register-link a:hover {
            text-decoration: underline;
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
        
        .back-home:hover {
            color: #be123c;
        }

        @media (max-width: 992px) {
            body { flex-direction: column; min-height: 100vh; overflow-y: auto; }
            .left-panel { flex: none; padding: 50px 30px; min-height: 35vh; }
            .feature-list { display: none; }
            .right-panel { flex: none; padding: 40px 20px; background: #fff; margin-top: -30px; border-radius: 30px 30px 0 0; display: flex; justify-content: center; align-items: center; }
        }
    </style>
</head>
<body>

    <!-- Left Panel -->
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo">
                <i class="bi bi-heart-pulse-fill text-white"></i> Coach Studio
            </div>
            <p class="brand-tagline">
                Provide wellness coaching & self-defense events for women. Access dynamic scheduling calendar, track bookings, and retrieve safe payouts.
            </p>
            <ul class="feature-list">
                <li>
                    <span class="feat-icon"><i class="bi bi-calendar-event"></i></span>
                    Manage customized timings & hourly session fee
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-wallet2"></i></span>
                    Track completed coaching earnings instantly
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-patch-check"></i></span>
                    Admin verified credentials safety badge
                </li>
            </ul>
        </div>
    </div>

    <!-- Right Panel -->
    <div class="right-panel">
        <div class="login-card">
            
            <a href="${pageContext.request.contextPath}/" class="back-home">
                <i class="bi bi-arrow-left"></i> Back to Homepage
            </a>

            <h2>Coach Studio Login</h2>
            <p class="subtitle">Access your trainer dashboard panel</p>

            <c:if test="${not empty success}">
                <div class="success-alert">
                    <i class="bi bi-check-circle-fill"></i> ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="error-alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/fitness/trainer/login" method="POST">
                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope"></i>
                        <input type="email" name="email" class="form-input" placeholder="e.g. coach@fitness.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <div class="input-wrapper">
                        <i class="bi bi-lock"></i>
                        <input type="password" name="password" id="passwordInput" class="form-input" placeholder="••••••••" style="padding-right: 46px;" required>
                        <i class="bi bi-eye-slash" id="togglePassword" style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #94a3b8; font-size: 1.1rem; z-index: 10;"></i>
                    </div>
                </div>

                <button type="submit" class="btn-login">Log In to Studio</button>
            </form>

            <div class="divider">or</div>

            <div class="register-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/fitness/trainer/register">Register as Coach</a>
            </div>
            
        </div>
    </div>

    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const passwordInput = document.querySelector('#passwordInput');
        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function () {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }
    </script>
</body>
</html>
