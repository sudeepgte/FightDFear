<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            min-height: 100vh;
            display: flex;
            background: #f8f7ff;
        }

        /* === Left Panel — Visual Side === */
        .left-panel {
            flex: 1;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%);
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

        .left-panel::after {
            content: '';
            position: absolute;
            bottom: -150px; left: -80px;
            width: 500px; height: 500px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
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

        .brand-logo i {
            font-size: 2rem;
            margin-right: 8px;
            opacity: 0.9;
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

        /* === Right Panel — Form Side === */
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
            color: #1a1a2e;
            margin-bottom: 6px;
        }

        .login-card .subtitle {
            color: #6b7280;
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
            color: #374151;
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
            color: #9ca3af;
            font-size: 1rem;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px 14px 46px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
            background: #fff;
            color: #1a1a2e;
        }

        .form-input:focus {
            outline: none;
            border-color: #1e1b4b;
            box-shadow: 0 0 0 4px rgba(30, 27, 75, 0.1);
        }

        .form-input::placeholder {
            color: #9ca3af;
        }

        .password-toggle-btn {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: #9ca3af;
            cursor: pointer;
            padding: 4px;
            font-size: 1.1rem;
            z-index: 2;
        }

        .password-toggle-btn:hover { color: #1e1b4b; }

        .input-wrapper.password-field .form-input {
            padding-right: 46px;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: #6b7280;
            cursor: pointer;
        }

        .remember-me input[type="checkbox"] {
            width: 16px; height: 16px;
            accent-color: #1e1b4b;
            cursor: pointer;
        }

        .forgot-link {
            font-size: 0.85rem;
            color: #1e1b4b;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: #1e1b4b;
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #1e1b4b, #1e1b4b);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.35);
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #1e1b4b, #1e1b4b);
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(124, 45, 94, 0.45);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 16px;
            margin: 24px 0;
            color: #9ca3af;
            font-size: 0.8rem;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }

        .register-link {
            text-align: center;
            font-size: 0.9rem;
            color: #6b7280;
        }

        .register-link a {
            color: #1e1b4b;
            text-decoration: none;
            font-weight: 700;
            transition: color 0.2s;
        }

        .register-link a:hover {
            color: #1e1b4b;
        }

        .error-alert {
            background: #fff1f8;
            border: 1px solid #ffc2df;
            color: #1e1b4b;
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
            color: #6b7280;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 28px;
            transition: color 0.2s;
        }

        .back-home:hover {
            color: #1e1b4b;
        }

        /* === Responsive === */
        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel {
                padding: 50px 30px;
                min-height: 35vh;
                text-align: center;
            }
            .left-panel .brand-tagline {
                margin: 0 auto;
            }
            .feature-list { display: none; }
            .right-panel { 
                padding: 40px 20px;
                background: #fff;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -30px;
                position: relative;
                z-index: 5;
            }
            .login-card {
                max-width: 100%;
            }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .brand-tagline { font-size: 1rem; }
            .login-card h2 { font-size: 1.5rem; }
            .form-input { padding: 12px 16px 12px 42px; }
        }
    </style>
</head>
<body>

    <!-- Left Panel -->
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo">
                <i class="bi bi-shield-check"></i> Fight D Fear
            </div>
            <p class="brand-tagline">
                Empowering Women's Safety Through Technology. Your safety is our mission — anytime, anywhere.
            </p>
            <ul class="feature-list">
                <li>
                    <span class="feat-icon"><i class="bi bi-bell-fill"></i></span>
                    One-tap SOS Emergency Alerts
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-geo-alt-fill"></i></span>
                    Real-time Location Sharing
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-people-fill"></i></span>
                    Verified Volunteer Network
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-shield-lock-fill"></i></span>
                    Self-Defense Training & Resources
                </li>
                <li>
                    <span class="feat-icon"><i class="bi bi-camera-reels-fill"></i></span>
                    Community Reels & Video Sharing
                </li>
            </ul>
        </div>
    </div>

    <!-- Right Panel -->
    <div class="right-panel">
        <div class="login-card">

            <a href="${pageContext.request.contextPath}/index.html" class="back-home">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>

            <h2>Welcome Back 👋</h2>
            <p class="subtitle">Sign in to your account to continue</p>

            <c:if test="${not empty error}">
                <div class="error-alert">
                    <i class="bi bi-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope"></i>
                        <input type="email" id="email" name="email" class="form-input"
                               placeholder="Enter your email" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper password-field">
                        <i class="bi bi-lock"></i>
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Enter your password" required autocomplete="current-password">
                        <button type="button" class="password-toggle-btn" data-toggle-password="password" aria-label="Show password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox"> Remember me
                    </label>
                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="forgot-link">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-login">
                    Sign In <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="divider">or</div>

            <p class="register-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/users/register">Create one here</a>
            </p>
        </div>
    </div>

<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>


