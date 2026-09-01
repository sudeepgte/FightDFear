<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Login — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #0F172A;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --border-color: #E2E8F0;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
            --rose-border: #FECDD3;
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
            background: #fff;
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
            display: flex; align-items: center; gap: 10px;
            font-size: 1.15rem; font-weight: 800; color: var(--navy); text-decoration: none;
        }
        .header-links a { color: var(--text-gray); text-decoration: none; font-size: 0.9rem; font-weight: 600; }
        .header-links a:hover { color: var(--primary); }
        .main-container {
            flex: 1; max-width: 440px; width: 100%; margin: 40px auto; padding: 0 16px;
        }
        .login-card {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 32px 28px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .login-card h1 { font-size: 1.5rem; font-weight: 800; margin-bottom: 6px; }
        .subtitle { color: var(--text-gray); font-size: 0.92rem; margin-bottom: 24px; line-height: 1.45; }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px;
        }
        .label-row {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;
        }
        .label-row label { margin-bottom: 0; }
        .forgot { font-size: 0.8rem; color: var(--primary); text-decoration: none; font-weight: 600; }
        .input-wrap { position: relative; }
        .input-wrap .prefix { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
        .form-input {
            width: 100%; padding: 13px 14px 13px 42px;
            border: 1px solid var(--border-color); border-radius: 10px;
            font-size: 0.95rem; font-family: inherit; transition: 0.2s;
        }
        .form-input:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-input.is-invalid { border-color: var(--error); background: #fff5f5; }
        .password-field .form-input { padding-right: 46px; }
        .password-toggle {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            border: none; background: transparent; color: #94a3b8; cursor: pointer; font-size: 1.1rem;
        }
        .password-toggle:hover { color: var(--primary); }
        .error-msg { display: none; color: var(--error); font-size: 0.78rem; margin-top: 6px; font-weight: 600; }
        .btn-login {
            width: 100%; padding: 13px; margin-top: 6px;
            background: var(--primary); color: #fff; border: none; border-radius: 12px;
            font-size: 1rem; font-weight: 700; cursor: pointer;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: inline-flex; align-items: center; justify-content: center; gap: 8px;
            transition: 0.2s;
        }
        .btn-login:hover:not(:disabled) { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-login:disabled { opacity: 0.6; cursor: not-allowed; box-shadow: none; transform: none; }
        .register-link { text-align: center; margin-top: 22px; font-size: 0.9rem; color: var(--text-gray); }
        .register-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .error-alert {
            background: var(--error-bg); border: 1px solid #fecaca; color: var(--error);
            padding: 12px 14px; border-radius: 10px; font-size: 0.88rem; font-weight: 600;
            margin-bottom: 18px; display: flex; align-items: center; gap: 8px;
        }
        .info-alert {
            background: var(--rose-soft); border: 1px solid var(--rose-border); color: var(--navy);
            padding: 12px 14px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 18px; line-height: 1.45;
        }
        @media (max-width: 480px) {
            .app-header { padding: 12px 16px; }
            .login-card { padding: 24px 18px; }
            .login-card h1 { font-size: 1.3rem; }
            .main-container { margin: 24px auto; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear"
                 style="height:32px;width:32px;border-radius:8px;object-fit:cover;">
            Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/doctors/register">Register</a>
        </div>
    </header>

    <main class="main-container">
        <div class="login-card">
            <h1>Doctor Login</h1>
            <p class="subtitle">Sign in to manage appointments, patients and your clinic profile</p>

            <c:if test="${prefillFromRegistration}">
                <div class="info-alert">
                    Your registration email is ready. Enter your password and sign in to continue.
                </div>
            </c:if>

            <c:if test="${param.logout == 'true'}">
                <div class="info-alert">
                    You have been signed out of the Doctor Portal. Sign in again to continue.
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-alert"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>

            <form id="loginForm" action="${pageContext.request.contextPath}/doctors/login" method="post" autocomplete="on" novalidate>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrap">
                        <i class="bi bi-envelope prefix"></i>
                        <input type="email" id="email" name="email" class="form-input"
                               placeholder="doctor@example.com" required maxlength="120"
                               value="${prefillEmail != null ? prefillEmail : ''}"
                               autocomplete="username">
                    </div>
                    <div class="error-msg" id="emailError">Enter a valid email address.</div>
                </div>
                <div class="form-group">
                    <div class="label-row">
                        <label for="password">Password</label>
                        <a class="forgot" href="${pageContext.request.contextPath}/auth/forgot-password">Forgot Password?</a>
                    </div>
                    <div class="input-wrap password-field">
                        <i class="bi bi-lock prefix"></i>
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Enter your password" required maxlength="64"
                               autocomplete="current-password">
                        <button type="button" class="password-toggle" id="togglePwd" aria-label="Show password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="error-msg" id="pwdError">Password is required.</div>
                </div>
                <button type="submit" class="btn-login" id="loginBtn">
                    Sign In <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="register-link">
                New doctor? <a href="${pageContext.request.contextPath}/doctors/register">Create an account</a>
            </div>
        </div>
    </main>

    <script>
        (function () {
            const form = document.getElementById('loginForm');
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const loginBtn = document.getElementById('loginBtn');
            const emailRule = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
            let submitting = false;

            function showErr(id, show, msg) {
                const el = document.getElementById(id);
                if (!el) return;
                if (msg) el.textContent = msg;
                el.style.display = show ? 'block' : 'none';
            }

            function validate(show) {
                const e = email.value.trim();
                const p = password.value;
                let ok = true;
                if (!e || !emailRule.test(e)) {
                    ok = false;
                    if (show) {
                        email.classList.add('is-invalid');
                        showErr('emailError', true, e ? 'Enter a valid email address.' : 'Email is required.');
                    }
                } else {
                    email.classList.remove('is-invalid');
                    showErr('emailError', false);
                }
                if (!p) {
                    ok = false;
                    if (show) {
                        password.classList.add('is-invalid');
                        showErr('pwdError', true, 'Password is required.');
                    }
                } else {
                    password.classList.remove('is-invalid');
                    showErr('pwdError', false);
                }
                return ok;
            }

            email.addEventListener('blur', () => validate(true));
            password.addEventListener('blur', () => validate(true));

            document.getElementById('togglePwd').addEventListener('click', function () {
                const icon = this.querySelector('i');
                if (password.type === 'password') {
                    password.type = 'text';
                    icon.classList.replace('bi-eye', 'bi-eye-slash');
                } else {
                    password.type = 'password';
                    icon.classList.replace('bi-eye-slash', 'bi-eye');
                }
            });

            form.addEventListener('submit', function (e) {
                if (!validate(true)) {
                    e.preventDefault();
                    return;
                }
                if (submitting) {
                    e.preventDefault();
                    return;
                }
                submitting = true;
                loginBtn.disabled = true;
                loginBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Signing in...';
            });
        })();
    </script>
</body>
</html>
