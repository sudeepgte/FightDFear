<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login — Fight D Fear</title>
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
            --rose-soft: #FFE4E6;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --success: #166534;
            --success-bg: #F0FDF4;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }
        .app-header {
            background: #fff;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
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
        .header-brand i { color: var(--primary); }
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
        .card-header { text-align: center; margin-bottom: 24px; }
        .card-header h2 { font-size: 1.4rem; font-weight: 800; margin-bottom: 6px; }
        .card-header p { font-size: 0.9rem; color: var(--text-gray); }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .input-wrapper { position: relative; }
        .input-wrapper > i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary);
        }
        .form-input {
            width: 100%;
            padding: 12px 14px 12px 42px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            outline: none;
        }
        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .password-field .form-input { padding-right: 44px; }
        .password-toggle-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            width: 36px;
            height: 36px;
        }
        .password-toggle-btn .icon-eye-show { display: none; }
        .password-toggle-btn.is-visible .icon-eye-show { display: block; }
        .password-toggle-btn.is-visible .icon-eye-hide { display: none; }
        .password-toggle-btn svg { width: 18px; height: 18px; }
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            font-size: 0.85rem;
        }
        .forgot-link { color: var(--primary); text-decoration: none; font-weight: 600; }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
        }
        .btn-login:hover { background: var(--primary-hover); }
        .error-alert {
            background: var(--error-bg);
            border: 1px solid #FECACA;
            color: var(--error);
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            gap: 8px;
            align-items: flex-start;
        }
        .success-alert {
            background: var(--success-bg);
            border: 1px solid #BBF7D0;
            color: var(--success);
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
        }
        .register-link {
            text-align: center;
            margin-top: 18px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }
        .register-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .back-home {
            display: inline-flex;
            gap: 6px;
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 18px;
        }
        @media (max-width: 480px) {
            .form-card { padding: 24px 16px; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-heart-fill"></i> Fight D Fear
        </a>
    </header>

    <div class="main-container">
        <a href="${pageContext.request.contextPath}/" class="back-home">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
        <div class="form-card">
            <div class="card-header">
                <h2>Welcome back</h2>
                <p>Sign in to the Fight D Fear Admin Portal</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-alert"><i class="bi bi-exclamation-circle"></i><span>${error}</span></div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="success-alert"><i class="bi bi-check-circle"></i> ${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/loginAdmin" method="post">
                <div class="form-group">
                    <label for="email">Admin Email</label>
                    <div class="input-wrapper">
                        <i class="bi bi-envelope"></i>
                        <input type="email" id="email" name="email" class="form-input"
                               placeholder="admin@example.com" required autocomplete="username"
                               value="<c:out value='${prefillEmail}'/>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper password-field">
                        <i class="bi bi-lock"></i>
                        <input type="password" id="adminPassword" name="password" class="form-input"
                               placeholder="Enter your password" required autocomplete="current-password"
                               value="<c:out value='${prefillPassword}'/>">
                        <button type="button" class="password-toggle-btn" data-toggle-password="adminPassword" aria-label="Show password" aria-pressed="false">
                            <span class="icon-eye-show" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </span>
                            <span class="icon-eye-hide" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"></path><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"></path><path d="M1 1l22 22"></path></svg>
                            </span>
                        </button>
                    </div>
                </div>

                <div class="form-options">
                    <span></span>
                    <!-- No forgot password in original admin login, skipping it -->
                </div>

                <button type="submit" class="btn-login">Sign in</button>
            </form>

            <p class="register-link">
                Need an admin account? <a href="${pageContext.request.contextPath}/admin/registerAdmin">Register here</a>
            </p>
        </div>
    </div>

<script>
(function () {
    document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var id = btn.getAttribute('data-toggle-password');
            var input = document.getElementById(id);
            if (!input) return;
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            btn.classList.toggle('is-visible', show);
            btn.setAttribute('aria-pressed', show ? 'true' : 'false');
        });
    });
})();
</script>
</body>
</html>
