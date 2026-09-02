<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Partner Login - Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
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
            --warning: #C2410C;
            --warning-bg: #FFF7ED;
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

        .header-brand i {
            color: var(--primary);
            font-size: 1.3rem;
        }

        .main-container {
            flex: 1;
            max-width: 440px;
            width: 100%;
            margin: 40px auto;
            padding: 0 16px;
        }

        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 32px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }

        .card-header {
            margin-bottom: 24px;
            text-align: center;
        }

        .card-header h2 {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .card-header p {
            font-size: 0.9rem;
            color: var(--text-gray);
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: all 0.2s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .password-field .form-input {
            padding-right: 42px;
        }

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
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .login-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }

        .login-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
        }

        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-error {
            background: var(--error-bg);
            border: 1px solid #FECACA;
            color: var(--error);
        }

        .alert-success {
            background: var(--success-bg);
            border: 1px solid #BBF7D0;
            color: var(--success);
        }
        
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            font-size: 0.85rem;
        }
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-gray);
            cursor: pointer;
        }
        .forgot-pass {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }
        .forgot-pass:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <header class="app-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/32'"> Fight D Fear
        </a>
    </header>

    <main class="main-container">
        <div class="form-card">
            <div class="card-header">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 64px; width: 64px; border-radius: 16px; object-fit: cover; margin-bottom: 12px; box-shadow: 0 4px 12px rgba(244,63,94,0.15);" onerror="this.src='https://via.placeholder.com/64'">
                <h2>Salon Partner Login</h2>
                <p>Welcome Back 👋</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-circle-fill"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <c:if test="${not empty message}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/salons/login" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email" 
                           value="<c:out value='${not empty registeredEmail ? registeredEmail : (not empty param.email ? param.email : "")}'/>" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('password', this)" aria-label="Toggle password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" id="rememberMe" style="width:16px; height:16px; accent-color:var(--primary);">
                        Remember me
                    </label>
                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="forgot-pass">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-submit">
                    Access Dashboard <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="login-footer">
                Don't have a partner account? <br>
                <a href="${pageContext.request.contextPath}/salons/register">Initialize Salon Registration</a>
            </div>
        </div>
    </main>

    <script>
        function togglePassVisibility(id, btn) {
            const input = document.getElementById(id);
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }
    </script>
</body>
</html>