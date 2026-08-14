<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Event Host Login | Fight D Fear</title>
    
    <link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1e1b4b;
            --secondary: #a855f7;
            --dark-navy: #1e1b4b;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fdf2f8 0%, #f3e8ff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 30px;
            box-shadow: 0 20px 50px rgba(124, 45, 94, 0.08);
            width: 100%;
            max-width: 480px;
            padding: 40px;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
        }

        .form-control {
            border-radius: 14px;
            padding: 12px 18px;
            border: 1.5px solid #e2e8f0;
            font-size: 0.95rem;
            transition: all 0.3s;
            background: rgba(255, 255, 255, 0.9);
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(124, 45, 94, 0.15);
            background: #fff;
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            color: #fff;
            padding: 12px;
            border-radius: 14px;
            font-weight: 600;
            font-family: 'Outfit', sans-serif;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            box-shadow: 0 10px 25px rgba(124, 45, 94, 0.2);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3);
            color: #fff;
        }

        .reg-link {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s;
        }

        .reg-link:hover {
            color: var(--secondary);
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="login-card text-center">
        <a href="${pageContext.request.contextPath}/" class="brand-logo">Fight D Fear</a>
        <h3 class="fw-bold mb-1" style="color: var(--dark-navy); font-family: 'Outfit', sans-serif;">Event Host Portal</h3>
        <p class="text-muted small mb-4">Log in to organize and manage safety events</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 small py-2 px-3 mb-4" style="border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            </div>
        </c:if>

        <c:if test="${param.registered}">
            <div class="alert alert-success border-0 small py-2 px-3 mb-4" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill me-2"></i> Registration successful! Pending Admin approval.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/women-events/host/login" method="post" class="text-start">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Email Address</label>
                <input type="email" name="email" class="form-control" placeholder="organizer@example.com" required>
            </div>
            
            <div class="mb-4">
                <div class="d-flex justify-content-between">
                    <label class="form-label small fw-semibold text-muted">Password</label>
                </div>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-login w-100 mb-3">Sign In as Host</button>
            
            <p class="text-center small text-muted mb-0">
                Want to host events? <a href="${pageContext.request.contextPath}/women-events/host/register" class="reg-link">Register Now</a>
            </p>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
