<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Centre Login — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; background: #fffcfd; }
        .left-panel { flex: 1; background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%); display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 60px 40px; position: relative; overflow: hidden; }
        .left-panel::before { content: ''; position: absolute; top: -100px; right: -100px; width: 400px; height: 400px; border-radius: 50%; background: rgba(255,255,255,0.06); }
        .left-panel::after { content: ''; position: absolute; bottom: -150px; left: -80px; width: 500px; height: 500px; border-radius: 50%; background: rgba(255,255,255,0.04); }
        .left-panel .brand { position: relative; z-index: 2; text-align: center; color: white; }
        .brand-logo { font-size: 2.2rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 16px; }
        .brand-logo i { font-size: 2rem; margin-right: 8px; }
        .brand-tagline { font-size: 1.1rem; font-weight: 300; opacity: 0.9; max-width: 360px; line-height: 1.7; margin-bottom: 40px; }
        .right-panel { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px; }
        .login-card { width: 100%; max-width: 420px; }
        .login-card h2 { font-size: 1.85rem; font-weight: 800; color: #3F1430; margin-bottom: 6px; }
        .login-card .subtitle { color: #6b7280; font-size: 0.95rem; margin-bottom: 32px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: #3F1430; margin-bottom: 8px; }
        .input-wrapper { position: relative; }
        .input-wrapper i { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #9ca3af; font-size: 1rem; }
        .form-input { width: 100%; padding: 14px 16px 14px 46px; border: 2px solid #f3e8ef; border-radius: 12px; font-size: 0.95rem; transition: all 0.3s ease; }
        .form-input:focus { outline: none; border-color: #1e1b4b; box-shadow: 0 0 0 4px rgba(30, 27, 75, 0.1); }
        .btn-login { width: 100%; padding: 14px; background: linear-gradient(135deg, #1e1b4b, #1e1b4b); color: white; border: none; border-radius: 12px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3); }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 6px 25px rgba(124, 45, 94, 0.4); }
        .register-link { text-align: center; margin-top: 24px; font-size: 0.9rem; color: #6b7280; }
        .register-link a { color: #1e1b4b; text-decoration: none; font-weight: 700; }
        .error-alert { background: #fff1f8; border: 1px solid #ffc2df; color: #1e1b4b; padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .back-home { display: inline-flex; align-items: center; gap: 6px; color: #6b7280; text-decoration: none; font-size: 0.85rem; font-weight: 500; margin-bottom: 28px; }
        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 16px; text-align: left; margin-top: 20px; }
        .feature-list li { display: flex; align-items: center; gap: 14px; color: rgba(255,255,255,0.9); font-size: 0.95rem; font-weight: 400; }
        .feature-list li .feat-icon { width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; justify-content: center; align-items: center; font-size: 1.1rem; flex-shrink: 0; }
        @media (max-width: 992px) {
            body { flex-direction: column; }
            .left-panel {
                padding: 50px 30px;
                min-height: 30vh;
                text-align: center;
            }
            .brand-tagline { 
                margin: 0 auto;
                font-size: 1rem;
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
            .login-card h2 { font-size: 1.5rem; }
            .form-input { padding: 12px 16px 12px 42px; }
        }
    </style>
</head>
<body>
    <div class="left-panel">
        <div class="brand">
            <div class="brand-logo"><i class="fa-solid fa-dumbbell"></i> Fight D Fear</div>
            <p class="brand-tagline">Empower your students with professional martial arts training and safety education.</p>
            <ul class="feature-list">
                <li><span class="feat-icon"><i class="bi bi-person-badge-fill"></i></span> Learn Self-Defense from Experts</li>
                <li><span class="feat-icon"><i class="bi bi-graph-up-arrow"></i></span> Beginner to Advanced Training Programs</li>
                <li><span class="feat-icon"><i class="bi bi-award-fill"></i></span> Build Confidence & Strength</li>
                <li><span class="feat-icon"><i class="bi bi-shield-shaded"></i></span> Stay Prepared for Real-Life Situations</li>
            </ul>
        </div>
    </div>
    <div class="right-panel">
        <div class="login-card">
            <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Back to Home</a>
            <h2>Welcome Back 👋</h2>
            <p class="subtitle">Enter your centre credentials to manage your gym</p>
            <c:if test="${not empty error}">
                <div class="error-alert"><i class="bi bi-exclamation-circle"></i> ${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="error-alert" style="background:#ecfdf5;border-color:#a7f3d0;color:#065f46;">
                    <i class="bi bi-check-circle"></i> ${message}
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/centres/loginCentre" method="post">
                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-wrapper"><i class="bi bi-envelope"></i><input type="email" name="email" class="form-input" placeholder="centre@example.com" required></div>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-wrapper"><i class="bi bi-lock"></i><input type="password" name="password" class="form-input" placeholder="••••••••" required></div>
                </div>
                <button type="submit" class="btn-login">Sign In <i class="bi bi-arrow-right"></i></button>
            </form>
            <p class="register-link">New Centre? <a href="${pageContext.request.contextPath}/centres/registerCentre">Register here</a></p>
        </div>
    </div>
</body>
</html>

