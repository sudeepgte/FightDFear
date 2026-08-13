<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrepreneur Login — Fight D Fear</title>
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

        .feature-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 16px;
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
            .feature-list { display: none; }
            .right-panel { padding: 40px 20px; background: #fff; margin-top: -30px; border-radius: 30px 30px 0 0; }
        }
    </style>
</head>
<body>

    <!-- Left Panel -->
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo">
                <i class="bi bi-briefcase"></i> Entrepreneur Portal
            </div>
            <p class="brand-tagline">
                Turn your business ideas into reality. Connect with investors who believe in you and fund your vision.
            </p>
            <ul class="feature-list">
                <li>
                    <span class="feat-icon"><i class="bi bi-rocket-takeoff"></i></span>
                    Submit detailed business proposals
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-currency-dollar"></i></span>
                    Raise full or partial funding easily
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-calendar-event"></i></span>
                    Schedule face-to-face or video meetings
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-chat-text"></i></span>
                    Real-time chats with interested investors
                </li>
            </ul>
        </div>
    </div>

    <!-- Right Panel -->
    <div class="right-panel">
        <div class="login-card">

            <a href="${pageContext.request.contextPath}/" class="back-home">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>

            <h2>Welcome Back, Partner! 👋</h2>
            <p class="subtitle">Log in to manage your proposals and track investments</p>

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

            <form action="${pageContext.request.contextPath}/entrepreneur/login" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope"></i>
                        <input type="email" id="email" name="email" class="form-input" placeholder="Enter your registered email" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <i class="bi bi-lock"></i>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                    </div>
                </div>

                <button type="submit" class="btn-login">
                    Sign In <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="divider">or</div>

            <p class="register-link">
                Don't have an entrepreneur account? <a href="${pageContext.request.contextPath}/entrepreneur/register">Register here</a>
            </p>
        </div>
    </div>
</body>
</html>
