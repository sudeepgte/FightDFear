<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Host Sign In — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #0F172A;
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
            font-family: 'Outfit', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
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

        .form-input.is-invalid {
            border-color: var(--error) !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.12) !important;
        }

        .form-input.is-valid {
            border-color: var(--success) !important;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.12) !important;
        }

        .error-feedback {
            color: var(--error);
            font-size: 0.8rem;
            margin-top: 5px;
            font-weight: 500;
            display: none;
        }

        .next-steps-card {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 16px 18px;
            margin-bottom: 20px;
            text-align: left;
        }
        .next-steps-card h3 {
            font-size: 0.95rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 8px;
        }
        .next-steps-card ol {
            margin: 0 0 0 18px;
            padding: 0;
            color: var(--text-gray);
            font-size: 0.85rem;
            line-height: 1.6;
        }
        .next-steps-card ol strong { color: var(--navy); }
    </style>
</head>
<body>

    <header class="app-header">
        <a href="${pageContext.request.contextPath}/women-events" class="header-brand">
            <i class="bi bi-shield-heart-fill"></i> Fight D Fear Event Studio
        </a>
        <div style="font-size: 0.88rem;">
            New Host? <a href="${pageContext.request.contextPath}/women-events/host/register" style="color: var(--primary); font-weight: 700; text-decoration: none;">Register here</a>
        </div>
    </header>

    <main class="main-container">
        <div class="form-card">
            <div class="card-header">
                <div style="width: 56px; height: 56px; border-radius: 16px; background: var(--rose-soft); color: var(--primary); display: inline-flex; align-items: center; justify-content: center; font-size: 1.6rem; margin-bottom: 12px;">
                    <i class="bi bi-person-badge-fill"></i>
                </div>
                <h2>Host Sign In</h2>
                <p>Sign in to manage women safety events, attendees & profile</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-circle-fill"></i> ${error}
                </div>
            </c:if>
            <c:if test="${param.registered}">
                <div class="alert-box alert-success">

                    <i class="bi bi-check-circle-fill"></i> Account created! Sign in to complete your host profile. Email and password are filled from registration.

                    <i class="bi bi-check-circle-fill"></i> Account created. Sign in with the email you just registered.
                </div>
                <div class="next-steps-card">
                    <h3>What happens next</h3>
                    <ol>
                        <li><strong>Sign in</strong> with this email and password.</li>
                        <li><strong>Complete your organizer profile</strong> — organization, location, categories, bio, and documents.</li>
                        <li><strong>Review the preview card</strong> on the profile page, then submit for admin verification.</li>
                        <li>You can create events only after an admin <strong>approves</strong> your profile.</li>
                    </ol>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill"></i> ${success}
                </div>
            </c:if>

            <form id="loginForm" action="${pageContext.request.contextPath}/women-events/host/login" method="post" onsubmit="return handleLogin(event)">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="organizer@example.com" required autofocus oninput="validateEmail()" onblur="validateEmail()"
                           value="<c:out value='${not empty registeredEmail ? registeredEmail : (not empty param.email ? param.email : \"\")}'/>">
                    <div class="error-feedback" id="error-email"></div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required oninput="validatePassword()" onblur="validatePassword()">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('password', this)" aria-label="Toggle password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="error-feedback" id="error-password"></div>
                </div>

                <div class="form-group" style="text-align: right; margin-top: -8px; margin-bottom: 14px;">
                    <a href="${pageContext.request.contextPath}/auth/forgot-password" style="color: var(--primary); font-size: 0.85rem; font-weight: 600; text-decoration: none;">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-submit">
                    Sign In <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="login-footer">
                New Host? <a href="${pageContext.request.contextPath}/women-events/host/register">Register here</a>
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

        function validateEmail() {
            const el = document.getElementById('email');
            const err = document.getElementById('error-email');
            const val = el.value.trim();
            if (!val) {
                showFieldInvalid(el, err, 'Email Address is required.');
                return false;
            }
            const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!regex.test(val)) {
                showFieldInvalid(el, err, 'Please enter a valid email address.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function validatePassword() {
            const el = document.getElementById('password');
            const err = document.getElementById('error-password');
            const val = el.value;
            if (!val) {
                showFieldInvalid(el, err, 'Password is required.');
                return false;
            }
            if (val.length < 6) {
                showFieldInvalid(el, err, 'Password must be at least 6 characters.');
                return false;
            }
            showFieldValid(el, err);
            return true;
        }

        function showFieldInvalid(el, err, msg) {
            el.classList.add('is-invalid');
            el.classList.remove('is-valid');
            err.innerText = msg;
            err.style.display = 'block';
        }

        function showFieldValid(el, err) {
            el.classList.remove('is-invalid');
            el.classList.add('is-valid');
            err.innerText = '';
            err.style.display = 'none';
        }

        function handleLogin(e) {
            const isEmailValid = validateEmail();
            const isPasswordValid = validatePassword();

            if (!isEmailValid || !isPasswordValid) {
                e.preventDefault();
                const firstInvalid = document.querySelector('.form-input.is-invalid');
                if (firstInvalid) firstInvalid.focus();
                return false;
            }
            try { sessionStorage.removeItem('fdf_host_login_prefill'); } catch (err) { /* ignore */ }
            return true;
        }

        (function prefillFromRegistration() {
            const emailEl = document.getElementById('email');
            const passEl = document.getElementById('password');
            try {
                const raw = sessionStorage.getItem('fdf_host_login_prefill');
                if (!raw) return;
                const data = JSON.parse(raw);
                if (data.email && emailEl && !emailEl.value) emailEl.value = data.email;
                if (data.password && passEl) passEl.value = data.password;
            } catch (err) { /* ignore */ }
        })();
    </script>
</body>
</html>
