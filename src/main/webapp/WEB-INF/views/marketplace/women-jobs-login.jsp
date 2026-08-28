<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Women Jobs Login — Fight D Fear</title>
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
            max-width: 440px;
            width: 100%;
            margin: 40px auto;
            padding: 0 16px 40px;
        }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 32px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .card-header { margin-bottom: 24px; text-align: center; }
        .card-header h2 { font-size: 1.4rem; font-weight: 800; color: var(--navy); margin-bottom: 6px; }
        .card-header p { font-size: 0.9rem; color: var(--text-gray); }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .input-wrapper { position: relative; }
        .form-input {
            width: 100%;
            padding: 12px 14px 12px 42px;
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
        .prefix-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-gray);
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
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
        }
        .btn-submit:hover { background: var(--primary-hover); }
        .login-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }
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
        .confirm-card {
            background: var(--card-bg);
            border: 1px solid #BBF7D0;
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            text-align: center;
            margin-bottom: 20px;
        }
        .confirm-icon {
            width: 64px; height: 64px;
            border-radius: 50%;
            background: var(--success-bg);
            color: var(--success);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 14px;
        }
        .confirm-card h2 { font-size: 1.25rem; font-weight: 800; color: var(--navy); margin-bottom: 8px; }
        .confirm-card p { font-size: 0.9rem; color: var(--text-gray); line-height: 1.55; margin-bottom: 8px; }
        .confirm-list {
            text-align: left;
            list-style: none;
            margin: 16px 0 8px;
            padding: 0;
        }
        .confirm-list li {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 0.9rem;
            color: var(--navy);
            font-weight: 600;
            margin-bottom: 10px;
        }
        .confirm-list li i { color: var(--success); margin-top: 2px; }
        .confirm-next {
            background: var(--rose-soft);
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 0.85rem;
            color: var(--navy);
            margin: 16px 0 18px;
            font-weight: 600;
        }
        .btn-confirm {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 22px;
            background: var(--primary);
            color: #fff;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.95rem;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
        }
        .btn-confirm:hover { background: var(--primary-hover); color: #fff; }
        .pw-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
        .pw-row a { font-size: 0.8rem; color: var(--primary); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <i class="bi bi-briefcase-fill"></i> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/women-jobs/register">Register</a>
        </div>
    </header>

    <main class="main-container">
        <c:if test="${not empty success}">
            <div class="confirm-card" id="registrationConfirm">
                <div class="confirm-icon"><i class="bi bi-check-lg"></i></div>
                <h2>Registration Successful</h2>
                <ul class="confirm-list">
                    <li><i class="bi bi-check-circle-fill"></i> Account and application created successfully</li>
                    <li><i class="bi bi-check-circle-fill"></i> ${success}</li>
                </ul>
                <div class="confirm-next">Sign in with the email you registered. After admin verification you can complete your profile and manage bookings from your worker portal.</div>
                <a href="#workerLoginCard" class="btn-confirm" id="btnContinueLogin">Continue to Login <i class="bi bi-arrow-right"></i></a>
            </div>
        </c:if>

        <div class="form-card" id="workerLoginCard"<c:if test="${not empty success and empty error}"> style="display:none;"</c:if>>
            <div class="card-header">
                <h2>Women Jobs Sign In</h2>
                <p>Enter your credentials to access your worker portal</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-alert alert-box alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>
            <div id="js-login-error" class="error-alert alert-box alert-error" style="display:none;">
                <i class="bi bi-exclamation-circle-fill"></i> <span id="js-login-error-msg"></span>
            </div>

            <form id="workerLoginForm" action="${pageContext.request.contextPath}/women-jobs/login" method="post">
                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope prefix-icon"></i>
                        <input type="email" name="email" class="form-input" placeholder="partner@example.com" value="<c:out value='${registeredEmail}'/>" required>
                    </div>
                </div>
                <div class="form-group">
                    <div class="pw-row">
                        <label style="margin-bottom: 0;">Password</label>
                        <a href="${pageContext.request.contextPath}/auth/forgot-password">Forgot Password?</a>
                    </div>
                    <div class="input-wrapper password-field">
                        <i class="bi bi-shield-lock prefix-icon"></i>
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePassword()"><i class="bi bi-eye"></i></button>
                    </div>
                </div>
                <button type="submit" class="btn-login btn-submit">Sign In <i class="bi bi-arrow-right"></i></button>
            </form>
            <p class="register-link login-footer">New Worker? <a href="${pageContext.request.contextPath}/women-jobs/register">Register here</a></p>
        </div>
    </main>

    <script>
        function togglePassword() {
            var passwordInput = document.getElementById("password");
            var toggleBtn = document.querySelector(".password-toggle-btn i");
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleBtn.classList.remove("bi-eye");
                toggleBtn.classList.add("bi-eye-slash");
            } else {
                passwordInput.type = "password";
                toggleBtn.classList.remove("bi-eye-slash");
                toggleBtn.classList.add("bi-eye");
            }
        }

        var continueBtn = document.getElementById('btnContinueLogin');
        if (continueBtn) {
            continueBtn.addEventListener('click', function(e) {
                e.preventDefault();
                var card = document.getElementById('workerLoginCard');
                card.style.display = 'block';
                card.scrollIntoView({ behavior: 'smooth', block: 'start' });
            });
        }

        document.getElementById('workerLoginForm').addEventListener('submit', function(event) {
            var box = document.getElementById('js-login-error');
            var msg = document.getElementById('js-login-error-msg');
            box.style.display = 'none';
            var email = (this.email.value || '').trim();
            var password = this.password.value || '';
            if (email === '') {
                event.preventDefault();
                msg.textContent = 'Email Address is required.';
                box.style.display = 'flex';
                return;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                event.preventDefault();
                msg.textContent = 'Please enter a valid email address.';
                box.style.display = 'flex';
                return;
            }
            if (password === '') {
                event.preventDefault();
                msg.textContent = 'Password is required.';
                box.style.display = 'flex';
            }
        });
    </script>
</body>
</html>
